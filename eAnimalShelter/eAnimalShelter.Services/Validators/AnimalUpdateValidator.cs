using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnimalUpdateValidator
        : AbstractValidator<AnimalUpdateRequest>
    {
        public AnimalUpdateValidator()
        {
            RuleFor(x => x.Name)
                .NotEmpty()
                .WithMessage("Animal name is required.")
                .MaximumLength(100)
                .WithMessage("Animal name cannot exceed 100 characters.");

            RuleFor(x => x.SpeciesId)
                .GreaterThan(0)
                .WithMessage("Species is required.");

            RuleFor(x => x.BreedId)
                .GreaterThan(0)
                .WithMessage("Breed is required.");

            RuleFor(x => x.Gender)
                .IsInEnum()
                .WithMessage("Gender is invalid.");

            RuleFor(x => x.BirthDate)
                .LessThan(DateTime.UtcNow)
                .WithMessage("Birth date must be in the past.");

            RuleFor(x => x.Description)
                .NotEmpty()
                .WithMessage("Description is required.")
                .MaximumLength(2000)
                .WithMessage("Description cannot exceed 2000 characters.");

            RuleFor(x => x.PersonalityDescription)
                .NotEmpty()
                .WithMessage("Personality description is required.")
                .MaximumLength(2000)
                .WithMessage("Personality description cannot exceed 2000 characters.");

            RuleFor(x => x.HealthStatus)
                .NotEmpty()
                .WithMessage("Health status is required.")
                .MaximumLength(500)
                .WithMessage("Health status cannot exceed 500 characters.");

            RuleFor(x => x.MedicalNotes)
                .MaximumLength(2000)
                .WithMessage("Medical notes cannot exceed 2000 characters.");

            RuleFor(x => x.AdoptionStatus)
                .IsInEnum()
                .WithMessage("Adoption status is invalid.");

            RuleFor(x => x.ArrivalDate)
                .LessThanOrEqualTo(DateTime.UtcNow)
                .When(x => x.ArrivalDate.HasValue)
                .WithMessage("Arrival date cannot be in the future.");

            RuleFor(x => x.ArrivalDate)
                .GreaterThanOrEqualTo(x => x.BirthDate)
                .When(x => x.ArrivalDate.HasValue)
                .WithMessage("Arrival date cannot be earlier than birth date.");
        }
    }
}