using eAnimalShelter.Model.Enums;


namespace eAnimalShelter.Model.Requests
{
    public class DonationUpdateRequest
    {
        public decimal Amount { get; set; }

        public DateTime DonationDate { get; set; }

        public string PaymentMethod { get; set; } = string.Empty;

        public string? StripePaymentIntentId { get; set; }

        public string? Note { get; set; }

        public string? ReceiptPdfPath { get; set; }

        public DonationStatus TransactionStatus { get; set; }
    }
}
