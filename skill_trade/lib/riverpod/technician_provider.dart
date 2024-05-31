import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_trade/models/technician.dart';
import 'dart:convert';
import 'package:skill_trade/riverpod/secure_storage_provider.dart';


import '../ip_info.dart';

final technicianProvider = FutureProvider<List<Technician>>( (ref) async {

  final secureStorageService = await ref.read(secureStorageProvider);

  final token = await secureStorageService.read("token");
    final response =
        await http.get(Uri.parse("http://$endpoint:9000/technician"), 
        headers: { 
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      var ans =  data.map((json) => Technician.fromJson(json)).toList();
      
     return ans;
    } else {
      throw Exception("Failed to load technicians.");
    }
  });


final pendingTechniciansProvider = FutureProvider<List<Technician>>((ref) async {
  final secureStorageService = ref.read(secureStorageProvider);


  final token = await secureStorageService.read("token");
  
  final response = await http.get(
    Uri.parse("http://$endpoint:9000/technician/pending/all"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final ans = data.map((json)=> Technician.fromFullJson(json)).toList();
    return ans;
    
    } else {
    throw Exception("Failed to load technician.");
  }
});

final technicianByIdProvider = FutureProvider.family<Technician, int>((ref, int technicianId) async {
  final secureStorageService = ref.read(secureStorageProvider);


  final token = await secureStorageService.read("token");
  
  final response = await http.get(
    Uri.parse("http://$endpoint:9000/technician/$technicianId"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body);
    data['id'] = technicianId;

    final technician =  Technician.fromFullJson(data);
    return technician;
    } else {
    throw Exception("Failed to load technician.");
  }
});

final allTechnicianProvider = FutureProvider<List<Technician>>( (ref) async {

  final secureStorageService = await ref.read(secureStorageProvider);

  final token = await secureStorageService.read("token");
    final response =
        await http.get(Uri.parse("http://$endpoint:9000/technician"), 
        headers: { 
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      var ans =  data.map((json) => Technician.fromFullJson(json)).toList();
      
     return ans;
    } else {
      throw Exception("Failed to load technicians.");
    }
  });



final suspendedTechniciansProvider = FutureProvider<List<Technician>>((ref) async {
  final secureStorageService = ref.read(secureStorageProvider);


  final token = await secureStorageService.read("token");
  
  final response = await http.get(
    Uri.parse("http://$endpoint:9000/technician/suspended/all"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final ans = data.map((json)=> Technician.fromFullJson(json)).toList();
    return ans;
    
    } else {
    throw Exception("Failed to load technician.");
  }
});


final technicianProfileProvider = FutureProvider<Technician>((ref) async {

    final _secureStorageService = ref.read(secureStorageProvider);
    final token = await _secureStorageService.read("token");
    final role = await _secureStorageService.read('role');
    final id = await _secureStorageService.read('userId');
    
    if (id == null){
      throw Exception("No technician");
    }


    final response = await http.get(
      Uri.parse('http://$endpoint:9000/technician/$id'),
      headers: { 
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    
    );

    if (response.statusCode == 200) {

      final dynamic data = jsonDecode(response.body);
      data['id'] = int.parse(id);

      return Technician.fromFullJson(data);
    } else {
      throw Exception('Failed to load bookings');
    }
  });


class TechnicianState {
  final bool isLoading;
  final bool success;
  final String? errorMessage;

  TechnicianState({
    this.isLoading = false,
    this.success = false,
    this.errorMessage,
  });

  TechnicianState copyWith({
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return TechnicianState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TechnicianNotifier extends StateNotifier<TechnicianState> {
  final SecureStorageService _secureStorageService;

  
  TechnicianNotifier(this._secureStorageService) : super(TechnicianState());

  Future<void> updateTechnician(technician) async {
    state = state.copyWith(isLoading: true);

    final token = await _secureStorageService.read("token");
    final id = await _secureStorageService.read('userId');
    await updateTechnicianById(technician, id);

  }

  Future<void> updateTechnicianById(update, id) async {
    state = state.copyWith(isLoading: true);

    final token = await _secureStorageService.read("token");


    final response = await http.patch(
      Uri.parse('http://$endpoint:9000/technician/$id'),
      headers: { 
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(update)
    
    );
    
    print("patch result $response {$response.statuscode}");

    

    if (response.statusCode == 200) {
      state = state.copyWith(isLoading: false, success: true);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update technician.',
      );
    }

  }
}



final technicianProfileUpdateProvider = StateNotifierProvider<TechnicianNotifier, TechnicianState>((ref) {
  final secureStorageService = ref.read(secureStorageProvider);
  return TechnicianNotifier(secureStorageService);

});


