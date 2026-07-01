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
public class AnimalBreedController : BaseCRUDController<
    AnimalBreedResponse,
    AnimalBreedSearchObject,
    AnimalBreedInsertRequest,
    AnimalBreedUpdateRequest,
    IAnimalBreedService>
{
    public AnimalBreedController(IAnimalBreedService service)
        : base(service)
    {
    }

        [Authorize(Roles = "Admin")]
        public override async Task<AnimalBreedResponse> Insert(
            [FromBody] AnimalBreedInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnimalBreedResponse> Update(
            int id,
            [FromBody] AnimalBreedUpdateRequest request)
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
    