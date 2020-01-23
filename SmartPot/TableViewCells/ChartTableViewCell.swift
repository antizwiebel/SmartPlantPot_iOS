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
    @IBOutlet weak var chartSizeConstraint: NSLayoutConstraint?

    weak var axisFormatDelegate: IAxisValueFormatter?

    public struct Model {
        public let title: String
        public let measurements: [Measurement]?
        public let treshold: Float?
        public var chartSize: CGFloat = 450.0

        init(title: String, measurements: [Measurement]?, treshold: Float?, chartSize: CGFloat = 450.0) {
            self.title = title
            self.measurements = measurements
            self.treshold = treshold
            self.chartSize = chartSize
        }
    }

    public var model: Model? {
        didSet {
            updateForModel()
        }
    }
    
    private func updateForModel() {

        guard let historyObject = model, let dataPoints = historyObject.measurements?.reversed() else { return }
        titleLabel?.text = historyObject.title

        chartSizeConstraint?.constant = historyObject.chartSize

        // Define the reference time interval
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = dataPoints.min()?.date.timeIntervalSince1970 {
            referenceTimeInterval = minTimeInterval
        }

        // Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm"

        // check if time intervals are within a day
        if let min = dataPoints.min()?.date, let max = dataPoints.max()?.date,
            (max.timeIntervalSince1970 - min.timeIntervalSince1970) < (3600 * 24) {
            formatter.dateFormat = "HH:mm"
        }

        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)

        lineChartView?.xAxis.valueFormatter = xValuesNumberFormatter

        // Define chart entries
        var entries = [ChartDataEntry]()
        var tresholdEntries = [ChartDataEntry]()
        for object in dataPoints {
            let xValue = (object.date.timeIntervalSince1970 - referenceTimeInterval) / (3600 * 24)
            let yValue = object.value
            let entry = ChartDataEntry(x: xValue, y: Double(yValue))
            entries.append(entry)
            if let treshold = historyObject.treshold {
                tresholdEntries.append(ChartDataEntry(x: xValue, y: Double(treshold)))
            }
        }


        // create chart lines
        let line1 = LineChartDataSet(entries: entries, label: historyObject.title)
        let line2 = LineChartDataSet(entries: tresholdEntries, label: "Lower Treshold")

        // style lines
        line1.colors = [.orange]
        line1.drawCirclesEnabled = false
        line1.axisDependency = .left
        line1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        line1.lineWidth = 1.5
        line1.drawCirclesEnabled = false
        line1.fillAlpha = 0.26
        line1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        line1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        line1.drawCircleHoleEnabled = false

        line2.colors = [.systemRed]
        line2.drawCirclesEnabled = false
        line2.drawValuesEnabled = false

        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)

        lineChartView?.xAxis.labelRotationAngle = -90
        lineChartView?.data = data
        lineChartView?.chartDescription?.text = historyObject.title + "Values"

        updateConstraintsIfNeeded()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateForModel()
    }

}
