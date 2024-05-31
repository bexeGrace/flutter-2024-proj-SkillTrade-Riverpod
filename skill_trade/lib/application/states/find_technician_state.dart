import 'package:equatable/equatable.dart';
import 'package:skill_trade/domain/models/technician.dart';

abstract class TechniciansState extends Equatable {
  const TechniciansState();

  @override
  List<Object?> get props => [];
}

class TechniciansLoading extends TechniciansState {}
class TechniciansLoaded extends TechniciansState {
  final List<Technician> technicians;
  final List<Technician> pendingTechnicians;
  final List<Technician> suspendedTechnicians;

  const TechniciansLoaded({
    this.technicians = const [],
    this.pendingTechnicians = const [],
    this.suspendedTechnicians = const [],
  });

  TechniciansLoaded copyWith({
    List<Technician>? technicians,
    List<Technician>? pendingTechnicians,
    List<Technician>? suspendedTechnicians,
  }) {
    return TechniciansLoaded(
      technicians: technicians ?? this.technicians,
      pendingTechnicians: pendingTechnicians ?? this.pendingTechnicians,
      suspendedTechnicians: suspendedTechnicians ?? this.suspendedTechnicians,
    );
  }

  @override
  List<Object?> get props => [technicians, pendingTechnicians, suspendedTechnicians];
}


// class TechniciansLoaded extends TechniciansState {
//   final List<Technician> technicians;

//   const TechniciansLoaded(this.technicians);

//   @override
//   List<Object?> get props => [technicians];
// }

// class PendingTechniciansLoaded extends TechniciansState {
//   final List<Technician> technicians;

//   const PendingTechniciansLoaded(this.technicians);

//   @override
//   List<Object?> get props => [technicians];
// }

// class SuspendedTechniciansLoaded extends TechniciansState {
//   final List<Technician> technicians;

//   const SuspendedTechniciansLoaded(this.technicians);

//   @override
//   List<Object?> get props => [technicians];
// }

class TechniciansError extends TechniciansState {
  final String error;

  const TechniciansError(this.error);

  @override
  List<Object?> get props => [error];
}
