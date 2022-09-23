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

// Multiprotocol conformnce gets wierd.

protocol LocationBroadcaster {
    var locationStream:AsyncStream<LSLocation> { get }
    var currentLocation:LSLocation { get }
}

protocol LocationUpdater:AnyObject {
    func update(with location:LSLocation)
}

protocol MyLocationService:LocationBroadcaster & LocationUpdater {
    
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
    var locationBroadcaster: LocationBroadcaster { get }
    
    func makeWeatherDisplayVM() -> WeatherDisplayVM
}

protocol LocationViewModelFactory {
    var fakeLocationService: MyLocationService { get }
    func makeLocationVM() -> LocationViewModel
}


struct Services {
    var weatherService: WeatherService
    var fakeLocationService: MyLocationService
    var graphicsDriver: GraphicsDriver
    let realLocaitonService: LocationService
    
    var locationBroadcaster: LocationBroadcaster {
        fakeLocationService
    }
    
    
    init(weatherService: WeatherService, flocationService: MyLocationService, graphicsDriver: GraphicsDriver) {
        self.weatherService = weatherService
        self.fakeLocationService = flocationService
        self.graphicsDriver = graphicsDriver
        self.realLocaitonService = LocationService(locationStore: LocationStore(), deviceLocationManager: DeviceLocationManager())
    }
}

extension Services:WeatherViewModelFactory {

    func makeWeatherDisplayVM() -> WeatherDisplayVM {
        //WeatherDisplayVM(weatherService: weatherService, locationStream: locationBroadcaster.locationStream)
        WeatherDisplayVM(
            weatherService: weatherService,
            locationService: locationBroadcaster,
            displayGenerator: graphicsDriver
        )
    }
    
}

extension Services:LocationViewModelFactory {
    @MainActor func makeLocationVM() -> LocationViewModel {
        return LocationViewModel(locationService: fakeLocationService)
    }
}

extension Services {
    static let forPreviews =
        Services(
            weatherService: GoogleWeatherService(),
            flocationService: MockLocationService(),
            graphicsDriver: DisplayGenerator.shared
        )
    
}



