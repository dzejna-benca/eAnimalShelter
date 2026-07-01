using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IFavoriteService
        : IBaseCRUDService<
            FavoriteResponse,
            FavoriteSearchObject,
            FavoriteInsertRequest,
            FavoriteUpdateRequest>
    {
        Task ToggleFavoriteAsync(int animalId);

        Task<List<int>> GetMyFavoriteAnimalIdsAsync();
    }
}
