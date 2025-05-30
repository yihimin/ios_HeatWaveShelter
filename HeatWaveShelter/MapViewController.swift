import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var focusedAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let address = focusedAddress {
            showPin(for: address)
            focusedAddress = nil  // 중복 검색 방지
        }
    }

    func showPin(for address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {

                let coordinate = location.coordinate

                // 기존 핀 제거
                self.mapView.removeAnnotations(self.mapView.annotations)

                // 카메라 이동
                let region = MKCoordinateRegion(center: coordinate,
                                                latitudinalMeters: 1000,
                                                longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)

                // 핀 추가
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = address
                self.mapView.addAnnotation(annotation)

            } else {
                print("❌ 주소 변환 실패: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

    // (선택) 핀 클릭 시 말풍선 보이게 하기
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CoolingCenterPin"

        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}
