import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:skill_trade/application/states/find_technician_state.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/infrastructure/repositories/technician_repository.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:riverpod/riverpod.dart';

import 'find_technician_riverpod_test.mocks.dart';


@GenerateMocks([TechnicianRepository])
void main() {
  WidgetsFlutterBinding.ensureInitialized(); 

  late ProviderContainer container;
  late MockTechnicianRepository mockTechnicianRepository;

  setUp(() {
    mockTechnicianRepository = MockTechnicianRepository();
    container = ProviderContainer(
      overrides: [
        technicianRepositoryProvider.overrideWithValue(mockTechnicianRepository),
      ], 
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TechniciansNotifier', () {
    
    final List<Technician> technicians = [
      Technician(
        id: 1,
        skills: 'some',
        experience: 'required',
        education_level: 'level',
        available_location: 'location',
        additional_bio: 'why',
        phone: '0987654',
        name: 'Techie Smith',
        email: 'techiesmith@example.com',
        status: 'active',
      ),
      Technician(
        id: 2,
        skills: 'other',
        experience: 'some',
        education_level: 'level',
        available_location: 'location2',
        additional_bio: 'why not',
        phone: '1234567',
        name: 'Techie Johnson',
        email: 'techiejohnson@example.com',
        status: 'active',
      ),
    ];

    test('emits [TechniciansLoading, TechniciansLoaded] when loadTechnicians is called', () async {
      when(mockTechnicianRepository.getTechnicians()).thenAnswer((_) async => technicians);

      final techniciansNotifier = container.read(techniciansNotifierProvider.notifier);
      final List<TechniciansState> states = [];
      container.listen<TechniciansState>(
        techniciansNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      techniciansNotifier.loadTechnicians();
      await container.pump();

      expect(states, await [
        TechniciansLoading(),
        TechniciansLoaded(technicians: technicians),
        // TechniciansError("Exception: ")
      ]);
    });

    test('emits [TechniciansLoading, TechniciansLoaded] when loadPendingTechnicians is called', () async {
      when(mockTechnicianRepository.getPendingTechnicians()).thenAnswer((_) async => technicians);

      final techniciansNotifier = container.read(techniciansNotifierProvider.notifier);
      final List<TechniciansState> states = [];
      container.listen<TechniciansState>(
        techniciansNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      techniciansNotifier.loadPendingTechnicians();
      await container.pump();

      expect(states, [
        TechniciansLoading(),
        TechniciansLoaded(pendingTechnicians: technicians),
      ]);
    });

    test('emits [TechniciansLoading, TechniciansLoaded] when loadSuspendedTechnicians is called', () async {
      when(mockTechnicianRepository.getSuspendedTechnicians()).thenAnswer((_) async => technicians);

      final techniciansNotifier = container.read(techniciansNotifierProvider.notifier);
      final List<TechniciansState> states = [];
      container.listen<TechniciansState>(
        techniciansNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      ); 

      techniciansNotifier.loadSuspendedTechnicians();
      await container.pump();

      expect(states, [
        TechniciansLoading(),
        TechniciansLoaded(suspendedTechnicians: technicians),
      ]);
    });

    test('emits [TechniciansLoading, TechniciansError] when loadTechnicians is called and an error occurs', () async {
      when(mockTechnicianRepository.getTechnicians()).thenThrow(Exception('Failed to load technicians'));

      final techniciansNotifier = container.read(techniciansNotifierProvider.notifier);
      final List<TechniciansState> states = [];
      container.listen<TechniciansState>(
        techniciansNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      techniciansNotifier.loadTechnicians();
      await container.pump();

      expect(states, [
        TechniciansLoading(),
        TechniciansError('Exception: Failed to load technicians'),
      ]);
    });

    test('emits [TechniciansLoading, TechniciansError] when loadPendingTechnicians is called and an error occurs', () async {
      when(mockTechnicianRepository.getPendingTechnicians()).thenThrow(Exception('Failed to load pending technicians'));

      final techniciansNotifier = container.read(techniciansNotifierProvider.notifier);
      final List<TechniciansState> states = [];
      container.listen<TechniciansState>(
        techniciansNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      techniciansNotifier.loadPendingTechnicians();
      await container.pump();

      expect(states, await [
        TechniciansLoading(),
        TechniciansError('Exception: Failed to load pending technicians'),
      ]);
    });

    test('emits [TechniciansLoading, TechniciansError] when loadSuspendedTechnicians is called and an error occurs', () async {
      when(mockTechnicianRepository.getSuspendedTechnicians()).thenThrow(Exception('Failed to load suspended technicians'));

      final techniciansNotifier = container.read(techniciansNotifierProvider.notifier);
      final List<TechniciansState> states = [];
      container.listen<TechniciansState>(
        techniciansNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      techniciansNotifier.loadSuspendedTechnicians();
      await container.pump();

      expect(states, [
        TechniciansLoading(),
        TechniciansError('Exception: Failed to load suspended technicians'),
      ]);
    });
  });
}
