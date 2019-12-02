//
//  ChartTableViewCell.swift
//  SmartPot
//
//  Created by Mark on 29.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell {

    var temperatureData: [Float]?

    @IBOutlet private weak var lineChartView: LineChartView?

    @IBOutlet private weak var titleLabel: UILabel?

    public struct Model {
        public let title: String
        public let dataPoints: [DataPoint]?
        public let treshold: Double?
    }

    public var model: Model? {
        didSet {
            updateForModel()
        }
    }
    
    private func updateForModel() {

        guard let historyObject = model, let dataPoints = historyObject.dataPoints else { return }
        titleLabel?.text = historyObject.title

        // Define the reference time interval
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = dataPoints.min()?.date {
            referenceTimeInterval = TimeInterval(minTimeInterval)
        }

        // Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current

        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)

        lineChartView?.xAxis.valueFormatter = xValuesNumberFormatter

        // Define chart entries
        var entries = [ChartDataEntry]()
        var tresholdEntries = [ChartDataEntry]()
        for object in dataPoints {
            let xValue = (TimeInterval(object.date) - referenceTimeInterval) / (3600 * 24)

            let yValue = object.value
            let entry = ChartDataEntry(x: xValue, y: Double(yValue))
            entries.append(entry)
            if let treshold = historyObject.treshold {
                tresholdEntries.append(ChartDataEntry(x: xValue, y: treshold))
            }
        }


        let line1 = LineChartDataSet(entries: entries, label: historyObject.title)
        let line2 = LineChartDataSet(entries: tresholdEntries, label: "Treshold")
        line1.colors = [.orange]

        line2.colors = [.systemRed]
        line2.circleRadius = 0.5

        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        lineChartView?.data = data

        lineChartView?.chartDescription?.text = historyObject.title + "Values"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateForModel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

