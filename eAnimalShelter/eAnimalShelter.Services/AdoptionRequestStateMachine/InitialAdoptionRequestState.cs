using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.AdoptionRequestStateMachine;
using eAnimalShelter.Services.Database;
using MapsterMapper;

namespace eAnimalShelter.Services.AdoptionRequestStateMachine{
public class InitialAdoptionRequestState
    : BaseAdoptionRequestState
{
    public InitialAdoptionRequestState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
        : base(dbContext, mapper, serviceProvider)
    {
    }

    public override async Task<AdoptionRequestResponse>
        InsertAsync(AdoptionRequestInsertRequest request)
    {
        var entity = Mapper.Map<AdoptionRequest>(request);

        entity.RequestDate = DateTime.UtcNow;
        entity.Status = AdoptionRequestStatus.Pending;

        DbContext.AdoptionRequests.Add(entity);

        await DbContext.SaveChangesAsync();

        return Mapper.Map<AdoptionRequestResponse>(entity);
    }

    public override List<string> AllowedActions()
    {
        return new() { nameof(InsertAsync) };
    }
}
}