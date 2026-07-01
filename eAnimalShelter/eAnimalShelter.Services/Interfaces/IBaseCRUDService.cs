using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IBaseCRUDService<TResponse, TSearch, TInsert, TUpdate>
        : IBaseReadService<TResponse, TSearch>
        where TSearch : BaseSearchObject
    {
        Task<TResponse> InsertAsync(TInsert request);

        Task<TResponse> UpdateAsync(int id, TUpdate request);

        Task DeleteAsync(int id);
    }
}