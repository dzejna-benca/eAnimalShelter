using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class AnimalImageService : BaseCRUDService<
        AnimalImage,
        AnimalImageResponse,
        AnimalImageSearchObject,
        AnimalImageInsertRequest,
        AnimalImageUpdateRequest>,
        IAnimalImageService
    {
        public AnimalImageService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<AnimalImageInsertRequest> insertValidator,
            IValidator<AnimalImageUpdateRequest> updateValidator)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
        }

        protected override IQueryable<AnimalImage> Include(
            IQueryable<AnimalImage> query,
            AnimalImageSearchObject? search)
        {
            return query.Include(x => x.Animal);
        }

        protected override IQueryable<AnimalImage> ApplyFilters(
            IQueryable<AnimalImage> query,
            AnimalImageSearchObject? search)
        {
            if (search?.AnimalId.HasValue == true)
            {
                query = query.Where(x =>
                    x.AnimalId == search.AnimalId.Value);
            }

            if (search?.DateAddedFrom.HasValue == true)
            {
                query = query.Where(x =>
                    x.DateAdded >= search.DateAddedFrom.Value);
            }

            if (search?.DateAddedTo.HasValue == true)
            {
                query = query.Where(x =>
                    x.DateAdded <= search.DateAddedTo.Value);
            }

            return query;
        }

        public override async Task<AnimalImageResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<AnimalImage>()
                .Include(x => x.Animal)
                .FirstOrDefaultAsync(x => x.ImageId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Animal image with id {id} not found.");
            }

            return _mapper.Map<AnimalImageResponse>(entity);
        }

        public override async Task<AnimalImageResponse> InsertAsync(
            AnimalImageInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<AnimalImage>(request);

            entity.DateAdded = DateTime.UtcNow;

            _dbContext.Set<AnimalImage>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return await GetByIdAsync(entity.ImageId);
        }
    }
}