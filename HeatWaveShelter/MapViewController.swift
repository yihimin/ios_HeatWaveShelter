import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var centers: [CoolingCenter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        showCentersOnMap()
    }

    func showCentersOnMap() {
        for center in centers {
            guard let x = Double(center.x),
                  let y = Double(center.y) else { continue }

            // ⚠️ 임시 변환 (실제에선 TM to WGS 변환 필요)
            let coordinate = convertTMToWGS84(x: x, y: y)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = center.name
            annotation.subtitle = center.address
            mapView.addAnnotation(annotation)
        }

        if let first = mapView.annotations.first {
            mapView.setRegion(MKCoordinateRegion(center: first.coordinate,
                                                 latitudinalMeters: 5000,
                                                 longitudinalMeters: 5000),
                              animated: true)
        }
    }

    // ✨ TM → 위도경도 (임시 계산용, 실제 변환 함수 이후 대체 가능)
    func convertTMToWGS84(x: Double, y: Double) -> CLLocationCoordinate2D {
        // ➤ 테스트용: X, Y를 경도/위도로 대충 맞춰서 매핑
        // 실제 변환 필요 시 나중에 공식 로직 적용 예정
        return CLLocationCoordinate2D(latitude: y / 100000, longitude: x / 100000)
    }

}
