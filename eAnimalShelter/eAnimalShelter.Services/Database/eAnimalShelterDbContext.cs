using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services.Database
{
    public partial class eAnimalShelterDbContext : DbContext
    {
        public eAnimalShelterDbContext(DbContextOptions<eAnimalShelterDbContext> options) : base(options)
        {
        }

        // DbSets for all entities
        public DbSet<User> Users { get; set; }

        public DbSet<Role> Roles { get; set; }

        public DbSet<UserRole> UserRoles { get; set; }

        public DbSet<Animal> Animals { get; set; }

        public DbSet<AnimalSpecies> AnimalSpecies { get; set; }

        public DbSet<AnimalBreed> AnimalBreeds { get; set; }

        public DbSet<AnimalImage> AnimalImages { get; set; }

        public DbSet<AdoptionRequest> AdoptionRequests { get; set; }

        public DbSet<Favorite> Favorites { get; set; }

        public DbSet<Donation> Donations { get; set; }

        public DbSet<VolunteerActivity> VolunteerActivities { get; set; }

        public DbSet<VolunteerAssignment> VolunteerAssignments { get; set; }

        public DbSet<Notification> Notifications { get; set; }

        public DbSet<Announcement> Announcements { get; set; }
        public DbSet<Location> Locations { get; set; }
        public DbSet<RefreshToken> RefreshTokens { get; set; }
        public DbSet<AnimalViewHistory> AnimalViewHistories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            CreateConfiguration(modelBuilder);

            CreateSeed(modelBuilder);
            
        }

       
    }
}
