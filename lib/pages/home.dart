import 'package:flutter/material.dart';
import 'package:medication_tracker/data/medication_manager.dart';
import 'package:medication_tracker/models/prescription_medication.dart';
import 'package:medication_tracker/pages/login.dart';
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

  bool isPrescription = false;

  // Function to validate time format (HH:MM)
  bool isValidTime(String time) {
    final timeRegex = RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  void createNewMedication() {
    bool localIsPrescription = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text("Add New Medication",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      const Text("Prescription Medication?")
                    ],
                  ),
                  TextField(
                    controller: medicationNameController,
                    decoration:
                        const InputDecoration(labelText: "Medication Name"),
                  ),
                  TextField(
                    controller: timeController,
                    decoration:
                        const InputDecoration(labelText: "Time (HH:MM)"),
                  ),
                  TextField(
                    controller: doseController,
                    decoration: const InputDecoration(labelText: "Dose"),
                  ),
                  if (localIsPrescription) ...[
                    TextField(
                      controller: doctorNameController,
                      decoration:
                          const InputDecoration(labelText: "Doctor's Name"),
                    ),
                    TextField(
                      controller: prescriptionNumberController,
                      decoration: const InputDecoration(
                          labelText: "Prescription Number"),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (validateFields(localIsPrescription)) {
                    save(localIsPrescription);
                  }
                },
                child: const Text("Save"),
              ),
              TextButton(
                onPressed: cancel,
                child:
                    const Text("Cancel"),
              ),
            ],
          );
        },
      ),
    );
  }

  bool validateFields(bool isPrescription) {
    if (medicationNameController.text.isEmpty) {
      _showErrorDialog("Medication name cannot be empty.");
      return false;
    }

    if (!isValidTime(timeController.text)) {
      _showErrorDialog("Time must be in HH:MM format.");
      return false;
    }

    if (doseController.text.isEmpty) {
      _showErrorDialog("Dose cannot be empty.");
      return false;
    }

    if (isPrescription) {
      if (doctorNameController.text.isEmpty) {
        _showErrorDialog("Doctor's name cannot be empty.");
        return false;
      }
      if (prescriptionNumberController.text.isEmpty) {
        _showErrorDialog("Prescription number cannot be empty.");
        return false;
      }
    }

    return true; // All validations passed
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void save(bool isPrescription) {
    String newMedicationName = medicationNameController.text;
    String newTime = timeController.text;
    String newDose = doseController.text;

    if (isPrescription) {
      String doctorName = doctorNameController.text;
      String prescriptionNumber = prescriptionNumberController.text;

      Provider.of<MedicationManager>(context, listen: false)
          .addPrescriptionMedication(
        newMedicationName,
        newTime,
        newDose,
        doctorName,
        prescriptionNumber,
      );
    } else {
      Provider.of<MedicationManager>(context, listen: false).addMedication(
        newMedicationName,
        newTime,
        newDose,
      );
    }

    clear();
    Navigator.pop(context);
  }

  void edit(int index) {
    final currentMedication =
        Provider.of<MedicationManager>(context, listen: false)
            .getMedicationList()[index];

    medicationNameController.text = currentMedication.name;
    timeController.text = currentMedication.time;
    doseController.text = currentMedication.dose;

    if (currentMedication is PrescriptionMedication) {
      doctorNameController.text = currentMedication.doctorName;
      prescriptionNumberController.text = currentMedication.prescriptionNumber;
      setState(() {
        isPrescription = true;
      });
    } else {
      setState(() {
        isPrescription = false;
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Medication",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  const Text("Prescription Medication?")
                ],
              ),
              TextField(
                controller: medicationNameController,
                decoration: const InputDecoration(labelText: "Medication Name"),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: "Time (HH:MM)"),
              ),
              TextField(
                controller: doseController,
                decoration: const InputDecoration(labelText: "Dose"),
              ),
              if (isPrescription) ...[
                TextField(
                  controller: doctorNameController,
                  decoration: const InputDecoration(labelText: "Doctor's Name"),
                ),
                TextField(
                  controller: prescriptionNumberController,
                  decoration:
                      const InputDecoration(labelText: "Prescription Number"),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (validateFields(isPrescription)) {
                saveEdit(currentMedication.id);
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void saveEdit(int id) {
    String updatedName = medicationNameController.text;
    String updatedTime = timeController.text;
    String updatedDose = doseController.text;

    if (isPrescription) {
      String updatedDoctorName = doctorNameController.text;
      String updatedPrescriptionNumber = prescriptionNumberController.text;

      Provider.of<MedicationManager>(context, listen: false).updateMedication(
        id,
        updatedName,
        updatedTime,
        updatedDose,
        doctorName: updatedDoctorName,
        prescriptionNumber: updatedPrescriptionNumber,
      );
    } else {
      Provider.of<MedicationManager>(context, listen: false).updateMedication(
        id,
        updatedName,
        updatedTime,
        updatedDose,
      );
    }

    clear();
    Navigator.pop(context);
  }

  void clear() {
    medicationNameController.clear();
    timeController.clear();
    doseController.clear();
    doctorNameController.clear();
    prescriptionNumberController.clear();
    isPrescription = false;
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void delete(int index) {
    int id = Provider.of<MedicationManager>(context, listen: false)
        .getMedicationList()[index]
        .id;
    Provider.of<MedicationManager>(context, listen: false).removeMedication(id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationManager>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Medication Tracker", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 111, 136, 173),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewMedication,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the list
          child: ListView.builder(
            itemCount: value.getMedicationList().length,
            itemBuilder: (context, index) {
              final medication = value.getMedicationList()[index];

              return Card(
                // Use Card widget for a clean card design
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  title: Text(medication.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(label: Text(medication.time)),
                          SizedBox(width: 8), // Add space between chips
                          Chip(label: Text(medication.dose)),
                        ],
                      ),
                      if (medication is PrescriptionMedication) ...[
                        Text('Prescribed by Dr. ${medication.doctorName}'),
                        Text(
                            'Prescription No: ${medication.prescriptionNumber}'),
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
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
