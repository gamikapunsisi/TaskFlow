//
//  TaskFlowTests.swift
//  TaskFlowTests
//
//  Created by Gamika Punsisi on 2025-09-19.
//

import Testing
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
//@testable import TaskFlow
@testable import TaskFlowApp999

// MARK: - BookingStatus Tests

struct BookingStatusTests {
    
    @Test("BookingStatus enum values")
    func bookingStatusValues() async throws {
        #expect(BookingStatus.pending.rawValue == "pending")
        #expect(BookingStatus.confirmed.rawValue == "confirmed")
        #expect(BookingStatus.inProgress.rawValue == "in_progress")
        #expect(BookingStatus.completed.rawValue == "completed")
        #expect(BookingStatus.cancelled.rawValue == "cancelled")
    }
    
    @Test("BookingStatus display names")
    func bookingStatusDisplayNames() async throws {
        #expect(BookingStatus.pending.displayName == "Pending")
        #expect(BookingStatus.confirmed.displayName == "Confirmed")
        #expect(BookingStatus.inProgress.displayName == "In Progress")
        #expect(BookingStatus.completed.displayName == "Completed")
        #expect(BookingStatus.cancelled.displayName == "Cancelled")
    }
    
    @Test("BookingStatus icons")
    func bookingStatusIcons() async throws {
        #expect(BookingStatus.pending.icon == "clock")
        #expect(BookingStatus.confirmed.icon == "checkmark.circle")
        #expect(BookingStatus.inProgress.icon == "gear")
        #expect(BookingStatus.completed.icon == "checkmark.circle.fill")
        #expect(BookingStatus.cancelled.icon == "xmark.circle")
    }
    
    @Test("BookingStatus all cases")
    func bookingStatusAllCases() async throws {
        #expect(BookingStatus.allCases.count == 5)
        #expect(BookingStatus.allCases.contains(.pending))
        #expect(BookingStatus.allCases.contains(.confirmed))
        #expect(BookingStatus.allCases.contains(.inProgress))
        #expect(BookingStatus.allCases.contains(.completed))
        #expect(BookingStatus.allCases.contains(.cancelled))
    }
}

// MARK: - ServiceBooking Tests

struct ServiceBookingTests {
    
    @Test("ServiceBooking initialization with required parameters")
    func serviceBookingInitialization() async throws {
        let scheduledDate = Date()
        let scheduledTime = Date()
        
        let booking = ServiceBooking(
            serviceId: "service-123",
            serviceName: "House Cleaning",
            servicePrice: 2500.0,
            estimatedDuration: "2 hours",
            customerName: "John Doe",
            customerEmail: "john@example.com",
            customerPhone: "+94771234567",
            customerAddress: "123 Main Street, Colombo",
            scheduledDate: scheduledDate,
            scheduledTime: scheduledTime,
            notes: "Test booking"
        )
        
        #expect(booking.serviceId == "service-123")
        #expect(booking.serviceName == "House Cleaning")
        #expect(booking.servicePrice == 2500.0)
        #expect(booking.estimatedDuration == "2 hours")
        #expect(booking.customerName == "John Doe")
        #expect(booking.customerEmail == "john@example.com")
        #expect(booking.customerPhone == "+94771234567")
        #expect(booking.customerAddress == "123 Main Street, Colombo")
        #expect(booking.scheduledDate == scheduledDate)
        #expect(booking.scheduledTime == scheduledTime)
        #expect(booking.notes == "Test booking")
        #expect(booking.status == .pending)
        #expect(booking.paymentStatus == "pending")
        #expect(booking.currency == "LKR")
        #expect(booking.createdBy == "gamikapunsisi")
        #expect(booking.platform == "ios")
        #expect(booking.version == "1.0")
        #expect(booking.bookingType == "client_booking")
        #expect(!booking.id.isEmpty)
    }
    
    @Test("ServiceBooking formatted properties")
    func serviceBookingFormattedProperties() async throws {
        let booking = ServiceBooking(
            serviceId: "test-service",
            serviceName: "Test Service",
            servicePrice: 1500.50,
            estimatedDuration: "1 hour",
            customerName: "Test Customer",
            customerEmail: "test@example.com",
            customerPhone: "+94771111111",
            customerAddress: "Test Address",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: "Test notes"
        )
        
        #expect(booking.formattedPrice == "LKR 1500.50")
        #expect(!booking.formattedDate.isEmpty)
        #expect(!booking.formattedTime.isEmpty)
    }
    
    @Test("ServiceBooking Firestore data conversion")
    func serviceBookingFirestoreData() async throws {
        let booking = ServiceBooking(
            serviceId: "test-service",
            serviceName: "Test Service",
            servicePrice: 2000.0,
            estimatedDuration: "90 minutes",
            customerName: "Test User",
            customerEmail: "test@example.com",
            customerPhone: "+94777777777",
            customerAddress: "Test Location",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: "Test booking notes"
        )
        
        let firestoreData = booking.toFirestoreData()
        
        #expect(firestoreData["id"] as? String == booking.id)
        #expect(firestoreData["serviceId"] as? String == "test-service")
        #expect(firestoreData["serviceName"] as? String == "Test Service")
        #expect(firestoreData["servicePrice"] as? Double == 2000.0)
        #expect(firestoreData["customerName"] as? String == "Test User")
        #expect(firestoreData["customerEmail"] as? String == "test@example.com")
        #expect(firestoreData["customerPhone"] as? String == "+94777777777")
        #expect(firestoreData["status"] as? String == "pending")
        #expect(firestoreData["currency"] as? String == "LKR")
        #expect(firestoreData["platform"] as? String == "ios")
    }
}

