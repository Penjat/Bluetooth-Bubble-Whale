import UIKit
import CoreBluetooth

class BubbleWhaleRemoteViewController: UIViewController {
	var centralManager: CBCentralManager!
	var bubbleWhalePeripheral: CBPeripheral!
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		return stack
	}()
	let bubbleWhaleStatusLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpViews();
		centralManager = CBCentralManager(delegate: self, queue: nil)
	}

	public func setUpViews() {
		view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(bubbleWhaleStatusLabel)
	}
}

extension BubbleWhaleRemoteViewController
: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
		  case .unknown:
			print("central.state is .unknown")
		  case .resetting:
			print("central.state is .resetting")
		  case .unsupported:
			print("central.state is .unsupported")
		  case .unauthorized:
			print("central.state is .unauthorized")
		  case .poweredOff:
			print("central.state is .poweredOff")
		  case .poweredOn:
			print("central.state is .poweredOn")
			bubbleWhaleStatusLabel.text = "Scanning for buuble whale..."
			self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
		}
	}
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		if advertisementData["kCBAdvDataLocalName"] != nil {
			print("Bubble-Whale-Detected");
			bubbleWhaleStatusLabel.text = "Bubble-Whale-Detected..."
			bubbleWhalePeripheral = peripheral
			centralManager.stopScan()
			centralManager.connect(bubbleWhalePeripheral)
		}
	}

	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
	  print("Bubble Whale Connected!")
		bubbleWhaleStatusLabel.text = "Connected to Bubble Whale"
//		bubbleWhalePeripheral.discoverServices(nil)
	}
}
