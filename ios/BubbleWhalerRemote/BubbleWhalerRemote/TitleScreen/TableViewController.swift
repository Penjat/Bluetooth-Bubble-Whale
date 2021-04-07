import UIKit
import SwiftUI

enum PresentaionExample: Int, CaseIterable {
	case uiKit
	case swiftUI

	var nameText: String {
		switch self {
		case .swiftUI:
			return "Swift UI"
		case .uiKit:
			return "UI Kit"
		}
	}
}

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Presentation-Example-Cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return PresentaionExample.allCases.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Presentation-Example-Cell", for: indexPath)
		cell.textLabel?.text = PresentaionExample(rawValue: indexPath.row)?.nameText
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch PresentaionExample(rawValue: indexPath.row) {
		case .uiKit:
			let viewModel = BubbleWhaleViewModel()
			navigationController?.pushViewController(BubbleWhaleViewController(viewModel: viewModel), animated: true)
			break
		case .swiftUI:
			let swiftUIView = RemoteSwiftUIView()
			navigationController?.pushViewController(UIHostingController(rootView: swiftUIView), animated: true)
			break
		case .none:
			break
		}
	}
}
