using eAnimalShelter.Model;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using EasyNetQ;
using eAnimalShelter.Model.Messages;

namespace eAnimalShelter.Services
{
    public class NotificationService : BaseCRUDService<
        Notification,
        NotificationResponse,
        NotificationSearchObject,
        NotificationInsertRequest,
        NotificationUpdateRequest>,
        INotificationService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;
        private readonly IBus _bus;

        public NotificationService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<NotificationInsertRequest> insertValidator,
            IValidator<NotificationUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor,
            IBus bus)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
            _bus = bus;
        }

        protected override IQueryable<Notification> ApplyFilters(
            IQueryable<Notification> query,
            NotificationSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x =>
                    x.Title.Contains(search.FTS) ||
                    x.Message.Contains(search.FTS));
            }
            if (search?.UserId.HasValue == true)
            {
                query = query.Where(x =>
                    x.UserId == search.UserId.Value);
            }

            if (search?.TargetRoleId.HasValue == true)
            {
                query = query.Where(x =>
                    x.TargetRoleId == search.TargetRoleId.Value);
            }

            if (search?.Type.HasValue == true)
            {
                query = query.Where(x =>
                    x.Type == search.Type.Value);
            }

            if (search?.IsRead.HasValue == true)
            {
                query = query.Where(x =>
                    x.IsRead == search.IsRead.Value);
            }

            if (search?.DateSentFrom.HasValue == true)
            {
                query = query.Where(x =>
                    x.DateSent >= search.DateSentFrom.Value);
            }

            if (search?.DateSentTo.HasValue == true)
            {
                query = query.Where(x =>
                    x.DateSent <= search.DateSentTo.Value);
            }

            return query;
        }
        protected override IQueryable<Notification> ApplySorting(
            IQueryable<Notification> query,
            NotificationSearchObject search)
        {
            switch (search.SortBy)
            {
                case "title":
                    return query.OrderBy(x => x.Title);

                case "title_desc":
                    return query.OrderByDescending(x => x.Title);

                case "date":
                    return query.OrderBy(x => x.DateSent);

                case "date_desc":
                    return query.OrderByDescending(x => x.DateSent);

                case "type":
                    return query.OrderBy(x => x.Type);

                case "type_desc":
                    return query.OrderByDescending(x => x.Type);

                case "status":
                    return query.OrderBy(x => x.IsRead);

                case "status_desc":
                    return query.OrderByDescending(x => x.IsRead);

                default:
                    return query.OrderByDescending(x => x.DateSent);
            }
        }

        protected override IQueryable<Notification> Include(
            IQueryable<Notification> query,
            NotificationSearchObject? search)
        {
            return query
                .Include(x => x.User)
                .Include(x => x.TargetRole);
        }

        public override async Task<PageResult<NotificationResponse>> GetAllAsync(
            NotificationSearchObject? search = null)
        {
            search ??= Activator.CreateInstance<NotificationSearchObject>();

            // Get current user info
            var currentUserId = _authenticatedUserAccessor.GetUserId();
            var isAdmin = _authenticatedUserAccessor.IsInRole("Admin");

            IQueryable<Notification> query = _dbContext.Set<Notification>();

            query = Include(query, search);

            // Apply access control: 
            // - Admins can see all notifications
            // - Non-admins can only see notifications sent to them or their role
            if (!isAdmin && currentUserId.HasValue)
            {
                // Get user's roles
                var userRoleIds = await _dbContext.Set<UserRole>()
                    .Where(ur => ur.UserId == currentUserId.Value)
                    .Select(ur => ur.RoleId)
                    .ToListAsync();

                query = query.Where(x =>
                    x.UserId == currentUserId.Value ||
                    (x.TargetRoleId.HasValue && userRoleIds.Contains(x.TargetRoleId.Value)));
            }

            query = ApplyFilters(query, search);

            int? totalCount = null;

            if (search.IncludeTotalCount)
            {
                totalCount = await query.CountAsync();
            }

            if (search.Page.HasValue && search.PageSize.HasValue)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var entities = await query.ToListAsync();

            return new PageResult<NotificationResponse>
            {
                Items = _mapper.Map<List<NotificationResponse>>(entities),
                TotalCount = totalCount
            };
        }

        public override async Task<NotificationResponse> GetByIdAsync(int id)
        {
            var currentUserId = _authenticatedUserAccessor.GetUserId();
            var isAdmin = _authenticatedUserAccessor.IsInRole("Admin");

            var entity = await _dbContext.Set<Notification>()
                .Include(x => x.User)
                .Include(x => x.TargetRole)
                .FirstOrDefaultAsync(x => x.NotificationId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Notification with id {id} not found.");
            }

            // Check access: admin or user receiving the notification
            if (!isAdmin && currentUserId.HasValue)
            {
                if (entity.UserId != currentUserId.Value)
                {
                    // Check if user is in the target role
                    var userRoleIds = await _dbContext.Set<UserRole>()
                        .Where(ur => ur.UserId == currentUserId.Value)
                        .Select(ur => ur.RoleId)
                        .ToListAsync();

                    if (!entity.TargetRoleId.HasValue || !userRoleIds.Contains(entity.TargetRoleId.Value))
                    {
                        throw new UnauthorizedAccessException(
                            "You do not have access to this notification.");
                    }
                }
            }

            return _mapper.Map<NotificationResponse>(entity);
        }

        public override async Task<NotificationResponse> InsertAsync(
            NotificationInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<Notification>(request);

            entity.DateSent = DateTime.UtcNow;
            entity.IsRead = false;

            _dbContext.Set<Notification>().Add(entity);

            await _dbContext.SaveChangesAsync();

            await _bus.PubSub.PublishAsync(
                new NotificationCreatedEvent
                {
                    UserId = entity.UserId,
                    TargetRoleId = entity.TargetRoleId,
                    Title = entity.Title,
                    Message = entity.Message
                });

            return _mapper.Map<NotificationResponse>(entity);
        }

        public override async Task<NotificationResponse> UpdateAsync(
            int id,
            NotificationUpdateRequest request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            var entity = await _dbContext.Set<Notification>().FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Notification with id {id} not found.");
            }

            entity.Title = request.Title;
            entity.Message = request.Message;
            entity.Type = request.Type;
            entity.UserId = request.UserId;
            entity.TargetRoleId = request.TargetRoleId;
            entity.IsRead = request.IsRead;

            if (request.IsRead && !entity.ReadAt.HasValue)
            {
                entity.ReadAt = DateTime.UtcNow;
            }

            _dbContext.Set<Notification>().Update(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<NotificationResponse>(entity);
        }
        public async Task<int> GetUnreadCountAsync()
        {
            var currentUserId = _authenticatedUserAccessor.GetUserId();

            if (!currentUserId.HasValue)
                return 0;

            var userRoleIds = await _dbContext.UserRoles
                .Where(x => x.UserId == currentUserId.Value)
                .Select(x => x.RoleId)
                .ToListAsync();

            return await _dbContext.Notifications.CountAsync(x =>
                !x.IsRead &&
                (
                    x.UserId == currentUserId.Value ||
                    (x.TargetRoleId.HasValue &&
                    userRoleIds.Contains(x.TargetRoleId.Value))
                ));
        }
        public async Task MarkAsReadAsync(int notificationId)
        {
            var currentUserId = _authenticatedUserAccessor.GetUserId();

            if (!currentUserId.HasValue)
                throw new UnauthorizedAccessException();

            var userRoleIds = await _dbContext.UserRoles
                .Where(x => x.UserId == currentUserId.Value)
                .Select(x => x.RoleId)
                .ToListAsync();

            var notification = await _dbContext.Notifications
                .FirstOrDefaultAsync(x =>
                    x.NotificationId == notificationId &&
                    (
                        x.UserId == currentUserId.Value ||
                        (x.TargetRoleId.HasValue &&
                        userRoleIds.Contains(x.TargetRoleId.Value))
                    ));

            if (notification == null)
                throw new KeyNotFoundException();

            notification.IsRead = true;
            notification.ReadAt = DateTime.UtcNow;

            await _dbContext.SaveChangesAsync();
        }
        public async Task MarkAllAsReadAsync()
        {
            var currentUserId = _authenticatedUserAccessor.GetUserId();

            if (!currentUserId.HasValue)
                throw new UnauthorizedAccessException();

            var userRoleIds = await _dbContext.UserRoles
                .Where(x => x.UserId == currentUserId.Value)
                .Select(x => x.RoleId)
                .ToListAsync();

            var notifications = await _dbContext.Notifications
                .Where(x =>
                    !x.IsRead &&
                    (
                        x.UserId == currentUserId.Value ||
                        (x.TargetRoleId.HasValue &&
                        userRoleIds.Contains(x.TargetRoleId.Value))
                    ))
                .ToListAsync();

            foreach (var notification in notifications)
            {
                notification.IsRead = true;
                notification.ReadAt = DateTime.UtcNow;
            }

            await _dbContext.SaveChangesAsync();
        }
    }
}
