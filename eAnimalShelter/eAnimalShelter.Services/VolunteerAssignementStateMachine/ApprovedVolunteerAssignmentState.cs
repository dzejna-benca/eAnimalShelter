using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services.VolunteerAssignmentStateMachine
{
    public class ApprovedVolunteerAssignmentState
        : BaseVolunteerAssignmentState
    {
        public ApprovedVolunteerAssignmentState(
            eAnimalShelterDbContext dbContext,
            IMapper mapper,
            IServiceProvider serviceProvider)
            : base(dbContext, mapper, serviceProvider)
        {
        }
        public override async Task<VolunteerAssignmentResponse>
            CompleteAsync(int id)
        {
            var assignment = await DbContext.VolunteerAssignments
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException();

            assignment.Status = AssignmentStatus.Completed;

            await DbContext.SaveChangesAsync();

            return Mapper.Map<VolunteerAssignmentResponse>(
                assignment);
        }
        public override async Task<VolunteerAssignmentResponse> CancelAsync(int id)
        {
            var assignment = await DbContext.VolunteerAssignments
                .Include(x => x.Activity)
                .FirstOrDefaultAsync(x => x.AssignmentId == id);

            if (assignment == null)
                throw new KeyNotFoundException();

            if (assignment.Activity.StartDateTime <= DateTime.UtcNow.AddDays(2))
            {
                throw new Exception(
                    "Applications cannot be cancelled less than 2 days before the activity starts.");
            }

            assignment.Status = AssignmentStatus.Cancelled;
            assignment.AdminResponseReason = "Cancelled by volunteer.";

            await DbContext.SaveChangesAsync();

            return Mapper.Map<VolunteerAssignmentResponse>(assignment);
        }

    }
}