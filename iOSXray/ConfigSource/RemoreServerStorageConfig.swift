import Foundation

struct RemoteConfigError: Error {
	enum ErrorKind {
		case hashHeaderEmpty
	}

	let kind: ErrorKind
}

class RemoteServerStorageConfig: ConfigSource {
	var defaults = UserDefaults.standard

	var remoteConfig: Config?
	var cacheConfig: Config?

	init() {
	}

	func IsRemoteConfigChanged() -> (Bool, Error?) {
		if self.cacheConfig == nil {
			NSLog("Cached config is nil")

			let (cache, error) = self.ReadLocalConfig()
			if error != nil {
				NSLog("Error read cached config")
				NSLog("Error read config from cache: \(error.debugDescription)")
				return (false, error)
			}

			if cache == nil {
				NSLog("Read cached config is nil")
				return (true, nil)
			}

			NSLog("Got cached config")
			self.cacheConfig = cache
		}

		NSLog("we have cached config")

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
		var req = URLRequest(url: URL(string: "http://xray.truewebber.com/config.php")!)
		req.httpMethod = "HEAD"

		NSLog("start head request")
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
					NSLog("Got remote hash: \(hash)")
					remoteHash = hash
				}
			}

			myGroup.leave()
		}
		task.resume()

		myGroup.wait()

		if remoteHash == "" {
			NSLog("Error read config hash")
			return (false, RemoteConfigError(kind: .hashHeaderEmpty))
		}

		if remoteHash != self.cacheConfig?.uniqueConfigHash {
			NSLog("Remote hash is NOT equal cached")
			return (true, nil)
		}

		NSLog("Remote hash is equal cached")
		return (false, nil)
	}

	func ReadRemoteConfig() -> (Config?, Error?) {
		//HTTP HEAD Request
		let myGroup = DispatchGroup()
		myGroup.enter()

		//create session without caches
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData
		config.urlCache = nil

		let session = URLSession.init(configuration: config)

		// GET CONFIG FROM NETWORK
		var configData: Data?
		var req = URLRequest(url: URL(string: "http://xray.truewebber.com/config.php")!)
		req.httpMethod = "GET"

		let task = session.dataTask(with: req as URLRequest) {
			data, response, error in

			if error != nil {
				NSLog("Error make request: \(error.debugDescription)")
				myGroup.leave()

				return
			}

			configData = data

			myGroup.leave()
		}
		task.resume()

		myGroup.wait()


		if configData == nil {
			NSLog("Config str is not nil, but decoded to data nil")
			return (nil, ConfigError(kind: .configTextEmpty))
		}

		return self.DecodeConfig(data: configData!)
	}
}

