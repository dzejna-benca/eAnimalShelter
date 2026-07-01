using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;

namespace eAnimalShelter.Services.VolunteerAssignmentStateMachine
{
    public class RejectedVolunteerAssignmentState
        : BaseVolunteerAssignmentState
    {
        public RejectedVolunteerAssignmentState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }

    }
}