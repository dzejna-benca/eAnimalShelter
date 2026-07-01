namespace eAnimalShelter.Model.Responses
{
    public class DashboardResponse
    {
        public int TotalAnimals { get; set; }

         public int ApprovedAdoptions { get; set; }

        public int TotalVolunteers { get; set; }

        public decimal TotalDonations { get; set; }
        public Dictionary<string, int> AnimalsBySpecies { get; set; } = new();
        
        public Dictionary<string, int> AdoptedAnimalsBySpecies { get; set; } = new();
    }
}