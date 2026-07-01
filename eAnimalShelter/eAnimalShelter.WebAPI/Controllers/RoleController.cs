using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Controllers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [Authorize]
    public class RoleController : BaseCRUDController<
        RoleResponse,
        RoleSearchObject,
        RoleInsertRequest,
        RoleUpdateRequest,
        IRoleService>
    {
        public RoleController(IRoleService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<RoleResponse> Insert(
            [FromBody] RoleInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<RoleResponse> Update(
            int id,
            [FromBody] RoleUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}
