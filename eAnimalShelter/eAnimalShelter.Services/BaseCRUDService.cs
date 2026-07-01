using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;

namespace eAnimalShelter.Services
{
    public abstract class BaseCRUDService
        <TEntity, TResponse, TSearch, TInsert, TUpdate>
        : BaseReadService<TEntity, TResponse, TSearch>,
          IBaseCRUDService<TResponse, TSearch, TInsert, TUpdate>
        where TEntity : class
        where TSearch : BaseSearchObject
    {
        protected readonly IValidator<TInsert> _insertValidator;
        protected readonly IValidator<TUpdate> _updateValidator;

        protected BaseCRUDService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<TInsert> insertValidator,
            IValidator<TUpdate> updateValidator)
            : base(dbContext, mapper)
        {
            _insertValidator = insertValidator;
            _updateValidator = updateValidator;
        }

        public virtual async Task<TResponse> InsertAsync(TInsert request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<TEntity>(request);

            _dbContext.Set<TEntity>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<TResponse>(entity);
        }

        public virtual async Task<TResponse> UpdateAsync(int id, TUpdate request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            var entity = await _dbContext.Set<TEntity>().FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"{typeof(TEntity).Name} with id {id} not found.");
            }

            _mapper.Map(request, entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<TResponse>(entity);
        }

        public virtual async Task DeleteAsync(int id)
        {
            var entity = await _dbContext.Set<TEntity>().FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"{typeof(TEntity).Name} with id {id} not found.");
            }

            _dbContext.Set<TEntity>().Remove(entity);

            await _dbContext.SaveChangesAsync();
        }
    }
}