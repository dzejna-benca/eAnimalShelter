using eAnimalShelter.Common.Services.CryptoService;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class UserService : BaseCRUDService<
        User,
        UserResponse,
        UserSearchObject,
        UserInsertRequest,
        UserUpdateRequest>,
        IUserService
    {
        private readonly ICryptoService _cryptoService;

        public UserService(
            eAnimalShelterDbContext dbContext,
            MapsterMapper.IMapper mapper,
            IValidator<UserInsertRequest> insertValidator,
            IValidator<UserUpdateRequest> updateValidator,
            ICryptoService cryptoService)
            : base(
                dbContext,
                mapper,
                insertValidator,
                updateValidator)
        {
            _cryptoService = cryptoService;
        }

        protected override IQueryable<User> ApplyFilters(
            IQueryable<User> query,
            UserSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.Username))
            {
                query = query.Where(x =>
                    x.Username.Contains(search.Username));
            }

            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                query = query.Where(x =>
                    x.Email.Contains(search.Email));
            }
            if (!string.IsNullOrWhiteSpace(search?.Role))
            {
                query = query.Where(x =>
                    x.UserRoles.Any(r =>
                        r.Role.Name == search.Role));
            }

            if (search?.IsActive != null)
            {
                query = query.Where(x =>
                    x.IsActive == search.IsActive);
            }
           if(!string.IsNullOrWhiteSpace(search?.FullName))
            {
                query = query.Where(x =>
                    (x.FirstName + " " + x.LastName)
                    .Contains(search.FullName));
            }


            return query;
        }

        protected virtual User MapInsertRequestToEntity(
            UserInsertRequest request)
        {
            var entity = _mapper.Map<User>(request);

            var salt = _cryptoService.GenerateSalt();

            entity.PasswordSalt = salt;
            entity.PasswordHash =
                _cryptoService.GenerateHash(
                    request.Password,
                    salt);

            return entity;
        }

        private async Task AssignRoleAsync(
            int userId,
            int roleId)
        {
            _dbContext.UserRoles.Add(
                new UserRole
                {
                    UserId = userId,
                    RoleId = roleId
                });

            await _dbContext.SaveChangesAsync();
        }
        public override async Task<UserResponse> InsertAsync(
            UserInsertRequest request)
        {
            await _insertValidator.ValidateAndThrowAsync(request);

            if (await _dbContext.Users.AnyAsync(x =>
                x.Username == request.Username))
            {
                throw new InvalidOperationException(
                    $"Username '{request.Username}' already exists.");
            }

            if (await _dbContext.Users.AnyAsync(x =>
                x.Email == request.Email))
            {
                throw new InvalidOperationException(
                    $"Email '{request.Email}' already exists.");
            }

            var role = await _dbContext.Roles
                .FirstOrDefaultAsync(x => x.Id == request.RoleId);

            if (role == null)
            {
                throw new InvalidOperationException(
                    "Selected role does not exist.");
            }

            var entity = MapInsertRequestToEntity(request);

           _dbContext.Users.Add(entity);

            await _dbContext.SaveChangesAsync();

            await AssignRoleAsync(
                entity.UserId,
                request.RoleId);

            return await GetByIdAsync(entity.UserId);
        }
        private async Task UpdateRoleAsync(
            int userId,
            int roleId)
        {
            var existingRole =
                await _dbContext.UserRoles
                    .FirstOrDefaultAsync(x =>
                        x.UserId == userId);

            if (existingRole != null)
            {
                existingRole.RoleId = roleId;
            }
            else
            {
                _dbContext.UserRoles.Add(
                    new UserRole
                    {
                        UserId = userId,
                        RoleId = roleId
                    });
            }

            await _dbContext.SaveChangesAsync();
        }
       public override async Task<UserResponse> UpdateAsync(
            int id,
            UserUpdateRequest request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);

            var entity = await _dbContext.Users
                .Include(x => x.UserRoles)
                .FirstOrDefaultAsync(x => x.UserId == id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"User with id {id} not found.");
            }

            if (await _dbContext.Users.AnyAsync(x =>
                x.Email == request.Email &&
                x.UserId != id))
            {
                throw new InvalidOperationException(
                    $"Email '{request.Email}' already exists.");
            }

            var role = await _dbContext.Roles
                .FirstOrDefaultAsync(x => x.Id == request.RoleId);

            if (role == null)
            {
                throw new InvalidOperationException(
                    "Selected role does not exist.");
            }

            _mapper.Map(request, entity);

            await UpdateRoleAsync(
                entity.UserId,
                request.RoleId);

            await _dbContext.SaveChangesAsync();

            return await GetByIdAsync(entity.UserId);
        }

        public override async Task DeleteAsync(int id)
        {
            var entity = await _dbContext.Users.FindAsync(id);

            if (entity == null)
            {
                throw new KeyNotFoundException(
                    $"User with id {id} not found.");
            }

            _dbContext.Users.Remove(entity);

            await _dbContext.SaveChangesAsync();
        }

        public async Task<UserSensitiveResponse?> GetByUsernameAsync(
            string username)
        {
            var user = await _dbContext.Users
                .AsNoTracking()
                .Include(x => x.UserRoles)
                .ThenInclude(x => x.Role)
                .FirstOrDefaultAsync(x => x.Username == username);

            if (user == null)
                return null;

            var response = _mapper.Map<UserSensitiveResponse>(user);

            response.Role =
                user.UserRoles.FirstOrDefault()?.Role.Name;

            response.RoleId =
                user.UserRoles.FirstOrDefault()?.RoleId;

            return response;
        }
        public async Task<UserResponse?> GetWithRoleByIdAsync(int id)
        {
            var user = await _dbContext.Users
                .AsNoTracking()
                .Include(x => x.UserRoles)
                .ThenInclude(x => x.Role)
                .FirstOrDefaultAsync(x => x.UserId == id);

            if (user == null)
                return null;

            var response = _mapper.Map<UserResponse>(user);

            response.Role =
                user.UserRoles.FirstOrDefault()?.Role.Name;

            response.RoleId =
                user.UserRoles.FirstOrDefault()?.RoleId;

            return response;
        }
        public override async Task<UserResponse> GetByIdAsync(int id)
        {
            var user = await _dbContext.Users
                .AsNoTracking()
                .Include(x => x.UserRoles)
                .ThenInclude(x => x.Role)
                .FirstOrDefaultAsync(x => x.UserId == id);

            if (user == null)
            {
                throw new KeyNotFoundException(
                    $"User with id {id} not found.");
            }

            var response = _mapper.Map<UserResponse>(user);

            response.Role =
                user.UserRoles.FirstOrDefault()?.Role.Name;

            response.RoleId =
                user.UserRoles.FirstOrDefault()?.RoleId;

            return response;
        }
       public override async Task<PageResult<UserResponse>> GetAllAsync(
            UserSearchObject search)
        {
            IQueryable<User> query = _dbContext.Users
                .AsNoTracking()
                .Include(x => x.UserRoles)
                .ThenInclude(x => x.Role);

            query = ApplyFilters(query, search);

            var totalCount = await query.CountAsync();

            query = query
                .Skip(
                    ((search.Page ?? 1) - 1)
                    * (search.PageSize ?? 10))
                .Take(search.PageSize ?? 10);

            var list = await query.ToListAsync();

            var result = list.Select(user =>
            {
                var response = _mapper.Map<UserResponse>(user);

                response.Role = user.UserRoles .FirstOrDefault()?.Role.Name;
                response.RoleId = user.UserRoles.FirstOrDefault()?.RoleId;

                return response;
            }).ToList();

            return new PageResult<UserResponse>
            {
                Items = result,
                TotalCount = totalCount
            };
        }
        public async Task ChangePasswordAsync(
            int userId,
            UserPasswordChangeRequest request)
        {
            var user = await _dbContext.Users
                .FirstOrDefaultAsync(x => x.UserId == userId);

            if (user == null)
            {
                throw new KeyNotFoundException("User not found.");
            }

            if (!_cryptoService.Verify(
                    user.PasswordHash,
                    user.PasswordSalt,
                    request.Password))
            {
                throw new Exception("Current password is incorrect.");
            }

            if (request.NewPassword != request.ConfirmNewPassword)
            {
                throw new Exception(
                    "Password confirmation does not match.");
            }

            var salt = _cryptoService.GenerateSalt();

            user.PasswordSalt = salt;
            user.PasswordHash =
                _cryptoService.GenerateHash(
                    request.NewPassword,
                    salt);

            await _dbContext.SaveChangesAsync();
        }
    }
}