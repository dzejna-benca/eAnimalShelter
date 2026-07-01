using eAnimalShelter.Model;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public abstract class BaseReadService<TEntity, TResponse, TSearch>
        : IBaseReadService<TResponse, TSearch>
        where TEntity : class
        where TSearch : BaseSearchObject
    {
        protected readonly eAnimalShelterDbContext _dbContext;
        protected readonly MapsterMapper.IMapper _mapper;

        protected BaseReadService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        protected abstract IQueryable<TEntity> ApplyFilters(
            IQueryable<TEntity> query,
            TSearch? search);

        protected virtual IQueryable<TEntity> Include(
            IQueryable<TEntity> query,
            TSearch? search)
        {
            return query;
        }
        protected virtual IQueryable<TEntity> ApplySorting(
            IQueryable<TEntity> query,
            TSearch search)
        {
            return query;
        }

        public virtual async Task<PageResult<TResponse>> GetAllAsync(TSearch? search = null)
        {
            search ??= Activator.CreateInstance<TSearch>();

            IQueryable<TEntity> query = _dbContext.Set<TEntity>();

            query = Include(query, search);

            query = ApplyFilters(query, search);
            query = ApplySorting(query, search);

            int? totalCount = null;

            if (search.IncludeTotalCount)
            {
                totalCount = await query.CountAsync();
            }

            if (search.Page.HasValue && search.PageSize.HasValue)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var entities = await query.ToListAsync();

            return new PageResult<TResponse>
            {
                Items = _mapper.Map<List<TResponse>>(entities),
                TotalCount = totalCount
            };
        }

        public virtual async Task<TResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<TEntity>().FindAsync(id);

            if (entity == null)
                throw new KeyNotFoundException();

            return _mapper.Map<TResponse>(entity);
        }
    }
}