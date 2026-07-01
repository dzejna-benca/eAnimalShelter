using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

public class BaseVolunteerActivityState
{
    protected readonly eAnimalShelterDbContext DbContext;
    protected readonly IMapper Mapper;
    protected readonly IServiceProvider ServiceProvider;

    public BaseVolunteerActivityState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
    {
        DbContext = dbContext;
        Mapper = mapper;
        ServiceProvider = serviceProvider;
    }

    public virtual Task<VolunteerActivityResponse> InsertAsync(
        VolunteerActivityInsertRequest request)
    {
        throw new InvalidOperationException(
            "Creating activity is not allowed in current state.");
    }

    public virtual Task<VolunteerActivityResponse> CompleteAsync(int id)
    {
        throw new InvalidOperationException(
            "Completing activity is not allowed in current state.");
    }

    public virtual Task<VolunteerActivityResponse> CancelAsync(int id)
    {
        throw new InvalidOperationException(
            "Cancelling activity is not allowed in current state.");
    }

    public virtual List<string> AllowedActions()
    {
        return new();
    }

    public BaseVolunteerActivityState GetState(
        ActivityStatus status)
    {
        return status switch
        {
            ActivityStatus.Active =>
                ServiceProvider.GetRequiredService<ActiveVolunteerActivityState>(),

            ActivityStatus.Completed =>
                ServiceProvider.GetRequiredService<CompletedVolunteerActivityState>(),

            ActivityStatus.Cancelled =>
                ServiceProvider.GetRequiredService<CancelledVolunteerActivityState>(),

            _ => throw new InvalidOperationException()
        };
    }
}