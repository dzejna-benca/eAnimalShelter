using eAnimalShelter.Services.Database;
using MapsterMapper;

public class CompletedVolunteerActivityState
    : BaseVolunteerActivityState
{
    public CompletedVolunteerActivityState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
        : base(dbContext, mapper, serviceProvider)
    {
    }
}