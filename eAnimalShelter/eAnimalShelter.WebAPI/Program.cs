using Scalar.AspNetCore;
using eAnimalShelter.Services.Database;
using Microsoft.EntityFrameworkCore;
using Mapster;
using eAnimalShelter.Services.Interfaces;
using eAnimalShelter.Services;
using eAnimalShelter.Model.Requests;
using eAnimalShelter.Model.Enums;
using eAnimalShelter.Services.Validators;
using FluentValidation;
using eAnimalShelter.WebAPI.Filters;
using eAnimalShelter.Common.Services.CryptoService;
using eAnimalShelter.Model.Responses;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using eAnimalShelter.WebAPI.Services.AccessManager;
using eAnimalShelter.WebAPI.Services;
using Microsoft.OpenApi.MicrosoftExtensions;
using Microsoft.OpenApi;
using EasyNetQ;
using eAnimalShelter.Services.AdoptionRequestStateMachine;
using eAnimalShelter.Services.VolunteerAssignmentStateMachine;
using Stripe;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IAuthenticatedUserAccessor, HttpAuthenticatedUserAccessor>();
builder.Services.AddControllers(options =>
{
    options.Filters.AddService<GlobalExceptionFilter>();
});
builder.Services.AddSingleton<IBus>(_ =>
    RabbitHutch.CreateBus(
        $"host={Environment.GetEnvironmentVariable("RABBITMQ_HOST")}:{Environment.GetEnvironmentVariable("RABBITMQ_PORT")};" +
        $"username={Environment.GetEnvironmentVariable("RABBITMQ_USER")};" +
        $"password={Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD")}"
    )
);
StripeConfiguration.ApiKey =
    Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");

builder.Services.AddScoped<BaseAdoptionRequestState>();
builder.Services.AddScoped<InitialAdoptionRequestState>();
builder.Services.AddScoped<PendingAdoptionRequestState>();
builder.Services.AddScoped<ApprovedAdoptionRequestState>();
builder.Services.AddScoped<RejectedAdoptionRequestState>();
builder.Services.AddScoped<CancelledAdoptionRequestState>();

builder.Services.AddScoped<BaseVolunteerActivityState>();
builder.Services.AddScoped<ActiveVolunteerActivityState>();
builder.Services.AddScoped<CompletedVolunteerActivityState>();
builder.Services.AddScoped<CancelledVolunteerActivityState>();

builder.Services.AddScoped<BaseVolunteerAssignmentState>();
builder.Services.AddScoped<PendingVolunteerAssignmentState>();
builder.Services.AddScoped<ApprovedVolunteerAssignmentState>();
builder.Services.AddScoped<RejectedVolunteerAssignmentState>();
builder.Services.AddScoped<CancelledVolunteerAssignmentState>();
builder.Services.AddScoped<CompletedVolunteerAssignmentState>();
// register Mapster for object mapping
builder.Services.AddMapster();

// configure a few mappings explicitly if needed (optional)
// Mapster will automatically map same-named properties, but configuration
// ensures any custom rules or future needs can be added here.
TypeAdapterConfig<AnimalBreed, AnimalBreedResponse>
    .NewConfig()
    .Map(dest => dest.SpeciesName,
         src => src.Species.SpeciesName);
TypeAdapterConfig<AnimalSpecies, AnimalSpeciesResponse>.NewConfig();
TypeAdapterConfig<Role, RoleResponse>.NewConfig();
TypeAdapterConfig<User, UserResponse>.NewConfig().IgnoreNullValues(true);
TypeAdapterConfig<UserUpdateRequest, User>.NewConfig().IgnoreNullValues(true);
TypeAdapterConfig<Announcement, AnnouncementResponse>
    .NewConfig()
    .Map(dest => dest.CreatedByUserName,
         src => src.CreatedByUser.Username);
TypeAdapterConfig<VolunteerActivity, VolunteerActivityResponse>
    .NewConfig()
    .Map(dest => dest.CreatedByUserName,
         src => src.CreatedByUser.Username)
    .Map(dest => dest.LocationName,
         src => src.Location.Name)
    .Map(dest => dest.CurrentVolunteers,
     src => src.VolunteerAssignments.Count(x =>
         x.Status == AssignmentStatus.Approved ||
         x.Status == AssignmentStatus.Completed))
    .Map(dest => dest.ApplicationsCount,
         src => src.VolunteerAssignments.Count());

TypeAdapterConfig<VolunteerActivityInsertRequest, VolunteerActivity>
    .NewConfig()
    .Ignore(dest => dest.ActivityId)
    .Ignore(dest => dest.CreatedBy)
    .Ignore(dest => dest.Status)
    .Ignore(dest => dest.CreatedByUser)
    .Ignore(dest => dest.Location)
    .Ignore(dest => dest.VolunteerAssignments);
