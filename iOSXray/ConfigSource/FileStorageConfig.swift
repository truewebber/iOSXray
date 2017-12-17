import Foundation

class FileStorageConfig: ConfigSource {
	var remoteConfig: Config?
	var cacheConfig: Config?

	init() {
	}

	func IsRemoteConfigChanged() -> (Bool, Error?) {
		if self.remoteConfig == nil {
			let (config, error) = self.ReadRemoteConfig()
			if error != nil {
				NSLog("Error read config from file: \(error.debugDescription)")
				return (false, error)
			}

			if config == nil {
				NSLog("Config read from file, but returns nil")
				return (false, ConfigError(kind: .configTextEmpty))
			}

			self.remoteConfig = config
		}

		if self.cacheConfig == nil {
			let (config, error) = self.ReadRemoteConfig()
			if error != nil {
				NSLog("Error read config from cache: \(error.debugDescription)")
				return (false, error)
			}

			if config == nil {
				return (true, ConfigError(kind: .configTextEmpty))
			}

			self.remoteConfig = config
		}

		if self.remoteConfig?.uniqueConfigHash != self.cacheConfig?.uniqueConfigHash {
			return (true, nil)
		}

		return (false, nil)
	}

	func ReadRemoteConfig() -> (Config?, Error?) {
		var textFromFile: String = ""
		if let path = Bundle.main.path(forResource: "config.json", ofType: "txt") {
			do {
				textFromFile = try String(contentsOfFile: path, encoding: .utf8)
			} catch {
				NSLog("Error read config from file `config.json`")
				return (nil, error)
			}
		}

		let dataFromFile = (textFromFile).data(using: .utf8)
		if dataFromFile == nil {
			NSLog("Config str is not nil, but decoded to data nil")
			return (nil, ConfigError(kind: .configTextEmpty))
		}

		return self.DecodeConfig(data: dataFromFile!)
	}
}
