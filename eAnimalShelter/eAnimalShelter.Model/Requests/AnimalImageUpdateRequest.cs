namespace eAnimalShelter.Model.Requests
{
    public class AnimalImageUpdateRequest
    {
        public int AnimalId { get; set; }

        public string FileName { get; set; } = string.Empty;

        public string ImagePath { get; set; } = string.Empty;
    }
}