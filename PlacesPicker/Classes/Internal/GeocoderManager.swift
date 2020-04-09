import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps

class GeocoderManager {
    typealias GeocoderManagerCallback = (_ adresses: [AddressResult], _ error: Error?) -> ()
    
    private let geocoder: GeocoderProtocol
    private let placesClient: GMSPlacesClient
    
    init(geocoder: GeocoderProtocol, placesClient: GMSPlacesClient = GMSPlacesClient.shared()) {
        self.geocoder = geocoder
        self.placesClient = placesClient
    }
    
    func fetchPlacesFor(coordinate: CLLocationCoordinate2D, bounds: GMSCoordinateBounds?, completion: @escaping GeocoderManagerCallback) {
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard let addresses = response?.results() else { return completion([], error) }
            completion(Array(addresses), nil)
        }
    }
    
    func fetchPlaceDetails(placeId: String, completion: @escaping GeocoderManagerCallback) {
        placesClient.lookUpPlaceID(placeId) { (place, error) in
            guard error == nil else { return completion([], error!) }
            completion( place == nil ? [] : [place!] , nil)
        }
    }
}
