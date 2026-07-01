using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class AnnouncementService : BaseCRUDService<
        Announcement,
        AnnouncementResponse,
        AnnouncementSearchObject,
        AnnouncementInsertRequest,
        AnnouncementUpdateRequest>,
        IAnnouncementService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;

        public AnnouncementService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<AnnouncementInsertRequest> insertValidator,
            IValidator<AnnouncementUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
        }

        protected override IQueryable<Announcement> ApplyFilters(
            IQueryable<Announcement> query,
            AnnouncementSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.Title))
            {
                query = query.Where(x =>
                    x.Title.Contains(search.Title));
            }

            if (search?.IsActive.HasValue == true)
            {
                query = query.Where(x =>
                    x.IsActive == search.IsActive.Value);
            }

            return query;
        }
        protected override IQueryable<Announcement> ApplySorting(
            IQueryable<Announcement> query,
            AnnouncementSearchObject search)
        {
            return query.OrderByDescending(x => x.PublishedDate);
        }

        protected override IQueryable<Announcement> Include(
            IQueryable<Announcement> query,
            AnnouncementSearchObject? search)
        {
            return query.Include(x => x.CreatedByUser);
        }

        public override async Task<AnnouncementResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<Announcement>()
                .Include(x => x.CreatedByUser)
                .FirstOrDefaultAsync(x => x.AnnouncementId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Announcement with id {id} not found.");
            }

            return _mapper.Map<AnnouncementResponse>(entity);
        }

        public override async Task<AnnouncementResponse> InsertAsync(
            AnnouncementInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<Announcement>(request);

            entity.CreatedBy = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            _dbContext.Set<Announcement>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<AnnouncementResponse>(entity);
        }
        public override async Task DeleteAsync(int id)
        {
            var entity = await _dbContext
                .Set<Announcement>()
                .FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Announcement with id {id} not found.");
            }

            entity.IsActive = false;

            await _dbContext.SaveChangesAsync();
        }
    }
}