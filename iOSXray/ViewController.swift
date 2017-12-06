import UIKit

class ViewController: UIViewController {
	var window: UIWindow?
	var links: [Int: OnClick] = [:]

	//	@objc func openScreen(id: String, _ sender: UITapGestureRecognizer) {
	@objc func openScreen(sender: UITapGestureRecognizer) {
		if let s = sender.view {
			if let click = self.links[s.tag] {
				if click.Action == "open_screen" {
					if let screen = delegate.Screens[click.ID] {
						let navController = UINavigationController(rootViewController: screen)
						navController.isNavigationBarHidden = true

						self.present(navController, animated:true, completion: nil)
					} else {
						NSLog("Error get screen by id ", click.ID)
					}
				} else {
					NSLog("Action is not `open_screen`")
				}
			} else {
				NSLog("Error get click history from links")
			}
		} else {
			NSLog("Error get view")
		}
	}

	func SetScreen(screen: Config.Screen) {
		//		window and current view
		self.window = UIWindow(frame: UIScreen.self.main.bounds)
		self.view.backgroundColor = UIColor.init(
				red: CGFloat(screen.bgColor.red), green: CGFloat(screen.bgColor.green),
				blue: CGFloat(screen.bgColor.blue), alpha: CGFloat(screen.bgColor.alpha)
		)

		for myUiView in screen.views {
			let uiViewHeight = (myUiView.height != -1) ? myUiView.height : Int((self.window?.frame.height)!);
			let uiViewWidth = (myUiView.width != -1) ? myUiView.width : Int((self.window?.frame.width)!);

			//views
			let myView: UIView = UIView(frame: CGRect(
					origin: CGPoint(x: myUiView.posX, y: myUiView.posY),
					size: CGSize(width: uiViewWidth, height: uiViewHeight)
			))
			myView.backgroundColor = UIColor.init(
					red: CGFloat(myUiView.bgColor.red), green: CGFloat(myUiView.bgColor.green),
					blue: CGFloat(myUiView.bgColor.blue), alpha: CGFloat(myUiView.bgColor.alpha)
			)
			self.view.addSubview(myView)

			//clicks
			if let click = myUiView.onClick {

				if click.Action == "open_screen" {
					let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openScreen))
					self.links[myView.tag] = click

					myView.addGestureRecognizer(gesture)
				}
			}

			//labels
			for myUiLabel in myUiView.labels {
				let uiLabelHeight = (myUiLabel.height != -1) ? myUiLabel.height : Int((self.window?.frame.height)!);
				let uiLabelWidth = (myUiLabel.width != -1) ? myUiLabel.width : Int((self.window?.frame.width)!);

				let myLabel = UILabel(frame: CGRect(
						origin: CGPoint(x: myUiLabel.posX, y: myUiLabel.posY),
						size: CGSize(width: uiLabelWidth, height: uiLabelHeight)
				))
				myLabel.text = myUiLabel.text
				myLabel.textColor = UIColor.init(
						red: CGFloat(myUiLabel.color.red), green: CGFloat(myUiLabel.color.green),
						blue: CGFloat(myUiLabel.color.blue), alpha: CGFloat(myUiLabel.color.alpha)
				)
				myLabel.font = myLabel.font.withSize(CGFloat(myUiLabel.textSize))
				switch myUiLabel.align {
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

				myView.addSubview(myLabel)
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
