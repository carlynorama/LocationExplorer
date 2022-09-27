//
//  ViewModel.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import Foundation
import LocationServices
import CoreLocation


class WeatherDisplayVM:ObservableObject {

    let weatherService: WeatherService
    let locationService: LocationService
    
    @Published var weatherInfo:String = ""
    
    var lastLocation:LSLocation? = nil
    var lastProfile:WeatherProfile? = nil
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
    
    deinit {
        print("Confirmed VM for \(weatherService.serviceID) deinit")
    }
    
    @MainActor
    func rephreshDescription() async throws {
        weatherInfo =  "It's \(descriptionForProfile(lastProfile)) in \(lastLocation?.description ?? "somewhere") says \(weatherService.serviceID)"
    }

    private func updateLocation() async {
        if await self.locationService.locationToUse != self.lastLocation {
            //print("Not the same")
            self.lastLocation = await self.locationService.locationToUse
            await updateProfile()
        }
    }
    
    private func updateLocation(_ loc:LSLocation) async {
        if loc != self.lastLocation {
            //print("Not the same")
            self.lastLocation = loc
            await updateProfile()
        }
    }
    
    func updateProfile() async {
        if let lastLocation {
            let profile = try? await self.weatherService.weatherProfile(for: lastLocation.location)
            lastProfile = profile ?? .undefined
        } else {
            lastProfile = .undefined
        }
        
    }
    
    
    func descriptionForProfile(_ profile:WeatherProfile?) -> String {
        switch profile {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .hopefullyCold:
            return "not cold enough"
        case .offWorld:
            return "other worldly"
        case .undefined:
            return "indescribable"
        case .none:
            return "unavailable"
        }

    }
    
//    private func beginStream(_ stream:AsyncStream<LSLocation>) async {
//        for await update in stream {
//            do {
//                await updateLocation(update)
//                try await rephreshDescription()
//            } catch {
//                weatherInfo = "No information at this time."
//                print("Weather serive error")
//            }
//        }
//    }
    
    func listen() async {
        for await update in await locationService.$locationToUse.values {
            do {
                await updateLocation(update)
                try await rephreshDescription()
            } catch {
                weatherInfo = "No information at this time."
                print("Weather serive error")
            }
        }
    }
    
//    func listen() {
//     //   Task { @MainActor in
//     //       await connectToStream(locationStream)
//     //   }
//        //TODO: Who kills this timer?
//        //https://www.hackingwithswift.com/books/ios-swiftui/triggering-events-repeatedly-using-a-timer
//        //TODO: What happens if the location changes faster than the weather service provides info?
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] _ in
//
//
//                Task { @MainActor in
//                    do {
//                        self.weatherInfo = "waiting..."
//                        await self.updateLocation()
//                        await updateProfile()
//                        try await rephreshDescription()
//                    } catch {
//                        self.weatherInfo = "No information at this time."
//                        print("Weather service error")
//                    }
//                }
//            }
//
//    }
    

    
}
