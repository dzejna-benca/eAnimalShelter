using eAnimalShelter.Model.Enums;


namespace eAnimalShelter.Model.Responses
{
   public class DonationResponse
{
    public int DonationId { get; set; }

    public int UserId { get; set; }

    public decimal Amount { get; set; }

    public DateTime? DonationDate { get; set; }

    public string PaymentMethod { get; set; } = string.Empty;

    public string? StripePaymentIntentId { get; set; }

    public DonationStatus TransactionStatus { get; set; }

    public string? Note { get; set; }

    public string? ReceiptPdfPath { get; set; }

    public string? CreatedByUserName { get; set; }

    public string? UserFullName { get; set; }
}
}
