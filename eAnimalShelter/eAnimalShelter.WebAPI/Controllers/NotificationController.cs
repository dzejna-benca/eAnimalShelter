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
    public class NotificationController : BaseCRUDController<
        NotificationResponse,
        NotificationSearchObject,
        NotificationInsertRequest,
        NotificationUpdateRequest,
        INotificationService>
    {
        public NotificationController(INotificationService service)
            : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override async Task<NotificationResponse> Insert(
            [FromBody] NotificationInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<NotificationResponse> Update(
            int id,
            [FromBody] NotificationUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
        [HttpGet("unread-count")]
        public async Task<int> GetUnreadCount()
        {
            return await _service.GetUnreadCountAsync();
        }
        [HttpPut("{id}/read")]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            await _service.MarkAsReadAsync(id);
            return Ok();
        }
        [HttpPut("read-all")]
        public async Task<IActionResult> MarkAllAsRead()
        {
            await _service.MarkAllAsReadAsync();
            return Ok();
        }
    }
}
