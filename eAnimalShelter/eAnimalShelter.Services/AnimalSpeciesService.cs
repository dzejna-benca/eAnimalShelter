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
    public class AnimalSpeciesService : BaseCRUDService<
        AnimalSpecies,
        AnimalSpeciesResponse,
        AnimalSpeciesSearchObject,
        AnimalSpeciesInsertRequest,
        AnimalSpeciesUpdateRequest>,
        IAnimalSpeciesService
    {
        public AnimalSpeciesService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<AnimalSpeciesInsertRequest> insertValidator,
            IValidator<AnimalSpeciesUpdateRequest> updateValidator)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
        }

        protected override IQueryable<AnimalSpecies> ApplyFilters(
            IQueryable<AnimalSpecies> query,
            AnimalSpeciesSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.SpeciesName))
            {
                query = query.Where(x =>
                    x.SpeciesName.Contains(search.SpeciesName));
            }

            return query;
        }

        protected override IQueryable<AnimalSpecies> Include(
            IQueryable<AnimalSpecies> query,
            AnimalSpeciesSearchObject? search)
        {
            return query;
        }

        public override async Task<AnimalSpeciesResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<AnimalSpecies>()
                .FirstOrDefaultAsync(x => x.SpeciesId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"AnimalSpecies with id {id} not found.");
            }

            return _mapper.Map<AnimalSpeciesResponse>(entity);
        }
        public override async Task<AnimalSpeciesResponse> InsertAsync(
            AnimalSpeciesInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var exists = await _dbContext.AnimalSpecies.AnyAsync(x =>
            x.SpeciesName.ToLower() == request.SpeciesName.Trim().ToLower());

        if (exists)
        {
            throw new ClientException(
                $"Species '{request.SpeciesName}' already exists.");
        }

            return await base.InsertAsync(request);
        }
    }
}
