using eAnimalShelter.Model;
using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace eAnimalShelter.Services
{
    public class AnimalService : BaseCRUDService<
        Animal,
        AnimalResponse,
        AnimalSearchObject,
        AnimalInsertRequest,
        AnimalUpdateRequest>,
        IAnimalService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;

        public AnimalService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<AnimalInsertRequest> insertValidator,
            IValidator<AnimalUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
        }

        protected override IQueryable<Animal> Include(
            IQueryable<Animal> query,
            AnimalSearchObject? search)
        {
            return query
                .Include(x => x.Species)
                .Include(x => x.Breed)
                .Include(x => x.CreatedByUser)
                .Include(x => x.Images);
        }

        protected override IQueryable<Animal> ApplyFilters(
            IQueryable<Animal> query,
            AnimalSearchObject? search)
        {
            if (search?.Gender.HasValue == true)
            {
                query = query.Where(x =>
                    x.Gender == search.Gender.Value);
            }

            if (search?.CreatedBy.HasValue == true)
            {
                query = query.Where(x => x.CreatedBy == search.CreatedBy.Value);
            }

            if (search?.ArrivalDateFrom.HasValue == true)
            {
                query = query.Where(x =>
                    x.ArrivalDate >= search.ArrivalDateFrom.Value);
            }

            if (search?.ArrivalDateTo.HasValue == true)
            {
                query = query.Where(x =>
                    x.ArrivalDate <= search.ArrivalDateTo.Value);
            }
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.Name));
            }

            if (search?.SpeciesId.HasValue == true)
            {
                query = query.Where(x =>
                    x.SpeciesId == search.SpeciesId);
            }

            if (search?.BreedId.HasValue == true)
            {
                query = query.Where(x =>
                    x.BreedId == search.BreedId);
            }

            if (search?.AdoptionStatus.HasValue == true)
            {
                query = query.Where(x =>
                    x.AdoptionStatus ==
                    search.AdoptionStatus.Value);
            }

            if (search?.IsVaccinated.HasValue == true)
            {
                query = query.Where(x =>
                    x.IsVaccinated ==
                    search.IsVaccinated.Value);
            }
            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                switch (search.SortBy)
                {
                    case "name_asc":
                        query = query.OrderBy(x => x.Name);
                        break;

                    case "name_desc":
                        query = query.OrderByDescending(x => x.Name);
                        break;

                    case "arrival_desc":
                        query = query.OrderByDescending(x => x.ArrivalDate);
                        break;

                    case "arrival_asc":
                        query = query.OrderBy(x => x.ArrivalDate);
                        break;
                }
            }
            return query;
        }

        public override async Task<AnimalResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<Animal>()
                .Include(x => x.Species)
                .Include(x => x.Breed)
                .Include(x => x.CreatedByUser)
                .Include(x => x.Images)
                .FirstOrDefaultAsync(x => x.AnimalId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Animal with id {id} not found.");
            }

           return _mapper.Map<AnimalResponse>(entity);
        }

        public override async Task<AnimalResponse> InsertAsync(
            AnimalInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<Animal>(request);

            entity.CreatedBy =
                _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException();

            _dbContext.Set<Animal>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return await GetByIdAsync(entity.AnimalId);
        }

        public override async Task<AnimalResponse> UpdateAsync(
            int id,
            AnimalUpdateRequest request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            var entity = await _dbContext.Set<Animal>()
                .FirstOrDefaultAsync(x => x.AnimalId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Animal with id {id} not found.");
            }

            entity.Name = request.Name;
            entity.SpeciesId = request.SpeciesId;
            entity.BreedId = request.BreedId;
            entity.Gender = request.Gender;
            entity.BirthDate = request.BirthDate;
            entity.Description = request.Description;
            entity.PersonalityDescription = request.PersonalityDescription;
            entity.HealthStatus = request.HealthStatus;
            entity.IsVaccinated = request.IsVaccinated;
            entity.MedicalNotes = request.MedicalNotes;
            entity.ArrivalDate = request.ArrivalDate;
            entity.AdoptionStatus = request.AdoptionStatus;

            await _dbContext.SaveChangesAsync();

            return await GetByIdAsync(id);
        }
        public override async Task DeleteAsync(int id)
        {
            var animal = await _dbContext.Animals
                .FirstOrDefaultAsync(x => x.AnimalId == id);

            if (animal == null)
            {
                throw new KeyNotFoundException(
                    $"Animal with id {id} not found.");
            }

            animal.AdoptionStatus = AnimalStatus.Archived;

            await _dbContext.SaveChangesAsync();
        }
    }
}