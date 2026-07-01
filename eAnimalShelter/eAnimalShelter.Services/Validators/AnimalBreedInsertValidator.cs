using eAnimalShelter.Model.Requests;
using eAnimalShelter.Services.Database;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnimalBreedInsertValidator
        : AbstractValidator<AnimalBreedInsertRequest>
    {
        public AnimalBreedInsertValidator()
        {
            RuleFor(x => x.BreedName)
                .NotEmpty()
                .WithMessage("Breed name is required.")
                .MinimumLength(2)
                .WithMessage("Breed name must contain at least 2 characters.")
                .MaximumLength(50)
                .WithMessage("Breed name cannot exceed 50 characters.")
                .Matches(@"^[a-zA-Z\s\-']+$")
                .WithMessage("Breed name contains invalid characters.");

            RuleFor(x => x.SpeciesId)
                .GreaterThan(0)
                .WithMessage("Species is required.");
                
        }
    }
}