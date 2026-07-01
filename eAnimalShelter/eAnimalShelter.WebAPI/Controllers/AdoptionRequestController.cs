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
    public class AdoptionRequestController : BaseCRUDController<
        AdoptionRequestResponse,
        AdoptionRequestSearchObject,
        AdoptionRequestInsertRequest,
        AdoptionRequestUpdateRequest,
        IAdoptionRequestService>
    {
        public AdoptionRequestController(IAdoptionRequestService service)
            : base(service)
        {
        }

        public override async Task<AdoptionRequestResponse> Update(
            int id,
            [FromBody] AdoptionRequestUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [HttpPost("{id}/approve")]
        [Authorize(Roles = "Admin")]
        public async Task<AdoptionRequestResponse> Approve(
            int id,
            [FromBody] string? comment)
        {
            return await _service.ApproveAsync(id, comment);
        }
        [HttpPost("{id}/reject")]
        [Authorize(Roles = "Admin")]
        public async Task<AdoptionRequestResponse> Reject(
            int id,
            [FromBody] string? comment)
        {
            return await _service.RejectAsync(id, comment);
        }
        [HttpPost("{id}/cancel")]
        public async Task<AdoptionRequestResponse> Cancel(int id)
        {
            return await _service.CancelAsync(id);
        }
    }
}
