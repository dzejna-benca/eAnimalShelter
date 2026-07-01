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
    public class FavoriteController : BaseCRUDController<
        FavoriteResponse,
        FavoriteSearchObject,
        FavoriteInsertRequest,
        FavoriteUpdateRequest,
        IFavoriteService>
    {
        public FavoriteController(IFavoriteService service)
            : base(service)
        {
        }

        [Authorize]
        public override async Task<FavoriteResponse> Insert(
            [FromBody] FavoriteInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize]
        public override async Task<FavoriteResponse> Update(
            int id,
            [FromBody] FavoriteUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
        [HttpPost("{animalId}/toggle")]
        public async Task<IActionResult> ToggleFavorite(int animalId)
        {
            await _service.ToggleFavoriteAsync(animalId);

            return Ok();
        }

        [HttpGet("my-animal-ids")]
        public async Task<ActionResult<List<int>>> GetMyFavoriteAnimalIds()
        {
            return Ok(await _service.GetMyFavoriteAnimalIdsAsync());
        }
    }
}
