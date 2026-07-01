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
    public class AnimalSpeciesController : BaseCRUDController<
        AnimalSpeciesResponse,
        AnimalSpeciesSearchObject,
        AnimalSpeciesInsertRequest,
        AnimalSpeciesUpdateRequest,
        IAnimalSpeciesService>
    {
        public AnimalSpeciesController(IAnimalSpeciesService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnimalSpeciesResponse> Insert(
            [FromBody] AnimalSpeciesInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnimalSpeciesResponse> Update(
            int id,
            [FromBody] AnimalSpeciesUpdateRequest request)
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
