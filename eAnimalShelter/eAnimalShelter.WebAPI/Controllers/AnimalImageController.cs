using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.WebAPI.models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAnimalShelter.WebAPI.Controllers
{
    [Authorize]
    public class AnimalImageController : BaseCRUDController<
        AnimalImageResponse,
        AnimalImageSearchObject,
        AnimalImageInsertRequest,
        AnimalImageUpdateRequest,
        IAnimalImageService>
    {
        private readonly IWebHostEnvironment _env;

        public AnimalImageController(
            IAnimalImageService service,
            IWebHostEnvironment env)
            : base(service)
        {
            _env = env;
        }

        // =========================
        // UPLOAD IMAGE
        // =========================
        [Authorize(Roles = "Admin")]
        [HttpPost("upload")]
        [Consumes("multipart/form-data")]
        public async Task<AnimalImageResponse> Upload(
            [FromForm] AnimalImageUploadRequest request)
        {
            if (request.File == null || request.File.Length == 0)
                throw new Exception("Image file is required.");

           
            var uploadsFolder = Path.Combine(
                _env.WebRootPath,
                "images",
                "animals");

            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var fileName = $"{Guid.NewGuid()}_{request.File.FileName}";
            var physicalPath = Path.Combine(uploadsFolder, fileName);

            using (var stream = new FileStream(physicalPath, FileMode.Create))
            {
                await request.File.CopyToAsync(stream);
            }

            var insertRequest = new AnimalImageInsertRequest
            {
                AnimalId = request.AnimalId,
                FileName = fileName,
                ImagePath = $"/images/animals/{fileName}"
            };

            return await _service.InsertAsync(insertRequest);
        }

        // =========================
        // UPDATE
        // =========================
        [Authorize(Roles = "Admin")]
        public override async Task<AnimalImageResponse> Update(
            int id,
            [FromBody] AnimalImageUpdateRequest request)
        {
            return await base.Update(id, request);
        }

        // =========================
        // DELETE
        // =========================
        [Authorize(Roles = "Admin")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}