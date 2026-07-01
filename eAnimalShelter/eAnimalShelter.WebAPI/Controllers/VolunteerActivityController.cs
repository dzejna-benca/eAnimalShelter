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
    public class VolunteerActivityController : BaseCRUDController<
        VolunteerActivityResponse,
        VolunteerActivitySearchObject,
        VolunteerActivityInsertRequest,
        VolunteerActivityUpdateRequest,
        IVolunteerActivityService>
    {
        public VolunteerActivityController(IVolunteerActivityService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<VolunteerActivityResponse> Insert(
            [FromBody] VolunteerActivityInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<VolunteerActivityResponse> Update(
            int id,
            [FromBody] VolunteerActivityUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
        
        [HttpGet("{id}/details")]
         public async Task<ActionResult<VolunteerActivityDetailsResponse>> GetDetails(
            int id)
        {
            try
            {
                return Ok(await _service.GetDetailsAsync(id));
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
        }
        [HttpPost("{id}/complete")]
        [Authorize(Roles = "Admin")]
        public async Task<VolunteerActivityResponse>
            Complete(int id)
        {
            return await _service.CompleteAsync(id);
        }
        [HttpPost("{id}/cancel")]
        [Authorize(Roles = "Admin")]
        public async Task<VolunteerActivityResponse>
            Cancel(int id)
        {
            return await _service.CancelAsync(id);
        }
    }
}
