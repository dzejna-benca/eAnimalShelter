using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;

namespace eAnimalShelter.Services.AdoptionRequestStateMachine
{
    public class CancelledAdoptionRequestState
        : BaseAdoptionRequestState
    {
        public CancelledAdoptionRequestState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }

        public override Task<AdoptionRequestResponse> ApproveAsync(int id)
        {
            throw new InvalidOperationException(
                "A cancelled adoption request cannot be approved.");
        }

        public override Task<AdoptionRequestResponse> RejectAsync(int id)
        {
            throw new InvalidOperationException(
                "A cancelled adoption request cannot be rejected.");
        }

        public override Task<AdoptionRequestResponse> CancelAsync(int id)
        {
            throw new InvalidOperationException(
                "This adoption request has already been cancelled.");
        }

        public override List<string> AllowedActions()
        {
            return new();
        }
    }
}