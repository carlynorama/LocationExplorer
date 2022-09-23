//
//  WeatherView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var weatherViewModel:WeatherDisplayVM = services.makeWeatherDisplayVM()
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(services.graphicsDriver.backgroundColor)
            VStack {
                Text(weatherViewModel.locationService.locationToUse.description)
                Text(weatherViewModel.weatherInfo)
            }
        }.onAppear(perform: weatherViewModel.listen)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weatherViewModel: Services.forPreviews.makeWeatherDisplayVM())
    }
}
