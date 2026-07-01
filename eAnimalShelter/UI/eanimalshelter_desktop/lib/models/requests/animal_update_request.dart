import 'animal_insert_request.dart';

class AnimalUpdateRequest
    extends AnimalInsertRequest {
  AnimalUpdateRequest({
    required super.name,
    required super.speciesId,
    required super.breedId,
    required super.gender,
    required super.birthDate,
    required super.description,
    required super.personalityDescription,
    required super.healthStatus,
    required super.isVaccinated,
    super.medicalNotes,
    super.arrivalDate,
    required super.adoptionStatus,
  });
}