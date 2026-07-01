using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IRoleService
        : IBaseCRUDService<
            RoleResponse,
            RoleSearchObject,
            RoleInsertRequest,
            RoleUpdateRequest>
    {
    }
}
