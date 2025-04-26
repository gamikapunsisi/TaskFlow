//
//  JobDetailView.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-22.
//

import SwiftUI
import MapKit
import UserNotifications


struct JobDetailView: View {
    
    @State private var showApplyAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Job Details")
                        .font(.title2).bold()
                    Spacer()
                    Image("client_photo") // Replace with your image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding()
//                .navigationTitle("Job Details")


                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Job Info
                        HStack {
                            Text("Posted 2 seconds ago")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Proposal: 5 to 10")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Text("Home Garden Service")
                            .font(.headline)
                            .foregroundColor(Color.purple)

                        Text("Fixed Price – Est Budget : Rs:15000")
                            .bold()
                            .font(.subheadline)

                        Text("""
I need assistance with general home garden maintenance including weeding, pruning, trimming hedges, watering plants, and applying fertilizer where needed. Ideally looking for someone with gardening experience who can bring their own tools.
""")
                            .font(.body)
                            .foregroundColor(.gray)

                        // Location + Map Track
                        HStack {
                            Label("Katunayaka, Seeduwa", systemImage: "mappin.and.ellipse")
                                .font(.subheadline)
                            Spacer()
                            NavigationLink(destination: JobMapView()) {
                                Text("Track Location")
                                    .foregroundColor(.purple)
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.purple, lineWidth: 1)
                                    )
                            }
                        }

                        // Client Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text("About the client")
                                .font(.title3).bold()
                            Text("Umindu Chethiya")
                                .bold()
                            Text("katunayaka, Seeduwa, Sri Lanka    \n2:22 AM")
                            Text("2 jobs posted")
                            Text("0% hire rate, 3 open jobs")
                            Text("Member since Mar 23, 2025")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

//                        Button("Apply Now") {
//                            showApplyAlert = true
//                        }
                        Button("Apply Now") {
                            showApplyAlert = true
                            NotificationManager.instance.sendLocalNotification(
                                title: "Job Application Submitted",
                                body: "You have successfully applied for this job."
                            )
                        }

                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .alert(isPresented: $showApplyAlert) {
                            Alert(
                                title: Text("Application Sent"),
                                message: Text("You have successfully applied for this job."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .padding()
                }

                // Bottom Nav
                HStack {
                    Image(systemName: "square.grid.2x2")
                    Spacer()
                    Image(systemName: "list.bullet")
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 60, height: 60)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "bell")
                    Spacer()
                    Image(systemName: "message")
                }
                .padding()
                .background(Color.white.shadow(radius: 2))
            }
//            .edgesIgnoringSafeArea(.bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            NotificationManager.instance.requestAuthorization()
        }

        }
    }


// MARK: - Map View for Job Location

struct JobMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.1695, longitude: 79.8882), // Katunayaka
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [JobLocation.example]) { location in
            MapMarker(coordinate: location.coordinate, tint: .purple)
        }
        .ignoresSafeArea()
        .navigationTitle("Job Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JobLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    static let example = JobLocation(
        name: "Katunayaka, Seeduwa",
        coordinate: CLLocationCoordinate2D(latitude: 7.1695, longitude: 79.8882)
    )
}

// MARK: - Preview

struct JobDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JobDetailView()
    }
}
