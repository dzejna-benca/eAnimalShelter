using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;

namespace eAnimalShelter.Services.AdoptionRequestStateMachine
{
    public class ApprovedAdoptionRequestState
        : BaseAdoptionRequestState
    {
        public ApprovedAdoptionRequestState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }

        public override Task<AdoptionRequestResponse> ApproveAsync(int id)
        {
            throw new InvalidOperationException(
                "This adoption request has already been approved.");
        }

        public override Task<AdoptionRequestResponse> RejectAsync(int id)
        {
            throw new InvalidOperationException(
                "An approved adoption request cannot be rejected.");
        }

        public override Task<AdoptionRequestResponse> CancelAsync(int id)
        {
            throw new InvalidOperationException(
                "An approved adoption request cannot be cancelled.");
        }

        public override List<string> AllowedActions()
        {
            return new();
        }
    }
}