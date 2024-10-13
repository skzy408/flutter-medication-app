import 'package:flutter/material.dart';
import 'package:medication_tracker/models/medication.dart';
import 'package:medication_tracker/models/prescription_medication.dart';

class MedicationManager extends ChangeNotifier {
  List<Medication> medicationList = [
    // default medications
    Medication(
      id: 1,
      name: "Aspirin",
      time: "10:00",
      dose: "100mg",
    ), 
    PrescriptionMedication(
      id: 1,
      name: "Sertraline",
      time: "12:00",
      dose: "50 mg",
      doctorName: "John Doe",
      prescriptionNumber: "RX778899",
    ),
  ];

  // Variable to track the next ID number
  int _nextId = 2; // Start from 2 since the first default medication has id 1

  // get list of medications
  List<Medication> getMedicationList() {
    return medicationList;
  }

  // add a medication
  void addMedication(String name, String time, String dose) {
    medicationList
        .add(Medication(id: _nextId, name: name, time: time, dose: dose));
    _nextId++; // Increment the ID for the next medication

    notifyListeners();
  }

  // add a prescription medication
  void addPrescriptionMedication(String name, String time, String dose,
      String doctorName, String prescriptionNumber) {
    medicationList.add(PrescriptionMedication(
      id: _nextId,
      name: name,
      time: time,
      dose: dose,
      doctorName: doctorName,
      prescriptionNumber: prescriptionNumber,
    ));
    _nextId++;
    notifyListeners();
  }

  // remove a medication by id number
  void removeMedication(int id) {
    medicationList.removeWhere((medication) => medication.id == id);

    notifyListeners();
  }

  // Update a medication by id
  void updateMedication(
      int id, String updatedName, String updatedTime, String updatedDose,
      {String? doctorName, String? prescriptionNumber}) {
    // Find the medication by id
    for (int i = 0; i < medicationList.length; i++) {
      if (medicationList[i].id == id) {
        if (medicationList[i] is PrescriptionMedication) {
          // Update prescription medication
          medicationList[i] = PrescriptionMedication(
            id: id,
            name: updatedName,
            time: updatedTime,
            dose: updatedDose,
            doctorName: doctorName!, // Required for prescription medication
            prescriptionNumber:
                prescriptionNumber!, // Required for prescription medication
          );
        } else {
          // Update regular medication
          medicationList[i] = Medication(
            id: id,
            name: updatedName,
            time: updatedTime,
            dose: updatedDose,
          );
        }
        notifyListeners(); // Notify listeners of the change
        break;
      }
    }
  }
}
