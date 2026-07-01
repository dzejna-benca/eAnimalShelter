using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.Controllers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
[Authorize]
public class AnnouncementController : BaseCRUDController<
    AnnouncementResponse,
    AnnouncementSearchObject,
    AnnouncementInsertRequest,
    AnnouncementUpdateRequest,
    IAnnouncementService>
{
    private readonly IWebHostEnvironment _env;

        public AnnouncementController(
            IAnnouncementService service,
            IWebHostEnvironment env)
            : base(service)
        {
            _env = env;
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnnouncementResponse> Insert(
            [FromBody] AnnouncementInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<AnnouncementResponse> Update(
            int id,
            [FromBody] AnnouncementUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }

        
        [HttpPost("upload-image")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<string>> UploadImage(
            IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("Image is required.");
            }

            var uploadsFolder = Path.Combine(
                _env.WebRootPath,
                "images",
                "announcements");

            if (!Directory.Exists(uploadsFolder))
            {
                Directory.CreateDirectory(uploadsFolder);
            }

            var fileName =
                $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";

            var filePath = Path.Combine(
                uploadsFolder,
                fileName);

            using (var stream = new FileStream(
                filePath,
                FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            return Ok(new
            {
                imageUrl = $"/images/announcements/{fileName}"
            });
        }
}
}
