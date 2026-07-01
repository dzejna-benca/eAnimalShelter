using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class RoleService : BaseCRUDService<
        Role,
        RoleResponse,
        RoleSearchObject,
        RoleInsertRequest,
        RoleUpdateRequest>,
        IRoleService
    {
        public RoleService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<RoleInsertRequest> insertValidator,
            IValidator<RoleUpdateRequest> updateValidator)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
        }

        protected override IQueryable<Role> ApplyFilters(
            IQueryable<Role> query,
            RoleSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.Name));
            }

            if (search?.IsActive.HasValue == true)
            {
                query = query.Where(x =>
                    x.IsActive == search.IsActive.Value);
            }

            return query;
        }

        protected override IQueryable<Role> Include(
            IQueryable<Role> query,
            RoleSearchObject? search)
        {
            return query;
        }

        public override async Task<RoleResponse> GetByIdAsync(int id)
        {
            var entity = await _dbContext.Set<Role>()
                .FirstOrDefaultAsync(x => x.Id == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"Role with id {id} not found.");
            }

            return _mapper.Map<RoleResponse>(entity);
        }

        public override async Task<RoleResponse> InsertAsync(
            RoleInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            var entity = _mapper.Map<Role>(request);

            _dbContext.Set<Role>().Add(entity);

            await _dbContext.SaveChangesAsync();

            return _mapper.Map<RoleResponse>(entity);
        }
    }
}
