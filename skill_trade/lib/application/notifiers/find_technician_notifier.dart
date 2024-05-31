import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/infrastructure/repositories/technician_repository.dart';
import 'package:skill_trade/application/states/find_technician_state.dart';

class TechniciansNotifier extends StateNotifier<TechniciansState> {
  final TechnicianRepository technicianRepository;

  TechniciansNotifier({required this.technicianRepository}) : super(TechniciansLoading());

  Future<void> loadTechnicians() async { 
    state = TechniciansLoading();
    try {
      final technicians = await technicianRepository.getTechnicians();
      state = (state is TechniciansLoaded)
          ? (state as TechniciansLoaded).copyWith(technicians: technicians)
          : TechniciansLoaded(technicians: technicians);
    } catch (error) {
      state = TechniciansError(error.toString());
    }
  }

  Future<void> loadPendingTechnicians() async {
    state = TechniciansLoading();
    try {
      final pendingTechnicians = await technicianRepository.getPendingTechnicians();
      state = (state is TechniciansLoaded)
          ? (state as TechniciansLoaded).copyWith(pendingTechnicians: pendingTechnicians)
          : TechniciansLoaded(pendingTechnicians: pendingTechnicians);
    } catch (error) {
      state = TechniciansError(error.toString());
    }
  }

  Future<void> loadSuspendedTechnicians() async {
    state = TechniciansLoading();
    try {
      final suspendedTechnicians = await technicianRepository.getSuspendedTechnicians();
      state = (state is TechniciansLoaded)
          ? (state as TechniciansLoaded).copyWith(suspendedTechnicians: suspendedTechnicians)
          : TechniciansLoaded(suspendedTechnicians: suspendedTechnicians);
    } catch (error) {
      state = TechniciansError(error.toString());
    }
  }
}
