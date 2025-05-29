import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var centers: [CoolingCenter] = []
    var focusedCenter: CoolingCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        showCentersOnMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let center = focusedCenter,
           let x = Double(center.x),
           let y = Double(center.y) {

            convertTM128ToWGS84(x: x, y: y) { coordinate in
                DispatchQueue.main.async {
                    guard let coordinate = coordinate else {
                        print("❌ 변환 실패: \(x), \(y)")
                        return
                    }

                    let region = MKCoordinateRegion(center: coordinate,
                                                    latitudinalMeters: 1000,
                                                    longitudinalMeters: 1000)
                    self.mapView.setRegion(region, animated: true)

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = center.name
                    annotation.subtitle = center.address
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    func showCentersOnMap() {
        for center in centers {
            guard let x = Double(center.x),
                  let y = Double(center.y) else { continue }

            convertTM128ToWGS84(x: x, y: y) { coordinate in
                DispatchQueue.main.async {
                    guard let coordinate = coordinate else {
                        print("❌ 위치 변환 실패: \(x), \(y)")
                        return
                    }

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = center.name
                    annotation.subtitle = center.address
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    func convertTM128ToWGS84(x: Double, y: Double, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let urlString = "https://api.vworld.kr/req/transcoord"
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "service", value: "transcoord"),
            URLQueryItem(name: "request", value: "getcoord"),
            URLQueryItem(name: "crs", value: "EPSG:5181"),
            URLQueryItem(name: "x", value: "\(x)"),
            URLQueryItem(name: "y", value: "\(y)"),
            URLQueryItem(name: "output", value: "json"),
            URLQueryItem(name: "apikey", value: "C9EA1455-3E83-3111-AFE4-A51881B3F332")
        ]

        guard let url = components.url else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ 네트워크 오류:", error.localizedDescription)
                completion(nil)
                return
            }

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("📦 응답 JSON:", json)
                
                if let response = json["response"] as? [String: Any],
                   let result = response["result"] as? [String: Any],
                   let lat = result["y"] as? Double,
                   let lng = result["x"] as? Double {
                    completion(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                } else {
                    print("❌ 응답 파싱 실패")
                    completion(nil)
                }
            } else {
                print("❌ 데이터 또는 JSON 디코딩 실패")
                completion(nil)
            }
        }.resume()

    }
}
