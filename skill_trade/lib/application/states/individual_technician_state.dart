import 'package:equatable/equatable.dart';
import 'package:skill_trade/domain/models/technician.dart';

abstract class IndividualTechnicianState extends Equatable {
  const IndividualTechnicianState();

  @override
  List<Object?> get props => [];
}

class IndividualTechnicianLoading extends IndividualTechnicianState {}

class IndividualTechnicianLoaded extends IndividualTechnicianState {
  final Technician technician;

  const IndividualTechnicianLoaded({required this.technician});

  @override
  List<Object?> get props => [technician];
}

class IndividualTechnicianError extends IndividualTechnicianState {
  final String error;

  const IndividualTechnicianError(this.error);

  @override
  List<Object?> get props => [error];
}
