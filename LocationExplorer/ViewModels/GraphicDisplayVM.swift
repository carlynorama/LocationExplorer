//
//  DisplayManager.swift
//  LocationExplorer
//
//  Created by Labtanza on 9/26/22.
//

import Foundation
import LocationServices


final class GraphicDisplayVM:ObservableObject {
    
    let weatherService: WeatherService
    let locationService: LocationService
    let displayGenerator: GraphicsDriver
    
    init(weatherService: WeatherService, locationService: LocationService, displayGenerator:GraphicsDriver) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.displayGenerator = displayGenerator
    }
    
    init() {
        self.weatherService = services.weatherService
        self.locationService = services.locationService
        self.displayGenerator = services.graphicsDriver
    }
    
    @Published var imageName = "circle.fill"
    
    
    
    
    func updateDisplayPoint(_ location:LSLocation) {
        let xFactor = (location.longitude + 180.0)/360.0
        let yFactor = ((location.latitude * -1) + 90.0)/180.0
        print("updating display")
        displayGenerator.updateFactors(xFactor, yFactor)
    }
    
    func imageForProfile(_ profile:WeatherProfile?) -> String {
        switch profile {
        case .sunny:
            return "sun.max.fill"
        case .cloudy:
            return "cloud.fill"
        case .hopefullyCold:
            return "thermometer.snowflake"
        case .offWorld:
            return "moonstars.fill"
        case .undefined:
            return "questionmark.circle.fill"
        case .none:
            return "circle.fill"
        }
        
    }
    
    
    //    The stream seems to update every loop, not just on change.
    //    func listen() async {
    //        await watchForLocations(locationService.locationStream())
    //    }
    //    var locationCache:LSLocation?
    //
    //    private func watchForLocations(_ stream:AsyncStream<LSLocation>) async {
    //        for await update in stream {
    //            print(update)
    //            if update != locationCache {
    //                locationCache = update
    //                updateDisplayPoint(update)
    //            }
    //        }
    //    }
    
    func watchForLocations() async {
        for await update in await locationService.$locationToUse.values {
            updateDisplayPoint(update)
            await asyncUpdateSymbol(update)
       }
    }
    
    func updateSymbol(_ loc:LSLocation) {
        Task {
            await asyncUpdateSymbol(loc)
        }
    }
    
    func asyncUpdateSymbol(_ loc:LSLocation) async {
        let profile = try? await weatherService.weatherProfile(for: loc.location)
        await MainActor.run { imageName = imageForProfile(profile) }
    }
}
