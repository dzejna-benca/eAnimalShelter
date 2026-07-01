using eAnimalShelter.Services.Database;
namespace eAnimalShelter.WebAPI.models
{
    public class AnimalImageUploadRequest
    {
        public int AnimalId { get; set; }
        public IFormFile File { get; set; }
    }
}