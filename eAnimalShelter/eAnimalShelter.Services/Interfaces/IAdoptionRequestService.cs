using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;


namespace eAnimalShelter.Services.Interfaces
{
public interface IAdoptionRequestService
    : IBaseCRUDService<
        AdoptionRequestResponse,
        AdoptionRequestSearchObject,
        AdoptionRequestInsertRequest,
        AdoptionRequestUpdateRequest>
{
    Task<AdoptionRequestResponse> ApproveAsync(int id, string? adminComment);

    Task<AdoptionRequestResponse> RejectAsync(int id, string? adminComment);

    Task<AdoptionRequestResponse> CancelAsync(int id);

}
}