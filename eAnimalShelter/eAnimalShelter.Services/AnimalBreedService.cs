using eAnimalShelter.Model.Exceptions;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class AnimalBreedService : BaseCRUDService<
        AnimalBreed,
        AnimalBreedResponse,
        AnimalBreedSearchObject,
        AnimalBreedInsertRequest,
        AnimalBreedUpdateRequest>,
        IAnimalBreedService
    {
        public AnimalBreedService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<AnimalBreedInsertRequest> insertValidator,
            IValidator<AnimalBreedUpdateRequest> updateValidator)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
        }

        protected override IQueryable<AnimalBreed> ApplyFilters(
            IQueryable<AnimalBreed> query,
            AnimalBreedSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.BreedName))
            {
                query = query.Where(x =>
                    x.BreedName.Contains(search.BreedName));
            }

            if (search?.SpeciesId.HasValue == true)
            {
                query = query.Where(x =>
                    x.SpeciesId == search.SpeciesId.Value);
            }

            return query;
        }

        protected override IQueryable<AnimalBreed> Include(
        IQueryable<AnimalBreed> query,
        AnimalBreedSearchObject? search)
        {
            return query.Include(x => x.Species);
        }

        public override async Task<AnimalBreedResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<AnimalBreed>()
                .Include(x => x.Species)
                .FirstOrDefaultAsync(x => x.BreedId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"AnimalBreed with id {id} not found.");
            }

            return _mapper.Map<AnimalBreedResponse>(entity);
        }
        public override async Task<AnimalBreedResponse> InsertAsync(
            AnimalBreedInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            bool exists = await _dbContext.AnimalBreeds.AnyAsync(x =>
                x.SpeciesId == request.SpeciesId &&
                x.BreedName.ToLower() == request.BreedName.Trim().ToLower());

            if (exists)
            {
                throw new ClientException(
                    "Breed already exists for the selected species.");
            }

            return await base.InsertAsync(request);
        }
    }
}