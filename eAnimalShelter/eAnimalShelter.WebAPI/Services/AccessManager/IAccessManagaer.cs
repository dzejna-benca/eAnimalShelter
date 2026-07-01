using eAnimalShelter.Model.Access;

namespace eAnimalShelter.WebAPI.Services.AccessManager
{
    public interface IAccessManager
    {
        Task<UserLoginResponse> LoginAsync(
            UserLoginRequest request);

        Task<UserLoginResponse> LoginWithRefreshTokenAsync(
            RefreshAccessTokenRequest request);
    }
}