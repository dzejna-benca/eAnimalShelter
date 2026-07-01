using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    
    public class FavoriteService : BaseCRUDService<
        Favorite,
        FavoriteResponse,
        FavoriteSearchObject,
        FavoriteInsertRequest,
        FavoriteUpdateRequest>,
        IFavoriteService
    {
        private readonly IAuthenticatedUserAccessor _authenticatedUserAccessor;

        public FavoriteService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<FavoriteInsertRequest> insertValidator,
            IValidator<FavoriteUpdateRequest> updateValidator,
            IAuthenticatedUserAccessor authenticatedUserAccessor)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _authenticatedUserAccessor = authenticatedUserAccessor;
        }

        protected override IQueryable<Favorite> ApplyFilters(
            IQueryable<Favorite> query,
            FavoriteSearchObject? search)
        {
            // Filter by authenticated user's ID to show only their favorites
            var authenticatedUserId = _authenticatedUserAccessor.GetUserId();
            if (authenticatedUserId.HasValue)
            {
                query = query.Where(x => x.UserId == authenticatedUserId.Value);
            }

            if (search?.AnimalId.HasValue == true)
            {
                query = query.Where(x =>
                    x.AnimalId == search.AnimalId.Value);
            }

            if (search?.UserId.HasValue == true)
            {
                query = query.Where(x =>
                    x.UserId == search.UserId.Value);
            }

            return query;
        }

        protected override IQueryable<Favorite> Include(
            IQueryable<Favorite> query,
            FavoriteSearchObject? search)
        {
            return query.Include(x => x.Animal)
                            .ThenInclude(x=> x.Images)
                         .Include(x => x.Animal)
                            .ThenInclude(x=> x.Breed)
                         .Include(x => x.Animal)
                            .ThenInclude(x=> x.Species)
                        .Include(x => x.User);
        }

        public override async Task<FavoriteResponse> GetByIdAsync(int id)
        {
            var authenticatedUserId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            var entity = await _dbContext.Set<Favorite>()
                .Include(x => x.Animal)
                  .ThenInclude(x => x.Images)
                .Include(x => x.Animal)
                  .ThenInclude(x=> x.Breed)
                .Include(x => x.Animal)
                  .ThenInclude(x=> x.Species)
                .Include(x => x.User)
                .FirstOrDefaultAsync(x => x.FavoriteId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Favorite with id {id} not found.");
            }

            if (entity.UserId != authenticatedUserId)
            {
                throw new UnauthorizedAccessException(
                    "You do not have permission to view this favorite.");
            }

            return _mapper.Map<FavoriteResponse>(entity);
        }

        public override async Task<FavoriteResponse> InsertAsync(
            FavoriteInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<Favorite>(request);

            entity.UserId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            entity.DateAdded = DateTime.UtcNow;

            _dbContext.Set<Favorite>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<FavoriteResponse>(entity);
        }

        public override async Task<FavoriteResponse> UpdateAsync(int id, FavoriteUpdateRequest request)
        {
            var authenticatedUserId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            await _updateValidator.ValidateAndThrowAsync(request);

            var entity = await _dbContext.Set<Favorite>().FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Favorite with id {id} not found.");
            }

            if (entity.UserId != authenticatedUserId)
            {
                throw new UnauthorizedAccessException(
                    "You do not have permission to update this favorite.");
            }

            _mapper.Map(request, entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<FavoriteResponse>(entity);
        }

        public override async Task DeleteAsync(int id)
        {
            var authenticatedUserId = _authenticatedUserAccessor.GetUserId()
                ?? throw new UnauthorizedAccessException(
                    "Authenticated user not found.");

            var entity = await _dbContext.Set<Favorite>().FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Favorite with id {id} not found.");
            }

            if (entity.UserId != authenticatedUserId)
            {
                throw new UnauthorizedAccessException(
                    "You do not have permission to delete this favorite.");
            }

            _dbContext.Set<Favorite>().Remove(entity);

            await _dbContext.SaveChangesAsync();
        }
        public async Task ToggleFavoriteAsync(int animalId)
{
    var userId = _authenticatedUserAccessor.GetUserId()
        ?? throw new UnauthorizedAccessException(
            "Authenticated user not found.");

    var favorite = await _dbContext.Favorites
        .FirstOrDefaultAsync(x =>
            x.UserId == userId &&
            x.AnimalId == animalId);

    if (favorite != null)
    {
        _dbContext.Favorites.Remove(favorite);
    }
    else
    {
        _dbContext.Favorites.Add(new Favorite
        {
            UserId = userId,
            AnimalId = animalId,
            DateAdded = DateTime.UtcNow
        });
    }

    await _dbContext.SaveChangesAsync();
}

    public async Task<List<int>> GetMyFavoriteAnimalIdsAsync()
    {
        var userId = _authenticatedUserAccessor.GetUserId()
            ?? throw new UnauthorizedAccessException(
                "Authenticated user not found.");

        return await _dbContext.Favorites
            .Where(x => x.UserId == userId)
            .Select(x => x.AnimalId)
            .ToListAsync();
    }
    }
}
