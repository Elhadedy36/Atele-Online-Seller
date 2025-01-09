import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/appointments/data/appointments_model.dart';
import 'package:atele_seller/feature/appointments/presentation/cubit/appointments_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentsCubit extends Cubit<void> {
  AppointmentsCubit() : super(AppointmentsInitial());

  final _firestore = FirebaseFirestore.instance;

  // Stream to get appointments filtered by status
  Stream<List<AppointmentsModel>> getAppointmentsStream(String status) {
    return _firestore
        .collection(FirebaseStrings.sellers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FirebaseStrings.appointments)
        .where(FirebaseStrings.status, isEqualTo: status)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AppointmentsModel.fromJson(doc.data());
      }).toList();
    });
  }

  // Function to update appointment status
  Future<void> updateAppointmentStatus(
      {required String appointmentId, required String newStatus}) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await _firestore
          .collection(FirebaseStrings.sellers)
          .doc(userId)
          .collection(FirebaseStrings.appointments)
          .doc(appointmentId)
          .update({FirebaseStrings.status: newStatus});

      print('Appointment status updated successfully');
    } catch (e) {
      print('Error updating appointment status: $e');
    }
  }
}
