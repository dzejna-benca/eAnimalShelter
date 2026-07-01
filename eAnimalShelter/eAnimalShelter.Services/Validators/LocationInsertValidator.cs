using eAnimalShelter.Model.Requests;
using eAnimalShelter.Services.Database;
using FluentValidation;

public class LocationInsertValidator
    : AbstractValidator<LocationInsertRequest>
{
    public LocationInsertValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .WithMessage("Name is required.")
            .MinimumLength(2)
            .MaximumLength(100)
            .WithMessage("Name must be between 2 and 100 characters.");

    }
}