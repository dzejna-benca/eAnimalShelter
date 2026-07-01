using eAnimalShelter.Model.Exceptions;
using FluentValidation;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Net;

namespace eAnimalShelter.WebAPI.Filters
{
    public class GlobalExceptionFilter : ExceptionFilterAttribute
    {
        private readonly ILogger<GlobalExceptionFilter> _logger;

        public GlobalExceptionFilter(
            ILogger<GlobalExceptionFilter> logger)
        {
            _logger = logger;
        }

        public override void OnException(ExceptionContext context)
        {
            _logger.LogError(
                context.Exception,
                context.Exception.Message);

            switch (context.Exception)
            {
                case ValidationException validationException:

                    context.Result = new BadRequestObjectResult(new
                    {
                        errors = validationException.Errors.Select(x => new
                        {
                            field = x.PropertyName,
                            message = x.ErrorMessage
                        })
                    });

                    break;

                case ClientException clientException:

                    context.Result = new BadRequestObjectResult(new
                    {
                        message = clientException.Message
                    });

                    break;

                case KeyNotFoundException:

                    context.Result = new NotFoundObjectResult(new
                    {
                        message = context.Exception.Message
                    });

                    break;

                case InvalidOperationException:

                    context.Result = new BadRequestObjectResult(new
                    {
                        message = context.Exception.Message
                    });

                    break;

                default:

                    context.Result = new ObjectResult(new
                    {
                        message = "Internal server error."
                    })
                    {
                        StatusCode = (int)HttpStatusCode.InternalServerError
                    };

                    break;
            }

            context.ExceptionHandled = true;
        }
    }
}