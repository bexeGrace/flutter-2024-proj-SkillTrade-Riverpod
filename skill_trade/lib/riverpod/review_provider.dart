import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_trade/models/booking.dart';
import 'package:skill_trade/models/review.dart';
import 'package:skill_trade/models/technician.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_trade/riverpod/secure_storage_provider.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';


import '../ip_info.dart';
// Assuming Review and SecureStorageService are defined elsewhere
class ReviewsState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<Review> reviews;

  ReviewsState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.reviews = const [],
  });

  ReviewsState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<Review>? reviews,
  }) {
    return ReviewsState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      reviews: reviews ?? this.reviews,
    );
  }
}


// Assuming Review and SecureStorageService are defined elsewhere
class ReviewsNotifier extends StateNotifier<ReviewsState> {
  final SecureStorageService _secureStorageService;
  int? _technicianId;

  ReviewsNotifier(this._secureStorageService) : super(ReviewsState());

  Future<void> fetchReviews(int? technicianId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _technicianId = technicianId;
    try {
      final token = await _secureStorageService.read("token");

      final response = await http.get(
        Uri.parse('http://$endpoint:9000/review-rate/technician/$technicianId'),
        headers: { 
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
        },
      );

      print("fetched reviews $response ${response.statusCode}");

      if (response.statusCode == 200) {

        final  List<dynamic> data = jsonDecode(response.body);
        print("fetched reviews data $data");

        final reviews = data.map((json) {
          Map<String, dynamic> cur = {
            "rate": json["rate"],
            "review": json["review"],
            "user": json["user"]["fullName"],
            "userId": json["user"]["id"],
            "id": json["id"]
          };
          return Review.fromJson(cur);
        }).toList();
        print(reviews);

        state = state.copyWith(isLoading: false, isSuccess: true, reviews: reviews);
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateReview(Map<String, dynamic> review, int id, ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final token = await _secureStorageService.read("token");
      print("updating review $review, $id");
      final response = await http.patch(
        Uri.parse('http://$endpoint:9000/review-rate/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(review),
      );
      print("update response ${response.statusCode}, $response");

      if (response.statusCode == 200) {
        await fetchReviews(_technicianId);
      } else {
        throw Exception('Failed to update review');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> createReview(technicianId, review, rate) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await _secureStorageService.read("token");
      final id = await _secureStorageService.read('userId');
      if (id == null) {
        throw Exception("no customer no review");
      }


      print("creating review $review");
      final response = await http.post(
        Uri.parse('http://$endpoint:9000/review-rate/technician/${technicianId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "technicianId": technicianId,
          "review": review,
          "rate": rate,
          "customerId": int.parse(id)
        }),
      );
      print("create response ${response.statusCode}, $response, ${response.body}");

      if (response.statusCode == 201) {
        await fetchReviews(_technicianId);
      } else {
        throw Exception('Failed to create review');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteReview(int id, int technicianId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await _secureStorageService.read("token");
      print("deleting review $id");
      final response = await http.delete(
        Uri.parse('http://$endpoint:9000/review-rate/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("delete response ${response.statusCode}, $response");

      if (response.statusCode == 200) {
        await fetchReviews(technicianId);
      } else {
        throw Exception('Failed to delete review');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}


final reviewProvider = StateNotifierProvider<ReviewsNotifier, ReviewsState>((ref) {
  final secureStorageService = ref.read(secureStorageProvider);
  return ReviewsNotifier(secureStorageService);
});


final fetchReviewProvider = FutureProvider.family<List<Review>, int>((ref, int? technicianId) async {
    
      final secureStorageService = ref.read(secureStorageProvider);
      final token = await secureStorageService.read("token");

      final response = await http.get(
        Uri.parse('http://$endpoint:9000/review-rate/technician/$technicianId'),
        headers: { 
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
        },
      );

      // print("fetched reviews $response");
      print("fetched reviews $response ${response.statusCode}");

      if (response.statusCode == 200) {

        final  List<dynamic> data = jsonDecode(response.body);
        print("fetched reviews data $data");

        final reviews = data.map((json) {
          Map<String, dynamic> cur = {
            "rate": json["rate"],
            "review": json["review"],
            "user": json["user"]["fullName"],
            "userId": json["user"]["id"],
            "id": json["id"]
          };
          return Review.fromJson(cur);
        }).toList();
        print("yohoo");
        print(reviews);
        return reviews;
      } else {
        throw Exception('Failed to load reviews');
      }
    
  });