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
    
    public var model: Plant? {
        didSet {
            updateForModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateForModel()
    }

    private func updateForModel() {
        guard let model = model else { return }

        plantTitleLabel?.text = model.name
        if let temp = model.temperatureTreshold {
            temperatureLabel?.text = String(describing: temp) + " °C"
        }

        if let hum = model.humidityTreshold {
            humidityLabel?.text = String(describing: hum) + " %"
        }

        let status = PlantStatus(rawValue: model.status ?? 0)
        switch status {
        case .green:
            plantStatusImageView?.backgroundColor = .green
        case .red:
            plantStatusImageView?.backgroundColor = .red
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
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
