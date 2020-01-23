//
//  PotOverviewTableViewCell.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import AlamofireImage
import ImageViewer_swift

class PlantOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView?

    @IBOutlet weak var plantImageView: UIImageView?
    @IBOutlet weak var plantTitleLabel: UILabel?

    @IBOutlet weak var webcamImageHeightConstraint: NSLayoutConstraint?


    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var humidityImageView: UIImageView?
    @IBOutlet weak var temperatureImageView: UIImageView?
    @IBOutlet weak var plantStatusImageView: UIImageView?
    @IBOutlet weak var humiditySoilImageView: UIImageView?
    @IBOutlet weak var smallStackView: UIStackView?
    @IBOutlet weak var largeStackView: UIStackView?
    @IBOutlet weak var humiditySoilLabel: UILabel?
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var largeTemperatureLabel: UILabel?
    @IBOutlet weak var largeSoilHumidityLabel: UILabel?
    @IBOutlet weak var largeAirHumidityLabel: UILabel?
    @IBOutlet weak var arrowRightImageView: UIImageView?

    
    @IBOutlet weak var webcamImageView: UIImageView?

    struct Model {
        public let plant: Plant?
        public let imageName: String?
        public let expanded: Bool
        public var hideExpandButton = false
    }

    public var model: Model? {
        didSet {
            updateForModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        temperatureImageView?.image = UIImage(systemName: "thermometer")
        humidityImageView?.image = UIImage(systemName: "wind")
        updateForModel()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func updateForModel() {
        guard let hideExpandButton = model?.hideExpandButton, let expanded = model?.expanded, let plantImage = model?.imageName,
            let model = model?.plant else { return }

        var warnings = 0

        plantImageView?.image = UIImage(named: plantImage)
        
        plantTitleLabel?.text = model.name
        if let temp = model.temperature {
            temperatureLabel?.text = String(describing: temp) + " °C"
            var largeLabelText = "Temperature: " + String(describing: temp) + " °C"
            if let treshold = model.temperatureTreshold {
                if temp < treshold {
                    temperatureImageView?.tintColor = .systemRed
                    temperatureLabel?.textColor = .systemRed
                    warnings += 1
                }
                largeLabelText.append(" Treshold: " + String(describing: treshold) + " °C")
            }
            largeTemperatureLabel?.text = largeLabelText
        }

        if let hum = model.humidityAir {
            humidityLabel?.text = String(describing: hum) + " %"
            var largeLabelText = "Air Humidity: " + String(describing: hum) + " %"
            if let treshold = model.humidityTreshold {
                if hum < treshold {
                    humidityImageView?.tintColor = .systemRed
                    humidityLabel?.textColor = .systemRed
                    warnings += 1
                } else {
                    humidityImageView?.tintColor = .black
                    humidityLabel?.textColor = .black
                }
                largeLabelText.append(" Treshold: " + String(describing: treshold) + " %")
            }
            largeAirHumidityLabel?.text = largeLabelText
        }

        if let hum = model.humiditySoil {
            humiditySoilLabel?.text = String(describing: hum) + " %"
            var largeLabelText = "Soil Humidity: " + String(describing: hum) + " %"
            if let treshold = model.humidityTreshold {
                if hum < treshold {
                    humiditySoilImageView?.tintColor = .systemRed
                    humiditySoilLabel?.textColor = .systemRed
                    warnings += 1
                } else {
                    humiditySoilImageView?.tintColor = .black
                    humiditySoilLabel?.textColor = .black
                }
                largeLabelText.append(" Treshold: " + String(describing: treshold) + " %")
            }
            largeSoilHumidityLabel?.text = largeLabelText
        }

        switch warnings {
        case 0:
            plantStatusImageView?.backgroundColor = .systemGreen
            statusLabel?.text = "healthy"
            statusLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        case 2,3:
            plantStatusImageView?.backgroundColor = .systemRed
            statusLabel?.text = "needs attention!"
            statusLabel?.textColor = .systemRed
        case 1:
            plantStatusImageView?.backgroundColor = .orange
            statusLabel?.text = "needs attention!"
            statusLabel?.textColor = .white
        default:
            plantStatusImageView?.backgroundColor = .gray
        }
        plantStatusImageView?.layer.cornerRadius = 10

        if let containerView = containerView {
            containerView.layer.shadowColor = UIColor.midgrey.cgColor
            containerView.layer.shadowOpacity = 1
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowRadius = 7
            containerView.layer.cornerRadius = 20
        }

        arrowRightImageView?.isHidden = hideExpandButton

        if expanded == false {
            smallStackView?.isHidden = false
            largeStackView?.isHidden = true
        } else if expanded == true {
            smallStackView?.isHidden = true
            largeStackView?.isHidden = false
        }

        if expanded, let imageUrl = model.profileImageId, let url = URL(string: imageUrl) {

            let placeholderImage = UIImage(named: plantImage)

            webcamImageView?.af_setImage(withURL: url, placeholderImage: placeholderImage)
            webcamImageView?.setupImageViewer(url: url)
            webcamImageHeightConstraint?.constant = 210
        } else {
            webcamImageHeightConstraint?.constant = 0
            webcamImageView?.isHidden = true
        }

        updateConstraintsIfNeeded()
    }


//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            containerView?.backgroundColor = .slategrey80
//        } else {
//            containerView?.backgroundColor = .white
//        }
//    }
//

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView?.backgroundColor = .slategrey80
        } else {
            containerView?.backgroundColor = .white
        }
    }
}
