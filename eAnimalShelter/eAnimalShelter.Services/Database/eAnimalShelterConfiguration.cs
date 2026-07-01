using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services.Database
{
    public partial class eAnimalShelterDbContext : DbContext
    {

        private void CreateConfiguration(ModelBuilder modelBuilder)
        {
              modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique();

            // USER ROLE
            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(ur => ur.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(ur => ur.RoleId)
                .OnDelete(DeleteBehavior.Cascade);

            // ANIMAL
            
            modelBuilder.Entity<Animal>()
                .HasOne(a => a.Species)
                .WithMany()
                .HasForeignKey(a => a.SpeciesId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Animal>()
                .HasOne(a => a.Breed)
                .WithMany()
                .HasForeignKey(a => a.BreedId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Animal>()
                .HasOne(a => a.CreatedByUser)
                .WithMany()
                .HasForeignKey(a => a.CreatedBy)
                .OnDelete(DeleteBehavior.Restrict);

            // ANIMAL IMAGES
            
            modelBuilder.Entity<AnimalImage>()
                .HasOne(ai => ai.Animal)
                .WithMany(a => a.Images)
                .HasForeignKey(ai => ai.AnimalId)
                .OnDelete(DeleteBehavior.Cascade);

            // ADOPTION REQUEST

            modelBuilder.Entity<AdoptionRequest>()
                .HasOne(ar => ar.User)
                .WithMany()
                .HasForeignKey(ar => ar.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<AdoptionRequest>()
                .HasOne(ar => ar.Animal)
                .WithMany(a => a.AdoptionRequests)
                .HasForeignKey(ar => ar.AnimalId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<AdoptionRequest>()
                .HasOne(ar => ar.Reviewer)
                .WithMany()
                .HasForeignKey(ar => ar.ReviewedBy)
                .OnDelete(DeleteBehavior.Restrict);

            // FAVORITES

            modelBuilder.Entity<Favorite>()
                .HasIndex(f => new { f.UserId, f.AnimalId })
                .IsUnique();

            modelBuilder.Entity<Favorite>()
                .HasOne(f => f.User)
                .WithMany()
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Favorite>()
                .HasOne(f => f.Animal)
                .WithMany()
                .HasForeignKey(f => f.AnimalId)
                .OnDelete(DeleteBehavior.Cascade);

            // DONATIONS
            
            modelBuilder.Entity<Donation>()
                .HasOne(d => d.User)
                .WithMany()
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.Restrict);
            // VOLUNTEER ACTIVITY
            
            modelBuilder.Entity<VolunteerActivity>()
                .HasOne(v => v.CreatedByUser)
                .WithMany()
                .HasForeignKey(v => v.CreatedBy)
                .OnDelete(DeleteBehavior.Restrict);
           
            // VOLUNTEER ASSIGNMENT
        
            modelBuilder.Entity<VolunteerAssignment>()
                .HasIndex(v => new { v.UserId, v.ActivityId })
                .IsUnique();

            modelBuilder.Entity<VolunteerAssignment>()
                .HasOne(v => v.User)
                .WithMany()
                .HasForeignKey(v => v.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<VolunteerAssignment>()
                .HasOne(v => v.Activity)
                .WithMany(a => a.VolunteerAssignments)
                .HasForeignKey(v => v.ActivityId)
                .OnDelete(DeleteBehavior.Cascade);

            // NOTIFICATIONS
        
            modelBuilder.Entity<Notification>()
                .HasOne(n => n.User)
                .WithMany()
                .HasForeignKey(n => n.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Notification>()
                .HasOne(n => n.TargetRole)
                .WithMany()
                .HasForeignKey(n => n.TargetRoleId)
                .OnDelete(DeleteBehavior.Restrict);

            
            // ANNOUNCEMENTS
           

            modelBuilder.Entity<Announcement>()
                .HasOne(a => a.CreatedByUser)
                .WithMany()
                .HasForeignKey(a => a.CreatedBy)
                .OnDelete(DeleteBehavior.Restrict);

            // Add any additional model configurations here
        }
    }
}
