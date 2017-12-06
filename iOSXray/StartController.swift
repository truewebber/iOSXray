import UIKit

let delegate = UIApplication.shared.delegate as! AppDelegate

class StartController: UIViewController {
	var window: UIWindow?

	override func viewDidLoad() {
		super.viewDidLoad()

		//window and current view
		self.window = UIWindow(frame: UIScreen.self.main.bounds)
		self.view.backgroundColor = UIColor.gray

		if delegate.ApplicationConfig == nil {
			//Alert about connection
			let alert = UIAlertController(title: "Network is unavailable", message: "First launch required internet connection",
			                              preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Exit Application", style: .default, handler: {
				action in

				switch action.style {
				case .default:
					NSLog("Alert Default")

					exit(10)
				case .cancel:
					NSLog("Alert Cancel")
				case .destructive:
					NSLog("Alert Destructive")
				}
			}))

			NSLog("WAIT until tap exit")
			self.present(alert, animated: true, completion: nil)

			return
		}

		for screenJSON in delegate.ApplicationConfig.screens {
			let vc = ViewController()
			vc.SetScreen(screen: screenJSON)

			delegate.Screens[screenJSON.screenId] = vc

		}

		delegate.NavigationController.present(delegate.Screens[delegate.ApplicationConfig.initScreen]!,
		                                      animated: false, completion: nil)

		NSLog("DONE")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
