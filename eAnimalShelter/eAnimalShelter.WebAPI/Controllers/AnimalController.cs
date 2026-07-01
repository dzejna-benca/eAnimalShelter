using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [Authorize]
    public class AnimalController : BaseCRUDController<
        AnimalResponse,
        AnimalSearchObject,
        AnimalInsertRequest,
        AnimalUpdateRequest,
        IAnimalService>
    {
        public AnimalController(IAnimalService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnimalResponse> Insert(
            [FromBody] AnimalInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnimalResponse> Update(
            int id,
            [FromBody] AnimalUpdateRequest request)
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