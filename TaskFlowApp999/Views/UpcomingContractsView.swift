
import SwiftUI
import MapKit

struct UpcomingContractsView: View {
    @StateObject private var bookingManager = BookingManager()
    @State private var selectedDate: Date = Date()
    
    // Filter bookings for the selected date
    var bookingsForSelectedDate: [ServiceBooking] {
        bookingManager.currentBookings.filter {
            Calendar.current.isDate($0.scheduledDate, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    CalendarWeekView(
                        selectedDate: $selectedDate,
                        bookings: bookingManager.currentBookings
                    )
                    
                    VStack(spacing: 16) {
                        if bookingManager.isLoading {
                            ProgressView("Loading bookings...")
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else if bookingsForSelectedDate.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                Text("No bookings scheduled")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                Text("for \(formattedSelectedDate())")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                        } else {
                            ForEach(bookingsForSelectedDate) { booking in
                                EnhancedBookingCardView(booking: booking) {
                                    Task {
                                        await bookingManager.updateBookingStatus(booking.id, status: .cancelled)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = bookingManager.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Upcoming Bookings")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                let userId = "gamikapunsisi"
                await bookingManager.fetchUserBookings(for: userId)
            }
            .onAppear {
                let userId = "gamikapunsisi"
                Task {
                    await bookingManager.fetchUserBookings(for: userId)
                }
            }
        }
    }
    
    private func formattedSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
}

// Enhanced Booking Card with Map Integration
struct EnhancedBookingCardView: View {
    let booking: ServiceBooking
    var onCancel: () -> Void
    @State private var showingMap = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with service name and status
            HStack {
                Text(booking.serviceName)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                StatusBadge(status: booking.status)
            }
            
            // Customer information
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                    Text(booking.customerName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                    Text("\(booking.formattedDate) • \(booking.formattedTime)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Address section with map button
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                    Text("Address:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack {
                    Text(booking.customerAddress)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: {
                        showingMap = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "map")
                                .font(.system(size: 12))
                            Text("View Map")
                                .font(.caption)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Action buttons
            HStack {
                Button("Cancel Booking") {
                    onCancel()
                }
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
                
                Spacer()
                
                Text(booking.formattedPrice)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showingMap) {
            BookingLocationMapView(
                booking: booking
            )
        }
    }
}

// Status badge component
struct StatusBadge: View {
    let status: BookingStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.system(size: 10))
            Text(status.displayName)
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(status.color.opacity(0.15))
        .foregroundColor(status.color)
        .cornerRadius(6)
    }
}

// Map view for booking location
struct BookingLocationMapView: View {
    let booking: ServiceBooking
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), // Colombo default
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map view
                Map(coordinateRegion: $region, annotationItems: coordinate.map { [MapLocation(coordinate: $0)] } ?? []) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            
                            VStack(spacing: 2) {
                                Text(booking.customerName)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text(booking.serviceName)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(6)
                            .background(.white)
                            .cornerRadius(6)
                            .shadow(radius: 2)
                        }
                    }
                }
                .ignoresSafeArea()
                
                // Loading indicator
                if isLoading {
                    VStack {
                        ProgressView()
                        Text("Locating address...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10)
                }
                
                // Error message
                if let errorMessage = errorMessage {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text(errorMessage)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(.red)
                        .cornerRadius(8)
                        .padding()
                    }
                }
                
                // Service info overlay
                if !isLoading && coordinate != nil {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(booking.serviceName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("Scheduled: \(booking.formattedDate) at \(booking.formattedTime)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            StatusBadge(status: booking.status)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Service Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let coordinate = coordinate {
                        Menu {
                            Button("Get Directions") {
                                openInAppleMaps(coordinate: coordinate)
                            }
                            
                            Button("Call Customer") {
                                callCustomer()
                            }
                            
                            Button("Share Location") {
                                shareLocation(coordinate: coordinate)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .onAppear {
                geocodeAddress()
            }
        }
    }
    
    private func geocodeAddress() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(booking.customerAddress) { placemarks, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Could not locate address: \(error.localizedDescription)"
                    return
                }
                
                guard let placemark = placemarks?.first,
                      let location = placemark.location else {
                    errorMessage = "Address not found. Please verify the address with customer."
                    return
                }
                
                coordinate = location.coordinate
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
            }
        }
    }
    
    private func openInAppleMaps(coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(booking.customerName) - \(booking.serviceName)"
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    private func callCustomer() {
        let cleanPhone = booking.customerPhone.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(cleanPhone)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareLocation(coordinate: CLLocationCoordinate2D) {
        let locationString = "Location for \(booking.serviceName): https://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)"
        
        let activityController = UIActivityViewController(
            activityItems: [locationString],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
}

// Map location model
struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


//
//import SwiftUI
//import MapKit
//import EventKit
//import UserNotifications
//
//struct UpcomingContractsView: View {
//    @StateObject private var bookingManager = BookingManager()
//    @StateObject private var reminderManager = ReminderManager()
//    @State private var selectedDate: Date = Date()
//    @State private var showingReminderSettings = false
//    
//    // Filter bookings for the selected date
//    var bookingsForSelectedDate: [ServiceBooking] {
//        bookingManager.currentBookings.filter {
//            Calendar.current.isDate($0.scheduledDate, inSameDayAs: selectedDate)
//        }
//    }
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 24) {
//                    CalendarWeekView(
//                        selectedDate: $selectedDate,
//                        bookings: bookingManager.currentBookings
//                    )
//                    
//                    // Reminder status summary
//                    if !bookingsForSelectedDate.isEmpty {
//                        ReminderSummaryView(
//                            bookings: bookingsForSelectedDate,
//                            reminderManager: reminderManager
//                        )
//                    }
//                    
//                    VStack(spacing: 16) {
//                        if bookingManager.isLoading {
//                            ProgressView("Loading bookings...")
//                                .frame(maxWidth: .infinity, minHeight: 200)
//                        } else if bookingsForSelectedDate.isEmpty {
//                            VStack(spacing: 16) {
//                                Image(systemName: "calendar.badge.exclamationmark")
//                                    .font(.system(size: 50))
//                                    .foregroundColor(.gray)
//                                
//                                Text("No bookings scheduled")
//                                    .font(.title2)
//                                    .foregroundColor(.secondary)
//                                
//                                Text("for \(formattedSelectedDate())")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//                            .frame(maxWidth: .infinity, minHeight: 200)
//                        } else {
//                            ForEach(bookingsForSelectedDate) { booking in
//                                EnhancedBookingCardView(booking: booking, reminderManager: reminderManager) {
//                                    Task {
//                                        // Remove reminder when cancelling booking
//                                        await reminderManager.removeBookingReminder(for: booking)
//                                        await bookingManager.updateBookingStatus(booking.id, status: .cancelled)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Error messages
//                    if let errorMessage = bookingManager.errorMessage {
//                        Text(errorMessage)
//                            .foregroundColor(.red)
//                            .font(.caption)
//                            .padding()
//                    }
//                    
//                    if let errorMessage = reminderManager.errorMessage {
//                        HStack {
//                            Image(systemName: "exclamationmark.triangle")
//                            Text(errorMessage)
//                        }
//                        .foregroundColor(.orange)
//                        .font(.caption)
//                        .padding()
//                        .background(Color.orange.opacity(0.1))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                    }
//                }
//                .padding(.vertical)
//            }
//            .navigationTitle("Upcoming Bookings")
//            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Menu {
//                        Button("Reminder Settings") {
//                            showingReminderSettings = true
//                        }
//                        
//                        Button("Create All Reminders") {
//                            Task {
//                                await createRemindersForAllBookings()
//                            }
//                        }
//                        
//                        Button("Refresh") {
//                            let userId = "gamikapunsisi"
//                            Task {
//                                await bookingManager.fetchUserBookings(for: userId)
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "ellipsis.circle")
//                    }
//                }
//            }
//            .refreshable {
//                let userId = "gamikapunsisi"
//                await bookingManager.fetchUserBookings(for: userId)
//            }
//            .onAppear {
//                let userId = "gamikapunsisi"
//                Task {
//                    await bookingManager.fetchUserBookings(for: userId)
//                }
//                reminderManager.checkAuthorizationStatus()
//            }
//            .sheet(isPresented: $showingReminderSettings) {
//                ReminderSettingsView(reminderManager: reminderManager)
//            }
//        }
//    }
//    
//    private func formattedSelectedDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: selectedDate)
//    }
//    
//    private func createRemindersForAllBookings() async {
//        let upcomingBookings = bookingManager.currentBookings.filter { booking in
//            booking.scheduledDate > Date() && booking.status != .cancelled
//        }
//        
//        let successCount = await reminderManager.createRemindersForMultipleBookings(upcomingBookings)
//        
//        DispatchQueue.main.async {
//            // Could show success message here if needed
//        }
//    }
//}
//
//// MARK: - Enhanced Booking Card with EventKit Integration
//struct EnhancedBookingCardView: View {
//    let booking: ServiceBooking
//    let reminderManager: ReminderManager
//    var onCancel: () -> Void
//    
//    @State private var showingMap = false
//    @State private var hasReminder = false
//    @State private var isCheckingReminder = false
//    @State private var isCreatingReminder = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // Header with service name and status
//            HStack {
//                Text(booking.serviceName)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//                Spacer()
//                StatusBadge(status: booking.status)
//            }
//            
//            // Customer information
//            VStack(alignment: .leading, spacing: 6) {
//                HStack {
//                    Image(systemName: "person.circle")
//                        .foregroundColor(.blue)
//                        .font(.system(size: 16))
//                    Text(booking.customerName)
//                        .font(.subheadline)
//                        .fontWeight(.medium)
//                }
//                
//                HStack {
//                    Image(systemName: "calendar")
//                        .foregroundColor(.green)
//                        .font(.system(size: 14))
//                    Text("\(booking.formattedDate) • \(booking.formattedTime)")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//            }
//            
//            // Address section with map button
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Image(systemName: "location")
//                        .foregroundColor(.red)
//                        .font(.system(size: 14))
//                    Text("Address:")
//                        .font(.caption)
//                        .fontWeight(.medium)
//                        .foregroundColor(.secondary)
//                    Spacer()
//                }
//                
//                HStack {
//                    Text(booking.customerAddress)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .lineLimit(2)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        showingMap = true
//                    }) {
//                        HStack(spacing: 4) {
//                            Image(systemName: "map")
//                                .font(.system(size: 12))
//                            Text("View Map")
//                                .font(.caption)
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 6)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            
//            // Reminder section
//            HStack {
//                Image(systemName: hasReminder ? "bell.fill" : "bell")
//                    .foregroundColor(hasReminder ? .orange : .gray)
//                    .font(.system(size: 14))
//                
//                Text("Calendar Reminder")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                
//                Spacer()
//                
//                if isCheckingReminder || isCreatingReminder {
//                    ProgressView()
//                        .scaleEffect(0.8)
//                } else {
//                    Toggle("", isOn: $hasReminder)
//                        .labelsHidden()
//                        .scaleEffect(0.8)
//                        .onChange(of: hasReminder) { newValue in
//                            Task {
//                                await toggleReminder(enabled: newValue)
//                            }
//                        }
//                }
//            }
//            .padding(.vertical, 4)
//            .padding(.horizontal, 8)
//            .background(Color(.systemGray6))
//            .cornerRadius(8)
//            
//            // Action buttons
//            HStack {
//                Button("Cancel Booking") {
//                    onCancel()
//                }
//                .font(.caption)
//                .foregroundColor(.red)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(Color.red.opacity(0.1))
//                .cornerRadius(6)
//                
//                Spacer()
//                
//                Text(booking.formattedPrice)
//                    .font(.caption)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.green)
//            }
//            .padding(.top, 4)
//            
//            // Error message
//            if let errorMessage = reminderManager.errorMessage {
//                HStack {
//                    Image(systemName: "exclamationmark.triangle")
//                        .foregroundColor(.orange)
//                        .font(.system(size: 12))
//                    Text(errorMessage)
//                        .font(.caption)
//                        .foregroundColor(.orange)
//                }
//                .padding(8)
//                .background(Color.orange.opacity(0.1))
//                .cornerRadius(6)
//            }
//        }
//        .padding(16)
//        .background(Color(.systemBackground))
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color(.systemGray4), lineWidth: 1)
//        )
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//        .sheet(isPresented: $showingMap) {
//            BookingLocationMapView(
//                booking: booking
//            )
//        }
//        .onAppear {
//            checkExistingReminder()
//        }
//    }
//    
//    private func checkExistingReminder() {
//        isCheckingReminder = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let existingEvent = reminderManager.findBookingEvent(for: booking)
//            hasReminder = existingEvent != nil
//            isCheckingReminder = false
//        }
//    }
//    
//    private func toggleReminder(enabled: Bool) async {
//        isCreatingReminder = true
//        
//        let success: Bool
//        if enabled {
//            success = await reminderManager.createBookingReminder(for: booking)
//            if success {
//                // Also schedule local notification as backup
//                await reminderManager.scheduleLocalNotificationReminder(for: booking)
//            }
//        } else {
//            success = await reminderManager.removeBookingReminder(for: booking)
//        }
//        
//        DispatchQueue.main.async {
//            isCreatingReminder = false
//            if !success {
//                // Revert toggle if operation failed
//                hasReminder = !enabled
//            }
//        }
//    }
//}
//
//// MARK: - ReminderManager Class
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
//    // MARK: - Find Existing Event
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
//
//// MARK: - Reminder Summary View
//struct ReminderSummaryView: View {
//    let bookings: [ServiceBooking]
//    let reminderManager: ReminderManager
//    
//    private var remindersCount: Int {
//        bookings.count { booking in
//            reminderManager.findBookingEvent(for: booking) != nil
//        }
//    }
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "bell.circle.fill")
//                .foregroundColor(.orange)
//                .font(.title3)
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text("Reminders")
//                    .font(.headline)
//                Text("\(remindersCount) of \(bookings.count) bookings have reminders")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            if remindersCount < bookings.count {
//                Button("Add Missing") {
//                    Task {
//                        await createMissingReminders()
//                    }
//                }
//                .font(.caption)
//                .padding(.horizontal, 8)
//                .padding(.vertical, 4)
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(6)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .padding(.horizontal)
//    }
//    
//    private func createMissingReminders() async {
//        let bookingsWithoutReminders = bookings.filter { booking in
//            reminderManager.findBookingEvent(for: booking) == nil
//        }
//        
//        await reminderManager.createRemindersForMultipleBookings(bookingsWithoutReminders)
//    }
//}
//
//// MARK: - Reminder Settings View
//struct ReminderSettingsView: View {
//    let reminderManager: ReminderManager
//    @Environment(\.dismiss) private var dismiss
//    @State private var requestingPermission = false
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 24) {
//                VStack(spacing: 16) {
//                    Image(systemName: "bell.badge")
//                        .font(.system(size: 50))
//                        .foregroundColor(.orange)
//                    
//                    Text("Calendar Reminders")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                    
//                    Text("Get notified about your upcoming service appointments")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                        .multilineTextAlignment(.center)
//                }
//                
//                VStack(spacing: 12) {
//                    PermissionStatusRow(
//                        title: "Calendar Access",
//                        status: reminderManager.authorizationStatus,
//                        icon: "calendar"
//                    )
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(12)
//                
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Reminder Schedule")
//                        .font(.headline)
//                    
//                    HStack {
//                        Image(systemName: "clock")
//                            .foregroundColor(.blue)
//                        Text("1 day before appointment")
//                    }
//                    
//                    HStack {
//                        Image(systemName: "clock")
//                            .foregroundColor(.green)
//                        Text("2 hours before appointment")
//                    }
//                    
//                    HStack {
//                        Image(systemName: "clock")
//                            .foregroundColor(.orange)
//                        Text("30 minutes before appointment")
//                    }
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(12)
//                
//                if reminderManager.authorizationStatus != .authorized {
//                    Button(action: {
//                        requestPermission()
//                    }) {
//                        HStack {
//                            if requestingPermission {
//                                ProgressView()
//                                    .scaleEffect(0.8)
//                            } else {
//                                Image(systemName: "checkmark.circle")
//                            }
//                            Text("Grant Calendar Access")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                    }
//                    .disabled(requestingPermission)
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Reminder Settings")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//    
//    private func requestPermission() {
//        requestingPermission = true
//        
//        Task {
//            await reminderManager.requestCalendarAccess()
//            DispatchQueue.main.async {
//                requestingPermission = false
//            }
//        }
//    }
//}
//
//// MARK: - Permission Status Row
//struct PermissionStatusRow: View {
//    let title: String
//    let status: EKAuthorizationStatus
//    let icon: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(statusColor)
//                .font(.title3)
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                Text(statusText)
//                    .font(.caption)
//                    .foregroundColor(statusColor)
//            }
//            
//            Spacer()
//            
//            Image(systemName: statusIcon)
//                .foregroundColor(statusColor)
//        }
//    }
//    
//    private var statusText: String {
//        switch status {
//        case .authorized:
//            return "Authorized"
//        case .denied:
//            return "Denied"
//        case .notDetermined:
//            return "Not Requested"
//        case .restricted:
//            return "Restricted"
//        @unknown default:
//            return "Unknown"
//        }
//    }
//    
//    private var statusColor: Color {
//        switch status {
//        case .authorized:
//            return .green
//        case .denied, .restricted:
//            return .red
//        case .notDetermined:
//            return .orange
//        @unknown default:
//            return .gray
//        }
//    }
//    
//    private var statusIcon: String {
//        switch status {
//        case .authorized:
//            return "checkmark.circle.fill"
//        case .denied, .restricted:
//            return "xmark.circle.fill"
//        case .notDetermined:
//            return "questionmark.circle.fill"
//        @unknown default:
//            return "questionmark.circle"
//        }
//    }
//}
//
//// MARK: - Status Badge Component
//struct StatusBadge: View {
//    let status: BookingStatus
//    
//    var body: some View {
//        HStack(spacing: 4) {
//            Image(systemName: status.icon)
//                .font(.system(size: 10))
//            Text(status.displayName)
//                .font(.caption)
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//        .background(status.color.opacity(0.15))
//        .foregroundColor(status.color)
//        .cornerRadius(6)
//    }
//}
//
//// MARK: - Map View for Booking Location
//struct BookingLocationMapView: View {
//    let booking: ServiceBooking
//    @Environment(\.dismiss) private var dismiss
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), // Colombo default
//        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    )
//    @State private var coordinate: CLLocationCoordinate2D?
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Map view
//                Map(coordinateRegion: $region, annotationItems: coordinate.map { [MapLocation(coordinate: $0)] } ?? []) { location in
//                    MapAnnotation(coordinate: location.coordinate) {
//                        VStack(spacing: 4) {
//                            Image(systemName: "mappin.circle.fill")
//                                .font(.title)
//                                .foregroundColor(.red)
//                            
//                            VStack(spacing: 2) {
//                                Text(booking.customerName)
//                                    .font(.caption)
//                                    .fontWeight(.medium)
//                                Text(booking.serviceName)
//                                    .font(.caption2)
//                                    .foregroundColor(.secondary)
//                            }
//                            .padding(6)
//                            .background(.white)
//                            .cornerRadius(6)
//                            .shadow(radius: 2)
//                        }
//                    }
//                }
//                .ignoresSafeArea()
//                
//                // Loading indicator
//                if isLoading {
//                    VStack {
//                        ProgressView()
//                        Text("Locating address...")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding()
//                    .background(.regularMaterial)
//                    .cornerRadius(10)
//                }
//                
//                // Error message
//                if let errorMessage = errorMessage {
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Image(systemName: "exclamationmark.triangle")
//                            Text(errorMessage)
//                        }
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(.red)
//                        .cornerRadius(8)
//                        .padding()
//                    }
//                }
//                
//                // Service info overlay
//                if !isLoading && coordinate != nil {
//                    VStack {
//                        HStack {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text(booking.serviceName)
//                                    .font(.headline)
//                                    .fontWeight(.semibold)
//                                Text("Scheduled: \(booking.formattedDate) at \(booking.formattedTime)")
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                            }
//                            Spacer()
//                            StatusBadge(status: booking.status)
//                        }
//                        .padding()
//                        .background(.ultraThinMaterial)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                        
//                        Spacer()
//                    }
//                }
//            }
//            .navigationTitle("Service Location")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Close") {
//                        dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    if let coordinate = coordinate {
//                        Menu {
//                            Button("Get Directions") {
//                                openInAppleMaps(coordinate: coordinate)
//                            }
//                            
//                            Button("Call Customer") {
//                                callCustomer()
//                            }
//                            
//                            Button("Share Location") {
//                                shareLocation(coordinate: coordinate)
//                            }
//                        } label: {
//                            Image(systemName: "ellipsis.circle")
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                geocodeAddress()
//            }
//        }
//    }
//    
//    private func geocodeAddress() {
//        let geocoder = CLGeocoder()
//        
//        geocoder.geocodeAddressString(booking.customerAddress) { placemarks, error in
//            DispatchQueue.main.async {
//                isLoading = false
//                
//                if let error = error {
//                    errorMessage = "Could not locate address: \(error.localizedDescription)"
//                    return
//                }
//                
//                guard let placemark = placemarks?.first,
//                      let location = placemark.location else {
//                    errorMessage = "Address not found. Please verify the address with customer."
//                    return
//                }
//                
//                coordinate = location.coordinate
//                region = MKCoordinateRegion(
//                    center: location.coordinate,
//                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//                )
//            }
//        }
//    }
//    
//    private func openInAppleMaps(coordinate: CLLocationCoordinate2D) {
//        let placemark = MKPlacemark(coordinate: coordinate)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "\(booking.customerName) - \(booking.serviceName)"
//        mapItem.openInMaps(launchOptions: [
//            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//        ])
//    }
//    
//    private func callCustomer() {
//        let cleanPhone = booking.customerPhone.replacingOccurrences(of: " ", with: "")
//        if let url = URL(string: "tel://\(cleanPhone)") {
//            UIApplication.shared.open(url)
//        }
//    }
//    
//    private func shareLocation(coordinate: CLLocationCoordinate2D) {
//        let locationString = "Location for \(booking.serviceName): https://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)"
//        
//        let activityController = UIActivityViewController(
//            activityItems: [locationString],
//            applicationActivities: nil
//        )
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            window.rootViewController?.present(activityController, animated: true)
//        }
//    }
//}
//
//// MARK: - Map Location Model
//struct MapLocation: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}
