# Employee_Attendence_Management
**Technologies**:

Flutter: As the primary framework for building a cross-platform mobile app (iOS and Android) with a single codebase.
Firebase: A suite of Google Cloud services utilized in this app:
Firebase Authentication (FirebaseAuth): Manages user authentication (login/signup) with email/password or social login providers.
Firebase Cloud Firestore: A NoSQL database for storing app data like attendance records, leave requests, and user roles.

**App Architecture**:

**Authentication (Onboarding):**

Presents a screen prompting users between "Admin" and "Employee" roles.
Implements user authentication using FirebaseAuth:
Login: Validates credentials (email/password) against Firebase.
Signup: Creates a new user in Firebase for employees (consider email verification for security).

**Employee Dashboard (Home Screen)**:

Checks for a stored employee UID in SharedPreferences (or SecureStorage).
If no UID exists, redirects to onboarding/login.
Upon successful login:
Fetches employee's attendance and leave data from Firestore using the UID.
Displays the following functionalities:
Check-in/Check-out:
Uses Geolocation (with user permission) to get the current location.
Retrieves the current time.
Stores the check-in/check-out time and location in Firestore, along with the UID as a document reference for easy retrieval.
View Attendance History:
Retrieves past attendance records from Firestore based on the employee's UID.
Displays a list or calendar view of attendance data.
Apply for Leave:
Presents a form to choose leave type, duration (start/end dates), and reason.
Submits the leave request to Firestore with the UID and a status of "Pending."


Requires admin authentication (separate login or role-based access).
Provides a dashboard to view and manage leave requests:
Lists all submitted leave requests with employee details (using UID reference), leave type, duration, and status.
Allows the admin to approve or reject leave requests, updating the status in Firestore.
Data Flow:

User interaction (login, check-in/check-out, leave application) triggers events in the Flutter UI.
Events are handled by controllers or business logic classes, which interact with Firebase services.
Firebase Authentication handles user login/signup and provides a UID for the logged-in employee.
Firebase Cloud Firestore stores and retrieves user data (attendance, leave requests), referenced by the UID.
