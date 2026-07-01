namespace eAnimalShelter.Model.Responses
{
    public class AnimalImageResponse
    {
        public int ImageId { get; set; }

        public int AnimalId { get; set; }

        public string? AnimalName { get; set; }

        public string FileName { get; set; } = string.Empty;

        public string ImagePath { get; set; } = string.Empty;

        public DateTime DateAdded { get; set; }
    }
}