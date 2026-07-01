using eAnimalShelter.Services.Database;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IPdfService
    {
        Task<string> GenerateDonationReceiptAsync(Donation donation);
    }
}