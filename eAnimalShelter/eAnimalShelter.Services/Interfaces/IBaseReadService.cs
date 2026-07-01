using eAnimalShelter.Model;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IBaseReadService<TResponse, TSearch>
        where TSearch : BaseSearchObject
    {
        Task<PageResult<TResponse>> GetAllAsync(TSearch? search = null);

        Task<TResponse> GetByIdAsync(int id);
    }
}