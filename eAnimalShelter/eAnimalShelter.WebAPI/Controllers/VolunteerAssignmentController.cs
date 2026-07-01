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
    public class VolunteerAssignmentController : BaseCRUDController<
        VolunteerAssignmentResponse,
        VolunteerAssignmentSearchObject,
        VolunteerAssignmentInsertRequest,
        VolunteerAssignmentUpdateRequest,
        IVolunteerAssignmentService>
    {
        public VolunteerAssignmentController(IVolunteerAssignmentService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<VolunteerAssignmentResponse> Update(
            int id,
            [FromBody] VolunteerAssignmentUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
        [Authorize(Roles = "Admin")]
        [HttpPost("{id}/approve")]
        public async Task<VolunteerAssignmentResponse> Approve(
            int id,
            [FromBody] VolunteerAssignmentActionRequest request)
        {
            return await _service.ApproveAsync(
                id,
                request.Reason);
        }
        [Authorize(Roles = "Admin")]
        [HttpPost("{id}/reject")]
        public async Task<VolunteerAssignmentResponse> Reject(
            int id,
            [FromBody] VolunteerAssignmentActionRequest request)
        {
            return await _service.RejectAsync(
                id,
                request.Reason);
        }
       
        [HttpPost("{id}/cancel")]
        public async Task<VolunteerAssignmentResponse> Cancel(
            int id)
        {
            return await _service.CancelAsync(id);
        }
        [Authorize(Roles = "Admin")]
        [HttpPost("{id}/complete")]
        public async Task<VolunteerAssignmentResponse> Complete(
            int id)
        {
            return await _service.CompleteAsync(id);
        }
    }
}
