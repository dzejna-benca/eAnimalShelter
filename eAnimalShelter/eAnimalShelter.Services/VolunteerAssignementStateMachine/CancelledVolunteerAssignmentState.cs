using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;

namespace eAnimalShelter.Services.VolunteerAssignmentStateMachine
{
    public class CancelledVolunteerAssignmentState
        : BaseVolunteerAssignmentState
    {
        public CancelledVolunteerAssignmentState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }

       
    }
}