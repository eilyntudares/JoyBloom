import UIKit

class WriteViewController: UIViewController {


    @IBOutlet weak var gratitudeTextView: UITextView!
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let entry = gratitudeTextView.text ?? ""
        if entry.isEmpty { return }

        var entries = UserDefaults.standard.stringArray(forKey: "gratitudeEntries") ?? []
        entries.append(entry)

        UserDefaults.standard.set(entries, forKey: "gratitudeEntries")

        gratitudeTextView.text = ""

        let alert = UIAlertController(title: "Saved!", message: "Your gratitude was added 🌸", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

