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
    private var selectedHistoryObject: PlantHistory?

    private let refreshControl = UIRefreshControl()

    private let plantImages = ["plant", "botanic_1", "botanic_2", "botanical", "bamboo", "monstera"]

    private var plantTresholds: (humidityTreshold: Float?, temperatureTreshold: Float?)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "History"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartTableViewCell")
        loadHistoryPage()

        var content = [SegmentioItem]()

        let standardItem = SegmentioItem(
            title: "Plant 1",
            image: UIImage(named: "plant")
        )
        content.append(standardItem)

        let standardItem2 = SegmentioItem(
            title: "Plant 2",
            image: UIImage(named: "botanic_1")
        )
        content.append(standardItem2)

        let standardItem3 = SegmentioItem(
            title: "Plant 3",
            image: UIImage(named: "botanic_2")
        )
        content.append(standardItem3)

        let options = SegmentioOptions(backgroundColor: .white, segmentPosition: .dynamic, scrollEnabled: true, indicatorOptions: SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 5, color: .systemOrange), horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0.5, color: .black30), verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(ratio: 0.5, color: .black30), imageContentMode: .scaleAspectFit, labelTextAlignment: .center, labelTextNumberOfLines: 2, segmentStates: SegmentioStates(
                    defaultState: SegmentioState(
                        backgroundColor: .clear,
                        titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                        titleTextColor: .black
                    ),
                    selectedState: SegmentioState(
                        backgroundColor: .clear,
                        titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                        titleTextColor: .black
                    ),
                    highlightedState: SegmentioState(
                        backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                        titleFont: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize),
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


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadPlants()
    }

    func loadPlants() {

        NetworkManager.shared().requestHomePage(success: { plantsResponse in

            guard let plants = plantsResponse.plants else { return }

            var content = [SegmentioItem]()

            for i in 0...(plants.count-1) {
                let item = SegmentioItem(
                    title: plants[i].name,
                    image: UIImage(named: self.plantImages[i % self.plantImages.count])
                )
                content.append(item)
            }

            // get the tresholds from only the first plant since we know that is the only with data
            self.plantTresholds = (humidityTreshold: plants.first?.humidityTreshold, temperatureTreshold: plants.first?.temperatureTreshold)

            self.segmentioView.setup(content: content, style: .imageOverLabel, options: nil)

        }) { errorString in
            print(errorString)
        }
    }

    func loadHistoryPage() {
        NetworkManager.shared().requestHistoryPage(forPlantId: 1, success: { plantHistory in
            self.historyPage = plantHistory
            self.selectedHistoryObject = plantHistory.plantHistory
            self.tableView.reloadData()
        }) { errorString in
            Toast.show(message: "There was an error while fetching the plant history. Please try again.", controller: self)
        }
    }

    private func selectedPlantDidChange(atIndex index: Int) {
        if index != 0 {
            selectedHistoryObject = nil
            tableView.reloadData()
        } else {
            selectedHistoryObject = historyPage?.plantHistory
            tableView.reloadData()
        }
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
                let model = ChartTableViewCell.Model(title: "Soil Humidity", measurements: selectedHistoryObject?.humiditySoil, treshold: plantTresholds?.humidityTreshold)
                potCell.model = model
            } else if indexPath.row % 3 == 1 {
                let model = ChartTableViewCell.Model(title: "Air Humidity", measurements: selectedHistoryObject?.humidityAir, treshold: plantTresholds?.humidityTreshold, chartSize: 350.0)
                potCell.model = model
            } else  {
                let model = ChartTableViewCell.Model(title: "Temperature", measurements: selectedHistoryObject?.temperature, treshold: plantTresholds?.temperatureTreshold, chartSize: 350.0)
                potCell.model = model
            }
        }
        return cell
    }


}

