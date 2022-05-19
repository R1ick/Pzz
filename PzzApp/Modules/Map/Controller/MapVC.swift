//
//  MapVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 04.04.2022.
//

import UIKit
import MapboxMaps

class MapVC: BaseViewController {
        
    private var mapView: MapView!
    
    let polygonID = "com.ya.polygonLayerID"
    let polygonSourceID = "com.ya.polygonLayerSourceID"
    let pointID = "com.ya.pointLayerID"
    let pointSourceID = "com.ya.pointLayerSourceID"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
        setupMap()
        mapView.mapboxMap.onNext(.styleLoaded) { [weak self] _ in
            self?.drawPolygons()
            self?.addPoints()
        }
    }
    
    private func setupScreen() {
        let resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoibWFybG90IiwiYSI6ImNrdXM5ZTVtYTA4NTEyb2x0azl6MGVpazUifQ.OsjqJA8KCdnWzrIGba8o7Q")
        let initOptions = MapInitOptions(resourceOptions: resourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: initOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.navigationController?.navigationItem.backButtonTitle = "Профиль"
//        self.navigationController?.navigationItem.backButtonDisplayMode = .minimal
        self.view.addSubview(mapView)
    }

    private func setupMap() {
        mapView.mapboxMap.onEvery(.cameraChanged) { [weak self] _ in
            guard let self = self else { return }
            let cameraPosition = self.mapView.cameraState.center
            if let currentLocation = self.mapView.location.latestLocation, cameraPosition.distance(to: currentLocation.coordinate) <= 1e-8 {
            }
        }
        mapView.gestures.options.pitchEnabled = false
        mapView.ornaments.options.attributionButton.position = .bottomLeft
        mapView.mapboxMap.loadStyleURI(.streets)
        mapView.location.options.puckType = .puck2D()
        mapView.location.locationProvider.requestWhenInUseAuthorization()
    }
    
    private func drawPolygons() {
        let minsk = CLLocationCoordinate2D(latitude: 53.90039383159455, longitude: 27.558345794677734)
        let options = CameraOptions(center: minsk, zoom: 9)
        mapView.camera.ease(to: options, duration: 0.5)
        var source = GeoJSONSource()
        guard let url = URL(string: "https://gist.githubusercontent.com/R1ick/962f0fcc9687bd3f9f9e1a51abb40f9b/raw/2d7cc31287f4b12c27b69cf956d32907b453920f/map.geojson")
        else { return }
        source.data = .url(url)
        var layer = FillLayer(id: polygonID)
        layer.source = polygonSourceID
        layer.fillColor = .expression(Exp(.get) { "fill" })
        layer.fillOpacity = .expression(Exp(.get) { "fill-opacity" })
        do {
            try mapView.mapboxMap.style.addSource(source, id: polygonSourceID)
            try mapView.mapboxMap.style.addLayer(layer)
        } catch let error {
            print("##error", error.localizedDescription)
        }
        addGesture(to: mapView)
    }
    
    private func addPoints() {
        guard let src = URL(string: "https://gist.githubusercontent.com/R1ick/d88a0f5fa0860bf270ab40e3ad3f75b2/raw/b5b02d1a985f5fd980947a2fac96274e84810407/map.geojson")
        else { return }
        var source = GeoJSONSource()
        source.data = .url(src)
        guard let image = UIImage(named: "point"),
              let image = resizeImage(image: image, targetSize: CGSize(width: 50, height: 50))
        else { return }
        try! mapView.mapboxMap.style.addImage(image, id: "point", stretchX: [], stretchY: [])
        var layer = SymbolLayer(id: pointID)
        layer.source = pointSourceID
        layer.iconImage = .constant(.name("point"))
        
        layer.iconRotationAlignment = .constant(.map)
        layer.iconAllowOverlap = .constant(true)
        layer.iconIgnorePlacement = .constant(true)
        
        do {
            try mapView.mapboxMap.style.addSource(source, id: self.pointSourceID)
            try mapView.mapboxMap.style.addLayer(layer)
        } catch let error {
            print(#file, #line, error.localizedDescription)
        }
    }
    
    private func addGesture(to mapView: MapView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(findPolygon))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func findPolygon(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: mapView)

        mapView.mapboxMap.queryRenderedFeatures(
            at: tapPoint,
            options: RenderedQueryOptions(layerIds: [polygonID, pointID], filter: nil)) { [weak self] result in
            switch result {
            case .success(let queriedfeatures):
                if let firstFeature = queriedfeatures.first?.feature.properties,
                   case let .string(price) = firstFeature["name"] {
                    self?.showAlert(title: price)
                }
            case .failure(let error):
                self?.showAlert(title: "An error occurred: \(error.localizedDescription)")
            }
        }
    }
}