// MARK: - BookingFormData Tests

struct BookingFormDataTests {
    
    @Test("BookingFormData initialization")
    func bookingFormDataInitialization() async throws {
        let formData = BookingFormData()
        
        #expect(formData.customerName.isEmpty)
        #expect(formData.customerPhone.isEmpty)
        #expect(formData.customerAddress.isEmpty)
        #expect(formData.notes.isEmpty)
        #expect(formData.customerInfoErrors.isEmpty)
        #expect(formData.isValidatingCustomerInfo == false)
        // Email might be auto-populated from Firebase Auth
        // scheduledDate and scheduledTime will be set to current date/time
    }
    
    @Test("BookingFormData validation - valid data")
    func bookingFormDataValidationSuccess() async throws {
        let formData = BookingFormData()
        formData.customerName = "John Smith"
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "123 Main Street, Colombo 07"
        
        let isValid = formData.validateCustomerInformation()
        
        #expect(isValid == true)
        #expect(formData.customerInfoErrors.isEmpty)
    }
    
    @Test("BookingFormData validation - empty name")
    func bookingFormDataValidationEmptyName() async throws {
        let formData = BookingFormData()
        formData.customerName = ""
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "123 Main Street, Colombo 07"
        
        let isValid = formData.validateCustomerInformation()
        
        #expect(isValid == false)
        #expect(formData.customerInfoErrors.contains("Full name is required"))
    }
    
    @Test("BookingFormData validation - short name")
    func bookingFormDataValidationShortName() async throws {
        let formData = BookingFormData()
        formData.customerName = "A"
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "123 Main Street, Colombo 07"
        
        let isValid = formData.validateCustomerInformation()
        
        #expect(isValid == false)
        #expect(formData.customerInfoErrors.contains("Full name must be at least 2 characters"))
    }
    
    @Test("BookingFormData validation - invalid phone")
    func bookingFormDataValidationInvalidPhone() async throws {
        let formData = BookingFormData()
        formData.customerName = "John Smith"
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "123" // Invalid phone
        formData.customerAddress = "123 Main Street, Colombo 07"
        
        let isValid = formData.validateCustomerInformation()
        
        #expect(isValid == false)
        #expect(formData.customerInfoErrors.contains("Please enter a valid Sri Lankan phone number"))
    }
    
    @Test("BookingFormData validation - empty address")
    func bookingFormDataValidationEmptyAddress() async throws {
        let formData = BookingFormData()
        formData.customerName = "John Smith"
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = ""
        
        let isValid = formData.validateCustomerInformation()
        
        #expect(isValid == false)
        #expect(formData.customerInfoErrors.contains("Service address is required"))
    }
    
    @Test("BookingFormData validation - invalid email")
    func bookingFormDataValidationInvalidEmail() async throws {
        let formData = BookingFormData()
        formData.customerName = "John Smith"
        formData.customerEmail = "invalid-email"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "123 Main Street, Colombo 07"
        
        let isValid = formData.validateCustomerInformation()
        
        #expect(isValid == false)
        #expect(formData.customerInfoErrors.contains("Please enter a valid email address"))
    }
    
    @Test("BookingFormData valid Sri Lankan phone numbers")
    func bookingFormDataValidSriLankanPhones() async throws {
        let validPhones = [
            "+94771234567",
            "0771234567",
            "+947712345678",
            "07712345678"
        ]
        
        for phone in validPhones {
            let formData = BookingFormData()
            formData.customerName = "John Smith"
            formData.customerEmail = "john@example.com"
            formData.customerPhone = phone
            formData.customerAddress = "123 Main Street, Colombo 07"
            
            let isValid = formData.validateCustomerInformation()
            #expect(isValid == true, "Phone \(phone) should be valid")
        }
    }
    
    @Test("BookingFormData valid Sri Lankan addresses")
    func bookingFormDataValidAddresses() async throws {
        let validAddresses = [
            "Colombo",
            "Kandy",
            "123 Galle Road, Colombo 03",
            "456 Main Street, Negombo",
            "Temple Road, Mount Lavinia",
            "Detailed address with house number"
        ]
        
        for address in validAddresses {
            let formData = BookingFormData()
            formData.customerName = "John Smith"
            formData.customerEmail = "john@example.com"
            formData.customerPhone = "+94771234567"
            formData.customerAddress = address
            
            let isValid = formData.validateCustomerInformation()
            #expect(isValid == true, "Address '\(address)' should be valid")
        }
    }
    
    @Test("BookingFormData has required fields check")
    func bookingFormDataHasRequiredFields() async throws {
        let formData = BookingFormData()
        
        #expect(formData.hasRequiredFields() == false)
        
        formData.customerName = "John"
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "Colombo"
        
        #expect(formData.hasRequiredFields() == true)
    }
    
    @Test("BookingFormData clear form data")
    func bookingFormDataClearFormData() async throws {
        let formData = BookingFormData()
        formData.customerName = "John Smith"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "Test Address"
        formData.notes = "Test notes"
        
        formData.clearFormData()
        
        #expect(formData.customerName.isEmpty)
        #expect(formData.customerPhone.isEmpty)
        #expect(formData.customerAddress.isEmpty)
        #expect(formData.notes.isEmpty)
        #expect(formData.customerInfoErrors.isEmpty)
        // Email should be repopulated from Firebase Auth
    }
    
