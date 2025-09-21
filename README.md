# TaskFlow Connect iOS App

**Developed by Gamika Punsisi**

TaskFlow Connect is a feature-rich iOS application designed to connect clients and taskers efficiently. It offers secure authentication, face recognition, real-time task tracking, and seamless communication to enhance productivity and reliability.

---

## Key Objectives of the App

1. Enable clients to post tasks and receive bids from qualified taskers.  
2. Allow taskers to find and accept suitable jobs efficiently.  
3. Provide real-time tracking, communication, and secure authentication to improve reliability and user experience.  

---

## Target Users

- **Clients:** Individuals or businesses looking to outsource tasks.  
- **Taskers:** Skilled workers seeking flexible job opportunities.  

---

## Key Features

### Task Posting & Bidding System

**How It Works:**  
- Clients create tasks by specifying title, description, budget, category, and deadline.  
- Taskers browse available tasks and submit bids with proposed price and estimated completion time.  
- Clients review bids and select a tasker based on ratings, price, or previous work experience.  

**Benefits:**  
- Helps clients quickly find skilled workers.  
- Provides taskers with more job opportunities efficiently.  

---

### Real-Time Task Tracking & Navigation (MapKit Integration)

**How It Works:**  
- Clients can track taskers in real time using MapKit-powered GPS tracking.  
- Taskers receive optimized navigation routes to the client’s location.  
- Estimated Time of Arrival (ETA) is displayed to clients.  

**Benefits:**  
- Clients know exactly when to expect their tasker.  
- Taskers navigate efficiently, reducing travel time and improving productivity.  

---

### Push Notifications

**How It Works:**  
- Clients and taskers communicate via in-app real-time chat.  
- Push notifications alert users about new messages, task updates, and bid approvals.  
- Message history is stored locally using Core Data for offline access.  

**Benefits:**  
- Eliminates miscommunication and provides a record of task-related conversations.  
- Keeps users informed with instant updates, improving engagement.  

---

### EventKit Integration

**How It Works:**  
- Requests calendar access from users.  
- Automatically adds accepted or posted tasks as calendar events.  
- Users can set alerts for task reminders.  

**Benefits:**  
- Prevents missed deadlines and task overlaps.  
- Improves time management and task prioritization.  

---

### Biometric Authentication (Face ID & Touch ID)

**How It Works:**  
- Users can enable Face ID or Touch ID login.  
- Adds an extra layer of security for payments and profile settings.  

**Benefits:**  
- Prevents unauthorized access.  
- Ensures user data and transactions remain secure.  

---

## Development Process

| Phase        | Tools / Tech Used                                   |
|-------------|----------------------------------------------------|
| UI/UX Design | Figma                                              |
| Frontend     | SwiftUI                                            |
| Database     | Firebase                                           |
| Notifications| Apple Push Notification Service (APNs)            |
| Biometric Auth | Local Authentication, Biometric Authentication |
| Calendar Access | EventKit                                        |

---

## Technologies Used

- **SwiftUI** – Modern UI framework for iOS development  
- **Firebase** – Database, authentication, and cloud services  
- **MapKit** – Real-time GPS tracking and navigation  
- **APNs** – Push notifications  
- **Core Data** – Local storage for offline messages  
- **EventKit** – Calendar integration  
- **Local Authentication** – Face ID & Touch ID security  

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**TaskFlow Connect** aims to simplify task management for clients and taskers while providing a secure, real-time, and user-friendly experience.  
**Developed by Gamika Punsisi**
