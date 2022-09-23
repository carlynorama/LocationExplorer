//
//  ViewModelFactory.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//



import Foundation
import CoreLocation
import SwiftUI
import LocationServices



protocol WeatherService {
    func getWeather(for location:CLLocation) async throws -> String
}

protocol GraphicsDriver {
    //Used by the view to display
    var epicenter:CGPoint { get }
    func updateSize(to size:CGSize)
    var backgroundColor:Color { get }
    
    //Used by others to influence display
    func updateFactors(_ x:Double,_ y:Double)
}

protocol WeatherViewModelFactory {
    var weatherService: WeatherService { get }  //can't be let b/c protocol
    var locationService: LocationService { get }
    
    func makeWeatherDisplayVM() -> WeatherDisplayVM
}

protocol LocationPusherFactory {
    var locationService:LocationService { get }
    func makeLocationPusher() -> LocationAutoUpdater
}


struct Services {
    var weatherService: WeatherService
    var graphicsDriver: GraphicsDriver
    let locationService: LocationService
    
    
    init(weatherService: WeatherService, locationService: LocationService, graphicsDriver: GraphicsDriver) {
        self.weatherService = weatherService
        self.graphicsDriver = graphicsDriver
        self.locationService = locationService
    }
}

extension Services:WeatherViewModelFactory {
    

    func makeWeatherDisplayVM() -> WeatherDisplayVM {
        //WeatherDisplayVM(weatherService: weatherService, locationStream: locationBroadcaster.locationStream)
        WeatherDisplayVM(
            weatherService: weatherService,
            locationService: locationService,
            displayGenerator: graphicsDriver
        )
    }
    
}

extension Services:LocationPusherFactory {
    @MainActor func makeLocationPusher() -> LocationAutoUpdater {
        return LocationAutoUpdater(locationService: locationService)
    }
}

extension Services {
    static let forPreviews =
        Services(
            weatherService: GoogleWeatherService(),
            locationService: LocationService(),
            graphicsDriver: DisplayGenerator.shared
        )
    
}



