# Medication Tracker App

## Project Description
This is a simple Flutter application that serves as a medication tracker, allowing users to manage and keep track of their medications easily.

## Design Choices

### Data Models
The application features a `Medication` class, which serves as a base class representing general medications. This class includes essential properties such as `id`, `name`, `time`, and `dose`. Additionally, there is a `PrescriptionMedication` class that extends the `Medication` class, incorporating properties specific to prescription medications, such as `doctorName` and `prescriptionNumber`. To manage the state and data of medications effectively, the `MedicationManager` class acts as a ViewModel, separating concerns between the UI and data logic while notifying the UI of any changes.

### State Management
For state management, the application utilizes the Provider package. This choice enables efficient data sharing across the widget tree, ensuring that the UI updates reactively when the medication list changes.

### UI Design
The UI is built using various Flutter widgets to enhance user experience. The `ListView` widget displays a scrollable list of medications, making it easy for users to browse through their medication list. Each medication is presented in a card format for a clean and organized appearance. The application employs an `AlertDialog` for adding and editing medications, providing a modal interface for user interactions. To promote a user-friendly experience, a floating action button is used to trigger the addition of a new medication. Each medication is also associated with a `PopupMenuButton` for quick access to editing or deleting actions. Input validation is integrated, ensuring that users provide the necessary information before saving a medication. In case of validation failures, error dialogs are displayed.

## Additional Features
The application includes basic form validation for the login screen. Email validation is performed using a regex pattern taken from the RFC2822 Email Validation standard, while passwords are required to be non-empty. On the homepage, time inputs must conform to the HH:MM format, adhering to the 24-hour time notation.

### Feedback
To enhance user experience, failure messages, such as "Enter a valid email address," are displayed for form validation issues.

## Assumptions

### Time Format
It is assumed that users are familiar with the 24-hour time format (HH:MM) when inputting medication times.

### Data Persistence
The current implementation does not include data persistence; it is assumed that users will manage their medications within a single session.

### Error Handling
Basic error handling has been implemented, operating under the assumption that users will provide valid input. Further enhancements may be required for comprehensive error management.

