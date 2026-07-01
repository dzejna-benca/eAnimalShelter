using eAnimalShelter.Services.Database;
using MapsterMapper;

public class CancelledVolunteerActivityState
    : BaseVolunteerActivityState
{
    public CancelledVolunteerActivityState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
        : base(dbContext, mapper, serviceProvider)
    {
    }
}