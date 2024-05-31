import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/customer_state.dart';
import 'package:skill_trade/domain/models/customer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skill_trade/infrastructure/repositories/customer_repository_impl.dart';
import 'customer_riverpod_test.mocks.dart';

@GenerateMocks([CustomerRepositoryImpl])
void main() {
  late MockCustomerRepositoryImpl mockCustomerRepository;
  late ProviderContainer container;

  setUp(() {
    mockCustomerRepository = MockCustomerRepositoryImpl();
    container = ProviderContainer(
      overrides: [
        customerRepositoryProvider.overrideWithValue(mockCustomerRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CustomerNotifierProvider', () {
    final customer = Customer(
      fullName: 'name',
      phone: '0987654',
      id: 1,
      email: 'johndoe@example.com',
    );

    final customers = [
      Customer(
        fullName: 'name',
        phone: '0987654',
        id: 1,
        email: 'johndoe@example.com',
      ),
      Customer(
        fullName: 'name',
        phone: '0987654',
        id: 1,
        email: 'johndoe@example.com',
      ),
    ];

    test('emits [CustomerLoading, CustomerLoaded] when LoadCustomer is invoked', () async {
      when(mockCustomerRepository.fetchCustomer(1)).thenAnswer((_) async => customer);

      final listener = container.listen(customerNotifierProvider, (previous, next) {});

      // Trigger the provider
      container.read(customerNotifierProvider.notifier).loadCustomer(1);

      await container.pump();

      expect(listener.read(), CustomerLoaded(customer: customer));
    });

    test('emits [CustomerLoading, AllCustomersLoaded] when LoadAllCustomers is invoked', () async {
      when(mockCustomerRepository.fetchAllCustomers()).thenAnswer((_) async => customers);

      final listener = container.listen(customerNotifierProvider, (previous, next) {});

      // Trigger the provider
      container.read(customerNotifierProvider.notifier).loadAllCustomers();

      await container.pump();

      expect(listener.read(), AllCustomersLoaded(customers));
    });

    test('emits [CustomerLoading, CustomerError] when LoadCustomer is invoked and an error occurs', () async {
      when(mockCustomerRepository.fetchCustomer(1)).thenThrow(Exception('Failed to load customer'));

      final listener = container.listen(customerNotifierProvider, (previous, next) {});

      // Trigger the provider
      container.read(customerNotifierProvider.notifier).loadCustomer(1);

      await container.pump();

      expect(listener.read(), CustomerError('Exception: Failed to load customer'));
    });

    test('emits [CustomerLoading, CustomerError] when LoadAllCustomers is invoked and an error occurs', () async {
      when(mockCustomerRepository.fetchAllCustomers()).thenThrow(Exception('Failed to load customers'));

      final listener = container.listen(customerNotifierProvider, (previous, next) {});

      // Trigger the provider
      container.read(customerNotifierProvider.notifier).loadAllCustomers();

      await container.pump();

      expect(listener.read(), CustomerError('Exception: Failed to load customers'));
    });
  });
}
