//
//  LocationExplorerApp.swift
//  LocationExplorer
//
//  Created by Labtanza on 9/20/22.
//

import SwiftUI
import LocationServices



@main
struct LocationExplorerApp: App {
    @StateObject private var locationManager = LocationProvider(locationStore: LocationStore(), deviceLocationManager: DeviceLocationManager())
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(locationManager)
        }
    }
}
