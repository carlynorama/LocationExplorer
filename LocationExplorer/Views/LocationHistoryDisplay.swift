//
//  LocationOnlyView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import SwiftUI
import CoreLocation
import LocationServices




struct LocationHistoryDisplay: View {
    var locationPusher:LocationAutoUpdater = services.makeLocationPusher()
    @EnvironmentObject var locationService:LocationService
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello \(locationService.locationToUse.description)").font(.title2).padding()
            List(Array(locationService.recentLocations), id:\.self) {
                Text($0.description)
            }
        }.onAppear() {
            Task {
                await locationPusher.listen()
            }
        }
    }
}

struct LocationOnlyView_Previews: PreviewProvider {
    static var previews: some View {
        LocationHistoryDisplay().environmentObject(Services.forPreviews.locationService)
    }
}
