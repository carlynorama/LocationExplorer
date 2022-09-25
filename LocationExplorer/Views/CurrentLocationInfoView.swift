//
//  CurrentLocationInfoView.swift
//  LocationExplorer
//
//  Created by Labtanza on 9/24/22.
//

import SwiftUI
import LocationServices

struct CurrentLocationInfoView: View {
    var locationToDisplay:LSLocation
    
    var body: some View {
            Text("Location \"Truth\"").font(.title2)
                Text("Current Coordinates: \(locationToDisplay.latitude), \(locationToDisplay.longitude)")
                Text("Place Name: \(locationToDisplay.description)")
                //Text("Locality name: \(locationManager.locality ?? "...")")
    }
}

struct CurrentLocationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationInfoView(locationToDisplay: LocationStore.defaultLSLocation)
    }
}
