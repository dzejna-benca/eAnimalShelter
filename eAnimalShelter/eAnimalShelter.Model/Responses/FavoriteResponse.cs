namespace eAnimalShelter.Model.Responses
{
    public class FavoriteResponse
    {
        public int FavoriteId { get; set; }

        public int AnimalId { get; set; }

        public int UserId { get; set; }

        public DateTime DateAdded { get; set; }
        public AnimalResponse Animal { get; set; } = null!;
    }
}