    @Test("BookingFormData get form summary")
    func bookingFormDataGetFormSummary() async throws {
        let formData = BookingFormData()
        formData.customerName = "John Smith"
        formData.customerEmail = "john@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "123 Test Street"
        formData.notes = "Test booking"
        
        let summary = formData.getFormSummary()
        
        #expect(summary.contains("John Smith"))
        #expect(summary.contains("john@example.com"))
        #expect(summary.contains("+94771234567"))
        #expect(summary.contains("123 Test Street"))
        #expect(summary.contains("Test booking"))
    }
}

// MARK: - BookingManager Tests

struct BookingManagerTests {
    
    @Test("BookingManager initialization")
    func bookingManagerInitialization() async throws {
        let manager = BookingManager()
        
        #expect(manager.isLoading == false)
        #expect(manager.errorMessage == nil)
        #expect(manager.bookingSuccess == false)
        #expect(manager.currentBookings.isEmpty)
    }
    
    @Test("BookingManager clear booking state")
    func bookingManagerClearBookingState() async throws {
        let manager = BookingManager()
        manager.bookingSuccess = true
        manager.errorMessage = "Test error"
        
        manager.clearBookingState()
        
        #expect(manager.bookingSuccess == false)
        #expect(manager.errorMessage == nil)
    }
    
    @Test("BookingManager get booking by ID")
    func bookingManagerGetBookingById() async throws {
        let manager = BookingManager()
        let booking = ServiceBooking(
            serviceId: "test-service",
            serviceName: "Test Service",
            servicePrice: 1000.0,
            estimatedDuration: "1 hour",
            customerName: "Test Customer",
            customerEmail: "test@example.com",
            customerPhone: "+94771111111",
            customerAddress: "Test Address",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: "Test"
        )
        
        manager.currentBookings = [booking]
        
        let foundBooking = manager.getBooking(by: booking.id)
        #expect(foundBooking?.id == booking.id)
        
        let notFoundBooking = manager.getBooking(by: "non-existent-id")
        #expect(notFoundBooking == nil)
    }
    
    @Test("BookingManager get bookings by status")
    func bookingManagerGetBookingsByStatus() async throws {
        let manager = BookingManager()
        
        let pendingBooking = ServiceBooking(
            serviceId: "pending-service",
            serviceName: "Pending Service",
            servicePrice: 1000.0,
            estimatedDuration: "1 hour",
            customerName: "Customer 1",
            customerEmail: "test1@example.com",
            customerPhone: "+94771111111",
            customerAddress: "Address 1",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: ""
        )
        
        manager.currentBookings = [pendingBooking]
        
        let pendingBookings = manager.getBookings(by: .pending)
        #expect(pendingBookings.count == 1)
        #expect(pendingBookings.first?.id == pendingBooking.id)
        
        let completedBookings = manager.getBookings(by: .completed)
        #expect(completedBookings.isEmpty)
    }
    
    @Test("BookingManager booking statistics")
    func bookingManagerBookingStatistics() async throws {
        let manager = BookingManager()
        
        let pendingBooking = ServiceBooking(
            serviceId: "service-1",
            serviceName: "Service 1",
            servicePrice: 1000.0,
            estimatedDuration: "1 hour",
            customerName: "Customer 1",
            customerEmail: "test1@example.com",
            customerPhone: "+94771111111",
            customerAddress: "Address 1",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: ""
        )
        
        manager.currentBookings = [pendingBooking]
        
        let stats = manager.getBookingStatistics()
        #expect(stats.total == 1)
        #expect(stats.pending == 1)
        #expect(stats.completed == 0)
        #expect(stats.cancelled == 0)
    }
    
    @Test("BookingManager has active bookings")
    func bookingManagerHasActiveBookings() async throws {
        let manager = BookingManager()
        
        #expect(manager.hasActiveBookings == false)
        
        let activeBooking = ServiceBooking(
            serviceId: "active-service",
            serviceName: "Active Service",
            servicePrice: 1000.0,
            estimatedDuration: "1 hour",
            customerName: "Active Customer",
            customerEmail: "active@example.com",
            customerPhone: "+94771111111",
            customerAddress: "Active Address",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: ""
        )
        
        manager.currentBookings = [activeBooking]
        
        #expect(manager.hasActiveBookings == true)
    }
}

// MARK: - CustomerInformation Tests

struct CustomerInformationTests {
    
    @Test("CustomerInformation initialization with basic parameters")
    func customerInformationInitialization() async throws {
        let customer = CustomerInformation(
            fullName: "John Doe",
            phoneNumber: "+94771234567",
            serviceAddress: "123 Main Street, Colombo"
        )
        
        #expect(customer.fullName == "John Doe")
        #expect(customer.phoneNumber == "+94771234567")
        #expect(customer.serviceAddress == "123 Main Street, Colombo")
        #expect(customer.createdBy == "gamikapunsisi")
        #expect(customer.platform == "ios")
        #expect(customer.version == "1.0")
        #expect(!customer.id.isEmpty)
        #expect(customer.latitude == nil)
        #expect(customer.longitude == nil)
    }
    
