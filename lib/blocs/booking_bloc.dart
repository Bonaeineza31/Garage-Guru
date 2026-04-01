import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/models/repair_model.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadRepairs extends BookingEvent {
  final String userId;
  const LoadRepairs(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddBooking extends BookingEvent {
  final Map<String, dynamic> bookingData;
  const AddBooking(this.bookingData);
  @override
  List<Object?> get props => [bookingData];
}

class CancelRepair extends BookingEvent {
  final String id;
  final bool isBooking;
  const CancelRepair(this.id, {this.isBooking = false});
  @override
  List<Object?> get props => [id, isBooking];
}

class SubmitFeedback extends BookingEvent {
  final String garageId;
  final String repairId;
  final bool isBooking;
  final String userName;
  final String userPhoto;
  final String serviceName;
  final int rating;
  final String comment;
  final String userId;

  const SubmitFeedback({
    required this.garageId,
    required this.repairId,
    required this.isBooking,
    required this.userName,
    required this.userPhoto,
    required this.serviceName,
    required this.rating,
    required this.comment,
    required this.userId,
  });

  @override
  List<Object?> get props => [garageId, repairId, isBooking, userName, userPhoto, serviceName, rating, comment, userId];
}

class RepairsUpdated extends BookingEvent {
  final List<RepairModel> repairs;
  const RepairsUpdated(this.repairs);
  @override
  List<Object?> get props => [repairs];
}

enum BookingStatus { initial, loading, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final List<RepairModel> activeRepairs;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.activeRepairs = const [],
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    List<RepairModel>? activeRepairs,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      activeRepairs: activeRepairs ?? this.activeRepairs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activeRepairs, errorMessage];
}

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<dynamic> _subscriptions = [];

  BookingBloc() : super(const BookingState()) {
    on<LoadRepairs>(_onLoadRepairs);
    on<AddBooking>(_onAddBooking);
    on<CancelRepair>(_onCancelRepair);
    on<SubmitFeedback>(_onSubmitFeedback);
    on<RepairsUpdated>(_onRepairsUpdated);
  }

  void _onLoadRepairs(LoadRepairs event, Emitter<BookingState> emit) {
    emit(state.copyWith(status: BookingStatus.loading));
    
    for (var sub in _subscriptions) {
      if (sub is StreamSubscription) sub.cancel();
    }
    _subscriptions.clear();

    List<RepairModel> repairsList = [];
    List<RepairModel> bookingsList = [];

    final repairsSub = _firestore
        .collection('repairs')
        .where('userId', isEqualTo: event.userId)
        .snapshots()
        .listen((snapshot) {
      final now = DateTime.now();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final startDateStr = data['startDate'] as String?;
        final status = data['status'] as String?;
        if (startDateStr != null && status != 'completed' && status != 'cancelled') {
          final startDate = DateTime.tryParse(startDateStr);
          if (startDate != null && startDate.isBefore(now)) {
            _firestore.collection('repairs').doc(doc.id).update({'status': 'completed'});
          }
        }
      }
      repairsList = snapshot.docs.map((doc) => _mapRepair(doc)).toList();
      _emitCombined(repairsList, bookingsList);
    });

    final bookingsSub = _firestore
        .collection('bookings')
        .where('userId', isEqualTo: event.userId)
        .snapshots()
        .listen((snapshot) {
      final now = DateTime.now();
       for (var doc in snapshot.docs) {
        final data = doc.data();
        final dateStr = data['date'] as String?;
        final status = data['status'] as String?;
        if (dateStr != null && status != 'Completed' && status != 'Cancelled') {
          final date = DateTime.tryParse(dateStr);
          if (date != null && date.isBefore(now)) {
            _firestore.collection('bookings').doc(doc.id).update({'status': 'Completed'});
          }
        }
      }
      bookingsList = snapshot.docs.map((doc) => _mapBookingToRepair(doc)).toList();
      _emitCombined(repairsList, bookingsList);
    });

    _subscriptions.add(repairsSub);
    _subscriptions.add(bookingsSub);
  }

  void _emitCombined(List<RepairModel> repairs, List<RepairModel> bookings) {
    final combined = [...repairs, ...bookings];
    combined.sort((a, b) => b.startDate.compareTo(a.startDate));
    add(RepairsUpdated(combined));
  }

  RepairModel _mapRepair(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RepairModel(
      id: doc.id,
      garageId: data['garageId'] ?? 'unknown_garage',
      serviceName: data['serviceName'] ?? 'Unknown Service',
      vehicleMake: data['vehicleMake'] ?? 'Unknown',
      vehicleModel: data['vehicleModel'] ?? 'Unknown',
      vehiclePlate: data['vehiclePlate'] ?? 'Unknown',
      progressPercent: (data['progressPercent'] ?? 0.0).toDouble(),
      status: _parseStatus(data['status']),
      mechanicName: data['mechanicName'] ?? 'Mechanic',
      mechanicSpecialty: data['mechanicSpecialty'] ?? 'Specialist',
      mechanicRating: (data['mechanicRating'] ?? 0.0).toDouble(),
      location: data['location'] ?? 'Location',
      startDate: DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
      estimatedCompletion: data['estimatedCompletion'] ?? 'TBD',
      repairDescription: data['repairDescription'] ?? '',
      partsCost: (data['partsCost'] ?? 0.0).toDouble(),
      laborCost: (data['laborCost'] ?? 0.0).toDouble(),
      updates: [],
      isPaid: data['isPaid'] ?? false,
      isBooking: false,
    );
  }

  RepairModel _mapBookingToRepair(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RepairModel(
      id: doc.id,
      garageId: data['garageId'] ?? 'unknown_garage',
      serviceName: data['service'] ?? 'Unknown Service',
      vehicleMake: (data['vehicle'] as String?)?.split('-').first.trim() ?? 'Unknown',
      vehicleModel: '',
      vehiclePlate: (data['vehicle'] as String?)?.contains('-') == true 
          ? (data['vehicle'] as String).split('-').last.trim() 
          : 'Unknown',
      progressPercent: 0.0,
      status: data['status'] == 'Cancelled' ? RepairStatus.cancelled : RepairStatus.booked,
      mechanicName: 'To be assigned',
      mechanicSpecialty: 'Garage Guru Pro',
      mechanicRating: 5.0,
      location: data['garageName'] ?? 'Garage',
      startDate: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      estimatedCompletion: data['time'] ?? 'TBD',
      repairDescription: 'Scheduled booking',
      partsCost: 0.0,
      laborCost: 0.0,
      updates: [],
      isPaid: false,
      isBooking: true,
    );
  }

  Future<void> _onAddBooking(AddBooking event, Emitter<BookingState> emit) async {
    try {
      await _firestore.collection('bookings').add(event.bookingData);
    } catch (e) {
    }
  }

  Future<void> _onCancelRepair(CancelRepair event, Emitter<BookingState> emit) async {
    try {
      final collection = event.isBooking ? 'bookings' : 'repairs';
      final statusString = event.isBooking ? 'Cancelled' : 'cancelled';
      await _firestore.collection(collection).doc(event.id).update({
        'status': statusString,
      });
    } catch (e) {
    }
  }

  RepairStatus _parseStatus(String? status) {
    if (status == null) return RepairStatus.inProgress;
    final s = status.toLowerCase();
    if (s.contains('booked') || s.contains('scheduled')) return RepairStatus.booked;
    if (s.contains('on way') || s.contains('way')) return RepairStatus.mechanicOnWay;
    if (s.contains('progress')) return RepairStatus.inProgress;
    if (s.contains('completed') || s.contains('done')) return RepairStatus.completed;
    if (s.contains('cancelled') || s.contains('canceled')) return RepairStatus.cancelled;
    return RepairStatus.inProgress;
  }

  Future<void> _onSubmitFeedback(SubmitFeedback event, Emitter<BookingState> emit) async {
    try {
      await _firestore.collection('reviews').add({
        'garageId': event.garageId,
        'repairId': event.repairId,
        'userId': event.userId,
        'userName': event.userName,
        'userPhoto': event.userPhoto,
        'rating': event.rating,
        'comment': event.comment,
        'serviceName': event.serviceName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final garageRef = _firestore.collection('garages').doc(event.garageId);
      
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(garageRef);
        if (!snapshot.exists) return;

        final data = snapshot.data()!;
        final currentRating = (data['rating'] ?? 0.0).toDouble();
        final currentCount = (data['reviewCount'] ?? 0).toInt();

        final newCount = currentCount + 1;
        final calculatedRating = ((currentRating * currentCount) + event.rating) / newCount;
        final newRating = double.parse(calculatedRating.toStringAsFixed(2));

        transaction.update(garageRef, {
          'rating': newRating,
          'reviewCount': newCount,
        });
      });

      final collection = event.isBooking ? 'bookings' : 'repairs';
      await _firestore.collection(collection).doc(event.repairId).update({
        'status': 'completed',
      });
    } catch (e) {
    }
  }

  void _onRepairsUpdated(RepairsUpdated event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      status: BookingStatus.success,
      activeRepairs: event.repairs,
    ));
  }

  @override
  Future<void> close() {
    for (var sub in _subscriptions) {
      if (sub is StreamSubscription) sub.cancel();
    }
    return super.close();
  }
}
