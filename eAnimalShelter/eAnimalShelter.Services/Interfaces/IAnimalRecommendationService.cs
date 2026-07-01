using eAnimalShelter.Model.Responses;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IRecommendationService
    {
        Task<List<AnimalRecommendationResponse>>GetRecommendationsAsync(int top = 10);
    }
}