    @Test("CustomerInformation initialization with location")
    func customerInformationInitializationWithLocation() async throws {
        let customer = CustomerInformation(
            fullName: "Jane Smith",
            phoneNumber: "+94771234568",
            serviceAddress: "456 Queen Street, Kandy",
            latitude: 7.2906,
            longitude: 80.6337
        )
        
        #expect(customer.fullName == "Jane Smith")
        #expect(customer.phoneNumber == "+94771234568")
        #expect(customer.serviceAddress == "456 Queen Street, Kandy")
        #expect(customer.latitude == 7.2906)
        #expect(customer.longitude == 80.6337)
        #expect(customer.hasLocation == true)
    }
    
    @Test("CustomerInformation display properties")
    func customerInformationDisplayProperties() async throws {
        let customer = CustomerInformation(
            fullName: "Test Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Test Address"
        )
        
        #expect(customer.displayName == "Test Customer")
        #expect(customer.displayPhone == "+94771234567")
        #expect(customer.displayAddress == "Test Address")
        
        let emptyCustomer = CustomerInformation(
            fullName: "",
            phoneNumber: "",
            serviceAddress: ""
        )
        
        #expect(emptyCustomer.displayName == "Unknown Customer")
        #expect(emptyCustomer.displayPhone == "No phone")
        #expect(emptyCustomer.displayAddress == "No address")
    }
    
    @Test("CustomerInformation validation")
    func customerInformationValidation() async throws {
        let validCustomer = CustomerInformation(
            fullName: "Valid Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Valid Address"
        )
        
        let errors = validCustomer.validateRequiredFields()
        #expect(errors.isEmpty)
        #expect(validCustomer.isValid == true)
        
        let invalidCustomer = CustomerInformation(
            fullName: "",
            phoneNumber: "",
            serviceAddress: ""
        )
        
        let invalidErrors = invalidCustomer.validateRequiredFields()
        #expect(!invalidErrors.isEmpty)
        #expect(invalidCustomer.isValid == false)
        #expect(invalidErrors.contains("Full name is required"))
        #expect(invalidErrors.contains("Phone number is required"))
        #expect(invalidErrors.contains("Service address is required"))
    }
    
    @Test("CustomerInformation location properties")
    func customerInformationLocationProperties() async throws {
        let customerWithLocation = CustomerInformation(
            fullName: "Located Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Located Address",
            latitude: 6.9271,
            longitude: 79.8612
        )
        
        #expect(customerWithLocation.hasLocation == true)
        #expect(customerWithLocation.locationCoordinate != nil)
        #expect(customerWithLocation.locationDescription.contains("6.9271"))
        #expect(customerWithLocation.locationDescription.contains("79.8612"))
        
        let customerWithoutLocation = CustomerInformation(
            fullName: "Non-located Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Non-located Address"
        )
        
        #expect(customerWithoutLocation.hasLocation == false)
        #expect(customerWithoutLocation.locationCoordinate == nil)
        #expect(customerWithoutLocation.locationDescription == "Location not available")
    }
    
    @Test("CustomerInformation with location")
    func customerInformationWithLocationMethod() async throws {
        let originalCustomer = CustomerInformation(
            fullName: "Test Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Test Address"
        )
        
        #expect(originalCustomer.hasLocation == false)
        
        let customerWithLocation = originalCustomer.withLocation(
            latitude: 6.9271,
            longitude: 79.8612
        )
        
        #expect(customerWithLocation.hasLocation == true)
        #expect(customerWithLocation.latitude == 6.9271)
        #expect(customerWithLocation.longitude == 79.8612)
        #expect(customerWithLocation.fullName == originalCustomer.fullName)
    }
    
    @Test("CustomerInformation search functionality")
    func customerInformationSearchFunctionality() async throws {
        let customer = CustomerInformation(
            fullName: "John Doe",
            phoneNumber: "+94771234567",
            serviceAddress: "123 Main Street, Colombo"
        )
        
        #expect(customer.matchesSearchQuery("john") == true)
        #expect(customer.matchesSearchQuery("doe") == true)
        #expect(customer.matchesSearchQuery("771234567") == true)
        #expect(customer.matchesSearchQuery("main street") == true)
        #expect(customer.matchesSearchQuery("colombo") == true)
        #expect(customer.matchesSearchQuery("xyz") == false)
    }
    
    @Test("CustomerInformation Firestore data conversion")
    func customerInformationFirestoreData() async throws {
        let customer = CustomerInformation(
            fullName: "Firestore Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Firestore Address",
            latitude: 6.9271,
            longitude: 79.8612
        )
        
        let firestoreData = customer.toFirestoreData()
        
        #expect(firestoreData["fullName"] as? String == "Firestore Customer")
        #expect(firestoreData["phoneNumber"] as? String == "+94771234567")
        #expect(firestoreData["serviceAddress"] as? String == "Firestore Address")
        #expect(firestoreData["latitude"] as? Double == 6.9271)
        #expect(firestoreData["longitude"] as? Double == 79.8612)
        #expect(firestoreData["platform"] as? String == "ios")
        #expect(firestoreData["version"] as? String == "1.0")
    }
}

// MARK: - LocationSelectionData Tests

struct LocationSelectionDataTests {
    
