//
//  WeatherView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import SwiftUI

struct WeatherView: View {
    // @StateObject var weatherViewModel:WeatherDisplayVM = services.makeWeatherDisplayVM()
    @State var showMe:Bool = true
    
    
    var body: some View {
        VStack {
            Button("Show/Hide Weather Display") {
                showMe.toggle()
            
            }
            if showMe {
                Text("From Services:")
                
                WeatherDisplay()
                    .environmentObject(services.makeWeatherDisplayVM())
                
                Text("Other Weather Sources")
                WeatherDisplay().environmentObject(WeatherDisplayVM(weatherService: WeatherChannelService(), locationService: services.locationService))
                WeatherDisplay().environmentObject(WeatherDisplayVM(weatherService: MockWeatherService(), locationService: services.locationService))
            }
            }
            
            
    }
}

struct WeatherDisplay:View {
    @EnvironmentObject var weatherViewModel:WeatherDisplayVM
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(services.graphicsDriver.backgroundColor)
            VStack {
                Text(weatherViewModel.locationService.locationToUse.description)
                Text(weatherViewModel.weatherInfo)
            }
        }.task {
            await weatherViewModel.listen()
        }
    }
}

//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView(weatherViewModel: Services.forPreviews.makeWeatherDisplayVM())
//    }
//}
