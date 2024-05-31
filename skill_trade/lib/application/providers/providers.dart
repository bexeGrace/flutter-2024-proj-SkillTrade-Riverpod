import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/notifiers/bookings_notifier.dart';
import 'package:skill_trade/application/notifiers/customer_notifier.dart';
import 'package:skill_trade/application/notifiers/find_technician_notifier.dart';
import 'package:skill_trade/application/notifiers/individual_technician_notifier.dart';
import 'package:skill_trade/application/notifiers/review_notifier.dart';
import 'package:skill_trade/application/states/bookings_state.dart';
import 'package:skill_trade/application/states/customer_state.dart';
import 'package:skill_trade/application/states/find_technician_state.dart';
import 'package:skill_trade/application/states/individual_technician_state.dart';
import 'package:skill_trade/application/states/review_state.dart';
import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/domain/models/review.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/domain/repositories/auth_repository.dart';
import 'package:skill_trade/application/notifiers/auth_notifier.dart';
import 'package:skill_trade/application/states/auth_state.dart';
import 'package:skill_trade/infrastructure/data_sources/bookings_remote_data_source_impl.dart';
import 'package:skill_trade/infrastructure/data_sources/customer_remote_data_source_impl.dart';
import 'package:skill_trade/infrastructure/data_sources/individual_technician_remote_data_source.dart';
import 'package:skill_trade/infrastructure/data_sources/remote_data_source.dart';
import 'package:skill_trade/infrastructure/data_sources/review_remote_data_source.dart';
import 'package:skill_trade/infrastructure/data_sources/technician_remote_data_source.dart';
import 'package:skill_trade/infrastructure/repositories/auth_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:skill_trade/infrastructure/repositories/bookings_repository_impl.dart';
import 'package:skill_trade/infrastructure/repositories/customer_repository_impl.dart';
import 'package:skill_trade/infrastructure/repositories/individual_technician_repository.dart';
import 'package:skill_trade/infrastructure/repositories/review_repository.dart';
import 'package:skill_trade/infrastructure/repositories/technician_repository.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

final httpClient = http.Client();
final remoteDataSource = RemoteDataSource(httpClient);
final bookingRemoteDataSource = BookingsRemoteDataSourceImpl(httpClient);
final customerRemoteDataSource = CustomerRemoteDataSourceImpl(client: httpClient);
final individualTechnicianRemoteDataSource = IndividualTechnicianRemoteDataSource();

final authRepository = AuthRepositoryImpl(remoteDataSource, SecureStorage.instance);
final bookingsRepository = BookingsRepositoryImpl(bookingRemoteDataSource, SecureStorage.instance);
final customerRepository = CustomerRepositoryImpl(secureStorage: SecureStorage.instance, remoteDataSource: customerRemoteDataSource);
final individualTechnicianRepository = IndividualTechnicianRepository(remoteDataSource: individualTechnicianRemoteDataSource);
final technicianRepository = TechnicianRepository(remoteDataSource: TechnicianRemoteDataSource());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return authRepository;
});

final bookingsRepositoryProvider = Provider((ref){
  return bookingsRepository;
});

final customerRepositoryProvider = Provider((ref){
  return customerRepository;
});

final individualTechnicianRepositoryProvider = Provider((ref) {
  return individualTechnicianRepository;
});

final technicianRepositoryProvider = Provider((ref) {
  return technicianRepository;
});
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository: authRepository);
});

final bookingsNotifierProvider = StateNotifierProvider<BookingsNotifier, BookingsState>((ref) {
  final bookingsRepository = ref.watch(bookingsRepositoryProvider);
  return BookingsNotifier(bookingsRepository: bookingsRepository);
});


final customerNotifierProvider = StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return CustomerNotifier(customerRepository: customerRepository);
});


final customerFutureProvider = FutureProvider.family<Customer, int>((ref, customerId) async {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.fetchCustomer(customerId);
});

final individualTechnicianFutureProvider = FutureProvider.family<Technician, int>((ref, technicianId)async {
  final individualRepository = ref.watch(individualTechnicianRepositoryProvider);
  return individualRepository.getIndividualTechnician(technicianId);
});

final techniciansNotifierProvider = StateNotifierProvider<TechniciansNotifier, TechniciansState>((ref) {
  // final technicianRepository = TechnicianRepository(remoteDataSource: TechnicianRemoteDataSource());
  final technicianRepository = ref.watch(technicianRepositoryProvider);
  return TechniciansNotifier(technicianRepository: technicianRepository);
});




final individualTechnicianNotifierProvider = StateNotifierProvider<IndividualTechnicianNotifier, IndividualTechnicianState>((ref) {
  final individualTechnicianRepository = IndividualTechnicianRepository(remoteDataSource: IndividualTechnicianRemoteDataSource());
  return IndividualTechnicianNotifier(individualTechnicianRepository: individualTechnicianRepository);
});




final reviewsNotifierProvider = StateNotifierProvider<ReviewsNotifier, ReviewsState>((ref) {
  final reviewRepository = ReviewRepository(remoteDataSource: ReviewRemoteDataSource());
  return ReviewsNotifier(reviewRepository: reviewRepository);
});

final reviewsFutureProvider = FutureProvider.family<List<Review>, int>((ref, technicianId) {
  final reviewRepository = ReviewRepository(remoteDataSource: ReviewRemoteDataSource());
  return reviewRepository.getTechnicianReviews(technicianId);
});

final techniciansFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(techniciansNotifierProvider.notifier).loadTechnicians();
});