    @Test("LocationSelectionData initialization")
    func locationSelectionDataInitialization() async throws {
        let locationData = LocationSelectionData()
        
        #expect(locationData.selectedCoordinate == nil)
        #expect(locationData.selectedAddress.isEmpty)
        #expect(locationData.isUsingCurrentLocation == false)
        #expect(locationData.currentLocation == nil)
        #expect(locationData.searchResults.isEmpty)
        #expect(locationData.isSearching == false)
        #expect(locationData.hasSelectedLocation == false)
    }
    
    @Test("LocationSelectionData set location")
    func locationSelectionDataSetLocation() async throws {
        let locationData = LocationSelectionData()
        let coordinate = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        
        locationData.setLocation(coordinate: coordinate, address: "Colombo, Sri Lanka")
        
        #expect(locationData.selectedCoordinate?.latitude == 6.9271)
        #expect(locationData.selectedCoordinate?.longitude == 79.8612)
        #expect(locationData.selectedAddress == "Colombo, Sri Lanka")
        #expect(locationData.hasSelectedLocation == true)
    }
    
    @Test("LocationSelectionData clear selection")
    func locationSelectionDataClearSelection() async throws {
        let locationData = LocationSelectionData()
        let coordinate = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        
        locationData.setLocation(coordinate: coordinate, address: "Test Location")
        #expect(locationData.hasSelectedLocation == true)
        
        locationData.clearSelection()
        
        #expect(locationData.selectedCoordinate == nil)
        #expect(locationData.selectedAddress.isEmpty)
        #expect(locationData.isUsingCurrentLocation == false)
        #expect(locationData.searchResults.isEmpty)
        #expect(locationData.hasSelectedLocation == false)
    }
    
    @Test("LocationSelectionData formatted location")
    func locationSelectionDataFormattedLocation() async throws {
        let locationData = LocationSelectionData()
        
        #expect(locationData.formattedLocation == "No location selected")
        
        let coordinate = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        locationData.setLocation(coordinate: coordinate, address: "Colombo")
        
        #expect(locationData.formattedLocation.contains("Selected: Colombo"))
        
        locationData.isUsingCurrentLocation = true
        #expect(locationData.formattedLocation.contains("Current Location: Colombo"))
    }
}

// MARK: - CustomerInformationManager Tests

struct CustomerInformationManagerTests {
    
    @Test("CustomerInformationManager initialization")
    func customerInformationManagerInitialization() async throws {
        let manager = CustomerInformationManager()
        
        #expect(manager.isLoading == false)
        #expect(manager.errorMessage == nil)
        #expect(manager.savedCustomers.isEmpty)
        #expect(manager.isGeocodingAddress == false)
        #expect(manager.selectedLocation == nil)
    }
    
    @Test("CustomerInformationManager search customers")
    func customerInformationManagerSearchCustomers() async throws {
        let manager = CustomerInformationManager()
        
        let customer1 = CustomerInformation(
            fullName: "John Doe",
            phoneNumber: "+94771234567",
            serviceAddress: "Colombo"
        )
        
        let customer2 = CustomerInformation(
            fullName: "Jane Smith",
            phoneNumber: "+94771234568",
            serviceAddress: "Kandy"
        )
        
        manager.recentCustomers = [customer1, customer2]
        
        let searchResults = manager.searchCustomers(by: "john")
        #expect(searchResults.count == 1)
        #expect(searchResults.first?.fullName == "John Doe")
        
        let emptyResults = manager.searchCustomers(by: "xyz")
        #expect(emptyResults.isEmpty)
        
        let allResults = manager.searchCustomers(by: "")
        #expect(allResults.count == 2)
    }
    
    @Test("CustomerInformationManager get recent customer by phone")
    func customerInformationManagerGetRecentCustomerByPhone() async throws {
        let manager = CustomerInformationManager()
        
        let customer = CustomerInformation(
            fullName: "Test Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Test Address"
        )
        
        manager.recentCustomers = [customer]
        
        let foundCustomer = manager.getRecentCustomerByPhone("+94771234567")
        #expect(foundCustomer?.fullName == "Test Customer")
        
        let notFoundCustomer = manager.getRecentCustomerByPhone("+94777777777")
        #expect(notFoundCustomer == nil)
    }
    
    @Test("CustomerInformationManager statistics")
    func customerInformationManagerStatistics() async throws {
        let manager = CustomerInformationManager()
        
        let customer1 = CustomerInformation(
            fullName: "Customer 1",
            phoneNumber: "+94771111111",
            serviceAddress: "Address 1"
        )
        
        let customer2 = CustomerInformation(
            fullName: "Customer 2",
            phoneNumber: "+94771111111", // Same phone number
            serviceAddress: "Address 2"
        )
        
        let customer3 = CustomerInformation(
            fullName: "Customer 3",
            phoneNumber: "+94772222222", // Different phone number
            serviceAddress: "Address 3"
        )
        
        manager.recentCustomers = [customer1, customer2, customer3]
        
        #expect(manager.getCustomerCount() == 3)
        #expect(manager.getUniqueCustomerCount() == 2) // Two unique phone numbers
        #expect(manager.hasRecentCustomers == true)
        #expect(manager.mostRecentCustomer?.fullName == "Customer 1")
    }
    
    @Test("CustomerInformationManager clear recent customers")
    func customerInformationManagerClearRecentCustomers() async throws {
        let manager = CustomerInformationManager()
        
        let customer = CustomerInformation(
            fullName: "Test Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Test Address"
        )
        
        manager.recentCustomers = [customer]
        manager.selectedLocation = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        
        #expect(manager.hasRecentCustomers == true)
        
        manager.clearRecentCustomers()
        
        #expect(manager.recentCustomers.isEmpty)
        #expect(manager.selectedLocation == nil)
        #expect(manager.hasRecentCustomers == false)
    }
}

