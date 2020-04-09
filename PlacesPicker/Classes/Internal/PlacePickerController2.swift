//
//  PlacePickerController2.swift
//  PlacesPicker
//
//  Created by Jozef Matus on 26/03/2020.
//  Copyright © 2020 Piotr Bernad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

public class PlacePickerController2: UIViewController {
      // Public
      public unowned var delegate: PlacesPickerDelegate?
      
      public override func loadView() {
          self.view = PlacePickerView2(frame: CGRect.zero)
          pickerView.mapView.delegate = self
      }
      
      public override func viewDidLoad() {
          super.viewDidLoad()
          setupNavigationBar()
          setInitialCoordinateIfNeeded()
      }
      
      private func setInitialCoordinateIfNeeded() {
          if let initialCoordinate = self.config.initialCoordinate {
              let position = GMSCameraPosition(latitude: initialCoordinate.latitude, longitude: initialCoordinate.longitude, zoom: config.initialZoom)
              pickerView.mapView.animate(to: position)
          } else {
            
        }
      }
      
      // Internal
      
      private var placesDataSource: PlacesTableViewDataSource!
      private var config: PlacePickerConfig!
      
      private var pickerView: PlacePickerView2 {
          return view as! PlacePickerView2
      }
      
      private func setupNavigationBar() {
          let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showPlacesSearch))
          config.pickerRenderer.configureSearchButton(barButtonItem: searchButton)
          self.navigationItem.rightBarButtonItem = searchButton
          
          let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelection))
          config.pickerRenderer.configureCancelButton(barButtonItem: cancelButton)
          self.navigationItem.leftBarButtonItem = cancelButton
      }
      
      @objc
      private func cancelSelection() {
//          self.delegate?.placePickerControllerDidCancel(controller: self)
      }
      
      @objc
      private func showPlacesSearch() {
          let autocompleteController = GMSAutocompleteViewController()
          autocompleteController.delegate = placesDataSource
          autocompleteController.placeFields = config.placeFields
          autocompleteController.autocompleteFilter = config.placesFilter
          
          present(autocompleteController, animated: true, completion: nil)
      }
      
      fileprivate func selectPlaceAt(coordinate: CLLocationCoordinate2D) {
          focusOn(coordinate: coordinate)
          
          let bounds = pickerView.mapView.cameraTargetBounds ??
              GMSCoordinateBounds(coordinate: pickerView.mapView.projection.visibleRegion().nearLeft,
                                  coordinate: pickerView.mapView.projection.visibleRegion().farRight)
          
          placesDataSource.fetchPlacesFor(coordinate: coordinate, bounds:bounds)
      }
      
      private func focusOn(coordinate: CLLocationCoordinate2D) {
          let zoom = pickerView.mapView.camera.zoom >= 10 ? pickerView.mapView.camera.zoom : 10
          let position = GMSCameraPosition(target: coordinate, zoom: zoom)
          pickerView.mapView.animate(to: position)
      }
      
      internal func autoCompleteControllerDidProvide(place: GMSPlace) {
          focusOn(coordinate: place.coordinate)
      }
}

extension PlacePickerController2: GMSMapViewDelegate {

  public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    print("changed position to \(position)")
  }
  
}

public extension PlacePickerController2 {
    static func controler(config: PlacePickerConfig) -> PlacePickerController2 {
        let controller = PlacePickerController2()
        controller.config = config
        return controller
    }
}
