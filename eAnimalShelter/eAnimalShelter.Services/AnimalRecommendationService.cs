using eAnimalShelter.Model.Enums;
using eAnimalShelter.Model.Responses;
using eAnimalShelter.Services.Database;
using eAnimalShelter.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eAnimalShelter.Services
{
    public class RecommendationService : IRecommendationService
    {
        private readonly eAnimalShelterDbContext _db;
        private readonly MapsterMapper.IMapper _mapper;
        private readonly IAuthenticatedUserAccessor _userAccessor;

        public RecommendationService(
            eAnimalShelterDbContext db,
            MapsterMapper.IMapper mapper,
            IAuthenticatedUserAccessor userAccessor)
        {
            _db = db;
            _mapper = mapper;
            _userAccessor = userAccessor;
        }

        public async Task<List<AnimalRecommendationResponse>> GetRecommendationsAsync(int top = 10)
        {
            var userId = _userAccessor.GetUserId();

            if (userId == null)
                return new();

            // FAVORITES
            var favoriteIds = await _db.Favorites
                .Where(x => x.UserId == userId.Value)
                .Select(x => x.AnimalId)
                .ToListAsync();

            // ADOPTION REQUESTS
            var adoptionIds = await _db.AdoptionRequests
                .Where(x =>
                    x.UserId == userId.Value &&
                    x.Status != AdoptionRequestStatus.Rejected)
                .Select(x => x.AnimalId)
                .ToListAsync();

            // VIEW HISTORY
            var viewedIds = await _db.AnimalViewHistories
                .Where(x => x.UserId == userId.Value)
                .Select(x => x.AnimalId)
                .Distinct()
                .ToListAsync();

            // Animals for scoring

            var favoriteAnimals = await _db.Animals
                .Include(x => x.Species)
                .Include(x => x.Breed)
                .Include(x => x.Images)
                .Where(x => favoriteIds.Contains(x.AnimalId))
                .ToListAsync();

            var adoptionAnimals = await _db.Animals
                .Include(x => x.Species)
                .Include(x => x.Breed)
                .Include(x => x.Images)
                .Where(x => adoptionIds.Contains(x.AnimalId))
                .ToListAsync();

            var viewedAnimals = await _db.Animals
                .Include(x => x.Species)
                .Include(x => x.Breed)
                .Include(x => x.Images)
                .Where(x => viewedIds.Contains(x.AnimalId))
                .ToListAsync();

           // Ako korisnik nema nikakvu historiju,
            // koristi popularity-based preporuke.

            if (!favoriteAnimals.Any() &&
                !adoptionAnimals.Any() &&
                !viewedAnimals.Any())
            {
                var popularAnimals = await _db.Animals
                    .Include(x => x.Species)
                    .Include(x => x.Breed)
                    .Include(x => x.Images)
                    .Where(x => x.AdoptionStatus == AnimalStatus.Available)
                    .Select(x => new
                    {
                        Animal = x,

                        Popularity =
                            _db.Favorites.Count(f => f.AnimalId == x.AnimalId) * 3 +

                            _db.AdoptionRequests.Count(a =>
                                a.AnimalId == x.AnimalId &&
                                a.Status != AdoptionRequestStatus.Rejected) * 2 +

                            _db.AnimalViewHistories.Count(v =>
                                v.AnimalId == x.AnimalId)
                    })
                    .OrderByDescending(x => x.Popularity)
                    .ThenByDescending(x => x.Animal.ArrivalDate)
                    .Take(top)
                    .ToListAsync();

                return popularAnimals
                    .Select(x => new AnimalRecommendationResponse
                    {
                        Animal = _mapper.Map<AnimalResponse>(x.Animal),
                        Score = x.Popularity,
                        Reason = x.Popularity > 0
                            ? "Popular among other adopters."
                            : "New arrival looking for a home."
                    })
                    .ToList();
            }

            // Excluded animals

            var excludedIds = new HashSet<int>();

            excludedIds.UnionWith(favoriteIds);
            excludedIds.UnionWith(adoptionIds);
            excludedIds.UnionWith(viewedIds);

            // Candidates

            var candidates = await _db.Animals
                .Include(x => x.Species)
                .Include(x => x.Breed)
                .Include(x => x.Images)
                .Where(x =>
                    x.AdoptionStatus == AnimalStatus.Available &&
                    !excludedIds.Contains(x.AnimalId))
                .ToListAsync();

            var recommendations =
                new List<(Animal animal, double score, string reason)>();

            foreach (var candidate in candidates)
            {
                double score = 0;

                double favoriteScore = 0;
                double adoptionScore = 0;
                double viewScore = 0;

                string? favoriteReason = null;
                string? adoptionReason = null;
                string? viewReason = null;

                CalculateScore(
                candidate,
                favoriteAnimals,
                3,
                ref score,
                ref favoriteScore,
                ref favoriteReason,
                "favorite");

            CalculateScore(
                candidate,
                adoptionAnimals,
                2,
                ref score,
                ref adoptionScore,
                ref adoptionReason,
                "adoption");

            CalculateScore(
                candidate,
                viewedAnimals,
                1,
                ref score,
                ref viewScore,
                ref viewReason,
                "view");

                if (score > 0)
                {
                    string reason;

                    if (favoriteScore >= adoptionScore &&
                        favoriteScore >= viewScore)
                    {
                        reason = favoriteReason ??
                            "Because you added similar animals to favorites.";
                    }
                    else if (adoptionScore >= viewScore)
                    {
                        reason = adoptionReason ??
                            "Because you applied for similar animals.";
                    }
                    else
                    {
                        reason = viewReason ??
                            "Because you viewed similar animals.";
                    }

                    recommendations.Add((
                        candidate,
                        score,
                        reason
                    ));
                }
            }

            return recommendations
                .OrderByDescending(x => x.score)
                .Take(top)
                .Select(x => new AnimalRecommendationResponse
                {
                    Animal = _mapper.Map<AnimalResponse>(x.animal),
                    Score = x.score,
                    Reason = x.reason
                })
                .ToList();
        }

        private static void CalculateScore(
            Animal candidate,
            IEnumerable<Animal> sourceAnimals,
            int weight,
            ref double totalScore,
            ref double sourceScore,
            ref string? reason,
            string source)
        {
            foreach (var liked in sourceAnimals)
            {
                if (candidate.SpeciesId == liked.SpeciesId)
                {
                    totalScore += 5 * weight;
                    sourceScore += 5 * weight;

                    reason ??= source switch
                    {
                        "favorite" =>
                            $"Because you added similar {candidate.Species?.SpeciesName?.ToLower()}s to favorites.",

                        "adoption" =>
                            $"Because you applied to adopt similar {candidate.Species?.SpeciesName?.ToLower()}s.",

                        _ =>
                            $"Because you viewed similar {candidate.Species?.SpeciesName?.ToLower()}s."
                    };
                }

                if (candidate.BreedId == liked.BreedId)
                {
                    totalScore += 4 * weight;
                    sourceScore += 4 * weight;

                    reason ??= source switch
                    {
                        "favorite" =>
                            $"Because you liked {candidate.Breed?.BreedName}s.",

                        "adoption" =>
                            $"Because you applied for {candidate.Breed?.BreedName}s.",

                        _ =>
                            $"Because you viewed {candidate.Breed?.BreedName}s."
                    };
                }

                if (candidate.Gender == liked.Gender)
                {
                    totalScore += 2 * weight;
                    sourceScore += 2 * weight;
                }

                var ageDifference = Math.Abs(
                    (candidate.BirthDate - liked.BirthDate).TotalDays);

                if (ageDifference <= 365)
                {
                    totalScore += 2 * weight;
                    sourceScore += 2 * weight;
                }
            }
        }
    }
}