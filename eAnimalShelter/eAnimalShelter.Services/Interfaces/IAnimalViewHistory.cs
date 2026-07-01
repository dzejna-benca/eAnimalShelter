public interface IAnimalViewHistoryService
{
    Task AddViewAsync(int animalId);
    Task RecordViewAsync(int animalId);
}