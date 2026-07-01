using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Model.SearchObjects;

namespace eAnimalShelter.Services.Interfaces
{
    public interface INotificationService
        : IBaseCRUDService<
            NotificationResponse,
            NotificationSearchObject,
            NotificationInsertRequest,
            NotificationUpdateRequest>
    {
        Task<int> GetUnreadCountAsync();

        Task MarkAsReadAsync(int notificationId);

        Task MarkAllAsReadAsync();
    }
}
