namespace eAnimalShelter.Model.Requests
{
    public class AnnouncementInsertRequest
    {
        public string Title { get; set; } = string.Empty;

        public string Content { get; set; } = string.Empty;

        public string? ImageUrl { get; set; }

    }
}
