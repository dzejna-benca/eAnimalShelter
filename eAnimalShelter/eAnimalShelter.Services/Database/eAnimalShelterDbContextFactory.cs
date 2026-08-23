using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace eAnimalShelter.Services.Database
{
    public class eAnimalShelterDbContextFactory
        : IDesignTimeDbContextFactory<eAnimalShelterDbContext>
    {
        public eAnimalShelterDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder =
                new DbContextOptionsBuilder<eAnimalShelterDbContext>();

            optionsBuilder.UseSqlServer(
                "Server=localhost,1433;Database=eAnimalShelter;User Id=sa;Password=Test1234!;TrustServerCertificate=True");

            return new eAnimalShelterDbContext(optionsBuilder.Options);
        }
    }
}