import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer.dart';

class CustomerRepository {
  final SupabaseClient _client;
  CustomerRepository(this._client);

  // EARS[Ubiquitous]: Normalizes phone string removing non-digits
  String normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  // EARS[Event]: Search customers by phone or name
  Future<List<Customer>> searchCustomers(String query) async {
    final cleanPhone = normalizePhone(query);
    var req = _client.from('customers').select('*, pets(*)');
    if (cleanPhone.isNotEmpty) {
      req = req.ilike('phone', '%$cleanPhone%');
    } else if (query.trim().isNotEmpty) {
      req = req.ilike('full_name', '%${query.trim()}%');
    }
    final response = await req.order('created_at', ascending: false);
    return (response as List)
        .map((json) => Customer.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // EARS[Unwanted]: WHERE duplicate phone -> DUPLICATE_PHONE
  Future<Customer> createCustomer({
    required String fullName,
    required String phone,
    String? address,
    String? notes,
  }) async {
    final cleanPhone = normalizePhone(phone);
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      throw Exception('Số điện thoại không hợp lệ (cần 10-11 chữ số)');
    }
    try {
      final user = _client.auth.currentUser;
      final response = await _client.from('customers').insert({
        'full_name': fullName.trim(),
        'phone': cleanPhone,
        'address': address?.trim(),
        'notes': notes?.trim(),
        'created_by': user?.id,
      }).select('*, pets(*)').single();
      return Customer.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Số điện thoại này đã được đăng ký cho chủ nuôi khác');
      }
      throw Exception('Không thể tạo chủ nuôi: ${e.message}');
    }
  }

  // EARS[Event]: WHEN updating customer info
  Future<Customer> updateCustomer({
    required String id,
    required String fullName,
    required String phone,
    String? address,
    String? notes,
  }) async {
    final cleanPhone = normalizePhone(phone);
    final response = await _client
        .from('customers')
        .update({
          'full_name': fullName.trim(),
          'phone': cleanPhone,
          'address': address?.trim(),
          'notes': notes?.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .select('*, pets(*)')
        .single();
    return Customer.fromJson(response);
  }
}
