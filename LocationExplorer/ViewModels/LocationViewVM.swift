//
//  LocationViewVM.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import Foundation
import LocationServices

@MainActor
class LocationViewModel:ObservableObject {
    var locationService:MyLocationService
    
    init(locationService: MyLocationService) {
        self.locationService = locationService
    }
    
    @Published var currentLocation = MockLocationService.locations[0]
    
    @Published var pastLocations:[LSLocation] = []
    
    @Published var counter:Double = 0
    
    
    private func connectToStream(_ stream:AsyncStream<LSLocation>) async {
        for await update in stream {
            pastLocations.append(currentLocation)
            currentLocation = update
            locationService.update(with: currentLocation)
            print("new location")
        }
    }
    
    private func disconnectStream() {
        //learn how to do???
        //fakeLocationService.killStreams?
    }
    
    func listen() async {
        await connectToStream(locationService.locationStream)
    }
}
