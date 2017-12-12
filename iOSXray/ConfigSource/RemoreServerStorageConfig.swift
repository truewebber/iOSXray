import Foundation

class RemoteServerStorageConfig: ConfigSource {
	var defaults = UserDefaults.standard

	var remoteConfig: Config?
	var cacheConfig: Config?

	init() {
	}

	func IsRemoteConfigChanged() -> (Bool, Error?) {
		if self.cacheConfig == nil {
			let (config, error) = self.ReadRemoteConfig()
			if error != nil {
				NSLog("Error read config from cache: \(error.debugDescription)")
				return (false, error)
			}

			if config == nil {
				return (true, nil)
			}

			self.remoteConfig = config
		}

		var remoteHash: String = ""
		//HTTP HEAD Request
		let myGroup = DispatchGroup()
		myGroup.enter()

		//create session without caches
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData
		config.urlCache = nil

		let session = URLSession.init(configuration: config)

		// GET CONFIG FROM NETWORK
		var req = URLRequest(url: URL(string: "http://xray.truewebber.com/config.json")!)
		req.httpMethod = "HEAD"

		let task = session.dataTask(with: req as URLRequest) {
			data, response, error in

			if error != nil {
				NSLog("Error make request: \(error.debugDescription)")
				myGroup.leave()

				return
			}

			//read headers
			if let httpResponse = response as? HTTPURLResponse {
				if let hash = httpResponse.allHeaderFields["Config-Hash"] as? String {
					remoteHash = hash
				}
			}

			myGroup.leave()
		}
		task.resume()

		myGroup.wait()

		if remoteHash == "" {
			NSLog("Error read config hash")
			return (false, nil)
		}

		if remoteHash != self.cacheConfig?.uniqueConfigHash {
			return (true, nil)
		}

		return (false, nil)
	}

	func ReadRemoteConfig() -> (Config?, Error?) {
		//HTTP GET Request

		let textFromFile = "bla bla json text must be here"
		let dataFromFile = (textFromFile).data(using: .utf8)
		if dataFromFile == nil {
			NSLog("Config str is not nil, but decoded to data nil")
			return (nil, nil)
		}

		return self.DecodeConfig(data: dataFromFile!)
	}
}

