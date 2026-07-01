using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.VolunteerAssignmentStateMachine;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

public class BaseVolunteerAssignmentState
{
    protected readonly eAnimalShelterDbContext DbContext;
    protected readonly IMapper Mapper;
    protected readonly IServiceProvider ServiceProvider;

    public BaseVolunteerAssignmentState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
    {
        DbContext = dbContext;
        Mapper = mapper;
        ServiceProvider = serviceProvider;
    }

    public virtual Task<VolunteerAssignmentResponse> ApproveAsync(
    int id,
    string? reason = null)
    {
        throw new InvalidOperationException("Action not allowed");
    }

    public virtual Task<VolunteerAssignmentResponse> RejectAsync(
        int id,
        string? reason = null)
    {
        throw new InvalidOperationException("Action not allowed");
    }

    public virtual Task<VolunteerAssignmentResponse> CancelAsync(
        int id)
    {
        throw new InvalidOperationException("Action not allowed");
    }

    public virtual Task<VolunteerAssignmentResponse> CompleteAsync(
        int id)
    {
        throw new InvalidOperationException("Action not allowed");
    }

    public BaseVolunteerAssignmentState GetState(
        AssignmentStatus status)
    {
        return status switch
        {
            AssignmentStatus.Pending =>
                ServiceProvider.GetRequiredService<PendingVolunteerAssignmentState>(),

            AssignmentStatus.Approved =>
                ServiceProvider.GetRequiredService<ApprovedVolunteerAssignmentState>(),

            AssignmentStatus.Rejected =>
                ServiceProvider.GetRequiredService<RejectedVolunteerAssignmentState>(),

            AssignmentStatus.Cancelled =>
                ServiceProvider.GetRequiredService<CancelledVolunteerAssignmentState>(),

            AssignmentStatus.Completed =>
                ServiceProvider.GetRequiredService<CompletedVolunteerAssignmentState>(),

            _ => throw new InvalidOperationException()
        };
    }
}