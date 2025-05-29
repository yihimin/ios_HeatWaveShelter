// ViewController.swift

import UIKit

// 1. 데이터 모델
struct CoolingCenter {
    var name: String = ""
    var type: String = ""
    var address: String = ""
    var useNumber: String = ""
    var x: String = ""
    var y: String = ""
}

// 2. XMLParserDelegate 구현 클래스
class CoolingCenterParser: NSObject, XMLParserDelegate {
    var centers: [CoolingCenter] = []
    var currentElement = ""
    var currentCenter: CoolingCenter?

    func parse(data: Data) -> [CoolingCenter] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return centers
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentCenter = CoolingCenter()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let center = currentCenter else { return }
        let value = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if value.isEmpty { return }

        switch currentElement {
        case "CC_NM": currentCenter?.name += value
        case "CC_TYPE": currentCenter?.type += value
        case "ADRES": currentCenter?.address += value
        case "USE_NUM": currentCenter?.useNumber += value
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item", let center = currentCenter {
            centers.append(center)
            currentCenter = nil
        }
    }
}

// 3. ViewController 구현
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var jobSites: [CoolingCenter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchShelters()
    }

    func fetchShelters() {
        let apiKey = "MDAVDC3T-MDAV-MDAV-MDAV-MDAVDC3TTS"
        let urlString = "https://safemap.go.kr/openApiService/data/getCoolingcentreData.do?serviceKey=\(apiKey)&pageNo=1&numOfRows=10"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let parser = CoolingCenterParser()
                let parsedCenters = parser.parse(data: data)
                DispatchQueue.main.async {
                    self.jobSites = parsedCenters
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobSites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterCell", for: indexPath)
        let shelter = jobSites[indexPath.row]
        cell.textLabel?.text = shelter.name
        cell.detailTextLabel?.text = shelter.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tabBar = tabBarController,
           let mapVC = tabBar.viewControllers?[1] as? MapViewController {
            mapVC.centers = jobSites
            tabBar.selectedIndex = 1
        }
    }

}
