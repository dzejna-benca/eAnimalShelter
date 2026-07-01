using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IDonationService
        : IBaseCRUDService<
            DonationResponse,
            DonationSearchObject,
            DonationInsertRequest,
            DonationUpdateRequest>
    {
         Task<DonationReportResponse> GetReportAsync();
         Task<CreatePaymentIntentResponse> CreatePaymentIntentAsync(CreatePaymentIntentRequest request);
         Task<(byte[] Content, string FileName)> GetReceiptAsync(int donationId);
         Task ConfirmPaymentAsync(int donationId);
    }
}
