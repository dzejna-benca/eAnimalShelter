using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class AnnouncementUpdateValidator
        : AbstractValidator<AnnouncementUpdateRequest>
    {
        public AnnouncementUpdateValidator()
        {
            RuleFor(x => x.Title)
                .NotEmpty()
                .WithMessage("Title is required.")
                .MinimumLength(3)
                .MaximumLength(200)
                .WithMessage("Title must be between 3 and 200 characters.");

            RuleFor(x => x.Content)
                .NotEmpty()
                .WithMessage("Content is required.")
                .MinimumLength(10)
                .WithMessage("Content must be at least 10 characters.");

            RuleFor(x => x.ImageUrl)
                .MaximumLength(500);
        }
    }
}
