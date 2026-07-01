using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class VolunteerActivityUpdateValidator
        : AbstractValidator<VolunteerActivityUpdateRequest>
    {
        public VolunteerActivityUpdateValidator()
        {
            RuleFor(x => x.Title)
                .NotEmpty()
                .WithMessage("Title is required.")
                .MinimumLength(3)
                .MaximumLength(200)
                .WithMessage("Title must be between 3 and 200 characters.");

            RuleFor(x => x.Description)
                .NotEmpty()
                .WithMessage("Description is required.")
                .MinimumLength(10)
                .WithMessage("Description must be at least 10 characters.");

            RuleFor(x => x.LocationId)
                .GreaterThan(0)
                .WithMessage("LocationId must be greater than 0.");

            RuleFor(x => x.StartDateTime)
                .NotEmpty()
                .WithMessage("Start date is required.");

            RuleFor(x => x.EndDateTime)
                .NotEmpty()
                .WithMessage("EndDateTime is required.")
                .GreaterThan(x => x.StartDateTime)
                .WithMessage("End date must be after Start date.");

            RuleFor(x => x.MaxVolunteers)
                .GreaterThan(0)
                .WithMessage("MaxVolunteers must be greater than 0.");
        }
    }
}
