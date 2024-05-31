import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/infrastructure/repositories/individual_technician_repository.dart';
import 'package:skill_trade/application/states/individual_technician_state.dart';

class IndividualTechnicianNotifier extends StateNotifier<IndividualTechnicianState> {
  final IndividualTechnicianRepository individualTechnicianRepository;

  IndividualTechnicianNotifier({required this.individualTechnicianRepository}) : super(IndividualTechnicianLoading());

  Future<void> loadIndividualTechnician(int technicianId) async {
    state = IndividualTechnicianLoading();
    try {
      final technician = await individualTechnicianRepository.getIndividualTechnician(technicianId);
      state = IndividualTechnicianLoaded(technician: technician);
    } catch (error) {
      state = IndividualTechnicianError(error.toString());
    }
  }

  Future<void> updateTechnicianProfile({
    required int technicianId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await individualTechnicianRepository.updateTechnicianProfile(technicianId, updates);
      await loadIndividualTechnician(technicianId);
    } catch (error) {
      state = IndividualTechnicianError(error.toString());
    }
  }

  Future<void> updatePassword({
    required String role,
    required int id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await individualTechnicianRepository.updatePassword({
        "role": role,
        "id": id,
        "newPassword": newPassword,
        "password": oldPassword,
      });
    } catch (error) {
      state = IndividualTechnicianError(error.toString());
    }
  }
}

