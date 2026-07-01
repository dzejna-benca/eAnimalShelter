using eAnimalShelter.Model.Responses;

namespace eAnimalShelter.Services.Interfaces
{
    public interface IDashboardService
    {
        Task<DashboardResponse> GetStatsAsync();
        Task<MobileDashboardResponse> GetMobileDashboardAsync();
    }
}