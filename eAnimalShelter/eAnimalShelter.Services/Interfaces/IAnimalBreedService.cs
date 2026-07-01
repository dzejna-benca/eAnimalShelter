using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IAnimalBreedService
        : IBaseCRUDService<
            AnimalBreedResponse,
            AnimalBreedSearchObject,
            AnimalBreedInsertRequest,
            AnimalBreedUpdateRequest>
    {
    }
}