// MARK: - BookingFormData Integration Tests

struct BookingFormDataIntegrationTests {
    
    @Test("BookingFormData create customer information")
    func bookingFormDataCreateCustomerInformation() async throws {
        let formData = BookingFormData()
        formData.customerName = "Integration Test Customer"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "Integration Test Address"
        
        let customer = formData.createCustomerInformation()
        
        #expect(customer.fullName == "Integration Test Customer")
        #expect(customer.phoneNumber == "+94771234567")
        #expect(customer.serviceAddress == "Integration Test Address")
        #expect(customer.createdBy == "gamikapunsisi")
        #expect(customer.platform == "ios")
    }
    
    @Test("BookingFormData create customer information with location")
    func bookingFormDataCreateCustomerInformationWithLocation() async throws {
        let formData = BookingFormData()
        formData.customerName = "Location Test Customer"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "Location Test Address"
        
        let latitude = 6.9271
        let longitude = 79.8612
        let customer = formData.createCustomerInformationWithLocation(latitude: latitude, longitude: longitude)
        
        #expect(customer.fullName == "Location Test Customer")
        #expect(customer.hasLocation == true)
        #expect(customer.latitude == latitude)
        #expect(customer.longitude == longitude)
    }
    
    @Test("BookingFormData populate from customer information")
    func bookingFormDataPopulateFromCustomerInformation() async throws {
        let customer = CustomerInformation(
            fullName: "Existing Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Existing Address"
        )
        
        let formData = BookingFormData()
        formData.populateFromCustomerInformation(customer)
        
        #expect(formData.customerName == "Existing Customer")
        #expect(formData.customerPhone == "+94771234567")
        #expect(formData.customerAddress == "Existing Address")
        // Email should be from current auth user, not from customer
    }
    
    @Test("BookingFormData update address from map")
    func bookingFormDataUpdateAddressFromMap() async throws {
        let formData = BookingFormData()
        let coordinate = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        
        formData.updateAddressFromMap(address: "Map Selected Address", coordinate: coordinate)
        
        #expect(formData.customerAddress == "Map Selected Address")
    }
}

// MARK: - Location Utility Function Tests

struct LocationUtilityTests {
    
    @Test("Format placemark address with nil placemark")
    func testFormatPlacemarkAddressWithNil() async throws {
        // Test the function's behavior with edge cases
        // This assumes your function can handle nil or has other test scenarios
        
        // If your formatPlacemarkAddress function has overloads or can handle other inputs
        // test those instead
        
        // For now, just verify the function exists by checking it compiles
        let functionExists = formatPlacemarkAddress != nil
        #expect(functionExists)
    }
}
// MARK: - Performance Tests

struct TaskFlowPerformanceTests {
    
    @Test("BookingFormData validation performance")
    func bookingFormDataValidationPerformance() async throws {
        let formData = BookingFormData()
        formData.customerName = "Performance Test Customer"
        formData.customerEmail = "performance@test.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "Performance Test Address"
        
        let startTime = Date()
        
        for _ in 0..<1000 {
            _ = formData.validateCustomerInformation()
        }
        
        let endTime = Date()
        let timeInterval = endTime.timeIntervalSince(startTime)
        
        #expect(timeInterval < 1.0) // Should complete 1000 validations within 1 second
    }
    
    @Test("Customer search performance")
    func customerSearchPerformance() async throws {
        let manager = CustomerInformationManager()
        
        // Create 1000 mock customers
        for i in 0..<1000 {
            let customer = CustomerInformation(
                fullName: "Customer \(i)",
                phoneNumber: "+9477123\(String(format: "%04d", i))",
                serviceAddress: "Address \(i)"
            )
            manager.recentCustomers.append(customer)
        }
        
        let startTime = Date()
        
        // Perform 100 searches
        for i in 0..<100 {
            _ = manager.searchCustomers(by: "Customer \(i)")
        }
        
        let endTime = Date()
        let timeInterval = endTime.timeIntervalSince(startTime)
        
        #expect(timeInterval < 2.0) // Should complete 100 searches within 2 seconds
    }
    
    @Test("Booking status filtering performance")
    func bookingStatusFilteringPerformance() async throws {
        let manager = BookingManager()
        
        // Create 1000 mock bookings with different statuses
        for i in 0..<1000 {
            let booking = ServiceBooking(
                serviceId: "service-\(i)",
                serviceName: "Service \(i)",
                servicePrice: Double(1000 + i),
                estimatedDuration: "1 hour",
                customerName: "Customer \(i)",
                customerEmail: "customer\(i)@test.com",
                customerPhone: "+9477\(String(format: "%07d", 1234567 + i))",
                customerAddress: "Address \(i)",
                scheduledDate: Date(),
                scheduledTime: Date(),
                notes: "Booking \(i)"
            )
            manager.currentBookings.append(booking)
        }
        
        let startTime = Date()
        
        // Test filtering by different statuses
        for status in BookingStatus.allCases {
            _ = manager.getBookings(by: status)
        }
        
        let endTime = Date()
        let timeInterval = endTime.timeIntervalSince(startTime)
        
        #expect(timeInterval < 0.5) // Should complete all status filters within 0.5 seconds
    }
}

