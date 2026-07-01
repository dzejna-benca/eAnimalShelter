namespace eAnimalShelter.Model.Requests
{
    public class CreatePaymentIntentRequest
    {
        public decimal Amount { get; set; }

        public string? Note { get; set; }
    }
}