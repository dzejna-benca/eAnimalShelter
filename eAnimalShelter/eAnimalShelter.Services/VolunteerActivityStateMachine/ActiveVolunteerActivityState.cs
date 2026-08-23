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
            throw new KeyNotFoundException( $"Volunteer activity with id {id} not found.");

        activity.Status = ActivityStatus.Completed;

        foreach (var assignment in activity.VolunteerAssignments)
        {
            if (assignment.Status == AssignmentStatus.Pending)
            {
                assignment.Status = AssignmentStatus.Rejected;
                assignment.AdminResponseReason =
                     "Volunteer activity has already been completed.";
            }
            else if (assignment.Status == AssignmentStatus.Approved)
            {
                assignment.Status = AssignmentStatus.Completed;
            }
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
            throw new KeyNotFoundException( $"Volunteer activity with id {id} not found.");

        activity.Status = ActivityStatus.Cancelled;

        foreach (var assignment in activity.VolunteerAssignments)
        {
            if (assignment.Status == AssignmentStatus.Pending ||
                assignment.Status == AssignmentStatus.Approved)
            {
                assignment.Status = AssignmentStatus.Cancelled;

                assignment.AdminResponseReason =
                    "Volunteer assignment was cancelled because the activity was cancelled.";
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