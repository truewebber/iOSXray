import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

	var window: UIWindow?
	var defaults = UserDefaults.standard
	var NavigationController: UINavigationController!

	var ApplicationConfig: Config!
	var Screens: [String: UIViewController] = [:]

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		//clear cache //for debug
		print(Array(self.defaults.dictionaryRepresentation().keys).count)
		self.defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
		self.defaults.synchronize()

		// Custom View Controller
		let startController: UIViewController = StartController()
		self.NavigationController = UINavigationController()
		if let navigationController = self.NavigationController {
			navigationController.delegate = self
			navigationController.setNavigationBarHidden(true, animated: true)
			navigationController.pushViewController(startController, animated: true)
			self.window = UIWindow(frame: UIScreen.self.main.bounds)
			if let window = self.window {
				window.rootViewController = navigationController
				window.makeKeyAndVisible()
			}
		}

		//config operations
		let configFactory = ConfigFactory(artifact: RemoteServerStorageConfig())
		let (config, error) = configFactory.GetConfig()
		if error != nil {
			NSLog("Error getting config: \(error.debugDescription)")

			return true
		}

//		cache config in all cases
		self.defaults.set(String(data: config!, encoding: String.Encoding.utf8), forKey: StoredConfigKey)

		//enable config for app
		self.ApplicationConfig = config

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state.
		// This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
		// or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
		// Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough
		// application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of
		// applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of
		// the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive.
		// If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate.
		// Save data if appropriate. See also applicationDidEnterBackground:.
	}
}
