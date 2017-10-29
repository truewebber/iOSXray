import Foundation

let StoredConfigKey = "stored::config"

//
// MARK: - Data Model
//
struct Config: CreatableFromJSON {
	let apiVersion: Int
	let authorization: String
	let configVersion: Int
	let uniqueConfigHash: String
	let views: [Views]

	init(apiVersion: Int, authorization: String, configVersion: Int, uniqueConfigHash: String, views: [Views]) {
		self.apiVersion = apiVersion
		self.authorization = authorization
		self.configVersion = configVersion
		self.uniqueConfigHash = uniqueConfigHash
		self.views = views
	}

	init?(json: [String: Any]) {
		guard let apiVersion = json["api_version"] as? Int
		else {
			return nil
		}
		guard let authorization = json["authorization"] as? String
		else {
			return nil
		}
		guard let configVersion = json["config_version"] as? Int
		else {
			return nil
		}
		guard let uniqueConfigHash = json["unique_config_hash"] as? String
		else {
			return nil
		}
		guard let views = Views.createRequiredInstances(from: json, arrayKey: "views")
		else {
			return nil
		}
		self.init(apiVersion: apiVersion, authorization: authorization, configVersion: configVersion, uniqueConfigHash: uniqueConfigHash, views: views)
	}

	struct Views: CreatableFromJSON {
		let bgColor: BgColor
		let labels: [Labels]

		init(bgColor: BgColor, labels: [Labels]) {
			self.bgColor = bgColor
			self.labels = labels
		}

		init?(json: [String: Any]) {
			guard let bgColor = BgColor(json: json, key: "bg_color")
			else {
				return nil
			}
			guard let labels = Labels.createRequiredInstances(from: json, arrayKey: "labels")
			else {
				return nil
			}
			self.init(bgColor: bgColor, labels: labels)
		}

		struct BgColor: CreatableFromJSON {
			let alpha: Int
			let blue: Int
			let green: Int
			let red: Int

			init(alpha: Int, blue: Int, green: Int, red: Int) {
				self.alpha = alpha
				self.blue = blue
				self.green = green
				self.red = red
			}

			init?(json: [String: Any]) {
				guard let alpha = json["alpha"] as? Int
				else {
					return nil
				}
				guard let blue = json["blue"] as? Int
				else {
					return nil
				}
				guard let green = json["green"] as? Int
				else {
					return nil
				}
				guard let red = json["red"] as? Int
				else {
					return nil
				}
				self.init(alpha: alpha, blue: blue, green: green, red: red)
			}
		}

		struct Labels: CreatableFromJSON {
			let labelHeight: Int
			let labelWidth: Int
			let posX: Int
			let posY: Int
			let text: Text

			init(labelHeight: Int, labelWidth: Int, posX: Int, posY: Int, text: Text) {
				self.labelHeight = labelHeight
				self.labelWidth = labelWidth
				self.posX = posX
				self.posY = posY
				self.text = text
			}

			init?(json: [String: Any]) {
				guard let labelHeight = json["label_height"] as? Int
				else {
					return nil
				}
				guard let labelWidth = json["label_width"] as? Int
				else {
					return nil
				}
				guard let posX = json["pos_x"] as? Int
				else {
					return nil
				}
				guard let posY = json["pos_y"] as? Int
				else {
					return nil
				}
				guard let text = Text(json: json, key: "text")
				else {
					return nil
				}
				self.init(labelHeight: labelHeight, labelWidth: labelWidth, posX: posX, posY: posY, text: text)
			}

			struct Text: CreatableFromJSON {
				let align: String
				let color: Color
				let text: String
				let textSize: Int

				init(align: String, color: Color, text: String, textSize: Int) {
					self.align = align
					self.color = color
					self.text = text
					self.textSize = textSize
				}

				init?(json: [String: Any]) {
					guard let align = json["align"] as? String
					else {
						return nil
					}
					guard let color = Color(json: json, key: "color")
					else {
						return nil
					}
					guard let text = json["text"] as? String
					else {
						return nil
					}
					guard let textSize = json["text_size"] as? Int
					else {
						return nil
					}
					self.init(align: align, color: color, text: text, textSize: textSize)
				}

				struct Color: CreatableFromJSON {
					let alpha: Int
					let blue: Int
					let green: Int
					let red: Int

					init(alpha: Int, blue: Int, green: Int, red: Int) {
						self.alpha = alpha
						self.blue = blue
						self.green = green
						self.red = red
					}

					init?(json: [String: Any]) {
						guard let alpha = json["alpha"] as? Int
						else {
							return nil
						}
						guard let blue = json["blue"] as? Int
						else {
							return nil
						}
						guard let green = json["green"] as? Int
						else {
							return nil
						}
						guard let red = json["red"] as? Int
						else {
							return nil
						}
						self.init(alpha: alpha, blue: blue, green: green, red: red)
					}
				}
			}
		}
	}
}

//
// MARK: - JSON Utilities
//
/// Adopted by a type that can be instantiated from JSON data.
protocol CreatableFromJSON {
	/// Attempts to configure a new instance of the conforming type with values from a JSON dictionary.
	init?(json: [String: Any])
}

extension CreatableFromJSON {
	/// Attempts to configure a new instance using a JSON dictionary selected by the `key` argument.
	init?(json: [String: Any], key: String) {
		guard let jsonDictionary = json[key] as? [String: Any]
		else {
			return nil
		}
		self.init(json: jsonDictionary)
	}

	/// Attempts to produce an array of instances of the conforming type based on an array in the JSON dictionary.
	/// - Returns: `nil` if the JSON array is missing or if there is an invalid/null element in the JSON array.
	static func createRequiredInstances(from json: [String: Any], arrayKey: String) -> [Self]? {
		guard let jsonDictionaries = json[arrayKey] as? [[String: Any]]
		else {
			return nil
		}
		return createRequiredInstances(from: jsonDictionaries)
	}

	/// Attempts to produce an array of instances of the conforming type based on an array of JSON dictionaries.
	/// - Returns: `nil` if there is an invalid/null element in the JSON array.
	static func createRequiredInstances(from jsonDictionaries: [[String: Any]]) -> [Self]? {
		var array = [Self]()
		for jsonDictionary in jsonDictionaries {
			guard let instance = Self.init(json: jsonDictionary)
			else {
				return nil
			}
			array.append(instance)
		}
		return array
	}

	/// Attempts to produce an array of instances of the conforming type, or `nil`, based on an array in the JSON dictionary.
	/// - Returns: `nil` if the JSON array is missing, or an array with `nil` for each invalid/null element in the JSON array.
	static func createOptionalInstances(from json: [String: Any], arrayKey: String) -> [Self?]? {
		guard let array = json[arrayKey] as? [Any]
		else {
			return nil
		}
		return createOptionalInstances(from: array)
	}

	/// Attempts to produce an array of instances of the conforming type, or `nil`, based on an array.
	/// - Returns: An array of instances of the conforming type and `nil` for each invalid/null element in the source array.
	static func createOptionalInstances(from array: [Any]) -> [Self?] {
		return array.map {
			item in
			if let jsonDictionary = item as? [String: Any] {
				return Self.init(json: jsonDictionary)
			} else {
				return nil
			}
		}
	}
}
