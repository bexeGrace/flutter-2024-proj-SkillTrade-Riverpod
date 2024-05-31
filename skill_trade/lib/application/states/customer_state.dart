import 'package:equatable/equatable.dart';
import 'package:skill_trade/domain/models/customer.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final Customer customer;

  const CustomerLoaded({required this.customer});

  @override
  List<Object?> get props => [customer];
}

class AllCustomersLoaded extends CustomerState {
  final List<Customer> customers;

  const AllCustomersLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomerError extends CustomerState {
  final String error;

  const CustomerError(this.error);

  @override
  List<Object?> get props => [error];
}
