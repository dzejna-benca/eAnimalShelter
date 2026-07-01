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
    public class LocationService : BaseCRUDService<
        Location,
        LocationResponse,
        LocationSearchObject,
        LocationInsertRequest,
        LocationUpdateRequest>,
        ILocationService
    {
        public LocationService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<LocationInsertRequest> insertValidator,
            IValidator<LocationUpdateRequest> updateValidator)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
        }

        protected override IQueryable<Location> ApplyFilters(
            IQueryable<Location> query,
            LocationSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.Name));
            }

            return query;
        }

        protected override IQueryable<Location> Include(
            IQueryable<Location> query,
            LocationSearchObject? search)
        {
            return query;
        }

        public override async Task<LocationResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<Location>()
                .FirstOrDefaultAsync(x => x.LocationId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Location with id {id} not found.");
            }

            return _mapper.Map<LocationResponse>(entity);
        }

        public override async Task<LocationResponse> InsertAsync(
            LocationInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var exists = await _dbContext.Locations.AnyAsync(x =>
                x.Name.ToLower() == request.Name.Trim().ToLower());

            if (exists)
            {
                throw new ClientException(
                    $"Location '{request.Name}' already exists.");
            }

            var entity = _mapper.Map<Location>(request);

            _dbContext.Set<Location>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<LocationResponse>(entity);
        }
    }
}
