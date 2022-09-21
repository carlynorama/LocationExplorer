//
//
//import CoreLocation
//import CoreLocationUI
////https://www.hackingwithswift.com/quick-start/concurrency/how-to-store-continuations-to-be-resumed-later
//
//@MainActor
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?
//    let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocation() async throws -> CLLocationCoordinate2D? {
//        try await withCheckedThrowingContinuation { continuation in
//            locationContinuation = continuation
//            manager.requestLocation()
//        }
//    }
//
//
//    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        Task { @MainActor in
//            locationContinuation?.resume(returning: locations.first?.coordinate)
//        }
//    }
//
//    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        Task { @MainActor in
//            locationContinuation?.resume(throwing: error)
//        }
//    }
//}
//
//
