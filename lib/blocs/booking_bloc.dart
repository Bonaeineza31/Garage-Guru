import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/models/repair_model.dart';

// Events
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

class RepairsUpdated extends BookingEvent {
  final List<RepairModel> repairs;
  const RepairsUpdated(this.repairs);
  @override
  List<Object?> get props => [repairs];
}

// States
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

// BLoC
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BookingBloc() : super(const BookingState()) {
    on<LoadRepairs>(_onLoadRepairs);
    on<AddBooking>(_onAddBooking);
    on<RepairsUpdated>(_onRepairsUpdated);
  }

  void _onLoadRepairs(LoadRepairs event, Emitter<BookingState> emit) {
    emit(state.copyWith(status: BookingStatus.loading));
    _firestore
        .collection('repairs')
        .where('userId', isEqualTo: event.userId)
        .snapshots()
        .listen((snapshot) {
      final repairs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return RepairModel(
          id: doc.id,
          serviceName: data['serviceName'] ?? 'Unknown Service',
          vehicleMake: data['vehicleMake'] ?? 'Unknown',
          vehicleModel: data['vehicleModel'] ?? 'Unknown',
          vehiclePlate: data['vehiclePlate'] ?? 'Unknown',
          progressPercent: (data['progressPercent'] ?? 0.0).toDouble(),
          status: RepairStatus.values.firstWhere(
            (e) => e.toString() == 'RepairStatus.${data['status']}',
            orElse: () => RepairStatus.inProgress,
          ),
          mechanicName: data['mechanicName'] ?? 'Mechanic',
          mechanicSpecialty: data['mechanicSpecialty'] ?? 'Specialist',
          mechanicRating: (data['mechanicRating'] ?? 0.0).toDouble(),
          location: data['location'] ?? 'Location',
          startDate: DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
          estimatedCompletion: data['estimatedCompletion'] ?? 'TBD',
          repairDescription: data['repairDescription'] ?? '',
          partsCost: (data['partsCost'] ?? 0.0).toDouble(),
          laborCost: (data['laborCost'] ?? 0.0).toDouble(),
          updates: [], // Assuming updates are handled separately or omitted for now
          isPaid: data['isPaid'] ?? false,
        );
      }).toList();
      add(RepairsUpdated(repairs));
    });
  }

  Future<void> _onAddBooking(AddBooking event, Emitter<BookingState> emit) async {
    try {
      await _firestore.collection('bookings').add(event.bookingData);
    } catch (e) {
      // Handle error
    }
  }

  void _onRepairsUpdated(RepairsUpdated event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      status: BookingStatus.success,
      activeRepairs: event.repairs,
    ));
  }
}
