//
//  ContentView.swift
//  LocationExplorer
//
//  Created by Labtanza on 9/20/22.
//

import SwiftUI
import CoreLocationUI
import CoreLocation.CLLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State var currentlocation:CLLocationCoordinate2D?

    var body: some View {
        if let currentlocation {
            Text("\(currentlocation.latitude)")
        }
        
        LocationButton {
            Task {
                if let location = try? await locationManager.requestLocation() {
                    currentlocation = location
                    print("Location: \(location)")
                } else {
                    print("Location unknown.")
                }
            }
        }
        .frame(height: 44)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
