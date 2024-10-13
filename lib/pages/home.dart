import 'package:flutter/material.dart';
import 'package:medication_tracker/data/medication_manager.dart';
import 'package:medication_tracker/models/prescription_medication.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final medicationNameController = TextEditingController();
  final timeController = TextEditingController();
  final doseController = TextEditingController();
  final doctorNameController = TextEditingController();
  final prescriptionNumberController = TextEditingController();

  bool isPrescription =
      false; // Flag to check if it's a prescription medication

  void createNewMedication() {
    // Declare a local state variable for prescription toggle within the dialog
    bool localIsPrescription = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text("Add new medication"),
            content: Column(
              mainAxisSize: MainAxisSize.min, // Adjust for small dialogs
              children: [
                // Checkbox to toggle between regular and prescription medication
                Row(
                  children: [
                    Checkbox(
                      value: localIsPrescription,
                      onChanged: (value) {
                        setDialogState(() {
                          localIsPrescription = value!;
                        });
                      },
                    ),
                    Text("Is Prescription Medication?")
                  ],
                ),
                // Medication name
                TextField(
                  controller: medicationNameController,
                  decoration: InputDecoration(labelText: "Medication Name"),
                ),
                // Time
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: "Time"),
                ),
                // Dose
                TextField(
                  controller: doseController,
                  decoration: InputDecoration(labelText: "Dose"),
                ),
                // Additional fields for prescription medication
                if (localIsPrescription) ...[
                  TextField(
                    controller: doctorNameController,
                    decoration: InputDecoration(labelText: "Doctor's Name"),
                  ),
                  TextField(
                    controller: prescriptionNumberController,
                    decoration:
                        InputDecoration(labelText: "Prescription Number"),
                  ),
                ],
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  // Pass the local `isPrescription` flag to the save method
                  save(localIsPrescription);
                },
                child: Text("Save"),
              ),
              MaterialButton(
                onPressed: cancel,
                child: Text("Cancel"),
              ),
            ],
          );
        },
      ),
    );
  }

  void save(bool isPrescription) {
    String newMedicationName = medicationNameController.text;
    String newTime = timeController.text;
    String newDose = doseController.text;

    if (isPrescription) {
      // Get prescription details
      String doctorName = doctorNameController.text;
      String prescriptionNumber = prescriptionNumberController.text;

      // Add prescription medication to MedicationManager
      Provider.of<MedicationManager>(context, listen: false)
          .addPrescriptionMedication(
        newMedicationName,
        newTime,
        newDose,
        doctorName,
        prescriptionNumber,
      );
    } else {
      // Add regular medication
      Provider.of<MedicationManager>(context, listen: false).addMedication(
        newMedicationName,
        newTime,
        newDose,
      );
    }

    // Clear controllers and close the dialog
    clear();
    Navigator.pop(context);
  }

  // edit medication details
  void edit(int index) {
    // Get the current medication data
    final currentMedication =
        Provider.of<MedicationManager>(context, listen: false)
            .getMedicationList()[index];

    // Pre-fill the fields with current medication data
    medicationNameController.text = currentMedication.name;
    timeController.text = currentMedication.time;
    doseController.text = currentMedication.dose;

    if (currentMedication is PrescriptionMedication) {
      // If it's a prescription medication, also pre-fill the doctor's name and prescription number
      doctorNameController.text = currentMedication.doctorName;
      prescriptionNumberController.text = currentMedication.prescriptionNumber;
      setState(() {
        isPrescription = true; // Set the flag for prescription medication
      });
    } else {
      setState(() {
        isPrescription = false; // Regular medication
      });
    }

    // Show edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit medication"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkbox to toggle between regular and prescription medication
            Row(
              children: [
                Checkbox(
                  value: isPrescription,
                  onChanged: (value) {
                    setState(() {
                      isPrescription = value!;
                    });
                  },
                ),
                Text("Is Prescription Medication?")
              ],
            ),
            // Medication name
            TextField(
              controller: medicationNameController,
              decoration: InputDecoration(labelText: "Medication Name"),
            ),
            // Time
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: "Time"),
            ),
            // Dose
            TextField(
              controller: doseController,
              decoration: InputDecoration(labelText: "Dose"),
            ),
            // Additional fields for prescription medication
            if (isPrescription) ...[
              TextField(
                controller: doctorNameController,
                decoration: InputDecoration(labelText: "Doctor's Name"),
              ),
              TextField(
                controller: prescriptionNumberController,
                decoration: InputDecoration(labelText: "Prescription Number"),
              ),
            ],
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              saveEdit(currentMedication.id); // Pass the correct ID
            },
            child: Text("Save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

// save edited medication details
  void saveEdit(int id) {
    String updatedName = medicationNameController.text;
    String updatedTime = timeController.text;
    String updatedDose = doseController.text;

    if (isPrescription) {
      // If it's a prescription medication, also capture the updated prescription details
      String updatedDoctorName = doctorNameController.text;
      String updatedPrescriptionNumber = prescriptionNumberController.text;

      // Update the prescription medication
      Provider.of<MedicationManager>(context, listen: false).updateMedication(
        id,
        updatedName,
        updatedTime,
        updatedDose,
        doctorName: updatedDoctorName,
        prescriptionNumber: updatedPrescriptionNumber,
      );
    } else {
      // Update regular medication
      Provider.of<MedicationManager>(context, listen: false).updateMedication(
        id,
        updatedName,
        updatedTime,
        updatedDose,
      );
    }

    // Clear text fields and pop the dialog
    clear();
    Navigator.pop(context);
  }

  // Clear all controllers
  void clear() {
    medicationNameController.clear();
    timeController.clear();
    doseController.clear();
    doctorNameController.clear();
    prescriptionNumberController.clear();
    isPrescription = false; // Reset the prescription flag
  }

  // cancel
  void cancel() {
    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // delete medication
  void delete(int index) {
    // Get the correct ID of the medication to delete
    int id = Provider.of<MedicationManager>(context, listen: false)
        .getMedicationList()[index]
        .id;

    // Remove medication using its ID
    Provider.of<MedicationManager>(context, listen: false).removeMedication(id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationManager>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Medication Tracker"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewMedication,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getMedicationList().length,
          itemBuilder: (context, index) {
            final medication = value.getMedicationList()[index];

            return Container(
              color: const Color.fromARGB(255, 181, 195, 217),
              child: ListTile(
                title: Text(medication.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // time
                        Chip(
                          label: Text(medication.time),
                        ),
                        // dose
                        Chip(
                          label: Text(medication.dose),
                        ),
                      ],
                    ),
                    if (medication is PrescriptionMedication) ...[
                      // Doctor's name and prescription number for prescription medications
                      Text('Prescribed by Dr. ${medication.doctorName}'),
                      Text('Prescription No: ${medication.prescriptionNumber}'),
                    ],
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'Edit') {
                      edit(index);
                    } else if (result == 'Delete') {
                      delete(index);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ],
                  icon: Icon(Icons.more_vert),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
