using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IVolunteerAssignmentService
        : IBaseCRUDService<
            VolunteerAssignmentResponse,
            VolunteerAssignmentSearchObject,
            VolunteerAssignmentInsertRequest,
            VolunteerAssignmentUpdateRequest>
    {
        Task<VolunteerAssignmentResponse> ApproveAsync(
        int id,
        string reason);

        Task<VolunteerAssignmentResponse> RejectAsync(
            int id,
            string reason);

        Task<VolunteerAssignmentResponse> CancelAsync(
            int id);

        Task<VolunteerAssignmentResponse> CompleteAsync(
            int id);
    }
}
