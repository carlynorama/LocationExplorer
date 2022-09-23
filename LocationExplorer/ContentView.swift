////
////  ContentView.swift
////  LocationExplorer
////
////  Created by Labtanza on 9/20/22.
////
//
//import SwiftUI
//import CoreLocationUI
//import CoreLocation.CLLocation
//import LocationServices
//
//struct ContentView: View {
//    @EnvironmentObject var locationManager:LocationService
//
//    //@State var currentlocation:CLLocationCoordinate2D?
//
//    var body: some View {
//        VStack {
//            Text("\(locationManager.locationToUse.description)")
//
//            LocationButton {
//                Task {
//                    await locationManager.requestDeviceLocation()
//                }
//            }
//            .frame(height: 44)
//            .foregroundColor(.white)
//            .clipShape(Capsule())
//            .padding()
//
//            Button("clear") {
//                locationManager.clearHistory()
//            }
//
//            List(Array(locationManager.recentLocations)) { item in
//                Text(item.description)
//            }
//
//            LocationPickerView()
//        }.environmentObject(locationManager)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(LocationService(locationStore: LocationStore(), deviceLocationManager: DeviceLocationManager()))
//    }
//}

//
//  ContentView.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//

import SwiftUI
import CoreLocation






struct ContentView: View {

    
    
    var body: some View {
        VStack {
            
            HStack {
                
                    VStack {
                        LocationPickerView()
                        LocationInfoDisplay()
                    }.environmentObject(services.locationService)
                
                VStack {
                    GraphicDisplayView(displayGenerator: services.graphicsDriver)
                    WeatherView()
                    
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
