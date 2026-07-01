using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using eAnimalShelter.Services.AdoptionRequestStateMachine;

namespace eAnimalShelter.Services
{
    public class AdoptionRequestService : BaseCRUDService<
        AdoptionRequest,
        AdoptionRequestResponse,
        AdoptionRequestSearchObject,
        AdoptionRequestInsertRequest,
        AdoptionRequestUpdateRequest>,
        IAdoptionRequestService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;
        private readonly BaseAdoptionRequestState _baseState;

        public AdoptionRequestService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<AdoptionRequestInsertRequest> insertValidator,
            IValidator<AdoptionRequestUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor,
            BaseAdoptionRequestState baseState)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
            _baseState = baseState;
        }

        protected override IQueryable<AdoptionRequest> ApplyFilters(
            IQueryable<AdoptionRequest> query,
            AdoptionRequestSearchObject? search)
        {
            var userId = _authenticatedUserAccessor.GetUserId();
            var isAdmin = _authenticatedUserAccessor.IsInRole("Admin");

            // Clients can only see their own requests, admins can see all
            if (!isAdmin && userId.HasValue)
            {
                query = query.Where(x => x.UserId == userId.Value);
            }

            if (search?.AnimalId.HasValue == true)
            {
                query = query.Where(x => x.AnimalId == search.AnimalId.Value);
            }

            if (search?.UserId.HasValue == true && isAdmin)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            if (search?.Status.HasValue == true)
            {
                query = query.Where(x => x.Status == search.Status.Value);
            }

            if (search?.RequestDateFrom.HasValue == true)
            {
                query = query.Where(x =>
                    x.RequestDate >= search.RequestDateFrom.Value);
            }

            if (search?.RequestDateTo.HasValue == true)
            {
                query = query.Where(x =>
                    x.RequestDate <= search.RequestDateTo.Value);
            }
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x =>
                    x.User.Username.Contains(search.FTS) ||
                    x.Animal.Name.Contains(search.FTS));
            }

            return query;
        }
        protected override IQueryable<AdoptionRequest> ApplySorting(
            IQueryable<AdoptionRequest> query,
            AdoptionRequestSearchObject search)
        {
            return search.SortBy?.ToLower() switch
            {
                "date_asc" => query.OrderBy(x => x.RequestDate),
                "date_desc" => query.OrderByDescending(x => x.RequestDate),

                "name_asc" => query.OrderBy(x => x.User.FirstName),
                "name_desc" => query.OrderByDescending(x => x.User.FirstName),

                "animal_asc" => query.OrderBy(x => x.Animal.Name),
                "animal_desc" => query.OrderByDescending(x => x.Animal.Name),

                "status_asc" => query.OrderBy(x => x.Status),
                "status_desc" => query.OrderByDescending(x => x.Status),

                _ => query.OrderByDescending(x => x.RequestDate)
            };
        }

        protected override IQueryable<AdoptionRequest> Include(
            IQueryable<AdoptionRequest> query,
            AdoptionRequestSearchObject? search)
        {
            return query
                .Include(x => x.User)
                .Include(x => x.Animal)
                  .ThenInclude(x => x.Species)
                .Include(x => x.Animal)
                  .ThenInclude(x => x.Breed)
                .Include(x => x.Animal)
                  .ThenInclude(x  => x.Images)
                .Include(x => x.Reviewer);
        }

        public override async Task<AdoptionRequestResponse> GetByIdAsync(int id)
        {
            var userId = _authenticatedUserAccessor.GetUserId();
            var isAdmin = _authenticatedUserAccessor.IsInRole("Admin");

            var entity = await _dbContext.Set<AdoptionRequest>()
                .Include(x => x.User)
                .Include(x => x.Animal)
                  .ThenInclude(x => x.Species)
                .Include(x => x.Animal)
                  .ThenInclude(x => x.Breed)
                .Include(x => x.Animal)
                  .ThenInclude(x  => x.Images)
                .Include(x => x.Reviewer)
                .FirstOrDefaultAsync(x => x.AdoptionRequestId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption Request with id {id} not found.");
            }

            // Clients can only view their own requests
            if (!isAdmin && userId.HasValue && entity.UserId != userId.Value)
            {
                throw new UnauthorizedAccessException(
                    "You do not have permission to view this adoption request.");
            }

            return _mapper.Map<AdoptionRequestResponse>(entity);
        }

        public override async Task<AdoptionRequestResponse> InsertAsync(
            AdoptionRequestInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<AdoptionRequest>(request);

            entity.UserId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            entity.RequestDate = DateTime.UtcNow;
            entity.Status = Model.Enums.AdoptionRequestStatus.Pending;

            _dbContext.Set<AdoptionRequest>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<AdoptionRequestResponse>(entity);
        }
        public override async Task DeleteAsync(int id)
        {
            var entity = await _dbContext.AdoptionRequests
                .FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption request with ID {id} was not found.");
            }

            var state = _baseState.GetState(entity.Status);

            await state.CancelAsync(id);
        }

       public override async Task<AdoptionRequestResponse> UpdateAsync(
            int id,
            AdoptionRequestUpdateRequest request)
        {
            var userId = _authenticatedUserAccessor.GetUserId();
            var isAdmin = _authenticatedUserAccessor.IsInRole("Admin");


            var entity = await _dbContext.Set<AdoptionRequest>()
                .FindAsync(id);
            if (isAdmin)
            {
                throw new InvalidOperationException(
                    "Admins must use approve/reject actions.");
            }

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption request with ID {id} was not found.");
            }

        
           
            if (!userId.HasValue)
                {
                    throw new UnauthorizedAccessException(
                        "You must be authenticated to update an adoption request.");
                }

                if (entity.UserId != userId.Value)
                {
                    throw new UnauthorizedAccessException(
                        "You can only update your own adoption requests.");
                }

                // zabrani izmjene nakon što je zahtjev obrađen
                if (entity.Status != Model.Enums.AdoptionRequestStatus.Pending)
                {
                    throw new InvalidOperationException(
                        $"This adoption request cannot be modified because its status is '{entity.Status}'.");
                }

                entity.HousingType = request.HousingType;
                entity.ExperienceWithPets = request.ExperienceWithPets;
                entity.HouseholdMembers = request.HouseholdMembers;
                entity.AdditionalNotes = request.AdditionalNotes;

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<AdoptionRequestResponse>(entity);
        }
        public async Task<AdoptionRequestResponse>
            ApproveAsync(int id, string? adminComment)
        {
            var entity = await _dbContext.AdoptionRequests
                .FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption request with ID {id} was not found.");
            }

            entity.AdminComment = adminComment;

            entity.ReviewedBy =
                _authenticatedUserAccessor.GetUserId();

            entity.ReviewDate = DateTime.UtcNow;

            var state = _baseState.GetState(entity.Status);

            return await state.ApproveAsync(id);
        }
        public async Task<AdoptionRequestResponse>
            RejectAsync(int id, string? adminComment)
        {
            var entity = await _dbContext.AdoptionRequests
                .FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption request with ID {id} was not found.");
            }

            entity.AdminComment = adminComment;

            entity.ReviewedBy =
                _authenticatedUserAccessor.GetUserId();

            entity.ReviewDate = DateTime.UtcNow;

            var state = _baseState.GetState(entity.Status);

            return await state.RejectAsync(id);
        }
        public async Task<AdoptionRequestResponse>
            CancelAsync(int id)
        {
            var entity = await _dbContext.AdoptionRequests
                .FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Adoption request with ID {id} was not found.");
            }

            var state = _baseState.GetState(entity.Status);

            return await state.CancelAsync(id);
        }
    }
}
