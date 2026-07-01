using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AdoptionRequestUpdateValidator
        : AbstractValidator<AdoptionRequestUpdateRequest>
    {
        public AdoptionRequestUpdateValidator()
        {
            RuleFor(x => x.HousingType)
                .NotEmpty()
                .WithMessage("HousingType is required.")
                .MinimumLength(5)
                .MaximumLength(100)
                .WithMessage("HousingType must be between 5 and 100 characters.");

            RuleFor(x => x.ExperienceWithPets)
                .NotEmpty()
                .WithMessage("ExperienceWithPets is required.")
                .MinimumLength(10)
                .WithMessage("ExperienceWithPets must be at least 10 characters.");

            RuleFor(x => x.HouseholdMembers)
                .GreaterThan(0)
                .WithMessage("HouseholdMembers must be greater than 0.")
                .LessThanOrEqualTo(20)
                .WithMessage("HouseholdMembers cannot exceed 20.");

            RuleFor(x => x.AdditionalNotes)
                .MaximumLength(500)
                .WithMessage("AdditionalNotes cannot exceed 500 characters.")
                .When(x => !string.IsNullOrEmpty(x.AdditionalNotes));

            RuleFor(x => x.AdminComment)
                .MaximumLength(500)
                .WithMessage("AdminComment cannot exceed 500 characters.")
                .When(x => !string.IsNullOrEmpty(x.AdminComment));
        }
    }
}
