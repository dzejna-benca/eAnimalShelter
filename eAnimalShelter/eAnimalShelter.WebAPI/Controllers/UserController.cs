using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Controllers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
     [Authorize(Roles = "Admin")]
    public class UserController : BaseCRUDController<
        UserResponse,
        UserSearchObject,
        UserInsertRequest,
        UserUpdateRequest,
        IUserService>
    {
        public UserController(IUserService service)
            : base(service)
        {
        }

    }
}
