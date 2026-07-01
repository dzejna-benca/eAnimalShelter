using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class VolunteerActivityService : BaseCRUDService<
        VolunteerActivity,
        VolunteerActivityResponse,
        VolunteerActivitySearchObject,
        VolunteerActivityInsertRequest,
        VolunteerActivityUpdateRequest>,
        IVolunteerActivityService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;
        private readonly BaseVolunteerActivityState _baseState;
        private readonly BaseVolunteerAssignmentState _assignmentState;

        public VolunteerActivityService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<VolunteerActivityInsertRequest> insertValidator,
            IValidator<VolunteerActivityUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor,
            BaseVolunteerActivityState baseState,
            BaseVolunteerAssignmentState assignmentState)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
            _baseState = baseState;
            _assignmentState = assignmentState;
        }

        protected override IQueryable<VolunteerActivity> ApplyFilters(
            IQueryable<VolunteerActivity> query,
            VolunteerActivitySearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.Title))
            {
                query = query.Where(x =>
                    x.Title.Contains(search.Title));
            }

            if (search?.LocationId.HasValue == true)
            {
                query = query.Where(x =>
                    x.LocationId == search.LocationId.Value);
            }

            if (search?.Status.HasValue == true)
            {
                query = query.Where(x =>
                    x.Status == search.Status.Value);
            }

            if (search?.StartDateTimeFrom.HasValue == true)
            {
                query = query.Where(x =>
                    x.StartDateTime >= search.StartDateTimeFrom.Value);
            }

            if (search?.StartDateTimeTo.HasValue == true)
            {
                query = query.Where(x =>
                    x.StartDateTime <= search.StartDateTimeTo.Value);
            }

            return query;
        }
        protected override IQueryable<VolunteerActivity> ApplySorting(
            IQueryable<VolunteerActivity> query,
            VolunteerActivitySearchObject search)
        {
            switch (search.SortBy?.ToLower())
            {
                case "title":
                    return query.OrderBy(x => x.Title);

                case "date":
                    return query.OrderBy(x => x.StartDateTime);

                case "status":
                    return query.OrderBy(x => x.Status);

                case "location":
                    return query.OrderBy(x => x.Location.Name);

                default:
                    return query.OrderBy(x => x.ActivityId);
            }
        }

        protected override IQueryable<VolunteerActivity> Include(
            IQueryable<VolunteerActivity> query,
            VolunteerActivitySearchObject? search)
        {
            return query
                .Include(x => x.CreatedByUser)
                .Include(x => x.Location)
                .Include(x => x.VolunteerAssignments);
        }
         private async Task UpdateExpiredActivities()
            {
                var expiredActivities = await _dbContext.VolunteerActivities
                    .Include(x => x.VolunteerAssignments)
                    .Where(x =>
                        x.Status == ActivityStatus.Active &&
                        x.EndDateTime < DateTime.UtcNow)
                    .ToListAsync();

                foreach (var activity in expiredActivities)
                {
                    // Activity: Active -> Completed
                    var activityState = _baseState.GetState(
                        activity.Status);

                    await activityState.CompleteAsync(
                        activity.ActivityId);

                    foreach (var assignment in activity.VolunteerAssignments)
                    {
                        var assignmentState = _assignmentState.GetState(
                            assignment.Status);

                        if (assignment.Status == AssignmentStatus.Pending)
                        {
                            await assignmentState.RejectAsync(
                                assignment.AssignmentId,
                                "Activity has expired.");
                        }
                        else if (
                            assignment.Status == AssignmentStatus.Approved)
                        {
                            await assignmentState.CompleteAsync(
                                assignment.AssignmentId);
                        }
                    }
                }
            }
        public override async Task<PageResult<VolunteerActivityResponse>> GetAllAsync(
            VolunteerActivitySearchObject? search = null)
        {
            await UpdateExpiredActivities();

            return await base.GetAllAsync(search);
        }

        public override async Task<VolunteerActivityResponse> GetByIdAsync(int id)
        {
            await UpdateExpiredActivities();
            var entity = await _dbContext.Set<VolunteerActivity>()
                .Include(x => x.CreatedByUser)
                .Include(x => x.Location)
                .Include(x => x.VolunteerAssignments)
                .FirstOrDefaultAsync(x => x.ActivityId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Volunteer Activity with id {id} not found.");
            }

            return _mapper.Map<VolunteerActivityResponse>(entity);
        }

        public override async Task<VolunteerActivityResponse> InsertAsync(
            VolunteerActivityInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<VolunteerActivity>(request);

            entity.CreatedBy = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            entity.Status = ActivityStatus.Active;

            _dbContext.Set<VolunteerActivity>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<VolunteerActivityResponse>(entity);
        }
        public async Task<VolunteerActivityDetailsResponse> GetDetailsAsync(int id)
            {
                await UpdateExpiredActivities();
                var entity = await _dbContext.VolunteerActivities
                    .Include(x => x.Location)
                    .Include(x => x.CreatedByUser)
                    .Include(x => x.VolunteerAssignments)
                        .ThenInclude(x => x.User)
                    .FirstOrDefaultAsync(x => x.ActivityId == id);
                var currentUserId = _authenticatedUserAccessor.GetUserId();

                if (entity == null)
                {
                    throw new KeyNotFoundException(
                        $"Volunteer activity with id {id} not found.");
                }

                return new VolunteerActivityDetailsResponse
                {
                    ActivityId = entity.ActivityId,
                    Title = entity.Title,
                    Description = entity.Description,
                    LocationName = entity.Location.Name,
                    StartDateTime = entity.StartDateTime,
                    EndDateTime = entity.EndDateTime,
                    MaxVolunteers = entity.MaxVolunteers,
                    Status = entity.Status,
                    CreatedByUserName =
                        $"{entity.CreatedByUser.FirstName} {entity.CreatedByUser.LastName}",
                    IsApplied = entity.VolunteerAssignments.Any(x => x.UserId == currentUserId),

                    Assignments = entity.VolunteerAssignments
                        .Select(a => new VolunteerAssignmentResponse
                        {
                            AssignmentId = a.AssignmentId,
                            UserId = a.UserId,
                            UserName = $"{a.User.FirstName} {a.User.LastName}",
                            ActivityId = a.ActivityId,
                            ActivityTitle = entity.Title,
                            AppliedAt = a.AppliedAt,
                            ApplicationNote = a.ApplicationNote,
                            Status = a.Status,
                            HoursWorked = a.HoursWorked,
                            Email = a.User.Email,
                            PhoneNumber = a.User.PhoneNumber,
                            AdminResponseReason = a.AdminResponseReason
                        })
                        .ToList()
                };
            }

        public override async Task<VolunteerActivityResponse> UpdateAsync(
            int id,
            VolunteerActivityUpdateRequest request)
        {
            var activity = await _dbContext.VolunteerActivities
                .FirstOrDefaultAsync(x => x.ActivityId == id);


            if (activity == null)
            {
                throw new KeyNotFoundException(
                    $"Volunteer activity with id {id} not found.");
            }

           if (activity.Status != ActivityStatus.Active)
            {
                throw new Exception(
                    "Only active activities can be edited.");
            }

            return await base.UpdateAsync(id, request);
            

        }
        public override async Task DeleteAsync(int id)
        {
            await CancelAsync(id);
        }
        public async Task<VolunteerActivityResponse>
        CompleteAsync(int id)
        {
            var activity = await _dbContext.VolunteerActivities
                .FirstOrDefaultAsync(x => x.ActivityId == id);

            if (activity == null)
            {
                throw new KeyNotFoundException(
                    $"Volunteer activity with id {id} not found.");
            }

            var state = _baseState.GetState(activity.Status);

            return await state.CompleteAsync(id);
    }
    public async Task<VolunteerActivityResponse>
        CancelAsync(int id)
    {
        var activity = await _dbContext.VolunteerActivities
            .FirstOrDefaultAsync(x => x.ActivityId == id);

        if (activity == null)
        {
            throw new KeyNotFoundException(
                $"Volunteer activity with id {id} not found.");
        }

        var state = _baseState.GetState(activity.Status);

        return await state.CancelAsync(id);
    }

    }
}
