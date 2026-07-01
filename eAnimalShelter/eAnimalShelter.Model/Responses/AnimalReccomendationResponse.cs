namespace eAnimalShelter.Model.Responses
{
    public class AnimalRecommendationResponse
    {
        public AnimalResponse Animal { get; set; } = null!;

        public double Score { get; set; }

        public string Reason { get; set; } = string.Empty;
    }
}