import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer.dart';
import '../repositories/customer_repository.dart';
import '../../../core/network/supabase_client_provider.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CustomerRepository(client);
});

class CustomerState {
  final bool isLoading;
  final String searchQuery;
  final List<Customer> customers;
  final String? errorMessage;

  CustomerState({
    this.isLoading = false,
    this.searchQuery = '',
    this.customers = const [],
    this.errorMessage,
  });

  CustomerState copyWith({
    bool? isLoading,
    String? searchQuery,
    List<Customer>? customers,
    String? errorMessage,
  }) {
    return CustomerState(
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      customers: customers ?? this.customers,
      errorMessage: errorMessage,
    );
  }
}

class CustomerController extends StateNotifier<CustomerState> {
  final CustomerRepository _repository;

  CustomerController(this._repository) : super(CustomerState()) {
    searchCustomers('');
  }

  Future<void> searchCustomers(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query, errorMessage: null);
    try {
      final results = await _repository.searchCustomers(query);
      state = state.copyWith(isLoading: false, customers: results);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<Customer?> createCustomer({
    required String fullName,
    required String phone,
    String? address,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newCustomer = await _repository.createCustomer(
        fullName: fullName,
        phone: phone,
        address: address,
        notes: notes,
      );
      searchCustomers(state.searchQuery);
      return newCustomer;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }
}

final customerControllerProvider =
    StateNotifierProvider<CustomerController, CustomerState>((ref) {
  final repo = ref.watch(customerRepositoryProvider);
  return CustomerController(repo);
});
