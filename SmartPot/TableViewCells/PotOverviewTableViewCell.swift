//
//  PotOverviewTableViewCell.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit

class PotOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView?

    @IBOutlet weak var plantImageView: UIImageView?
    @IBOutlet weak var plantTitleLabel: UILabel?
    
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var humidityImageView: UIImageView?
    @IBOutlet weak var temperatureImageView: UIImageView?
    @IBOutlet weak var plantStatusImageView: UIImageView?
    @IBOutlet weak var waterImageView: UIImageView?

    public var model: Plant? {
        didSet {
            updateForModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        temperatureImageView?.image = UIImage(systemName: "thermometer")
        humidityImageView?.image = UIImage(systemName: "wind")
        updateForModel()


    }

    private func updateForModel() {
        guard let model = model else { return }

        plantTitleLabel?.text = model.name
        if let temp = model.temperature {
            temperatureLabel?.text = String(describing: temp) + " °C"
            if let treshold = model.temperatureTreshold, temp < treshold  {
                temperatureImageView?.tintColor = .systemRed
                temperatureLabel?.textColor = .systemRed
            }
        }

        if let hum = model.humidity {
            humidityLabel?.text = String(describing: hum) + " %"
            if let treshold = model.humidityTreshold, hum < treshold {
                humidityImageView?.tintColor = .systemRed
                humidityLabel?.textColor = .systemRed
            }
        }

        switch model.status {
        case .green:
            plantStatusImageView?.backgroundColor = .systemGreen
        case .red:
            plantStatusImageView?.backgroundColor = .systemRed
        case .yellow:
            plantStatusImageView?.backgroundColor = .orange
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

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
