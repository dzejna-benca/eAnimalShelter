using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class VolunteerAssignmentInsertValidator
        : AbstractValidator<VolunteerAssignmentInsertRequest>
    {
        public VolunteerAssignmentInsertValidator()
        {
            RuleFor(x => x.ActivityId)
                .GreaterThan(0)
                .WithMessage("ActivityId must be greater than 0.");

            RuleFor(x => x.ApplicationNote)
                .MaximumLength(500)
                .WithMessage("ApplicationNote must not exceed 500 characters.")
                .When(x => !string.IsNullOrWhiteSpace(x.ApplicationNote));
        }
    }
}
