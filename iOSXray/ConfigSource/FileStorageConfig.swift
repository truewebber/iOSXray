import Foundation

class FileStorageConfig: ConfigSource {
	var remoteConfig: Config?
	var cacheConfig: Config?

	func IsRemoteConfigChanged() -> (Bool, Error?) {
		if self.remoteConfig == nil {
			let (config, error) = self.ReadRemoteConfig()
			if error != nil {
				NSLog("Error read config from file: \(error.debugDescription)")
				return (false, error)
			}

			if config == nil {
				NSLog("Config read from file, but returns nil")
				return (false, nil)
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
				return (true, nil)
			}

			self.remoteConfig = config
		}

		if self.remoteConfig?.uniqueConfigHash != self.cacheConfig?.uniqueConfigHash {
			return (true, nil)
		}

		return (false, nil)
	}

	func ReadRemoteConfig() -> (Config?, Error?) {
		//read from file ( i don't know how )

		let textFromFile = "bla bla json text must be here"
		let dataFromFile = (textFromFile).data(using: .utf8)
		if dataFromFile == nil {
			NSLog("Config str is not nil, but decoded to data nil")
			return (nil, nil)
		}

		return self.DecodeConfig(data: dataFromFile!)
	}
}
