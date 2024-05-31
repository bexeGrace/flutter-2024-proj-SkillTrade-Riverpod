import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/infrastructure/data_sources/technician_remote_data_source.dart';

class TechnicianRepository {
  final TechnicianRemoteDataSource remoteDataSource;

  TechnicianRepository({required this.remoteDataSource});

  Future<List<Technician>> getTechnicians() async {
    return await remoteDataSource.fetchTechnicians();
  }

  Future<List<Technician>> getPendingTechnicians() async {
    return await remoteDataSource.fetchPendingTechnicians();
  }

  Future<List<Technician>> getSuspendedTechnicians() async {
    return await remoteDataSource.fetchSuspendedTechnicians();
  }
}