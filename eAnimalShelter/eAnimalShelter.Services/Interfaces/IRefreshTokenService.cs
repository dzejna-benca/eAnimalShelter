using eAnimalShelter.Services.Database;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IRefreshTokenService
    {
        Task<RefreshToken> GetStoredTokenAsync(string refreshToken);

        Task InsertAsync(RefreshToken refreshToken);

        Task DeleteAllUserRefreshTokensAsync(int userId);
    }
}