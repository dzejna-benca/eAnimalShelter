using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;

namespace eAnimalShelter.Services.AdoptionRequestStateMachine
{
    public class RejectedAdoptionRequestState
        : BaseAdoptionRequestState
    {
        public RejectedAdoptionRequestState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }

        public override Task<AdoptionRequestResponse> ApproveAsync(int id)
        {
            throw new InvalidOperationException(
                "A rejected adoption request cannot be approved.");
        }

        public override Task<AdoptionRequestResponse> RejectAsync(int id)
        {
            throw new InvalidOperationException(
                "This adoption request has already been rejected.");
        }

        public override Task<AdoptionRequestResponse> CancelAsync(int id)
        {
            throw new InvalidOperationException(
                "A rejected adoption request cannot be cancelled.");
        }

        public override List<string> AllowedActions()
        {
            return new();
        }
    }
}