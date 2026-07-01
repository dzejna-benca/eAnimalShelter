
using eAnimalShelter.Model.Enums;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services.Database
{
    public partial class eAnimalShelterDbContext : DbContext
    {
        private void CreateSeed(ModelBuilder modelBuilder)
        {
            SeedRoles(modelBuilder);
            SeedUsers(modelBuilder);
            SeedUserRoles(modelBuilder);
                    
            SeedAnimalSpecies(modelBuilder);
            SeedAnimalBreeds(modelBuilder);

            SeedAnimals(modelBuilder);
            SeedAnimalImages(modelBuilder);

            SeedAdoptionRequests(modelBuilder);
            SeedLocations(modelBuilder);

            SeedVolunteerActivities(modelBuilder);
            SeedVolunteerAssignments(modelBuilder);

            SeedDonations(modelBuilder);
            SeedFavorites(modelBuilder);

            SeedAnnouncements(modelBuilder);
            SeedNotifications(modelBuilder);
            SeedAnimalViewHistory(modelBuilder);


        }
        private void SeedRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Role>().HasData(
                new
                {
                    Id = 1,
                    Name = "Admin",
                    Description = "System administrator",
                    IsActive = true,
                    CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new
                {
                    Id = 2,
                    Name = "Volunteer",
                    Description = "Shelter volunteer",
                    IsActive = true,
                    CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new
                {
                    Id = 3,
                    Name = "Client",
                    Description = "Client interested in adoption",
                    IsActive = true,
                    CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                }
            );
        }
        private void SeedUsers(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>().HasData(

                // ADMINS

                new
                {
                    UserId = 1,
                    FirstName = "Ahmed",
                    LastName = "Admin",
                    Email = "admin1@animalshelter.com",
                    Username = "admin1",
                    PasswordHash = "t9MfcxAdHWVdeliyootzQ71+avU=", //Test1
                    PasswordSalt = "gJ9vxvDflzSqxrAAsXeHYA==",
                    PhoneNumber = "061111111",
                    Address = "Zmaja od Bosne 35, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1),
                    LastLoginAt = (DateTime?)null,
                },

                new
                {
                    UserId = 2,
                    FirstName = "Maja",
                    LastName = "Admin",
                    Email = "admin2@animalshelter.com",
                    Username = "admin2",
                    PasswordHash = "eajMwvhAiMI1hWG1DaY/+qv+7IQ=",
                    PasswordSalt = "r3g2TDfGSEsq1oJ951N+ag==",
                    PhoneNumber = "061111112",
                    Address = "Maršala Tita 18, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1),
                    LastLoginAt = (DateTime?)null,
                },

                new
                {
                    UserId = 3,
                    FirstName = "Tarik",
                    LastName = "Admin",
                    Email = "admin3@animalshelter.com",
                    Username = "admin3",
                    PasswordHash = "bpA4f8nXHWDiYzkeVE88fOGeg2M=",
                    PasswordSalt = "TPQSxM0CzGiakXtUg6gkAw==",
                    PhoneNumber = "061111113",
                    Address = "Obala Kulina bana 15, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1),
                    LastLoginAt = (DateTime?)null,
                },

                // VOLUNTEERS

                new
                {
                    UserId = 4,
                    FirstName = "Marko",
                    LastName = "Volunteer",
                    Email = "volunteer1@gmail.com",
                    Username = "volunteer1",
                    PasswordHash = "8Hek5eOpof3BVH0+Cr3+KgpiZTk=",
                    PasswordSalt = "b8bRYmt1v9mJVXSYC/tTnQ==",
                    PhoneNumber = "062000001",
                    Address = "Grbavička 1, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 5,
                    FirstName = "Sara",
                    LastName = "Volunteer",
                    Email = "volunteer2@gmail.com",
                    Username = "volunteer2",
                    PasswordHash = "nYsojx8VgxDCn/OXh1K5Gylo9ns=",
                    PasswordSalt = "0lpOyTMhnIiWpBCM3aqAHw==",
                    PhoneNumber = "062000002",
                    Address = "Džemala Bijedića 37, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 6,
                    FirstName = "Amar",
                    LastName = "Volunteer",
                    Email = "volunteer3@gmail.com",
                    Username = "volunteer3",
                    PasswordHash = "1LVypaFIkCXvJQSz5aZxNdppKbo=",
                    PasswordSalt = "ubUirp6/jvd2pCZJCUb8rg==",
                    PhoneNumber = "062000003",
                    Address = "Kolodvorska 11, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 7,
                    FirstName = "Lejla",
                    LastName = "Volunteer",
                    Email = "volunteer4@gmail.com",
                    Username = "volunteer4",
                    PasswordHash = "0kBaTCDsvAWibA6XJ97vmeXb3bk=",
                    PasswordSalt = "Cb3pnf2QwnJLPCdw/TNLQw==",
                    PhoneNumber = "062000004",
                    Address = "Ložionička 16, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                // CLIENTS

                new
                {
                    UserId = 8,
                    FirstName = "Ana",
                    LastName = "Kovač",
                    Email = "client1@gmail.com",
                    Username = "client1",
                    PasswordHash = "kPhIPSV4gJUE8tl/kyNSGk40Jr8=",
                    PasswordSalt = "vn9cQcn+nPhdftrCThTbBA==",
                    PhoneNumber = "063000001",
                    Address = "Ferhadija 22, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 9,
                    FirstName = "Jasmin",
                    LastName = "Hadžić",
                    Email = "client2@gmail.com",
                    Username = "client2",
                    PasswordHash = "Ea4ZVMugoedwKFJvHl7dIbDYj/o=",
                    PasswordSalt = "L6eV/3Gicv6qKncURl7M4Q==",
                    PhoneNumber = "063000002",
                    Address = "Safeta Hadžića 107, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 10,
                    FirstName = "Emina",
                    LastName = "Alić",
                    Email = "client3@gmail.com",
                    Username = "client3",
                    PasswordHash = "urrhgJZQdNrP/C38NXvq5zE40pI=",
                    PasswordSalt = "pmspUO+IbXyky6hkMr+LUQ==",
                    PhoneNumber = "063000003",
                    Address = "Rustempašina 13, Ilidža",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 11,
                    FirstName = "Nina",
                    LastName = "Mehić",
                    Email = "client4@gmail.com",
                    Username = "client4",
                    PasswordHash = "DyEAzMxBlx8wLlc9ZhJS840es4A=",
                    PasswordSalt = "za0Kw4p3dLFuDgatyrj6Jw==",
                    PhoneNumber = "063000004",
                    Address = "Hrasnička cesta 25, Hrasnica",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 12,
                    FirstName = "Adnan",
                    LastName = "Karić",
                    Email = "client5@gmail.com",
                    Username = "client5",
                    PasswordHash = "Qq3uZkuBv0V73SRnbzT8slxupPY=",
                    PasswordSalt = "81uK+bV3fLHfgB3W/KpXtg==",
                    PhoneNumber = "063000005",
                    Address = "Bulevar branilaca Dobrinje 17, Dobrinja",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                },

                new
                {
                    UserId = 13,
                    FirstName = "Selma",
                    LastName = "Mujić",
                    Email = "client6@gmail.com",
                    Username = "client6",
                    PasswordHash = "I+Zv+FpDnWQx+Fu46+OaWDZud10=",
                    PasswordSalt = "Bcqje4Ldmj9fZK4ISBbgzQ==",
                    PhoneNumber = "063000006",
                    Address = "Zmaja od Bosne 74, Sarajevo",
                    IsActive = true,
                    CreatedAt = new DateTime(2026,1,1)
                }
            );
        }
        private void SeedUserRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserRole>().HasData(

                new { Id = 1, UserId = 1, RoleId = 1, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 2, UserId = 2, RoleId = 1, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 3, UserId = 3, RoleId = 1, DateAssigned = new DateTime(2026,1,1) },

                new { Id = 4, UserId = 4, RoleId = 2, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 5, UserId = 5, RoleId = 2, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 6, UserId = 6, RoleId = 2, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 7, UserId = 7, RoleId = 2, DateAssigned = new DateTime(2026,1,1) },

                new { Id = 8, UserId = 8, RoleId = 3, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 9, UserId = 9, RoleId = 3, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 10, UserId = 10, RoleId = 3, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 11, UserId = 11, RoleId = 3, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 12, UserId = 12, RoleId = 3, DateAssigned = new DateTime(2026,1,1) },
                new { Id = 13, UserId = 13, RoleId = 3, DateAssigned = new DateTime(2026,1,1) }
            );
        }     
        private void SeedAnimalSpecies(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AnimalSpecies>().HasData(
                new
                {
                    SpeciesId = 1,
                    SpeciesName = "Dog"
                },
                new
                {
                    SpeciesId = 2,
                    SpeciesName = "Cat"
                },
                new
                {
                    SpeciesId = 3,
                    SpeciesName = "Rabbit"
                },
                new
                {
                    SpeciesId = 4,
                    SpeciesName = "Bird"
                }
            );
        }
        private void SeedAnimalBreeds(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AnimalBreed>().HasData(

                // Dogs
                new
                {
                    BreedId = 1,
                    BreedName = "Labrador Retriever",
                    SpeciesId = 1
                },
                new
                {
                    BreedId = 2,
                    BreedName = "German Shepherd",
                    SpeciesId = 1
                },
                new
                {
                    BreedId = 3,
                    BreedName = "Golden Retriever",
                    SpeciesId = 1
                },
                new
                {
                    BreedId = 4,
                    BreedName = "Mixed Breed Dog",
                    SpeciesId = 1
                },

                // Cats
                new
                {
                    BreedId = 5,
                    BreedName = "Persian",
                    SpeciesId = 2
                },
                new
                {
                    BreedId = 6,
                    BreedName = "Siamese",
                    SpeciesId = 2
                },
                new
                {
                    BreedId = 7,
                    BreedName = "Maine Coon",
                    SpeciesId = 2
                },
                new
                {
                    BreedId = 8,
                    BreedName = "Mixed Breed Cat",
                    SpeciesId = 2
                },

                // Rabbits
                new
                {
                    BreedId = 9,
                    BreedName = "Mini Lop",
                    SpeciesId = 3
                },
                new
                {
                    BreedId = 10,
                    BreedName = "Dutch Rabbit",
                    SpeciesId = 3
                },

                // Birds
                new
                {
                    BreedId = 11,
                    BreedName = "Budgerigar",
                    SpeciesId = 4
                },
                new
                {
                    BreedId = 12,
                    BreedName = "Cockatiel",
                    SpeciesId = 4
                }
            );
        }
        private void SeedAnimals(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Animal>().HasData(

                new
                {
                    AnimalId = 1,
                    Name = "Max",
                    SpeciesId = 1,
                    BreedId = 1,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2022, 5, 10),
                    Description = "Friendly Labrador looking for a loving home.",
                    PersonalityDescription = "Energetic, playful and loyal.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 10, 1),
                    AdoptionStatus = AnimalStatus.Adopted,
                    CreatedBy = 1
                },

                new
                {
                    AnimalId = 2,
                    Name = "Bella",
                    SpeciesId = 1,
                    BreedId = 3,
                    Gender = AnimalGender.Female,
                    BirthDate = new DateTime(2021, 8, 15),
                    Description = "Golden Retriever rescued from the streets.",
                    PersonalityDescription = "Gentle and affectionate.",
                    HealthStatus = "Good",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 9, 12),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 1
                },

                new
                {
                    AnimalId = 3,
                    Name = "Rocky",
                    SpeciesId = 1,
                    BreedId = 2,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2020, 3, 5),
                    Description = "Strong and intelligent German Shepherd.",
                    PersonalityDescription = "Protective and obedient.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 8, 25),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 2
                },

                new
                {
                    AnimalId = 4,
                    Name = "Charlie",
                    SpeciesId = 1,
                    BreedId = 4,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2023, 2, 20),
                    Description = "Mixed breed dog with lots of energy.",
                    PersonalityDescription = "Friendly and curious.",
                    HealthStatus = "Good",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 11, 5),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 1
                },

                new
                {
                    AnimalId = 5,
                    Name = "Luna",
                    SpeciesId = 2,
                    BreedId = 5,
                    Gender = AnimalGender.Female,
                    BirthDate = new DateTime(2023, 6, 12),
                    Description = "Beautiful Persian cat.",
                    PersonalityDescription = "Calm and elegant.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 12, 1),
                    AdoptionStatus = AnimalStatus.Adopted,
                    CreatedBy = 2
                },

                new
                {
                    AnimalId = 6,
                    Name = "Milo",
                    SpeciesId = 2,
                    BreedId = 6,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2022, 11, 8),
                    Description = "British Shorthair with a loving personality.",
                    PersonalityDescription = "Quiet and affectionate.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 7, 20),
                    AdoptionStatus = AnimalStatus.Adopted,
                    CreatedBy = 1
                },

                new
                {
                    AnimalId = 7,
                    Name = "Nala",
                    SpeciesId = 2,
                    BreedId = 7,
                    Gender = AnimalGender.Female,
                    BirthDate = new DateTime(2023, 4, 14),
                    Description = "Playful Siamese cat.",
                    PersonalityDescription = "Very social and active.",
                    HealthStatus = "Good",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 10, 15),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 2
                },

                new
                {
                    AnimalId = 8,
                    Name = "Simba",
                    SpeciesId = 2,
                    BreedId = 8,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2021, 12, 5),
                    Description = "Mixed breed cat rescued from abandonment.",
                    PersonalityDescription = "Friendly and independent.",
                    HealthStatus = "Good",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 9, 5),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 3
                },

                new
                {
                    AnimalId = 9,
                    Name = "Snow",
                    SpeciesId = 3,
                    BreedId = 9,
                    Gender = AnimalGender.Female,
                    BirthDate = new DateTime(2024, 1, 20),
                    Description = "Mini Lop rabbit with soft white fur.",
                    PersonalityDescription = "Gentle and shy.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 12, 10),
                    AdoptionStatus = AnimalStatus.Adopted,
                    CreatedBy = 1
                },

                new
                {
                    AnimalId = 10,
                    Name = "Coco",
                    SpeciesId = 3,
                    BreedId = 10,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2023, 9, 1),
                    Description = "Friendly rabbit that enjoys human company.",
                    PersonalityDescription = "Playful and curious.",
                    HealthStatus = "Good",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 10, 22),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 2
                },

                new
                {
                    AnimalId = 11,
                    Name = "Sky",
                    SpeciesId = 4,
                    BreedId = 11,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2024, 3, 10),
                    Description = "Bright and cheerful budgerigar.",
                    PersonalityDescription = "Active and vocal.",
                    HealthStatus = "Excellent",
                    IsVaccinated = false,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 11, 15),
                    AdoptionStatus = AnimalStatus.Adopted,
                    CreatedBy = 3
                },

                new
                {
                    AnimalId = 12,
                    Name = "Sunny",
                    SpeciesId = 4,
                    BreedId = 12,
                    Gender = AnimalGender.Female,
                    BirthDate = new DateTime(2024, 5, 5),
                    Description = "Cockatiel that enjoys interaction.",
                    PersonalityDescription = "Friendly and intelligent.",
                    HealthStatus = "Excellent",
                    IsVaccinated = false,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 11, 20),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 3
                },

                new
                {
                    AnimalId = 13,
                    Name = "Daisy",
                    SpeciesId = 1,
                    BreedId = 1,
                    Gender = AnimalGender.Female,
                    BirthDate = new DateTime(2020, 7, 7),
                    Description = "Experienced family dog.",
                    PersonalityDescription = "Very calm and loving.",
                    HealthStatus = "Good",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 6, 15),
                    AdoptionStatus = AnimalStatus.Adopted,
                    CreatedBy = 1
                },

                new
                {
                    AnimalId = 14,
                    Name = "Leo",
                    SpeciesId = 2,
                    BreedId = 6,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2022, 2, 22),
                    Description = "British Shorthair with striking eyes.",
                    PersonalityDescription = "Relaxed and affectionate.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 9, 18),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 2
                },

                new
                {
                    AnimalId = 15,
                    Name = "Buddy",
                    SpeciesId = 1,
                    BreedId = 3,
                    Gender = AnimalGender.Male,
                    BirthDate = new DateTime(2021, 10, 10),
                    Description = "Golden Retriever looking for an active family.",
                    PersonalityDescription = "Friendly, loyal and energetic.",
                    HealthStatus = "Excellent",
                    IsVaccinated = true,
                    MedicalNotes = (string?)null,
                    ArrivalDate = new DateTime(2025, 8, 10),
                    AdoptionStatus = AnimalStatus.Available,
                    CreatedBy = 3
                }
            );
        }
        private void SeedAnimalImages(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AnimalImage>().HasData(

                // Max
                new
                {
                    ImageId = 1,
                    AnimalId = 1,
                    FileName = "max-1.jpg",
                    ImagePath = "/images/animals/max-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 2,
                    AnimalId = 1,
                    FileName = "max-2.jpg",
                    ImagePath = "/images/animals/max-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Bella
                new
                {
                    ImageId = 3,
                    AnimalId = 2,
                    FileName = "bella-1.jpg",
                    ImagePath = "/images/animals/bella-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 4,
                    AnimalId = 2,
                    FileName = "bella-2.jpg",
                    ImagePath = "/images/animals/bella-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Rocky
                new
                {
                    ImageId = 5,
                    AnimalId = 3,
                    FileName = "rocky-1.jpg",
                    ImagePath = "/images/animals/rocky-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 6,
                    AnimalId = 3,
                    FileName = "rocky-2.jpg",
                    ImagePath = "/images/animals/rocky-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Charlie
                new
                {
                    ImageId = 7,
                    AnimalId = 4,
                    FileName = "charlie-1.jpg",
                    ImagePath = "/images/animals/charlie-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Luna
                new
                {
                    ImageId = 8,
                    AnimalId = 5,
                    FileName = "luna-1.jpg",
                    ImagePath = "/images/animals/luna-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 9,
                    AnimalId = 5,
                    FileName = "luna-2.jpg",
                    ImagePath = "/images/animals/luna-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Milo
                new
                {
                    ImageId = 10,
                    AnimalId = 6,
                    FileName = "milo-1.jpg",
                    ImagePath = "/images/animals/milo-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Nala
                new
                {
                    ImageId = 11,
                    AnimalId = 7,
                    FileName = "nala-1.jpg",
                    ImagePath = "/images/animals/nala-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 12,
                    AnimalId = 7,
                    FileName = "nala-2.jpg",
                    ImagePath = "/images/animals/nala-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Simba
                new
                {
                    ImageId = 13,
                    AnimalId = 8,
                    FileName = "simba-1.jpg",
                    ImagePath = "/images/animals/simba-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Snow
                new
                {
                    ImageId = 14,
                    AnimalId = 9,
                    FileName = "snow-1.jpg",
                    ImagePath = "/images/animals/snow-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Coco
                new
                {
                    ImageId = 15,
                    AnimalId = 10,
                    FileName = "coco-1.jpg",
                    ImagePath = "/images/animals/coco-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 16,
                    AnimalId = 10,
                    FileName = "coco-2.jpg",
                    ImagePath = "/images/animals/coco-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Sky
                new
                {
                    ImageId = 17,
                    AnimalId = 11,
                    FileName = "sky-1.jpg",
                    ImagePath = "/images/animals/sky-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Sunny
                new
                {
                    ImageId = 18,
                    AnimalId = 12,
                    FileName = "sunny-1.jpg",
                    ImagePath = "/images/animals/sunny-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Daisy
                new
                {
                    ImageId = 19,
                    AnimalId = 13,
                    FileName = "daisy-1.jpg",
                    ImagePath = "/images/animals/daisy-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },
                new
                {
                    ImageId = 20,
                    AnimalId = 13,
                    FileName = "daisy-2.jpg",
                    ImagePath = "/images/animals/daisy-2.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Leo
                new
                {
                    ImageId = 21,
                    AnimalId = 14,
                    FileName = "leo-1.jpg",
                    ImagePath = "/images/animals/leo-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                },

                // Buddy
                new
                {
                    ImageId = 22,
                    AnimalId = 15,
                    FileName = "buddy-1.jpg",
                    ImagePath = "/images/animals/buddy-1.jpg",
                    DateAdded = new DateTime(2026,1,1)
                }
            );
        }
        private void SeedAdoptionRequests(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AdoptionRequest>().HasData(

                new
                {
                    AdoptionRequestId = 1,
                    UserId = 8,
                    AnimalId = 1,
                    RequestDate = new DateTime(2026, 1, 10),
                    HousingType = "Apartment",
                    ExperienceWithPets = "Owned dogs for 5 years",
                    HouseholdMembers = 3,
                    AdditionalNotes = "Lives near a park",
                    Status = AdoptionRequestStatus.Approved,
                    ReviewedBy = (int?)1,
                    ReviewDate = (DateTime?)new DateTime(2026, 1, 12),
                    AdminComment = "Suitable adopter"
                },

                new
                {
                    AdoptionRequestId = 2,
                    UserId = 9,
                    AnimalId = 3,
                    RequestDate = new DateTime(2026, 1, 15),
                    HousingType = "House",
                    ExperienceWithPets = "Previous dog owner",
                    HouseholdMembers = 4,
                    AdditionalNotes = (string?)null,
                    Status = AdoptionRequestStatus.Pending,
                    ReviewedBy = (int?)null,
                    ReviewDate = (DateTime?)null,
                    AdminComment = (string?)null
                },

                new
                {
                    AdoptionRequestId = 3,
                    UserId = 10,
                    AnimalId = 5,
                    RequestDate = new DateTime(2026, 1, 20),
                    HousingType = "Apartment",
                    ExperienceWithPets = "Cat owner",
                    HouseholdMembers = 2,
                    AdditionalNotes = "Works from home",
                    Status = AdoptionRequestStatus.Approved,
                    ReviewedBy = (int?)2,
                    ReviewDate = (DateTime?)new DateTime(2026, 1, 22),
                    AdminComment = "Excellent conditions"
                },

                new
                {
                    AdoptionRequestId = 4,
                    UserId = 11,
                    AnimalId = 8,
                    RequestDate = new DateTime(2026, 2, 1),
                    HousingType = "House",
                    ExperienceWithPets = "No previous experience",
                    HouseholdMembers = 5,
                    AdditionalNotes = (string?)null,
                    Status = AdoptionRequestStatus.Rejected,
                    ReviewedBy = (int?)1,
                    ReviewDate = (DateTime?)new DateTime(2026, 2, 3),
                    AdminComment = "Insufficient preparation"
                },

                new
                {
                    AdoptionRequestId = 5,
                    UserId = 12,
                    AnimalId = 9,
                    RequestDate = new DateTime(2026, 2, 5),
                    HousingType = "Apartment",
                    ExperienceWithPets = "Owned rabbits",
                    HouseholdMembers = 1,
                    AdditionalNotes = "Quiet environment",
                    Status = AdoptionRequestStatus.Approved,
                    ReviewedBy = (int?)3,
                    ReviewDate = (DateTime?)new DateTime(2026, 2, 7),
                    AdminComment = "Good match"
                },

                new
                {
                    AdoptionRequestId = 6,
                    UserId = 13,
                    AnimalId = 10,
                    RequestDate = new DateTime(2026, 2, 10),
                    HousingType = "House",
                    ExperienceWithPets = "Various pets",
                    HouseholdMembers = 2,
                    AdditionalNotes = (string?)null,
                    Status = AdoptionRequestStatus.Pending,
                    ReviewedBy = (int?)null,
                    ReviewDate = (DateTime?)null,
                    AdminComment = (string?)null
                },

                new
                {
                    AdoptionRequestId = 7,
                    UserId = 8,
                    AnimalId = 14,
                    RequestDate = new DateTime(2026, 2, 15),
                    HousingType = "Apartment",
                    ExperienceWithPets = "Cat owner",
                    HouseholdMembers = 2,
                    AdditionalNotes = (string?)null,
                    Status = AdoptionRequestStatus.Rejected,
                    ReviewedBy = (int?)2,
                    ReviewDate = (DateTime?)new DateTime(2026, 2, 18),
                    AdminComment = "Application incomplete"
                },

                new
                {
                    AdoptionRequestId = 8,
                    UserId = 9,
                    AnimalId = 15,
                    RequestDate = new DateTime(2026, 2, 20),
                    HousingType = "House",
                    ExperienceWithPets = "Dog owner",
                    HouseholdMembers = 4,
                    AdditionalNotes = "Large yard",
                    Status = AdoptionRequestStatus.Pending,
                    ReviewedBy = (int?)null,
                    ReviewDate = (DateTime?)null,
                    AdminComment = (string?)null
                },

                new
                {
                    AdoptionRequestId = 9,
                    UserId = 10,
                    AnimalId = 4,
                    RequestDate = new DateTime(2026, 2, 25),
                    HousingType = "Apartment",
                    ExperienceWithPets = "Some experience",
                    HouseholdMembers = 2,
                    AdditionalNotes = (string?)null,
                    Status = AdoptionRequestStatus.Cancelled,
                    ReviewedBy = (int?)null,
                    ReviewDate = (DateTime?)null,
                    AdminComment = (string?)null
                },
                new
                {
                    AdoptionRequestId = 10,
                    UserId = 13,
                    AnimalId = 11,
                    RequestDate = new DateTime(2026, 3, 25),
                    HousingType = "House with garden",
                    ExperienceWithPets = "Previously owned pets",
                    HouseholdMembers = 5,
                    AdditionalNotes = (string?)null,
                    Status = AdoptionRequestStatus.Approved,
                    ReviewedBy = (int?)null,
                    ReviewDate = (DateTime?)null,
                    AdminComment = (string?)null
                }
            );
        }
        private void SeedDonations(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Donation>().HasData(

                new
                {
                    DonationId = 1,
                    UserId = 8,
                    Amount = 50.00m,
                    DonationDate = new DateTime(2026, 1, 5),
                    PaymentMethod = "Credit Card",
                    StripePaymentIntentId = "DON-2026-001",
                    TransactionStatus = DonationStatus.Successful,
                    Note = "Keep up the great work!",
                    ReceiptPdfPath = (string?)null
                },

                new
                {
                    DonationId = 2,
                    UserId = 9,
                    Amount = 25.00m,
                    DonationDate = new DateTime(2026, 1, 18),
                    PaymentMethod = "PayPal",
                    StripePaymentIntentId = "DON-2026-002",
                    TransactionStatus = DonationStatus.Successful,
                    Note = (string?)null,
                    ReceiptPdfPath = (string?)null
                },

                new
                {
                    DonationId = 3,
                    UserId = 10,
                    Amount = 100.00m,
                    DonationDate = new DateTime(2026, 2, 1),
                    PaymentMethod = "Bank Transfer",
                    StripePaymentIntentId = "DON-2026-003",
                    TransactionStatus = DonationStatus.Pending,
                    Note = "For medical expenses",
                    ReceiptPdfPath = (string?)null
                },

                new
                {
                    DonationId = 4,
                    UserId = 11,
                    Amount = 15.00m,
                    DonationDate = new DateTime(2026, 2, 7),
                    PaymentMethod = "Credit Card",
                    StripePaymentIntentId = "DON-2026-004",
                    TransactionStatus = DonationStatus.Successful,
                    Note = (string?)null,
                    ReceiptPdfPath = (string?)null
                },

                new
                {
                    DonationId = 5,
                    UserId = 12,
                    Amount = 75.00m,
                    DonationDate = new DateTime(2026, 2, 15),
                    PaymentMethod = "PayPal",
                    StripePaymentIntentId = "DON-2026-005",
                    TransactionStatus = DonationStatus.Pending,
                    Note = "Hope this helps",
                    ReceiptPdfPath = (string?)null
                },

                new
                {
                    DonationId = 6,
                    UserId = 13,
                    Amount = 40.00m,
                    DonationDate = new DateTime(2026, 2, 20),
                    PaymentMethod = "Credit Card",
                    StripePaymentIntentId = "DON-2026-006",
                    TransactionStatus = DonationStatus.Failed,
                    Note = "Transaction declined",
                    ReceiptPdfPath = (string?)null
                },
                new
                {
                    DonationId = 7,
                    UserId = 10,
                    Amount = 50.00m,
                    DonationDate = new DateTime(2026, 3, 15),
                    PaymentMethod = "Credit Card",
                    StripePaymentIntentId = "DON-2026-007",
                    TransactionStatus = DonationStatus.Successful,
                    Note = "For feeding animals",
                    ReceiptPdfPath = (string?)null
                }
            );
        }
        private void SeedFavorites(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Favorite>().HasData(

                new { FavoriteId = 1, UserId = 8, AnimalId = 1, DateAdded = new DateTime(2026,1,10) },
                new { FavoriteId = 2, UserId = 8, AnimalId = 5, DateAdded = new DateTime(2026,1,11) },

                new { FavoriteId = 3, UserId = 9, AnimalId = 3, DateAdded = new DateTime(2026,1,12) },
                new { FavoriteId = 4, UserId = 9, AnimalId = 15, DateAdded = new DateTime(2026,1,12) },

                new { FavoriteId = 5, UserId = 10, AnimalId = 5, DateAdded = new DateTime(2026,1,15) },
                new { FavoriteId = 6, UserId = 10, AnimalId = 14, DateAdded = new DateTime(2026,1,15) },

                new { FavoriteId = 7, UserId = 11, AnimalId = 2, DateAdded = new DateTime(2026,1,18) },
                new { FavoriteId = 8, UserId = 11, AnimalId = 7, DateAdded = new DateTime(2026,1,18) },

                new { FavoriteId = 9, UserId = 12, AnimalId = 9, DateAdded = new DateTime(2026,1,20) },
                new { FavoriteId = 10, UserId = 12, AnimalId = 10, DateAdded = new DateTime(2026,1,20) },

                new { FavoriteId = 11, UserId = 13, AnimalId = 4, DateAdded = new DateTime(2026,1,25) },
                new { FavoriteId = 12, UserId = 13, AnimalId = 11, DateAdded = new DateTime(2026,1,25) },

                new { FavoriteId = 13, UserId = 8, AnimalId = 12, DateAdded = new DateTime(2026,2,1) },
                new { FavoriteId = 14, UserId = 9, AnimalId = 13, DateAdded = new DateTime(2026,2,2) },
                new { FavoriteId = 15, UserId = 10, AnimalId = 6, DateAdded = new DateTime(2026,2,3) }
            );
        }
         private void SeedLocations(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Location>().HasData(

                new { LocationId = 1, Name = "Main Shelter Building" },
                new { LocationId = 2, Name = "Shelter Veterinary Office" },
                new { LocationId = 3, Name = "Shelter Feeding Area" },
                new { LocationId = 4, Name = "Shelter Park" },
                new { LocationId = 5, Name = "Shelter Training Yard" },

                new { LocationId = 6, Name = "Sarajevo City Center" },
                new { LocationId = 7, Name = "Wilson's Promenade" },
                new { LocationId = 8, Name = "Vrelo Bosne" },
                new { LocationId = 9, Name = "Stojčevac Park" },
                new { LocationId = 10, Name = "Dariva Walking Trail" }
            );
        }
        private void SeedVolunteerActivities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<VolunteerActivity>().HasData(

                new
                {
                    ActivityId = 1,
                    Title = "Dog Walking Day",
                    Description = "Volunteers help walk shelter dogs.",
                    LocationId = 7,
                    StartDateTime = new DateTime(2026, 3, 5, 9, 0, 0),
                    EndDateTime = new DateTime(2026, 3, 5, 13, 0, 0),
                    MaxVolunteers = 10,
                    Status = ActivityStatus.Active,
                    CreatedBy = 1
                },

                new
                {
                    ActivityId = 2,
                    Title = "Shelter Cleaning",
                    Description = "General cleaning and maintenance.",
                    LocationId = 1,
                    StartDateTime = new DateTime(2026, 3, 10, 8, 0, 0),
                    EndDateTime = new DateTime(2026, 3, 10, 14, 0, 0),
                    MaxVolunteers = 8,
                    Status = ActivityStatus.Active,
                    CreatedBy = 2
                },

                new
                {
                    ActivityId = 3,
                    Title = "Pet Adoption Fair",
                    Description = "Community adoption event.",
                    LocationId = 9,
                    StartDateTime = new DateTime(2026, 4, 2, 10, 0, 0),
                    EndDateTime = new DateTime(2026, 4, 2, 18, 0, 0),
                    MaxVolunteers = 15,
                    Status = ActivityStatus.Active,
                    CreatedBy = 1
                },

                new
                {
                    ActivityId = 4,
                    Title = "Fundraising Event",
                    Description = "Collecting donations for shelter animals.",
                    LocationId = 6,
                    StartDateTime = new DateTime(2026, 2, 15, 9, 0, 0),
                    EndDateTime = new DateTime(2026, 2, 15, 17, 0, 0),
                    MaxVolunteers = 12,
                    Status = ActivityStatus.Completed,
                    CreatedBy = 3
                },

                new
                {
                    ActivityId = 5,
                    Title = "Animal Transport Assistance",
                    Description = "Helping transport rescued animals.",
                    LocationId = 2,
                    StartDateTime = new DateTime(2026, 4, 20, 7, 0, 0),
                    EndDateTime = new DateTime(2026, 4, 20, 15, 0, 0),
                    MaxVolunteers = 5,
                    Status = ActivityStatus.Cancelled,
                    CreatedBy = 2
                },
                new
                {
                    ActivityId = 6,
                    Title = "Cat Care Day",
                    Description = "Helping care for cats.",
                    LocationId = 3,
                    StartDateTime = new DateTime(2026, 1, 18, 9, 0, 0),
                    EndDateTime = new DateTime(2026, 1, 18, 13, 0, 0),
                    MaxVolunteers = 8,
                    Status = ActivityStatus.Completed,
                    CreatedBy = 1
                },

                new
                {
                    ActivityId = 7,
                    Title = "Puppy Socialization",
                    Description = "Playing with puppies.",
                    LocationId = 5,
                    StartDateTime = new DateTime(2026, 3, 20, 9, 0, 0),
                    EndDateTime = new DateTime(2026, 3, 20, 14, 0, 0),
                    MaxVolunteers = 10,
                    Status = ActivityStatus.Completed,
                    CreatedBy = 1
                },
                new
                {
                    ActivityId = 8,
                    Title = "Summer Dog Walking",
                    Description = "Morning walk with shelter dogs during the summer season.",
                    LocationId = 7,
                    StartDateTime = new DateTime(2026, 7, 24, 8, 0, 0),
                    EndDateTime = new DateTime(2026, 7, 24, 12, 0, 0),
                    MaxVolunteers = 8,
                    Status = ActivityStatus.Active,
                    CreatedBy = 1
                },

                new
                {
                    ActivityId = 9,
                    Title = "Animal Enrichment Workshop",
                    Description = "Preparing toys and enrichment activities for shelter animals.",
                    LocationId = 3,
                    StartDateTime = new DateTime(2026, 7, 30, 10, 0, 0),
                    EndDateTime = new DateTime(2026, 7, 30, 15, 0, 0),
                    MaxVolunteers = 10,
                    Status = ActivityStatus.Active,
                    CreatedBy = 2
                }
            );
        }
       private void SeedVolunteerAssignments(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<VolunteerAssignment>().HasData(

                new
                {
                    AssignmentId = 1,
                    UserId = 4,
                    ActivityId = 1,
                    AppliedAt = new DateTime(2026, 2, 20),
                    ApplicationNote = "Love working with dogs.",
                    Status = AssignmentStatus.Approved,
                    AdminResponseReason =
                        "Application approved. Previous volunteering experience and availability match activity requirements.",
                    HoursWorked = 4m
                },

                new
                {
                    AssignmentId = 2,
                    UserId = 5,
                    ActivityId = 1,
                    AppliedAt = new DateTime(2026, 2, 21),
                    ApplicationNote = "Available all day.",
                    Status = AssignmentStatus.Approved,
                    AdminResponseReason =
                        "Approved due to full-day availability and positive application details.",
                    HoursWorked = 4m
                },

                new
                {
                    AssignmentId = 3,
                    UserId = 6,
                    ActivityId = 2,
                    AppliedAt = new DateTime(2026, 2, 25),
                    ApplicationNote = "Happy to help.",
                    Status = AssignmentStatus.Pending,
                    AdminResponseReason =(string?)null,
                    HoursWorked = 0m
                },

                new
                {
                    AssignmentId = 4,
                    UserId = 7,
                    ActivityId = 3,
                    AppliedAt = new DateTime(2026, 3, 1),
                    ApplicationNote = "Experience with events.",
                    Status = AssignmentStatus.Approved,
                    AdminResponseReason =
                        "Approved because of prior event organization experience.",
                    HoursWorked = 0m
                },

                new
                {
                    AssignmentId = 5,
                    UserId = 4,
                    ActivityId = 4,
                    AppliedAt = new DateTime(2026, 2, 1),
                    ApplicationNote = "Can assist with fundraising.",
                    Status = AssignmentStatus.Completed,
                    AdminResponseReason =
                        "Application approved and activity successfully completed.",
                    HoursWorked = 8m
                },
                new
                {
                    AssignmentId = 6,
                    UserId = 6,
                    ActivityId = 4,
                    AppliedAt = new DateTime(2026, 2, 2),
                    ApplicationNote = "Available whole day.",
                    Status = AssignmentStatus.Completed,
                    AdminResponseReason =
                        "Approved due to availability and commitment. Activity completed successfully.",
                    HoursWorked = 8m
                },

                new
                {
                    AssignmentId = 7,
                    UserId = 5,
                    ActivityId = 5,
                    AppliedAt = new DateTime(2026, 3, 15),
                    ApplicationNote = "Can drive animals.",
                    Status = AssignmentStatus.Cancelled,
                    AdminResponseReason =
                        "Volunteer cancelled participation before activity start date.",
                    HoursWorked = 0m
                },

                new
                {
                    AssignmentId = 8,
                    UserId = 7,
                    ActivityId = 2,
                    AppliedAt = new DateTime(2026, 2, 28),
                    ApplicationNote = "Would like to participate.",
                    Status = AssignmentStatus.Rejected,
                    AdminResponseReason =
                        "Application rejected because all volunteer positions have already been filled.",
                    HoursWorked = 0m
                },
                new
                {
                    AssignmentId = 9,
                    UserId = 4,
                    ActivityId = 6,
                    AppliedAt = new DateTime(2026, 1, 10),
                    ApplicationNote = "Happy to help.",
                    Status = AssignmentStatus.Completed,
                    AdminResponseReason = "Completed successfully.",
                    HoursWorked = 5m
                },

                new
                {
                    AssignmentId = 10,
                    UserId = 4,
                    ActivityId = 7,
                    AppliedAt = new DateTime(2026, 3, 12),
                    ApplicationNote = "Love puppies.",
                    Status = AssignmentStatus.Completed,
                    AdminResponseReason = "Completed successfully.",
                    HoursWorked = 6m
                },
                new
                {
                    AssignmentId = 11,
                    UserId = 4,
                    ActivityId = 8,
                    AppliedAt = new DateTime(2026, 7, 10),
                    ApplicationNote = "Available during summer break.",
                    Status = AssignmentStatus.Pending,
                    AdminResponseReason = (string?)null,
                    HoursWorked = 0m
                },
                new
                {
                    AssignmentId = 12,
                    UserId = 6,
                    ActivityId = 9,
                    AppliedAt = new DateTime(2026, 7, 15),
                    ApplicationNote = "I'd like to help with enrichment activities.",
                    Status = AssignmentStatus.Approved,
                    AdminResponseReason = "Application approved.",
                    HoursWorked = 0m
                }
            );
        }
        private void SeedAnnouncements(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Announcement>().HasData(

                new
                {
                    AnnouncementId = 1,
                    Title = "Welcome to Our Shelter",
                    Content = "Thank you for supporting animal adoption.",
                    ImageUrl = "/images/announcements/welcome.jpg",
                    PublishedDate = new DateTime(2026,1,5),
                    IsActive = true,
                    CreatedBy = 1
                },

                new
                {
                    AnnouncementId = 2,
                    Title = "Adoption Fair Coming Soon",
                    Content = "Join us for our annual adoption fair.",
                    ImageUrl = "/images/announcements/fair.jpg",
                    PublishedDate = new DateTime(2026,2,1),
                    IsActive = true,
                    CreatedBy = 1
                },

                new
                {
                    AnnouncementId = 3,
                    Title = "Volunteer Recruitment",
                    Content = "We are looking for dedicated volunteers.",
                    ImageUrl = "/images/announcements/volunteers.jpg",
                    PublishedDate = new DateTime(2026,2,10),
                    IsActive = true,
                    CreatedBy = 2
                },

                new
                {
                    AnnouncementId = 4,
                    Title = "Donation Campaign",
                    Content = "Help us provide better care for animals.",
                    ImageUrl = "/images/announcements/donation.jpg",
                    PublishedDate = new DateTime(2026,3,1),
                    IsActive = true,
                    CreatedBy = 3
                },

                new
                {
                    AnnouncementId = 5,
                    Title = "New Animals Available",
                    Content = "Several animals are now available for adoption.",
                    ImageUrl = "/images/announcements/new-animals.jpg",
                    PublishedDate = new DateTime(2026,3,10),
                    IsActive = true,
                    CreatedBy = 2
                }
            );
        }
        private void SeedNotifications(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Notification>().HasData(

                new { NotificationId=1, UserId=8, TargetRoleId=(int?)null, Title="Adoption Request Received", Message="Your request has been submitted.", Type=NotificationType.Adoption, IsRead=true, DateSent=new DateTime(2026,1,10), ReadAt=(DateTime?)new DateTime(2026,1,10) },

                new { NotificationId=2, UserId=8, TargetRoleId=(int?)null, Title="Request Approved", Message="Your adoption request was approved.", Type=NotificationType.Adoption, IsRead=false, DateSent=new DateTime(2026,1,12), ReadAt=(DateTime?)null },

                new { NotificationId=3, UserId=9, TargetRoleId=(int?)null, Title="Request Pending", Message="Your request is under review.", Type=NotificationType.Adoption, IsRead=false, DateSent=new DateTime(2026,1,15), ReadAt=(DateTime?)null },

                new { NotificationId=4, UserId=10, TargetRoleId=(int?)null, Title="Thank You", Message="Thank you for your donation.", Type=NotificationType.Donation, IsRead=true, DateSent=new DateTime(2026,2,1), ReadAt=(DateTime?)new DateTime(2026,2,1) },

                new { NotificationId=5, UserId=11, TargetRoleId=(int?)null, Title="Request Rejected", Message="Unfortunately your request was rejected.", Type=NotificationType.Adoption, IsRead=true, DateSent=new DateTime(2026,2,3), ReadAt=(DateTime?)new DateTime(2026,2,3) },

                new { NotificationId=6, UserId=12, TargetRoleId=(int?)null, Title="Request Approved", Message="Congratulations, request approved.", Type=NotificationType.Adoption, IsRead=false, DateSent=new DateTime(2026,2,7), ReadAt=(DateTime?)null },

                new { NotificationId=7, UserId=13, TargetRoleId=(int?)null, Title="Donation Pending", Message="Your donation is pending confirmation.", Type=NotificationType.Donation, IsRead=false, DateSent=new DateTime(2026,2,15), ReadAt=(DateTime?)null },

                new { NotificationId=8, UserId=4, TargetRoleId=(int?)null, Title="Volunteer Approved", Message="You were approved for Dog Walking Day.", Type=NotificationType.Volunteer, IsRead=false, DateSent=new DateTime(2026,2,22), ReadAt=(DateTime?)null },

                new { NotificationId=9, UserId=5, TargetRoleId=(int?)null, Title="Volunteer Approved", Message="You were approved for Dog Walking Day.", Type=NotificationType.Volunteer, IsRead=false, DateSent=new DateTime(2026,2,22), ReadAt=(DateTime?)null },

                new { NotificationId=10, UserId=6, TargetRoleId=(int?)null, Title="Application Received", Message="Volunteer application received.", Type=NotificationType.Volunteer, IsRead=false, DateSent=new DateTime(2026,2,25), ReadAt=(DateTime?)null },

                new { NotificationId=11, UserId=7, TargetRoleId=(int?)null, Title="Event Participation", Message="You joined Adoption Fair.", Type=NotificationType.Volunteer, IsRead=false, DateSent=new DateTime(2026,3,1), ReadAt=(DateTime?)null },

                new { NotificationId=12, UserId=(int?)null, TargetRoleId=2, Title="New Volunteer Event", Message="A new activity is available.", Type=NotificationType.Volunteer, IsRead=false, DateSent=new DateTime(2026,3,2), ReadAt=(DateTime?)null },

                new { NotificationId=13, UserId=(int?)null, TargetRoleId=3, Title="New Animals Available", Message="Check newly available animals.", Type=NotificationType.Announcement, IsRead=false, DateSent=new DateTime(2026,3,10), ReadAt=(DateTime?)null },

                new { NotificationId=14, UserId=(int?)null, TargetRoleId=3, Title="Adoption Fair", Message="Visit our adoption fair this weekend.", Type=NotificationType.Announcement, IsRead=false, DateSent=new DateTime(2026,3,15), ReadAt=(DateTime?)null },

                new { NotificationId=15, UserId=(int?)null, TargetRoleId=1, Title="System Update", Message="Database maintenance scheduled.", Type=NotificationType.System, IsRead=false, DateSent=new DateTime(2026,3,18), ReadAt=(DateTime?)null },

                new { NotificationId=16, UserId=1, TargetRoleId=(int?)null, Title="New Adoption Request", Message="A new request requires review.", Type=NotificationType.Adoption, IsRead=false, DateSent=new DateTime(2026,3,19), ReadAt=(DateTime?)null },

                new { NotificationId=17, UserId=2, TargetRoleId=(int?)null, Title="New Donation", Message="A donation was received.", Type=NotificationType.Donation, IsRead=false, DateSent=new DateTime(2026,3,20), ReadAt=(DateTime?)null },

                new { NotificationId=18, UserId=3, TargetRoleId=(int?)null, Title="Activity Completed", Message="Fundraising event completed.", Type=NotificationType.Volunteer, IsRead=false, DateSent=new DateTime(2026,3,21), ReadAt=(DateTime?)null }
            );
        }
        private void SeedAnimalViewHistory(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<AnimalViewHistory>().HasData(

        // User 8 - najviše gleda pse
        new
        {
            AnimalViewHistoryId = 1,
            UserId = 8,
            AnimalId = 1,
            ViewedAt = new DateTime(2026, 6, 20, 10, 15, 0)
        },

        new
        {
            AnimalViewHistoryId = 2,
            UserId = 8,
            AnimalId = 2,
            ViewedAt = new DateTime(2026, 6, 20, 10, 20, 0)
        },

        new
        {
            AnimalViewHistoryId = 3,
            UserId = 8,
            AnimalId = 4,
            ViewedAt = new DateTime(2026, 6, 21, 9, 30, 0)
        },

        new
        {
            AnimalViewHistoryId = 4,
            UserId = 8,
            AnimalId = 5,
            ViewedAt = new DateTime(2026, 6, 21, 9, 35, 0)
        },

        new
        {
            AnimalViewHistoryId = 5,
            UserId = 8,
            AnimalId = 6,
            ViewedAt = new DateTime(2026, 6, 22, 14, 10, 0)
        }
    );
}

}
}
