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
    public class VolunteerAssignmentService : BaseCRUDService<
        VolunteerAssignment,
        VolunteerAssignmentResponse,
        VolunteerAssignmentSearchObject,
        VolunteerAssignmentInsertRequest,
        VolunteerAssignmentUpdateRequest>,
        IVolunteerAssignmentService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;
        private readonly BaseVolunteerAssignmentState _baseState;

        public VolunteerAssignmentService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<VolunteerAssignmentInsertRequest> insertValidator,
            IValidator<VolunteerAssignmentUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor,
            BaseVolunteerAssignmentState baseState)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
            _baseState = baseState;
        }

        protected override IQueryable<VolunteerAssignment> ApplyFilters(
            IQueryable<VolunteerAssignment> query,
            VolunteerAssignmentSearchObject? search)
        {
            // If user is not an Admin, they can only see their own assignments
            if (!_authenticatedUserAccessor.IsInRole("Admin"))
            {
                var currentUserId = _authenticatedUserAccessor.GetUserId()
                    ?? throw new UnauthorizedAccessException("Authenticated user not found.");
                query = query.Where(x => x.UserId == currentUserId);
            }

            if (search?.UserId.HasValue == true)
            {
                query = query.Where(x =>
                    x.UserId == search.UserId.Value);
            }

            if (search?.ActivityId.HasValue == true)
            {
                query = query.Where(x =>
                    x.ActivityId == search.ActivityId.Value);
            }

            if (search?.Status.HasValue == true)
            {
                query = query.Where(x =>
                    x.Status == search.Status.Value);
            }

            return query;
        }

        protected override IQueryable<VolunteerAssignment> Include(
            IQueryable<VolunteerAssignment> query,
            VolunteerAssignmentSearchObject? search)
        {
            return query
                .Include(x => x.User)
                .Include(x => x.Activity);
        }

        public override async Task<VolunteerAssignmentResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<VolunteerAssignment>()
                .Include(x => x.User)
                .Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Volunteer Assignment with id {id} not found.");
            }

            // If user is not an Admin, they can only view their own assignment
            if (!_authenticatedUserAccessor.IsInRole("Admin"))
            {
                var currentUserId = _authenticatedUserAccessor.GetUserId()
                    ?? throw new UnauthorizedAccessException("Authenticated user not found.");
                
                if (entity.UserId != currentUserId)
                {
                    throw new UnauthorizedAccessException(
                        "You do not have permission to view this assignment.");
                }
            }

            return _mapper.Map<VolunteerAssignmentResponse>(entity);
        }

        public override async Task<VolunteerAssignmentResponse> InsertAsync(
            VolunteerAssignmentInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var userId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            var alreadyApplied = await _dbContext.VolunteerAssignments
                .AnyAsync(x =>
                    x.UserId == userId &&
                    x.ActivityId == request.ActivityId);

            if (alreadyApplied)
            {
                throw new Exception(
                    "You have already applied for this activity.");
            }

            var entity = _mapper.Map<VolunteerAssignment>(request);

            entity.UserId = userId;
            entity.AppliedAt = DateTime.UtcNow;
            entity.Status = AssignmentStatus.Pending;
            entity.HoursWorked = 0;

            _dbContext.VolunteerAssignments.Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<VolunteerAssignmentResponse>(entity);
        }
        public override async Task<VolunteerAssignmentResponse> UpdateAsync(
            int id,
            VolunteerAssignmentUpdateRequest request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            var assignment = await _dbContext.VolunteerAssignments
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
            {
                throw new KeyNotFoundException(
                    $"Volunteer assignment with id {id} not found.");
            }

            assignment.ApplicationNote = request.ApplicationNote;
            assignment.HoursWorked = request.HoursWorked;

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<VolunteerAssignmentResponse>(assignment);
        }
        public async Task<VolunteerAssignmentResponse> ApproveAsync(
            int id,
            string reason)
        {
            var assignment = await _dbContext.VolunteerAssignments.Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException(
                    $"Volunteer assignment with id {id} not found.");

            var state = _baseState.GetState(
                assignment.Status);

            return await state.ApproveAsync(id, reason);
        }
        public async Task<VolunteerAssignmentResponse> RejectAsync(
            int id,
            string reason)
        {
            var assignment = await _dbContext.VolunteerAssignments.Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException(
                    $"Volunteer assignment with id {id} not found.");

            var state = _baseState.GetState(
                assignment.Status);

            return await state.RejectAsync(id, reason);
        }
        public async Task<VolunteerAssignmentResponse> CancelAsync(
            int id)
        {
            var assignment = await _dbContext.VolunteerAssignments.Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException(
                    $"Volunteer assignment with id {id} not found.");

            var state = _baseState.GetState(
                assignment.Status);

            return await state.CancelAsync(id);
        }
        public async Task<VolunteerAssignmentResponse> CompleteAsync(
            int id)
        {
            var assignment = await _dbContext.VolunteerAssignments.Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException(
                    $"Volunteer assignment with id {id} not found.");

            var state = _baseState.GetState(
                assignment.Status);

            return await state.CompleteAsync(id);
        }
    }
}
