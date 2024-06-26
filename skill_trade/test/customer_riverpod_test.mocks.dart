// Mocks generated by Mockito 5.4.4 from annotations
// in skill_trade/test/customer_riverpod_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:skill_trade/domain/models/customer.dart' as _i4;
import 'package:skill_trade/infrastructure/data_sources/customer_remote_data_source.dart'
    as _i3;
import 'package:skill_trade/infrastructure/repositories/customer_repository_impl.dart'
    as _i5;
import 'package:skill_trade/infrastructure/storage/storage.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSecureStorage_0 extends _i1.SmartFake implements _i2.SecureStorage {
  _FakeSecureStorage_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCustomerRemoteDataSource_1 extends _i1.SmartFake
    implements _i3.CustomerRemoteDataSource {
  _FakeCustomerRemoteDataSource_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCustomer_2 extends _i1.SmartFake implements _i4.Customer {
  _FakeCustomer_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CustomerRepositoryImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockCustomerRepositoryImpl extends _i1.Mock
    implements _i5.CustomerRepositoryImpl {
  MockCustomerRepositoryImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SecureStorage get secureStorage => (super.noSuchMethod(
        Invocation.getter(#secureStorage),
        returnValue: _FakeSecureStorage_0(
          this,
          Invocation.getter(#secureStorage),
        ),
      ) as _i2.SecureStorage);

  @override
  _i3.CustomerRemoteDataSource get remoteDataSource => (super.noSuchMethod(
        Invocation.getter(#remoteDataSource),
        returnValue: _FakeCustomerRemoteDataSource_1(
          this,
          Invocation.getter(#remoteDataSource),
        ),
      ) as _i3.CustomerRemoteDataSource);

  @override
  _i6.Future<_i4.Customer> fetchCustomer(int? customerId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchCustomer,
          [customerId],
        ),
        returnValue: _i6.Future<_i4.Customer>.value(_FakeCustomer_2(
          this,
          Invocation.method(
            #fetchCustomer,
            [customerId],
          ),
        )),
      ) as _i6.Future<_i4.Customer>);

  @override
  _i6.Future<List<_i4.Customer>> fetchAllCustomers() => (super.noSuchMethod(
        Invocation.method(
          #fetchAllCustomers,
          [],
        ),
        returnValue: _i6.Future<List<_i4.Customer>>.value(<_i4.Customer>[]),
      ) as _i6.Future<List<_i4.Customer>>);

  @override
  _i6.Future<void> updatePassword(Map<String, dynamic>? updates) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [updates],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}
