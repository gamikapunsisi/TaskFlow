//
//import Foundation
//import EventKit
//import UserNotifications
//
//class ReminderManager: ObservableObject {
//    private let eventStore = EKEventStore()
//    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
//    @Published var errorMessage: String?
//    
//    init() {
//        checkAuthorizationStatus()
//    }
//    
//    // MARK: - Authorization
//    func checkAuthorizationStatus() {
//        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
//    }
//    
//    func requestCalendarAccess() async -> Bool {
//        do {
//            let granted = try await eventStore.requestAccess(to: .event)
//            DispatchQueue.main.async {
//                self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
//            }
//            return granted
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to request calendar access: \(error.localizedDescription)"
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Create Booking Reminder Event
//    func createBookingReminder(for booking: ServiceBooking) async -> Bool {
//        // Check authorization first
//        if authorizationStatus != .authorized {
//            let granted = await requestCalendarAccess()
//            if !granted {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Calendar access required to create reminders"
//                }
//                return false
//            }
//        }
//        
//        do {
//            let event = EKEvent(eventStore: eventStore)
//            
//            // Configure event details
//            event.title = "Service: \(booking.serviceName)"
//            event.notes = createEventNotes(for: booking)
//            event.location = booking.customerAddress
//            event.startDate = booking.scheduledDate
//            event.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: booking.scheduledDate) ?? booking.scheduledDate
//            
//            // Add to default calendar
//            event.calendar = eventStore.defaultCalendarForNewEvents
//            
//            // Add alarms/reminders
//            let reminderTimes: [TimeInterval] = [
//                -24 * 60 * 60, // 1 day before
//                -2 * 60 * 60,  // 2 hours before
//                -30 * 60       // 30 minutes before
//            ]
//            
//            for timeInterval in reminderTimes {
//                let alarm = EKAlarm(relativeOffset: timeInterval)
//                event.addAlarm(alarm)
//            }
//            
//            // Save the event
//            try eventStore.save(event, span: .thisEvent)
//            
//            DispatchQueue.main.async {
//                self.errorMessage = nil
//            }
//            
//            return true
//            
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to create calendar event: \(error.localizedDescription)"
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Find and Update Existing Event
//    func findBookingEvent(for booking: ServiceBooking) -> EKEvent? {
//        let calendar = Calendar.current
//        let startDate = calendar.startOfDay(for: booking.scheduledDate)
//        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
//        
//        let predicate = eventStore.predicateForEvents(
//            withStart: startDate,
//            end: endDate,
//            calendars: nil
//        )
//        
//        let events = eventStore.events(matching: predicate)
//        
//        return events.first { event in
//            event.title.contains(booking.serviceName) &&
//            event.location == booking.customerAddress &&
//            abs(event.startDate.timeIntervalSince(booking.scheduledDate)) < 3600 // Within 1 hour
//        }
//    }
//    
//    // MARK: - Update Booking Reminder
//    func updateBookingReminder(for booking: ServiceBooking) async -> Bool {
//        guard let existingEvent = findBookingEvent(for: booking) else {
//            // If no existing event, create new one
//            return await createBookingReminder(for: booking)
//        }
//        
//        do {
//            // Update event details
//            existingEvent.title = "Service: \(booking.serviceName)"
//            existingEvent.notes = createEventNotes(for: booking)
//            existingEvent.location = booking.customerAddress
//            existingEvent.startDate = booking.scheduledDate
//            existingEvent.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: booking.scheduledDate) ?? booking.scheduledDate
//            
//            // Save changes
//            try eventStore.save(existingEvent, span: .thisEvent)
//            
//            DispatchQueue.main.async {
//                self.errorMessage = nil
//            }
//            
//            return true
//            
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to update calendar event: \(error.localizedDescription)"
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Remove Booking Reminder
//    func removeBookingReminder(for booking: ServiceBooking) async -> Bool {
//        guard let existingEvent = findBookingEvent(for: booking) else {
//            return true // No event to remove
//        }
//        
//        do {
//            try eventStore.remove(existingEvent, span: .thisEvent)
//            
//            DispatchQueue.main.async {
//                self.errorMessage = nil
//            }
//            
//            return true
//            
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to remove calendar event: \(error.localizedDescription)"
//            }
//            return false
//        }
//    }
//    
//    // MARK: - Helper Methods
//    private func createEventNotes(for booking: ServiceBooking) -> String {
//        return """
//        Customer: \(booking.customerName)
//        Phone: \(booking.customerPhone)
//        Service: \(booking.serviceName)
//        Address: \(booking.customerAddress)
//        Price: \(booking.formattedPrice)
//        Status: \(booking.status.displayName)
//        
//        Booking ID: \(booking.id)
//        """
//    }
//    
//    // MARK: - Batch Operations
//    func createRemindersForMultipleBookings(_ bookings: [ServiceBooking]) async -> Int {
//        var successCount = 0
//        
//        for booking in bookings {
//            let success = await createBookingReminder(for: booking)
//            if success {
//                successCount += 1
//            }
//        }
//        
//        return successCount
//    }
//    
//    // MARK: - Local Notifications (Backup)
//    func scheduleLocalNotificationReminder(for booking: ServiceBooking) async {
//        let center = UNUserNotificationCenter.current()
//        
//        // Request notification permission
//        do {
//            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
//            if !granted {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Notification permission required for reminders"
//                }
//                return
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to request notification permission: \(error.localizedDescription)"
//            }
//            return
//        }
//        
//        // Create notification content
//        let content = UNMutableNotificationContent()
//        content.title = "Upcoming Service"
//        content.body = "\(booking.serviceName) at \(booking.customerAddress)"
//        content.sound = .default
//        content.userInfo = [
//            "bookingId": booking.id,
//            "customerName": booking.customerName,
//            "serviceName": booking.serviceName
//        ]
//        
//        // Schedule for 30 minutes before
//        let triggerDate = Calendar.current.date(byAdding: .minute, value: -30, to: booking.scheduledDate) ?? booking.scheduledDate
//        let trigger = UNCalendarNotificationTrigger(
//            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
//            repeats: false
//        )
//        
//        // Create and add request
//        let request = UNNotificationRequest(
//            identifier: "booking-\(booking.id)",
//            content: content,
//            trigger: trigger
//        )
//        
//        do {
//            try await center.add(request)
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Failed to schedule notification: \(error.localizedDescription)"
//            }
//        }
//    }
//}
