using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IVolunteerActivityService
        : IBaseCRUDService<
            VolunteerActivityResponse,
            VolunteerActivitySearchObject,
            VolunteerActivityInsertRequest,
            VolunteerActivityUpdateRequest>
    {
        Task<VolunteerActivityDetailsResponse> GetDetailsAsync(int id);
        Task<VolunteerActivityResponse> CompleteAsync(int id);
        Task<VolunteerActivityResponse> CancelAsync(int id);
    }
}
