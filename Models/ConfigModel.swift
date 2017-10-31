import Foundation

var StoredConfigKey = "stored::config"

struct Config: Codable {
	var apiVersion: Int
	var authorization: String
	var configVersion: Int
	var uniqueConfigHash: String
	var views: [Views]

	private enum CodingKeys: String, CodingKey {
		case apiVersion = "api_version", authorization = "authorization", configVersion = "config_version",
		     uniqueConfigHash = "unique_config_hash", views = "views"
	}

	struct Views: Codable {
		var bgColor: Color
		var labels: [Labels]

		private enum CodingKeys: String, CodingKey {
			case bgColor = "bg_color", labels = "labels"
		}

		struct Labels: Codable {
			var labelHeight: Int
			var labelWidth: Int
			var posX: Int
			var posY: Int
			var text: Text

			private enum CodingKeys: String, CodingKey {
				case labelHeight = "label_height", labelWidth = "label_width",
				     posX = "pos_x", posY = "pos_y", text = "text"
			}

			struct Text: Codable {
				var align: String
				var color: Color
				var text: String
				var textSize: Int

				private enum CodingKeys: String, CodingKey {
					case align = "align", color = "color", text = "text", textSize = "text_size"
				}
			}
		}
	}
}

struct Color: Codable {
	var alpha: Int
	var blue: Int
	var green: Int
	var red: Int

	private enum CodingKeys: String, CodingKey {
		case alpha = "alpha", blue = "blue", green = "green", red = "red"
	}
}
