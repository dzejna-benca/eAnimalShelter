using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class VolunteerAssignmentUpdateValidator
        : AbstractValidator<VolunteerAssignmentUpdateRequest>
    {
        public VolunteerAssignmentUpdateValidator()
        {
            RuleFor(x => x.ApplicationNote)
                .MaximumLength(500)
                .WithMessage("ApplicationNote must not exceed 500 characters.")
                .When(x => !string.IsNullOrWhiteSpace(x.ApplicationNote));


            RuleFor(x => x.HoursWorked)
                .GreaterThanOrEqualTo(0)
                .WithMessage("HoursWorked must be greater than or equal to 0.");
        }
    }
}
