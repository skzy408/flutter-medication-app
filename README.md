# Medication Tracker

This is a simple Flutter application that serves as a medication tracker, helping users manage their medication schedules efficiently.

## Project Description

The Medication Tracker app allows users to add, edit, and delete medications while providing essential features like input validation and user feedback.

## Design Choices

### Data Models

- **Medication Class**: A base class representing general medications. This class contains properties such as `id`, `name`, `time`, and `dose`.
- **PrescriptionMedication Class**: A subclass of Medication, which includes additional properties specific to prescription medications, such as `doctorName` and `prescriptionNumber`.
- **MedicationManager Class**: This class acts as a ViewModel, managing the state and data of medications while notifying the UI of changes. This architecture emphasizes separating concerns between the UI and data logic.

### State Management

- **Provider Package**: The application utilizes the Provider package for state management. This allows for efficient data sharing across the widget tree, ensuring the UI updates reactively when the medication list changes.

### UI Design

- **Flutter Widgets**:
  - **ListView**: Displays a scrollable list of medications, making it easy for users to browse their medication list.
  - **Card**: Each medication is displayed in a card format for a clean and organized look.
  - **AlertDialog**: Used for adding and editing medications, providing a modal interface for user interactions.
  - **Floating Action Button**: A floating action button is used to trigger the addition of a new medication, promoting a user-friendly experience.
  - **PopupMenuButton**: Each medication has an associated popup menu for editing or deleting, allowing for quick access to these actions.
- **Input Validation**: Text fields are validated to ensure that users provide the necessary information before saving a medication. Error dialogs are displayed for any validation failures.

### Additional Features

- **Basic form validation for the login screen**:
  - **Login Validation**: Email validation regex pattern taken from the RFC2822 Email Validation. Passwords cannot be empty.
  - **Homepage Validation**: Time must be in the HH:MM format, 24-hour time notation.
  
### Feedback

- **Failure Messages** (e.g., “Enter valid email address.”) for form validation.

## Assumptions

- **Time Format**: It is assumed that the user is familiar with the 24-hour time format (HH:MM) for inputting medication times.
  
- **Data Persistence**: The current implementation does not include data persistence. It is assumed that users will manage medications in a session only.
  
- **Error Handling**: Basic error handling is implemented, assuming that users will provide valid input. Further enhancement may be required for comprehensive error management.

