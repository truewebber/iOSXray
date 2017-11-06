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

		self.view.backgroundColor = UIColor.init(
				red: CGFloat(delegate.ApplicationConfig.views[0].bgColor.red),
				green: CGFloat(delegate.ApplicationConfig.views[0].bgColor.green),
				blue: CGFloat(delegate.ApplicationConfig.views[0].bgColor.blue),
				alpha: CGFloat(delegate.ApplicationConfig.views[0].bgColor.alpha)
		)

		//		let myView: UIView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (self.window?.frame.width)!, height: 80)))
		//		myView.backgroundColor = UIColor.init(red: 0.25, green: 0.37, blue: 0.53, alpha: 1)
		//		self.view.addSubview(myView)

		for uiView in delegate.ApplicationConfig.views[0].labels {
			let uiHeight = (uiView.labelHeight != -1) ? uiView.labelHeight : Int((self.window?.frame.height)!);
			let uiWidth = (uiView.labelWidth != -1) ? uiView.labelWidth : Int((self.window?.frame.width)!);

			let myView: UIView = UIView(frame: CGRect(
					origin: CGPoint(x: uiView.posX, y: uiView.posY),
					size: CGSize(width: uiWidth, height: uiHeight)
			))
			myView.backgroundColor = UIColor.init(
					red: CGFloat(uiView.bgColor.red), green: CGFloat(uiView.bgColor.green),
					blue: CGFloat(uiView.bgColor.blue), alpha: CGFloat(uiView.bgColor.alpha)
			)
			self.view.addSubview(myView)

			let myLabel = UILabel(frame: CGRect(
					origin: CGPoint(x: uiView.posX, y: uiView.posY),
					size: CGSize(width: uiWidth, height: uiHeight)
			))
			myLabel.text = uiView.text.text
			myLabel.textColor = UIColor.init(
					red: CGFloat(uiView.text.color.red), green: CGFloat(uiView.text.color.green),
					blue: CGFloat(uiView.text.color.blue), alpha: CGFloat(uiView.text.color.alpha)
			)
			myLabel.font = myLabel.font.withSize(CGFloat(uiView.text.textSize))
			switch uiView.text.align {
			case ".left":
				myLabel.textAlignment = .left
			case ".right":
				myLabel.textAlignment = .right
			case ".center":
				myLabel.textAlignment = .center
			case ".justified":
				myLabel.textAlignment = .justified
			default:
				myLabel.textAlignment = .natural
			}
			self.view.addSubview(myLabel)
		}

		NSLog("DONE")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
