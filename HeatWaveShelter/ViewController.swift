import UIKit

// 1. 데이터 목록
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
        let value = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if value.isEmpty { return }

        switch currentElement {
        case "CC_NM": currentCenter?.name += value
        case "CC_TYPE": currentCenter?.type += value
        case "ADRES": currentCenter?.address += value
        case "USE_NUM": currentCenter?.useNumber += value
        case "X": currentCenter?.x += value
        case "Y": currentCenter?.y += value
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterCell", for: indexPath) as? ShelterTableViewCell else {
            return UITableViewCell()
        }

        let shelter = jobSites[indexPath.row]
        
        // 텍스트 설정
        cell.nameLabel.text = shelter.name
        cell.addressLabel.text = shelter.address
        cell.typeLabel.text = shelter.type
        cell.capacityLabel.text = "🧍‍♀️ 정원: \(shelter.useNumber)"

        // 스타일 적용
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.addressLabel.font = UIFont.systemFont(ofSize: 13)
        cell.addressLabel.textColor = .darkGray
        cell.typeLabel.font = UIFont.systemFont(ofSize: 13)
        cell.typeLabel.textColor = .gray
        cell.capacityLabel.font = UIFont.systemFont(ofSize: 13)
        cell.capacityLabel.textColor = .gray

        return cell
    }

    // 셀 클릭시 지도 탭으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = jobSites[indexPath.row]

        if let tabBar = tabBarController,
           let mapVC = tabBar.viewControllers?[2] as? MapViewController {
            mapVC.focusedAddress = selected.address
            tabBar.selectedIndex = 2
        }
    }

    // WebView 전환 버튼
    @IBAction func showInWebView(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let center = jobSites[indexPath.row]
            performSegue(withIdentifier: "toWebView", sender: center.name)
        }
    }

   
}
