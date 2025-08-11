import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    
        loadGratitudeEntries()
    }

    func loadGratitudeEntries() {
        let entries = UserDefaults.standard.stringArray(forKey: "gratitudeEntries") ?? []
        
        if entries.isEmpty {
            historyTextView.text = "No gratitude entries yet."
        } else {
            historyTextView.text = entries.reversed().joined(separator: "\n\n🌸 ")
            historyTextView.text = "🌸 " + historyTextView.text!
        }
    }
}

