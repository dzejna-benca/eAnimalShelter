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
    public class LocationController : BaseCRUDController<
        LocationResponse,
        LocationSearchObject,
        LocationInsertRequest,
        LocationUpdateRequest,
        ILocationService>
    {
        public LocationController(ILocationService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<LocationResponse> Insert(
            [FromBody] LocationInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<LocationResponse> Update(
            int id,
            [FromBody] LocationUpdateRequest request)
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