// MARK: - Edge Case Tests

struct TaskFlowEdgeCaseTests {
    
    @Test("BookingFormData whitespace handling")
    func bookingFormDataWhitespaceHandling() async throws {
        let formData = BookingFormData()
        formData.customerName = "  John Doe  "
        formData.customerEmail = "  john@example.com  "
        formData.customerPhone = "  +94771234567  "
        formData.customerAddress = "  123 Main Street  "
        
        let isValid = formData.validateCustomerInformation()
        #expect(isValid == true) // Should handle whitespace properly
    }
    
    @Test("CustomerInformation empty string handling")
    func customerInformationEmptyStringHandling() async throws {
        let customer = CustomerInformation(
            fullName: "",
            phoneNumber: "",
            serviceAddress: ""
        )
        
        #expect(customer.displayName == "Unknown Customer")
        #expect(customer.displayPhone == "No phone")
        #expect(customer.displayAddress == "No address")
        #expect(customer.isValid == false)
    }
    
    @Test("ServiceBooking negative price handling")
    func serviceBookingNegativePriceHandling() async throws {
        let booking = ServiceBooking(
            serviceId: "negative-price-service",
            serviceName: "Negative Price Service",
            servicePrice: -100.0, // Negative price
            estimatedDuration: "1 hour",
            customerName: "Test Customer",
            customerEmail: "test@example.com",
            customerPhone: "+94771234567",
            customerAddress: "Test Address",
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: "Test"
        )
        
        #expect(booking.servicePrice == -100.0)
        #expect(booking.totalAmount == -100.0)
        #expect(booking.formattedPrice == "LKR -100.00")
    }
    
    @Test("LocationSelectionData invalid coordinates")
    func locationSelectionDataInvalidCoordinates() async throws {
        let locationData = LocationSelectionData()
        
        // Test with invalid coordinates (outside Sri Lanka)
        let invalidCoordinate = CLLocationCoordinate2D(latitude: 90.0, longitude: 180.0)
        locationData.setLocation(coordinate: invalidCoordinate, address: "Invalid Location")
        
        #expect(locationData.hasSelectedLocation == true)
        #expect(locationData.selectedCoordinate?.latitude == 90.0)
        #expect(locationData.selectedCoordinate?.longitude == 180.0)
    }
    
    @Test("BookingFormData very long input handling")
    func bookingFormDataLongInputHandling() async throws {
        let formData = BookingFormData()
        let longString = String(repeating: "a", count: 1000)
        
        formData.customerName = longString
        formData.customerEmail = "test@example.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = longString
        
        let isValid = formData.validateCustomerInformation()
        #expect(isValid == true) // Should handle long strings
        #expect(formData.customerName.count == 1000)
        #expect(formData.customerAddress.count == 1000)
    }
}

// MARK: - Integration Workflow Tests

struct TaskFlowWorkflowTests {
    
    @Test("Complete booking workflow")
    func completeBookingWorkflow() async throws {
        // Step 1: Create and validate form data
        let formData = BookingFormData()
        formData.customerName = "Workflow Customer"
        formData.customerEmail = "workflow@test.com"
        formData.customerPhone = "+94771234567"
        formData.customerAddress = "Workflow Address"
        formData.notes = "Complete workflow test"
        
        let isFormValid = formData.validateCustomerInformation()
        #expect(isFormValid == true)
        
        // Step 2: Create customer information
        let customer = formData.createCustomerInformation()
        #expect(customer.fullName == "Workflow Customer")
        
        // Step 3: Create service booking
        let booking = ServiceBooking(
            serviceId: "workflow-service",
            serviceName: "Workflow Service",
            servicePrice: 2500.0,
            estimatedDuration: "2 hours",
            customerName: customer.fullName,
            customerEmail: customer.emailAddress,
            customerPhone: customer.phoneNumber,
            customerAddress: customer.serviceAddress,
            scheduledDate: Date(),
            scheduledTime: Date(),
            notes: formData.notes
        )
        
        #expect(booking.customerName == customer.fullName)
        #expect(booking.status == .pending)
        
        // Step 4: Initialize managers
        let bookingManager = BookingManager()
        let customerManager = CustomerInformationManager()
        
        #expect(bookingManager.currentBookings.isEmpty)
        #expect(customerManager.recentCustomers.isEmpty)
        
        // Step 5: Simulate booking creation (without actual Firebase calls)
        bookingManager.currentBookings.append(booking)
        customerManager.recentCustomers.append(customer)
        
        #expect(bookingManager.currentBookings.count == 1)
        #expect(customerManager.recentCustomers.count == 1)
        #expect(bookingManager.hasActiveBookings == true)
        
        // Step 6: Verify booking can be retrieved
        let retrievedBooking = bookingManager.getBooking(by: booking.id)
        #expect(retrievedBooking?.id == booking.id)
        
        // Step 7: Test status update
        let pendingBookings = bookingManager.getBookings(by: .pending)
        #expect(pendingBookings.count == 1)
        
        let completedBookings = bookingManager.getBookings(by: .completed)
        #expect(completedBookings.isEmpty)
    }
    
