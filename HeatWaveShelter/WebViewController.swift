import UIKit
import WebKit

class WebViewController: UIViewController {
    var query: String = ""
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://map.kakao.com/?q=\(encodedQuery)"
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
