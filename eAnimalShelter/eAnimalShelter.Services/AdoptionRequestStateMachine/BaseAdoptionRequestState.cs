using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;


namespace eAnimalShelter.Services.AdoptionRequestStateMachine;

public class BaseAdoptionRequestState
{
    protected readonly eAnimalShelterDbContext DbContext;
    protected readonly IMapper Mapper;
    protected readonly IServiceProvider ServiceProvider;

    public BaseAdoptionRequestState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
    {
        DbContext = dbContext;
        Mapper = mapper;
        ServiceProvider = serviceProvider;
    }

    public virtual Task<AdoptionRequestResponse> InsertAsync(
        AdoptionRequestInsertRequest request)
    {
        throw new InvalidOperationException("Insert is not allowed in current state.");
    }

    public virtual Task<AdoptionRequestResponse> ApproveAsync(int id)
    {
        throw new InvalidOperationException(
            "This adoption request cannot be approved in its current state.");
    }

    public virtual Task<AdoptionRequestResponse> RejectAsync(int id)
    {
        throw new InvalidOperationException(
            "This adoption request cannot be rejected in its current state.");
    }

    public virtual Task<AdoptionRequestResponse> CancelAsync(int id)
    {
        throw new InvalidOperationException(
            "This adoption request cannot be cancelled in its current state.");
    }


    public virtual List<string> AllowedActions()
    {
        return new();
    }
    protected async Task CreateNotification(
    int userId,
    string title,
    string message)
    {
        DbContext.Notifications.Add(new Notification
        {
            UserId = userId,
            Title = title,
            Message = message,
            Type = NotificationType.Adoption,
            IsRead = false,
            DateSent = DateTime.UtcNow
        });

    }
    public BaseAdoptionRequestState GetState(
        AdoptionRequestStatus status)
    {
        return status switch
        {
            AdoptionRequestStatus.Pending =>
                ServiceProvider.GetRequiredService<PendingAdoptionRequestState>(),

            AdoptionRequestStatus.Approved =>
                ServiceProvider.GetRequiredService<ApprovedAdoptionRequestState>(),

            AdoptionRequestStatus.Rejected =>
                ServiceProvider.GetRequiredService<RejectedAdoptionRequestState>(),

            AdoptionRequestStatus.Cancelled =>
                ServiceProvider.GetRequiredService<CancelledAdoptionRequestState>(),

            _ => throw new InvalidOperationException()
        };
    }
}