TypeAdapterConfig<VolunteerActivityUpdateRequest, VolunteerActivity>
    .NewConfig()
    .Ignore(dest => dest.ActivityId)
    .Ignore(dest => dest.CreatedBy)
    .Ignore(dest => dest.CreatedByUser)
    .Ignore(dest => dest.Location)
    .Ignore(dest => dest.VolunteerAssignments);
TypeAdapterConfig<Donation, DonationResponse>
    .NewConfig()
    .Map(dest => dest.CreatedByUserName,
         src => src.User.Username)
     .Map(dest => dest.UserFullName,
         src => src.User.FirstName + " " + src.User.LastName);
TypeAdapterConfig<DonationInsertRequest, Donation>
    .NewConfig()
    .Ignore(dest => dest.UserId)
    .Ignore(dest => dest.TransactionStatus)
    .Ignore(dest => dest.User);
TypeAdapterConfig<DonationUpdateRequest, Donation>
    .NewConfig()
    .Ignore(dest => dest.DonationId)
    .Ignore(dest => dest.UserId)
    .Ignore(dest => dest.User);
TypeAdapterConfig<VolunteerAssignment, VolunteerAssignmentResponse>
    .NewConfig()
    .Map(dest => dest.UserName,
         src => src.User.Username)
    .Map(dest => dest.ActivityTitle,
         src => src.Activity.Title)
    .Map(dest => dest.Email,
         src => src.User.Email)
    .Map(dest => dest.PhoneNumber,
         src => src.User.PhoneNumber)
    .Map(dest => dest.ActivityStartDateTime,
         src => src.Activity.StartDateTime);
TypeAdapterConfig<VolunteerAssignmentInsertRequest, VolunteerAssignment>
    .NewConfig()
    .Ignore(dest => dest.AssignmentId)
    .Ignore(dest => dest.UserId)
    .Ignore(dest => dest.AppliedAt)
    .Ignore(dest => dest.Status)
    .Ignore(dest => dest.HoursWorked)
    .Ignore(dest => dest.User)
    .Ignore(dest => dest.Activity);
TypeAdapterConfig<VolunteerAssignmentUpdateRequest, VolunteerAssignment>
    .NewConfig()
    .Ignore(dest => dest.AssignmentId)
    .Ignore(dest => dest.UserId)
    .Ignore(dest => dest.ActivityId)
    .Ignore(dest => dest.AppliedAt)
    .Ignore(dest => dest.User)
    .Ignore(dest => dest.Activity);
TypeAdapterConfig<Notification, NotificationResponse>
    .NewConfig()
    .Map(dest => dest.UserName,
         src => src.User != null ? src.User.Username : null)
    .Map(dest => dest.TargetRoleName,
         src => src.TargetRole != null ? src.TargetRole.Name : null);
TypeAdapterConfig<NotificationInsertRequest, Notification>
    .NewConfig()
    .Ignore(dest => dest.NotificationId)
    .Ignore(dest => dest.DateSent)
    .Ignore(dest => dest.ReadAt)
    .Ignore(dest => dest.IsRead)
    .Ignore(dest => dest.User)
    .Ignore(dest => dest.TargetRole);
TypeAdapterConfig<NotificationUpdateRequest, Notification>
    .NewConfig()
    .Ignore(dest => dest.NotificationId)
    .Ignore(dest => dest.DateSent)
    .Ignore(dest => dest.User)
    .Ignore(dest => dest.TargetRole);
TypeAdapterConfig<AdoptionRequest, AdoptionRequestResponse>
    .NewConfig()
    .Map(dest => dest.UserName,
         src => src.User.Username)
    .Map(dest => dest.AnimalName,
         src => src.Animal.Name)
    .Map(dest => dest.ReviewedByUserName,
         src => src.Reviewer != null ? src.Reviewer.Username : null);
TypeAdapterConfig<AdoptionRequestInsertRequest, AdoptionRequest>
    .NewConfig()
    .Ignore(dest => dest.AdoptionRequestId)
    .Ignore(dest => dest.UserId)
    .Ignore(dest => dest.RequestDate)
    .Ignore(dest => dest.Status)
    .Ignore(dest => dest.ReviewedBy)
    .Ignore(dest => dest.ReviewDate)
    .Ignore(dest => dest.AdminComment)
    .Ignore(dest => dest.User)
    .Ignore(dest => dest.Animal)
    .Ignore(dest => dest.Reviewer);
