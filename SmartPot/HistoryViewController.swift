//
//  SecondViewController.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import Charts
import Segmentio

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentioView: Segmentio!

    private var historyPage: HistoryPageResponse?
    private var selectedHistoryObject: HistoryObject?

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "History"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartTableViewCell")
        historyPage = loadJson(filename: "history_example_response")

        var content = [SegmentioItem]()

        let tornadoItem = SegmentioItem(
            title: "Plant 1",
            image: UIImage(named: "plants")
        )
        content.append(tornadoItem)



        let tornadoItem2 = SegmentioItem(
            title: "Plant 2",
            image: UIImage(named: "plants")
        )
        content.append(tornadoItem2)

        let tornadoItem3 = SegmentioItem(
            title: "Plant 3",
            image: UIImage(named: "plants")
        )
        content.append(tornadoItem3)

        let options = SegmentioOptions(backgroundColor: .white, segmentPosition: .dynamic, scrollEnabled: true, indicatorOptions: SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 5, color: .systemOrange), horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0.5, color: .black30), verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(ratio: 0.5, color: .black30), imageContentMode: .scaleAspectFit, labelTextAlignment: .center, labelTextNumberOfLines: 2, segmentStates: SegmentioStates(
                    defaultState: SegmentioState(
                        backgroundColor: .clear,
                        titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                        titleTextColor: .black
                    ),
                    selectedState: SegmentioState(
                        backgroundColor: .clear,
                        titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                        titleTextColor: .black
                    ),
                    highlightedState: SegmentioState(
                        backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                        titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                        titleTextColor: .black
                    )
        ))
        segmentioView.setup(
            content: content,
            style: .imageOverLabel,
            options: options
        )

        segmentioView.selectedSegmentioIndex = 0
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            self.selectedPlantDidChange(atIndex: segmentIndex)
        }

        selectedHistoryObject = historyPage?.historyObjects.first
    }

    func loadJson(filename fileName: String) -> HistoryPageResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(HistoryPageResponse.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    private func selectedPlantDidChange(atIndex index: Int) {
        guard let selectedObject = historyPage?.historyObjects[index] else { return }
        selectedHistoryObject = selectedObject
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate {

}

extension HistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedHistoryObject != nil ? 3 : 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
        if let potCell = cell as? ChartTableViewCell {
            if indexPath.row % 3 == 0 {
                let model = ChartTableViewCell.Model(title: "Temperature", dataPoints: selectedHistoryObject?.temperatures, treshold: historyPage?.historyObjects[0].temperatureTreshold)
                potCell.model = model
            } else if indexPath.row % 3 == 1 {
                let model = ChartTableViewCell.Model(title: "Humidity", dataPoints: selectedHistoryObject?.humidities, treshold: historyPage?.historyObjects[0].humidityTreshold)
                potCell.model = model
            } else  {
                let model = ChartTableViewCell.Model(title: "Water", dataPoints: selectedHistoryObject?.water, treshold: nil)
                potCell.model = model
            }
        }
        return cell
    }


}

