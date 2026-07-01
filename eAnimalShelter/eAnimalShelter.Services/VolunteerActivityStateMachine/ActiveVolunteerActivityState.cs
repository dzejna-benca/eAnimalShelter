using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

public class ActiveVolunteerActivityState
    : BaseVolunteerActivityState
{
    public ActiveVolunteerActivityState(
        eAnimalShelterDbContext dbContext,
        IMapper mapper,
        IServiceProvider serviceProvider)
        : base(dbContext, mapper, serviceProvider)
    {
    }

    public override async Task<VolunteerActivityResponse>
        CompleteAsync(int id)
    {
        var activity =
            await DbContext.VolunteerActivities
                .Include(x => x.VolunteerAssignments)
                .FirstOrDefaultAsync(x => x.ActivityId == id);

        if (activity == null)
            throw new KeyNotFoundException();

        activity.Status = ActivityStatus.Completed;

        foreach (var assignment in activity.VolunteerAssignments
                     .Where(x => x.Status == AssignmentStatus.Pending))
        {
            assignment.Status = AssignmentStatus.Rejected;
        }

        await DbContext.SaveChangesAsync();

        return Mapper.Map<VolunteerActivityResponse>(activity);
    }

    public override async Task<VolunteerActivityResponse>
        CancelAsync(int id)
    {
        var activity =
            await DbContext.VolunteerActivities
                .Include(x => x.VolunteerAssignments)
                .FirstOrDefaultAsync(x => x.ActivityId == id);

        if (activity == null)
            throw new KeyNotFoundException();

        activity.Status = ActivityStatus.Cancelled;

        foreach (var assignment in activity.VolunteerAssignments)
        {
            if (assignment.Status == AssignmentStatus.Pending)
            {
                assignment.Status = AssignmentStatus.Cancelled;
            }
        }

        await DbContext.SaveChangesAsync();

        return Mapper.Map<VolunteerActivityResponse>(activity);
    }

    public override List<string> AllowedActions()
    {
        return new()
        {
            nameof(CompleteAsync),
            nameof(CancelAsync)
        };
    }
}