namespace eAnimalShelter.Model.Responses
{
    public class CreatePaymentIntentResponse
    {
        public string ClientSecret { get; set; } = string.Empty;

        public int DonationId { get; set; }

        public string PaymentIntentId { get; set; } = string.Empty;
    }
}