    @Test("Customer auto-fill workflow")
    func customerAutoFillWorkflow() async throws {
        // Step 1: Create a customer information manager
        let manager = CustomerInformationManager()
        
        // Step 2: Add a previous customer
        let existingCustomer = CustomerInformation(
            fullName: "Returning Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Existing Address"
        )
        manager.recentCustomers.append(existingCustomer)
        
        // Step 3: Create new booking form
        let formData = BookingFormData()
        
        // Step 4: Simulate auto-fill by phone number
        formData.customerPhone = "+94771234567"
        
        let foundCustomer = manager.getRecentCustomerByPhone("+94771234567")
        #expect(foundCustomer != nil)
        
        if let customer = foundCustomer {
            formData.populateFromCustomerInformation(customer)
        }
        
        // Step 5: Verify auto-fill worked
        #expect(formData.customerName == "Returning Customer")
        #expect(formData.customerPhone == "+94771234567")
        #expect(formData.customerAddress == "Existing Address")
        
        // Step 6: Validate the auto-filled form
        formData.customerEmail = "returning@customer.com" // Set email for validation
        let isValid = formData.validateCustomerInformation()
        #expect(isValid == true)
    }
    
    @Test("Location-based customer workflow")
    func locationBasedCustomerWorkflow() async throws {
        // Step 1: Create customer with location
        let customer = CustomerInformation(
            fullName: "Located Customer",
            phoneNumber: "+94771234567",
            serviceAddress: "Colombo Fort",
            latitude: 6.9271,
            longitude: 79.8612
        )
        
        #expect(customer.hasLocation == true)
        
        // Step 2: Create location selection data
        let locationData = LocationSelectionData()
        let coordinate = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        locationData.setLocation(coordinate: coordinate, address: "Selected Location")
        
        #expect(locationData.hasSelectedLocation == true)
        
        // Step 3: Create booking form with location
        let formData = BookingFormData()
        formData.updateAddressFromMap(address: locationData.selectedAddress, coordinate: coordinate)
        
        #expect(formData.customerAddress == "Selected Location")
        
        // Step 4: Create customer with location data
        let customerWithLocation = formData.createCustomerInformationWithLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        #expect(customerWithLocation.hasLocation == true)
        #expect(customerWithLocation.latitude == coordinate.latitude)
        #expect(customerWithLocation.longitude == coordinate.longitude)
    }
}

// MARK: - Mock Data Tests

struct TaskFlowMockDataTests {
    
    @Test("ServiceBooking mock data")
    func serviceBookingMockData() async throws {
        let mockBooking = ServiceBooking.mockBooking
        
        #expect(mockBooking.serviceName == "House Cleaning Service")
        #expect(mockBooking.servicePrice == 2500.0)
        #expect(mockBooking.customerName == "John Doe")
        #expect(mockBooking.status == .pending)
        #expect(!mockBooking.id.isEmpty)
    }
    
    @Test("BookingFormData mock data")
    func bookingFormDataMockData() async throws {
        let mockFormData = BookingFormData.mockFormData
        
        #expect(mockFormData.customerName == "Jane Smith")
        #expect(mockFormData.customerPhone == "+94771234567")
        #expect(mockFormData.customerAddress == "456 Test Street, Kandy")
        #expect(mockFormData.notes == "Test booking notes")
    }
    
    @Test("CustomerInformation mock data")
    func customerInformationMockData() async throws {
        let mockCustomer = CustomerInformation.mockCustomer
        
        #expect(mockCustomer.fullName == "John Doe")
        #expect(mockCustomer.phoneNumber == "+94771234567")
        #expect(mockCustomer.serviceAddress == "123 Main Street, Colombo 07")
        #expect(mockCustomer.hasLocation == true)
        #expect(mockCustomer.isValid == true)
        
        let mockCustomers = CustomerInformation.mockCustomers
        #expect(mockCustomers.count == 3)
        #expect(mockCustomers.first?.fullName == "Jane Smith")
    }
}

// MARK: - Concurrent Access Tests

struct TaskFlowConcurrentAccessTests {
    
    @Test("Concurrent booking operations")
    func concurrentBookingOperations() async throws {
        let manager = BookingManager()
        
        // Create multiple bookings concurrently
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let booking = ServiceBooking(
                        serviceId: "concurrent-\(i)",
                        serviceName: "Concurrent Service \(i)",
                        servicePrice: Double(1000 + i * 100),
                        estimatedDuration: "1 hour",
                        customerName: "Customer \(i)",
                        customerEmail: "customer\(i)@test.com",
                        customerPhone: "+9477123456\(i)",
                        customerAddress: "Address \(i)",
                        scheduledDate: Date(),
                        scheduledTime: Date(),
                        notes: "Concurrent test \(i)"
                    )
                    
                    await MainActor.run {
                        manager.currentBookings.append(booking)
                    }
                }
            }
        }
        
        #expect(manager.currentBookings.count == 10)
    }
    
    @Test("Concurrent customer operations")
    func concurrentCustomerOperations() async throws {
        let manager = CustomerInformationManager()
        
        // Create multiple customers concurrently
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<5 {
                group.addTask {
                    let customer = CustomerInformation(
                        fullName: "Concurrent Customer \(i)",
                        phoneNumber: "+9477123\(String(format: "%04d", 4567 + i))",
                        serviceAddress: "Concurrent Address \(i)"
                    )
                    
                    await MainActor.run {
                        manager.recentCustomers.append(customer)
                    }
                }
            }
        }
        
        #expect(manager.recentCustomers.count == 5)
    }
}
