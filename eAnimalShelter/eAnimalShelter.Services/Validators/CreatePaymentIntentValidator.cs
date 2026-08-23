using eAnimalShelter.Model.Requests;
using FluentValidation;

namespace eAnimalShelter.Services.Validators
{
    public class CreatePaymentIntentValidator
        : AbstractValidator<CreatePaymentIntentRequest>
    {
        public CreatePaymentIntentValidator()
        {
            RuleFor(x => x.Amount)
                .GreaterThan(0)
                .WithMessage("Amount must be greater than 0.")
                .LessThanOrEqualTo(10000)
                .WithMessage("Maximum donation amount is 10000.")
                .Must(amount => decimal.Round(amount, 2) == amount)
                .WithMessage("Amount can have at most two decimal places.");

            RuleFor(x => x.Note)
                .MaximumLength(500)
                .WithMessage("Note must not exceed 500 characters.");
        }
    }
}