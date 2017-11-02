import UIKit

let delegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
	var window: UIWindow?

	var ApplicationConfig: Config!

	override func viewDidLoad() {
		super.viewDidLoad()

		//window and current view
		self.window = UIWindow(frame: UIScreen.self.main.bounds)
		self.view.backgroundColor = UIColor.white

		if delegate.ApplicationConfig == nil {
			//Alert about connection
			let alert = UIAlertController(title: "Network is unavailable", message: "First launch required internet connection",
			                              preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Exit Application", style: .default, handler: {
				action in

				switch action.style {
				case .default:
					print("default")

					exit(10)
				case .cancel:
					print("cancel")

				case .destructive:
					print("destructive")
				}
			}))

			self.present(alert, animated: true, completion: nil)
			return
		}

		let myView: UIView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (self.window?.frame.width)!, height: 80)))
		myView.backgroundColor = UIColor.init(red: 0.25, green: 0.37, blue: 0.53, alpha: 1)
		self.view.addSubview(myView)

		let myLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: (self.window?.frame.width)!, height: 60)))
		myLabel.text = "Hello World!"
		myLabel.textColor = UIColor.white
		myLabel.font = myLabel.font.withSize(30)
		myLabel.textAlignment = .center
		self.view.addSubview(myLabel)

		NSLog("DONE")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