TypeAdapterConfig<AdoptionRequestUpdateRequest, AdoptionRequest>
    .NewConfig()
    .Ignore(dest => dest.AdoptionRequestId)
    .Ignore(dest => dest.UserId)
    .Ignore(dest => dest.AnimalId)
    .Ignore(dest => dest.RequestDate)
    .Ignore(dest => dest.ReviewedBy)
    .Ignore(dest => dest.ReviewDate)
    .Ignore(dest => dest.User)
    .Ignore(dest => dest.Animal)
    .Ignore(dest => dest.Reviewer);
TypeAdapterConfig<Animal, AnimalResponse>
    .NewConfig()
    .Map(dest => dest.SpeciesName,
         src => src.Species.SpeciesName)
    .Map(dest => dest.BreedName,
         src => src.Breed.BreedName)
    .Map(dest => dest.CreatedByUserName,
         src => src.CreatedByUser.Username);
 TypeAdapterConfig<AnimalInsertRequest, Animal>
    .NewConfig()
    .Ignore(dest => dest.AnimalId)
    .Ignore(dest => dest.CreatedBy)
    .Ignore(dest => dest.CreatedByUser)
    .Ignore(dest => dest.Species)
    .Ignore(dest => dest.Breed)
    .Ignore(dest => dest.Images)
    .Ignore(dest => dest.AdoptionRequests);
TypeAdapterConfig<AnimalUpdateRequest, Animal>
    .NewConfig()
    .Ignore(dest => dest.AnimalId)
    .Ignore(dest => dest.CreatedBy)
    .Ignore(dest => dest.CreatedByUser)
    .Ignore(dest => dest.Species)
    .Ignore(dest => dest.Breed)
    .Ignore(dest => dest.Images)
    .Ignore(dest => dest.AdoptionRequests);

    TypeAdapterConfig<AnimalImage, AnimalImageResponse>
    .NewConfig()
    .Map(dest => dest.AnimalName,
         src => src.Animal.Name);

TypeAdapterConfig<AnimalImageInsertRequest, AnimalImage>
    .NewConfig()
    .Ignore(dest => dest.ImageId)
    .Ignore(dest => dest.DateAdded)
    .Ignore(dest => dest.Animal);

TypeAdapterConfig<AnimalImageUpdateRequest, AnimalImage>
    .NewConfig()
    .Ignore(dest => dest.ImageId)
    .Ignore(dest => dest.DateAdded)
    .Ignore(dest => dest.Animal);
TypeAdapterConfig<Favorite, FavoriteResponse>
    .NewConfig();



// register application services
builder.Services.AddScoped<IAnimalBreedService, AnimalBreedService>();
builder.Services.AddScoped<IAnimalSpeciesService, AnimalSpeciesService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IAnnouncementService, AnnouncementService>();
builder.Services.AddScoped<IDonationService, DonationService>();
builder.Services.AddScoped<ILocationService, LocationService>();
builder.Services.AddScoped<IFavoriteService, FavoriteService>();
builder.Services.AddScoped<IRoleService, RoleService>();
builder.Services.AddScoped<IVolunteerActivityService, VolunteerActivityService>();
builder.Services.AddScoped<IVolunteerAssignmentService, VolunteerAssignmentService>();
builder.Services.AddScoped<INotificationService, NotificationService>();
builder.Services.AddScoped<IAnimalService, AnimalService>();
builder.Services.AddScoped<IAnimalImageService, AnimalImageService>();
builder.Services.AddScoped<IAdoptionRequestService, AdoptionRequestService>();
builder.Services.AddScoped<GlobalExceptionFilter>();
builder.Services.AddScoped<IPdfService, PdfService>();
builder.Services.AddScoped<IAnimalViewHistoryService,AnimalViewHistoryService>();

builder.Services.AddScoped<ICryptoService, CryptoService>();
builder.Services.AddScoped<IRefreshTokenService, RefreshTokenService>();

builder.Services.AddScoped<IAccessManager, AccessManager>();
builder.Services.AddScoped<IDashboardService, DashboardService>();
builder.Services.AddScoped<IRecommendationService, RecommendationService>();

builder.Services.AddScoped<IValidator<AnimalBreedInsertRequest>,AnimalBreedInsertValidator>();
builder.Services.AddScoped<IValidator<AnimalBreedUpdateRequest>,AnimalBreedUpdateValidator>();

builder.Services.AddScoped<IValidator<AnnouncementInsertRequest>, AnnouncementInsertValidator>();
builder.Services.AddScoped<IValidator<AnnouncementUpdateRequest>, AnnouncementUpdateValidator>();

