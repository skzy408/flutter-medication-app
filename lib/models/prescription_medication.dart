import 'package:medication_tracker/models/medication.dart';

class PrescriptionMedication extends Medication {
  final String doctorName;
  final String prescriptionNumber;

  PrescriptionMedication({
    required int id,
    required String name,
    required String time,
    required String dose,
    required this.doctorName,
    required this.prescriptionNumber,
  }) : super(id: id, name: name, time: time, dose: dose);

  @override
  String toString() {
    return "$name, prescribed by Dr. $doctorName (Prescription No: $prescriptionNumber)";
  }
}
