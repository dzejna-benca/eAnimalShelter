using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnimalImageInsertValidator
        : AbstractValidator<AnimalImageInsertRequest>
    {
        public AnimalImageInsertValidator()
        {
            RuleFor(x => x.AnimalId)
                .GreaterThan(0)
                .WithMessage("Animal is required.");

            RuleFor(x => x.FileName)
                .NotEmpty()
                .WithMessage("File name is required.")
                .MaximumLength(100)
                .WithMessage("File name cannot exceed 100 characters.");

            RuleFor(x => x.ImagePath)
                .NotEmpty()
                .WithMessage("Image path is required.")
                .MaximumLength(500)
                .WithMessage("Image path cannot exceed 500 characters.");
        }
    }
}