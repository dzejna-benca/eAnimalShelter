using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IUserService
        : IBaseCRUDService<
            UserResponse,
            UserSearchObject,
            UserInsertRequest,
            AdminUserUpdateRequest>
    {
        Task<UserSensitiveResponse?> GetByUsernameAsync(string username);

        Task<UserResponse?> GetWithRoleByIdAsync(int id);
        Task ChangePasswordAsync(int userId,UserPasswordChangeRequest request);
        Task<UserResponse> RegisterAsync(RegisterRequest request);
        Task<UserResponse> UpdateProfileAsync(int id,ProfileUpdateRequest request);
    }
}