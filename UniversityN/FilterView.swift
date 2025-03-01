import SwiftUI

struct FilterView: View {
    @State private var selectedDateFilter = "Today"
    @State private var selectedLocation = "New York, USA"
    @State private var lowerPrice = 20.0
    @State private var upperPrice = 120.0

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Category icons with enhanced styling
                        categorySection

                        // Time & Date selection with segmented control
                        timeAndDateSection

                        // Location selection with improved styling
                        locationSection

                        // Price range selection with better slider visuals
                        priceRangeSection

                        // Reset and Apply buttons with better styling
                        actionButtons
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                }
                .navigationBarHidden(true)
                .navigationTitle("Filter")
                .navigationBarItems(trailing: Button(action: {}) {
                    Image(systemName: "xmark").foregroundColor(.gray)
                })
            }
        }
    }

    private var categorySection: some View {
        HStack(spacing: 20) {
            FilterIcon(label: "Sports", systemImage: "sportscourt")
            FilterIcon(label: "Music", systemImage: "music.note")
            FilterIcon(label: "Art", systemImage: "paintpalette")
            FilterIcon(label: "Food", systemImage: "fork.knife")
        }
        .padding(.top)
    }

    private var timeAndDateSection: some View {
        Group {
            Text("Time & Date")
                .bold()
            Picker("Date", selection: $selectedDateFilter) {
                Text("Today").tag("Today")
                Text("Tomorrow").tag("Tomorrow")
                Text("This week").tag("This week")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private var locationSection: some View {
        HStack {
            Image(systemName: "location")
                .foregroundColor(.blue)
            Text(selectedLocation)
                .foregroundColor(.gray)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }

    private var priceRangeSection: some View {
        VStack {
            Text("Select price range")
                .bold()
            Slider(value: $lowerPrice, in: 0...upperPrice, step: 1)
            Slider(value: $upperPrice, in: lowerPrice...200, step: 1)
            Text("$\(Int(lowerPrice)) - $\(Int(upperPrice))")
        }
        .padding()
    }

    private var actionButtons: some View {
        HStack {
            Button("RESET") {
                resetFilters()
            }
            .buttonStyle(FilterButtonStyle(backgroundColor: .gray))

            Button("APPLY") {
                // Apply filters
            }
            .buttonStyle(FilterButtonStyle(backgroundColor: .blue))
        }
    }

    func resetFilters() {
        selectedDateFilter = "Today"
        selectedLocation = "New York, USA"
        lowerPrice = 20.0
        upperPrice = 120.0
    }
}

struct FilterIcon: View {
    var label: String
    var systemImage: String

    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundColor(.blue)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 2)
            Text(label)
        }
    }
}

struct FilterButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .shadow(radius: 2)
    }
}

// Preview
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
