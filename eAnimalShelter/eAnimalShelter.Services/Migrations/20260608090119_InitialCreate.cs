using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eAnimalShelter.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AnimalSpecies",
                columns: table => new
                {
                    SpeciesId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SpeciesName = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalSpecies", x => x.SpeciesId);
                });

            migrationBuilder.CreateTable(
                name: "Locations",
                columns: table => new
                {
                    LocationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Locations", x => x.LocationId);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Username = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastLoginAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ProfileImageBase64 = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "AnimalBreeds",
                columns: table => new
                {
                    BreedId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BreedName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SpeciesId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalBreeds", x => x.BreedId);
                    table.ForeignKey(
                        name: "FK_AnimalBreeds_AnimalSpecies_SpeciesId",
                        column: x => x.SpeciesId,
                        principalTable: "AnimalSpecies",
                        principalColumn: "SpeciesId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Announcements",
                columns: table => new
                {
                    AnnouncementId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PublishedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedBy = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Announcements", x => x.AnnouncementId);
                    table.ForeignKey(
                        name: "FK_Announcements_Users_CreatedBy",
                        column: x => x.CreatedBy,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Donations",
                columns: table => new
                {
                    DonationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    DonationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    PaymentMethod = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TransactionId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TransactionStatus = table.Column<int>(type: "int", nullable: false),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ReceiptPdfPath = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Donations", x => x.DonationId);
                    table.ForeignKey(
                        name: "FK_Donations_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    NotificationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: true),
                    TargetRoleId = table.Column<int>(type: "int", nullable: true),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Type = table.Column<int>(type: "int", nullable: false),
                    IsRead = table.Column<bool>(type: "bit", nullable: false),
                    DateSent = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ReadAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.NotificationId);
                    table.ForeignKey(
                        name: "FK_Notifications_Roles_TargetRoleId",
                        column: x => x.TargetRoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RefreshTokens",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Token = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    ExpiresAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RefreshTokens", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RefreshTokens_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    DateAssigned = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "VolunteerActivities",
                columns: table => new
                {
                    ActivityId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LocationId = table.Column<int>(type: "int", nullable: false),
                    StartDateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    MaxVolunteers = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    CreatedBy = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VolunteerActivities", x => x.ActivityId);
                    table.ForeignKey(
                        name: "FK_VolunteerActivities_Locations_LocationId",
                        column: x => x.LocationId,
                        principalTable: "Locations",
                        principalColumn: "LocationId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_VolunteerActivities_Users_CreatedBy",
                        column: x => x.CreatedBy,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Animals",
                columns: table => new
                {
                    AnimalId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    SpeciesId = table.Column<int>(type: "int", nullable: false),
                    BreedId = table.Column<int>(type: "int", nullable: false),
                    Gender = table.Column<int>(type: "int", nullable: false),
                    BirthDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PersonalityDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    HealthStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsVaccinated = table.Column<bool>(type: "bit", nullable: false),
                    MedicalNotes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ArrivalDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    AdoptionStatus = table.Column<int>(type: "int", nullable: false),
                    CreatedBy = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Animals", x => x.AnimalId);
                    table.ForeignKey(
                        name: "FK_Animals_AnimalBreeds_BreedId",
                        column: x => x.BreedId,
                        principalTable: "AnimalBreeds",
                        principalColumn: "BreedId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Animals_AnimalSpecies_SpeciesId",
                        column: x => x.SpeciesId,
                        principalTable: "AnimalSpecies",
                        principalColumn: "SpeciesId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Animals_Users_CreatedBy",
                        column: x => x.CreatedBy,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "VolunteerAssignments",
                columns: table => new
                {
                    AssignmentId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ActivityId = table.Column<int>(type: "int", nullable: false),
                    AppliedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ApplicationNote = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<int>(type: "int", nullable: false),
                    HoursWorked = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VolunteerAssignments", x => x.AssignmentId);
                    table.ForeignKey(
                        name: "FK_VolunteerAssignments_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_VolunteerAssignments_VolunteerActivities_ActivityId",
                        column: x => x.ActivityId,
                        principalTable: "VolunteerActivities",
                        principalColumn: "ActivityId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AdoptionRequests",
                columns: table => new
                {
                    AdoptionRequestId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    AnimalId = table.Column<int>(type: "int", nullable: false),
                    RequestDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    HousingType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ExperienceWithPets = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    HouseholdMembers = table.Column<int>(type: "int", nullable: false),
                    AdditionalNotes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<int>(type: "int", nullable: false),
                    ReviewedBy = table.Column<int>(type: "int", nullable: true),
                    ReviewDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    AdminComment = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdoptionRequests", x => x.AdoptionRequestId);
                    table.ForeignKey(
                        name: "FK_AdoptionRequests_Animals_AnimalId",
                        column: x => x.AnimalId,
                        principalTable: "Animals",
                        principalColumn: "AnimalId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionRequests_Users_ReviewedBy",
                        column: x => x.ReviewedBy,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionRequests_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "AnimalImages",
                columns: table => new
                {
                    ImageId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalId = table.Column<int>(type: "int", nullable: false),
                    FileName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    ImagePath = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    DateAdded = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalImages", x => x.ImageId);
                    table.ForeignKey(
                        name: "FK_AnimalImages_Animals_AnimalId",
                        column: x => x.AnimalId,
                        principalTable: "Animals",
                        principalColumn: "AnimalId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Favorites",
                columns: table => new
                {
                    FavoriteId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    DateAdded = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Favorites", x => x.FavoriteId);
                    table.ForeignKey(
                        name: "FK_Favorites_Animals_AnimalId",
                        column: x => x.AnimalId,
                        principalTable: "Animals",
                        principalColumn: "AnimalId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Favorites_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AnimalSpecies",
                columns: new[] { "SpeciesId", "SpeciesName" },
                values: new object[,]
                {
                    { 1, "Dog" },
                    { 2, "Cat" },
                    { 3, "Rabbit" },
                    { 4, "Bird" }
                });

            migrationBuilder.InsertData(
                table: "Locations",
                columns: new[] { "LocationId", "Name" },
                values: new object[,]
                {
                    { 1, "Main Shelter Building" },
                    { 2, "Shelter Veterinary Office" },
                    { 3, "Shelter Feeding Area" },
                    { 4, "Shelter Park" },
                    { 5, "Shelter Training Yard" },
                    { 6, "Sarajevo City Center" },
                    { 7, "Wilson's Promenade" },
                    { 8, "Vrelo Bosne" },
                    { 9, "Stojčevac Park" },
                    { 10, "Dariva Walking Trail" }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "CreatedAt", "Description", "IsActive", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "System administrator", true, "Admin" },
                    { 2, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Shelter volunteer", true, "Volunteer" },
                    { 3, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Client interested in adoption", true, "Client" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "UserId", "Address", "CreatedAt", "Email", "FirstName", "IsActive", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfileImageBase64", "Username" },
                values: new object[,]
                {
                    { 1, "Zmaja od Bosne 35, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin1@animalshelter.com", "Ahmed", true, null, "Admin", "t9MfcxAdHWVdeliyootzQ71+avU=", "gJ9vxvDflzSqxrAAsXeHYA==", "061111111", null, "admin1" },
                    { 2, "Maršala Tita 18, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin2@animalshelter.com", "Maja", true, null, "Admin", "eajMwvhAiMI1hWG1DaY/+qv+7IQ=", "r3g2TDfGSEsq1oJ951N+ag==", "061111112", null, "admin2" },
                    { 3, "Obala Kulina bana 15, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin3@animalshelter.com", "Tarik", true, null, "Admin", "bpA4f8nXHWDiYzkeVE88fOGeg2M=", "TPQSxM0CzGiakXtUg6gkAw==", "061111113", null, "admin3" },
                    { 4, "Grbavička 1, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "volunteer1@gmail.com", "Marko", true, null, "Volunteer", "8Hek5eOpof3BVH0+Cr3+KgpiZTk=", "b8bRYmt1v9mJVXSYC/tTnQ==", "062000001", null, "volunteer1" },
                    { 5, "Džemala Bijedića 37, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "volunteer2@gmail.com", "Sara", true, null, "Volunteer", "nYsojx8VgxDCn/OXh1K5Gylo9ns=", "0lpOyTMhnIiWpBCM3aqAHw==", "062000002", null, "volunteer2" },
                    { 6, "Kolodvorska 11, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "volunteer3@gmail.com", "Amar", true, null, "Volunteer", "1LVypaFIkCXvJQSz5aZxNdppKbo=", "ubUirp6/jvd2pCZJCUb8rg==", "062000003", null, "volunteer3" },
                    { 7, "Ložionička 16, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "volunteer4@gmail.com", "Lejla", true, null, "Volunteer", "0kBaTCDsvAWibA6XJ97vmeXb3bk=", "Cb3pnf2QwnJLPCdw/TNLQw==", "062000004", null, "volunteer4" },
                    { 8, "Ferhadija 22, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "client1@gmail.com", "Ana", true, null, "Kovač", "kPhIPSV4gJUE8tl/kyNSGk40Jr8=", "vn9cQcn+nPhdftrCThTbBA==", "063000001", null, "client1" },
                    { 9, "Safeta Hadžića 107, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "client2@gmail.com", "Jasmin", true, null, "Hadžić", "Ea4ZVMugoedwKFJvHl7dIbDYj/o=", "L6eV/3Gicv6qKncURl7M4Q==", "063000002", null, "client2" },
                    { 10, "Rustempašina 13, Ilidža", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "client3@gmail.com", "Emina", true, null, "Alić", "urrhgJZQdNrP/C38NXvq5zE40pI=", "pmspUO+IbXyky6hkMr+LUQ==", "063000003", null, "client3" },
                    { 11, "Hrasnička cesta 25, Hrasnica", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "client4@gmail.com", "Nina", true, null, "Mehić", "DyEAzMxBlx8wLlc9ZhJS840es4A=", "za0Kw4p3dLFuDgatyrj6Jw==", "063000004", null, "client4" },
                    { 12, "Bulevar branilaca Dobrinje 17, Dobrinja", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "client5@gmail.com", "Adnan", true, null, "Karić", "Qq3uZkuBv0V73SRnbzT8slxupPY=", "81uK+bV3fLHfgB3W/KpXtg==", "063000005", null, "client5" },
                    { 13, "Zmaja od Bosne 74, Sarajevo", new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "client6@gmail.com", "Selma", true, null, "Mujić", "I+Zv+FpDnWQx+Fu46+OaWDZud10=", "Bcqje4Ldmj9fZK4ISBbgzQ==", "063000006", null, "client6" }
                });

            migrationBuilder.InsertData(
                table: "AnimalBreeds",
                columns: new[] { "BreedId", "BreedName", "SpeciesId" },
                values: new object[,]
                {
                    { 1, "Labrador Retriever", 1 },
                    { 2, "German Shepherd", 1 },
                    { 3, "Golden Retriever", 1 },
                    { 4, "Mixed Breed Dog", 1 },
                    { 5, "Persian", 2 },
                    { 6, "Siamese", 2 },
                    { 7, "Maine Coon", 2 },
                    { 8, "Mixed Breed Cat", 2 },
                    { 9, "Mini Lop", 3 },
                    { 10, "Dutch Rabbit", 3 },
                    { 11, "Budgerigar", 4 },
                    { 12, "Cockatiel", 4 }
                });

            migrationBuilder.InsertData(
                table: "Announcements",
                columns: new[] { "AnnouncementId", "Content", "CreatedBy", "ImageUrl", "IsActive", "PublishedDate", "Title" },
                values: new object[,]
                {
                    { 1, "Thank you for supporting animal adoption.", 1, "/images/announcements/welcome.jpg", true, new DateTime(2026, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Welcome to Our Shelter" },
                    { 2, "Join us for our annual adoption fair.", 1, "/images/announcements/fair.jpg", true, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Adoption Fair Coming Soon" },
                    { 3, "We are looking for dedicated volunteers.", 2, "/images/announcements/volunteers.jpg", true, new DateTime(2026, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Volunteer Recruitment" },
                    { 4, "Help us provide better care for animals.", 3, "/images/announcements/donation.jpg", true, new DateTime(2026, 3, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Donation Campaign" },
                    { 5, "Several animals are now available for adoption.", 2, "/images/announcements/new-animals.jpg", true, new DateTime(2026, 3, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "New Animals Available" }
                });

            migrationBuilder.InsertData(
                table: "Donations",
                columns: new[] { "DonationId", "Amount", "DonationDate", "Note", "PaymentMethod", "ReceiptPdfPath", "TransactionId", "TransactionStatus", "UserId" },
                values: new object[,]
                {
                    { 1, 50.00m, new DateTime(2026, 1, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Keep up the great work!", "Credit Card", null, "DON-2026-001", 0, 8 },
                    { 2, 25.00m, new DateTime(2026, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "PayPal", null, "DON-2026-002", 0, 9 },
                    { 3, 100.00m, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "For medical expenses", "Bank Transfer", null, "DON-2026-003", 2, 10 },
                    { 4, 15.00m, new DateTime(2026, 2, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Credit Card", null, "DON-2026-004", 0, 11 },
                    { 5, 75.00m, new DateTime(2026, 2, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "Hope this helps", "PayPal", null, "DON-2026-005", 2, 12 },
                    { 6, 40.00m, new DateTime(2026, 2, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), "Transaction declined", "Credit Card", null, "DON-2026-006", 1, 13 }
                });

            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "NotificationId", "DateSent", "IsRead", "Message", "ReadAt", "TargetRoleId", "Title", "Type", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "Your request has been submitted.", new DateTime(2026, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Adoption Request Received", 0, 8 },
                    { 2, new DateTime(2026, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Your adoption request was approved.", null, null, "Request Approved", 0, 8 },
                    { 3, new DateTime(2026, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Your request is under review.", null, null, "Request Pending", 0, 9 },
                    { 4, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "Thank you for your donation.", new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Thank You", 2, 10 },
                    { 5, new DateTime(2026, 2, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "Unfortunately your request was rejected.", new DateTime(2026, 2, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Request Rejected", 0, 11 },
                    { 6, new DateTime(2026, 2, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Congratulations, request approved.", null, null, "Request Approved", 0, 12 },
                    { 7, new DateTime(2026, 2, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Your donation is pending confirmation.", null, null, "Donation Pending", 2, 13 },
                    { 8, new DateTime(2026, 2, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "You were approved for Dog Walking Day.", null, null, "Volunteer Approved", 1, 4 },
                    { 9, new DateTime(2026, 2, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "You were approved for Dog Walking Day.", null, null, "Volunteer Approved", 1, 5 },
                    { 10, new DateTime(2026, 2, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Volunteer application received.", null, null, "Application Received", 1, 6 },
                    { 11, new DateTime(2026, 3, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "You joined Adoption Fair.", null, null, "Event Participation", 1, 7 },
                    { 12, new DateTime(2026, 3, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "A new activity is available.", null, 2, "New Volunteer Event", 1, null },
                    { 13, new DateTime(2026, 3, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Check newly available animals.", null, 3, "New Animals Available", 3, null },
                    { 14, new DateTime(2026, 3, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Visit our adoption fair this weekend.", null, 3, "Adoption Fair", 3, null },
                    { 15, new DateTime(2026, 3, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Database maintenance scheduled.", null, 1, "System Update", 4, null },
                    { 16, new DateTime(2026, 3, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "A new request requires review.", null, null, "New Adoption Request", 0, 1 },
                    { 17, new DateTime(2026, 3, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "A donation was received.", null, null, "New Donation", 2, 2 },
                    { 18, new DateTime(2026, 3, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Fundraising event completed.", null, null, "Activity Completed", 1, 3 }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1 },
                    { 2, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 2 },
                    { 3, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 3 },
                    { 4, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 4 },
                    { 5, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 5 },
                    { 6, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 6 },
                    { 7, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 7 },
                    { 8, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 8 },
                    { 9, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 9 },
                    { 10, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 10 },
                    { 11, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 11 },
                    { 12, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 12 },
                    { 13, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 13 }
                });

            migrationBuilder.InsertData(
                table: "VolunteerActivities",
                columns: new[] { "ActivityId", "CreatedBy", "Description", "EndDateTime", "LocationId", "MaxVolunteers", "StartDateTime", "Status", "Title" },
                values: new object[,]
                {
                    { 1, 1, "Volunteers help walk shelter dogs.", new DateTime(2026, 3, 5, 13, 0, 0, 0, DateTimeKind.Unspecified), 7, 10, new DateTime(2026, 3, 5, 9, 0, 0, 0, DateTimeKind.Unspecified), 0, "Dog Walking Day" },
                    { 2, 2, "General cleaning and maintenance.", new DateTime(2026, 3, 10, 14, 0, 0, 0, DateTimeKind.Unspecified), 1, 8, new DateTime(2026, 3, 10, 8, 0, 0, 0, DateTimeKind.Unspecified), 0, "Shelter Cleaning" },
                    { 3, 1, "Community adoption event.", new DateTime(2026, 4, 2, 18, 0, 0, 0, DateTimeKind.Unspecified), 9, 15, new DateTime(2026, 4, 2, 10, 0, 0, 0, DateTimeKind.Unspecified), 0, "Pet Adoption Fair" },
                    { 4, 3, "Collecting donations for shelter animals.", new DateTime(2026, 2, 15, 17, 0, 0, 0, DateTimeKind.Unspecified), 6, 12, new DateTime(2026, 2, 15, 9, 0, 0, 0, DateTimeKind.Unspecified), 1, "Fundraising Event" },
                    { 5, 2, "Helping transport rescued animals.", new DateTime(2026, 4, 20, 15, 0, 0, 0, DateTimeKind.Unspecified), 2, 5, new DateTime(2026, 4, 20, 7, 0, 0, 0, DateTimeKind.Unspecified), 2, "Animal Transport Assistance" }
                });

            migrationBuilder.InsertData(
                table: "Animals",
                columns: new[] { "AnimalId", "AdoptionStatus", "ArrivalDate", "BirthDate", "BreedId", "CreatedBy", "Description", "Gender", "HealthStatus", "IsVaccinated", "MedicalNotes", "Name", "PersonalityDescription", "SpeciesId" },
                values: new object[,]
                {
                    { 1, 0, new DateTime(2025, 10, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2022, 5, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1, "Friendly Labrador looking for a loving home.", 1, "Excellent", true, null, "Max", "Energetic, playful and loyal.", 1 },
                    { 2, 0, new DateTime(2025, 9, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 8, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1, "Golden Retriever rescued from the streets.", 2, "Good", true, null, "Bella", "Gentle and affectionate.", 1 },
                    { 3, 1, new DateTime(2025, 8, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2020, 3, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, "Strong and intelligent German Shepherd.", 1, "Excellent", true, null, "Rocky", "Protective and obedient.", 1 },
                    { 4, 0, new DateTime(2025, 11, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 2, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, 1, "Mixed breed dog with lots of energy.", 1, "Good", true, null, "Charlie", "Friendly and curious.", 1 },
                    { 5, 0, new DateTime(2025, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 6, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, 2, "Beautiful Persian cat.", 2, "Excellent", true, null, "Luna", "Calm and elegant.", 2 },
                    { 6, 2, new DateTime(2025, 7, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2022, 11, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), 6, 1, "British Shorthair with a loving personality.", 1, "Excellent", true, null, "Milo", "Quiet and affectionate.", 2 },
                    { 7, 0, new DateTime(2025, 10, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 4, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), 7, 2, "Playful Siamese cat.", 2, "Good", true, null, "Nala", "Very social and active.", 2 },
                    { 8, 1, new DateTime(2025, 9, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 12, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 8, 3, "Mixed breed cat rescued from abandonment.", 1, "Good", true, null, "Simba", "Friendly and independent.", 2 },
                    { 9, 0, new DateTime(2025, 12, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 1, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), 9, 1, "Mini Lop rabbit with soft white fur.", 2, "Excellent", true, null, "Snow", "Gentle and shy.", 3 },
                    { 10, 0, new DateTime(2025, 10, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2023, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 10, 2, "Friendly rabbit that enjoys human company.", 1, "Good", true, null, "Coco", "Playful and curious.", 3 },
                    { 11, 0, new DateTime(2025, 11, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 3, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 11, 3, "Bright and cheerful budgerigar.", 1, "Excellent", false, null, "Sky", "Active and vocal.", 4 },
                    { 12, 0, new DateTime(2025, 11, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2024, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 12, 3, "Cockatiel that enjoys interaction.", 2, "Excellent", false, null, "Sunny", "Friendly and intelligent.", 4 },
                    { 13, 2, new DateTime(2025, 6, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2020, 7, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1, "Experienced family dog.", 2, "Good", true, null, "Daisy", "Very calm and loving.", 1 },
                    { 14, 0, new DateTime(2025, 9, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2022, 2, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), 6, 2, "British Shorthair with striking eyes.", 1, "Excellent", true, null, "Leo", "Relaxed and affectionate.", 2 },
                    { 15, 0, new DateTime(2025, 8, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 10, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 3, "Golden Retriever looking for an active family.", 1, "Excellent", true, null, "Buddy", "Friendly, loyal and energetic.", 1 }
                });

            migrationBuilder.InsertData(
                table: "VolunteerAssignments",
                columns: new[] { "AssignmentId", "ActivityId", "ApplicationNote", "AppliedAt", "HoursWorked", "Status", "UserId" },
                values: new object[,]
                {
                    { 1, 1, "Love working with dogs.", new DateTime(2026, 2, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), 4m, 1, 4 },
                    { 2, 1, "Available all day.", new DateTime(2026, 2, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), 4m, 1, 5 },
                    { 3, 2, "Happy to help.", new DateTime(2026, 2, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), 0m, 0, 6 },
                    { 4, 3, "Experience with events.", new DateTime(2026, 3, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 0m, 1, 7 },
                    { 5, 4, "Can assist with fundraising.", new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 8m, 4, 4 },
                    { 6, 4, "Available whole day.", new DateTime(2026, 2, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), 8m, 4, 6 },
                    { 7, 5, "Can drive animals.", new DateTime(2026, 3, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 0m, 3, 5 }
                });

            migrationBuilder.InsertData(
                table: "AdoptionRequests",
                columns: new[] { "AdoptionRequestId", "AdditionalNotes", "AdminComment", "AnimalId", "ExperienceWithPets", "HouseholdMembers", "HousingType", "RequestDate", "ReviewDate", "ReviewedBy", "Status", "UserId" },
                values: new object[,]
                {
                    { 1, "Lives near a park", "Suitable adopter", 1, "Owned dogs for 5 years", 3, "Apartment", new DateTime(2026, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 1, 8 },
                    { 2, null, null, 3, "Previous dog owner", 4, "House", new DateTime(2026, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, 0, 9 },
                    { 3, "Works from home", "Excellent conditions", 5, "Cat owner", 2, "Apartment", new DateTime(2026, 1, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 1, 10 },
                    { 4, null, "Insufficient preparation", 8, "No previous experience", 5, "House", new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 2, 11 },
                    { 5, "Quiet environment", "Good match", 9, "Owned rabbits", 1, "Apartment", new DateTime(2026, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1, 12 },
                    { 6, null, null, 10, "Various pets", 2, "House", new DateTime(2026, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, 0, 13 },
                    { 7, null, "Application incomplete", 14, "Cat owner", 2, "Apartment", new DateTime(2026, 2, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, 8 },
                    { 8, "Large yard", null, 15, "Dog owner", 4, "House", new DateTime(2026, 2, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, 0, 9 },
                    { 9, null, null, 4, "Some experience", 2, "Apartment", new DateTime(2026, 2, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), null, null, 3, 10 }
                });

            migrationBuilder.InsertData(
                table: "AnimalImages",
                columns: new[] { "ImageId", "AnimalId", "DateAdded", "FileName", "ImagePath" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "max-1.jpg", "/images/animals/max-1.jpg" },
                    { 2, 1, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "max-2.jpg", "/images/animals/max-2.jpg" },
                    { 3, 2, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "bella-1.jpg", "/images/animals/bella-1.jpg" },
                    { 4, 2, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "bella-2.jpg", "/images/animals/bella-2.jpg" },
                    { 5, 3, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "rocky-1.jpg", "/images/animals/rocky-1.jpg" },
                    { 6, 3, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "rocky-2.jpg", "/images/animals/rocky-2.jpg" },
                    { 7, 4, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "charlie-1.jpg", "/images/animals/charlie-1.jpg" },
                    { 8, 5, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "luna-1.jpg", "/images/animals/luna-1.jpg" },
                    { 9, 5, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "luna-2.jpg", "/images/animals/luna-2.jpg" },
                    { 10, 6, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "milo-1.jpg", "/images/animals/milo-1.jpg" },
                    { 11, 7, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "nala-1.jpg", "/images/animals/nala-1.jpg" },
                    { 12, 7, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "nala-2.jpg", "/images/animals/nala-2.jpg" },
                    { 13, 8, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "simba-1.jpg", "/images/animals/simba-1.jpg" },
                    { 14, 9, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "snow-1.jpg", "/images/animals/snow-1.jpg" },
                    { 15, 10, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "coco-1.jpg", "/images/animals/coco-1.jpg" },
                    { 16, 10, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "coco-2.jpg", "/images/animals/coco-2.jpg" },
                    { 17, 11, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "sky-1.jpg", "/images/animals/sky-1.jpg" },
                    { 18, 12, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "sunny-1.jpg", "/images/animals/sunny-1.jpg" },
                    { 19, 13, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "daisy-1.jpg", "/images/animals/daisy-1.jpg" },
                    { 20, 13, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "daisy-2.jpg", "/images/animals/daisy-2.jpg" },
                    { 21, 14, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "leo-1.jpg", "/images/animals/leo-1.jpg" },
                    { 22, 15, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "buddy-1.jpg", "/images/animals/buddy-1.jpg" }
                });

            migrationBuilder.InsertData(
                table: "Favorites",
                columns: new[] { "FavoriteId", "AnimalId", "DateAdded", "UserId" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2026, 1, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 8 },
                    { 2, 5, new DateTime(2026, 1, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), 8 },
                    { 3, 3, new DateTime(2026, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 9 },
                    { 4, 15, new DateTime(2026, 1, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 9 },
                    { 5, 5, new DateTime(2026, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 10 },
                    { 6, 14, new DateTime(2026, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 10 },
                    { 7, 2, new DateTime(2026, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), 11 },
                    { 8, 7, new DateTime(2026, 1, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), 11 },
                    { 9, 9, new DateTime(2026, 1, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), 12 },
                    { 10, 10, new DateTime(2026, 1, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), 12 },
                    { 11, 4, new DateTime(2026, 1, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), 13 },
                    { 12, 11, new DateTime(2026, 1, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), 13 },
                    { 13, 12, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 8 },
                    { 14, 13, new DateTime(2026, 2, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), 9 },
                    { 15, 6, new DateTime(2026, 2, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), 10 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionRequests_AnimalId",
                table: "AdoptionRequests",
                column: "AnimalId");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionRequests_ReviewedBy",
                table: "AdoptionRequests",
                column: "ReviewedBy");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionRequests_UserId",
                table: "AdoptionRequests",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalBreeds_SpeciesId",
                table: "AnimalBreeds",
                column: "SpeciesId");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalImages_AnimalId",
                table: "AnimalImages",
                column: "AnimalId");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_BreedId",
                table: "Animals",
                column: "BreedId");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_CreatedBy",
                table: "Animals",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_SpeciesId",
                table: "Animals",
                column: "SpeciesId");

            migrationBuilder.CreateIndex(
                name: "IX_Announcements_CreatedBy",
                table: "Announcements",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Donations_UserId",
                table: "Donations",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Favorites_AnimalId",
                table: "Favorites",
                column: "AnimalId");

            migrationBuilder.CreateIndex(
                name: "IX_Favorites_UserId_AnimalId",
                table: "Favorites",
                columns: new[] { "UserId", "AnimalId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_TargetRoleId",
                table: "Notifications",
                column: "TargetRoleId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RefreshTokens_UserId",
                table: "RefreshTokens",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_UserId",
                table: "UserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_Email",
                table: "Users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_Username",
                table: "Users",
                column: "Username",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_VolunteerActivities_CreatedBy",
                table: "VolunteerActivities",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_VolunteerActivities_LocationId",
                table: "VolunteerActivities",
                column: "LocationId");

            migrationBuilder.CreateIndex(
                name: "IX_VolunteerAssignments_ActivityId",
                table: "VolunteerAssignments",
                column: "ActivityId");

            migrationBuilder.CreateIndex(
                name: "IX_VolunteerAssignments_UserId_ActivityId",
                table: "VolunteerAssignments",
                columns: new[] { "UserId", "ActivityId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdoptionRequests");

            migrationBuilder.DropTable(
                name: "AnimalImages");

            migrationBuilder.DropTable(
                name: "Announcements");

            migrationBuilder.DropTable(
                name: "Donations");

            migrationBuilder.DropTable(
                name: "Favorites");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "RefreshTokens");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "VolunteerAssignments");

            migrationBuilder.DropTable(
                name: "Animals");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "VolunteerActivities");

            migrationBuilder.DropTable(
                name: "AnimalBreeds");

            migrationBuilder.DropTable(
                name: "Locations");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "AnimalSpecies");
        }
    }
}