builder.Services.AddScoped<IValidator<DonationInsertRequest>, DonationInsertValidator>();
builder.Services.AddScoped<IValidator<DonationUpdateRequest>, DonationUpdateValidator>();

builder.Services.AddScoped<IValidator<LocationInsertRequest>, LocationInsertValidator>();
builder.Services.AddScoped<IValidator<LocationUpdateRequest>, LocationUpdateValidator>();

builder.Services.AddScoped<IValidator<UserInsertRequest>, UserInsertValidator>();
builder.Services.AddScoped<IValidator<UserUpdateRequest>, UserUpdateValidator>();

builder.Services.AddScoped<IValidator<FavoriteInsertRequest>, FavoriteInsertValidator>();
builder.Services.AddScoped<IValidator<FavoriteUpdateRequest>, FavoriteUpdateValidator>();

builder.Services.AddScoped<IValidator<RoleInsertRequest>, RoleInsertValidator>();
builder.Services.AddScoped<IValidator<RoleUpdateRequest>, RoleUpdateValidator>();

builder.Services.AddScoped<IValidator<VolunteerActivityInsertRequest>, VolunteerActivityInsertValidator>();
builder.Services.AddScoped<IValidator<VolunteerActivityUpdateRequest>, VolunteerActivityUpdateValidator>();

builder.Services.AddScoped<IValidator<VolunteerAssignmentInsertRequest>, VolunteerAssignmentInsertValidator>();
builder.Services.AddScoped<IValidator<VolunteerAssignmentUpdateRequest>, VolunteerAssignmentUpdateValidator>();

builder.Services.AddScoped<IValidator<NotificationInsertRequest>, NotificationInsertValidator>();
builder.Services.AddScoped<IValidator<NotificationUpdateRequest>, NotificationUpdateValidator>();

builder.Services.AddScoped<IValidator<AdoptionRequestInsertRequest>, AdoptionRequestInsertValidator>();
builder.Services.AddScoped<IValidator<AdoptionRequestUpdateRequest>, AdoptionRequestUpdateValidator>();

builder.Services.AddScoped<IValidator<AnimalInsertRequest>, AnimalInsertValidator>();
builder.Services.AddScoped<IValidator<AnimalUpdateRequest>, AnimalUpdateValidator>();

builder.Services.AddScoped<IValidator<AnimalImageInsertRequest>, AnimalImageInsertValidator>();
builder.Services.AddScoped<IValidator<AnimalImageUpdateRequest>, AnimalImageUpdateValidator>();
// category service
builder.Services.AddValidatorsFromAssemblyContaining<AnimalBreedInsertValidator>();
// Add DbContext
var connectionString =
    $"Server={Environment.GetEnvironmentVariable("DB_HOST")},{Environment.GetEnvironmentVariable("DB_PORT")};" +
    $"Database={Environment.GetEnvironmentVariable("DB_NAME")};" +
    $"User Id={Environment.GetEnvironmentVariable("DB_USER")};" +
    $"Password={Environment.GetEnvironmentVariable("DB_PASSWORD")};" +
    "TrustServerCertificate=true";
builder.Services.AddDbContext<eAnimalShelterDbContext>(options =>
    options.UseSqlServer(connectionString));


// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;

    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters =
        new TokenValidationParameters
        {
            ValidIssuer =
                Environment.GetEnvironmentVariable("JWT_ISSUER"),

            ValidAudience =
                Environment.GetEnvironmentVariable("JWT_AUDIENCE"),

            IssuerSigningKey =
                new SymmetricSecurityKey(
                    Encoding.UTF8.GetBytes(
                        Environment.GetEnvironmentVariable("JWT_SECRET_KEY") ?? string.Empty)),

            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ClockSkew = TimeSpan.Zero
        };
    options.Events = new JwtBearerEvents
        {
            OnChallenge = async context =>
        {
            context.HandleResponse();

            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            context.Response.ContentType = "application/json";

            await context.Response.WriteAsJsonAsync(new
            {
                message = "You must be logged in to access this resource."
            });
        },
            OnForbidden = async context =>
            {
                context.Response.StatusCode = StatusCodes.Status403Forbidden;
                context.Response.ContentType = "application/json";

                await context.Response.WriteAsJsonAsync(new
                {
                    message = "You do not have permission to perform this action."
                });
            }
        };
});

builder.Services.AddAuthorization();

builder.Services.AddEndpointsApiExplorer();


builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        Description = "Enter your JWT token"
    });
    
    options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});

var app = builder.Build();
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<eAnimalShelterDbContext>();

    db.Database.Migrate();
}

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();

    app.UseSwagger();
    app.UseSwaggerUI();

    
}

//app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
