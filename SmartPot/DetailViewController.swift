//
//  DetailViewController.swift
//  SmartPot
//
//  Created by Mark on 22.12.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    private let refreshControl = UIRefreshControl()
    public var model: DetailPageResponse?
    public var plantImage = "plant"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlantOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "PlantOverviewTableViewCell")
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartTableViewCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPlantData(_:)), for: .valueChanged)
        refreshControl.tintColor = .orange
    }

    override func viewWillAppear(_ animated: Bool) {
        title = model?.plant.name
        navigationController?.navigationBar.prefersLargeTitles = false
        refreshPlantData(self)
    }

    @objc func refreshPlantData(_ sender: Any) {
        defer {
            self.activityIndicatorView.stopAnimating()
        }
        self.activityIndicatorView.startAnimating()

        NetworkManager.shared().requestHomePage(success: { plants in
            if let firstPlant = plants.plants?.first {
                self.model = DetailPageResponse(plant: firstPlant)
                self.title = firstPlant.name

                //reload plant overview
                self.tableView.reloadData()
                self.fetchPlantHistory()
            }
        }) { errorString in
            Toast.show(message: "There was an error while fetching the plant data. Please try again.",
                       controller: self)
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
        }
    }

    func fetchPlantHistory() {
        NetworkManager.shared().requestHistoryPage(success: { historyResponse in
            self.model?.history = historyResponse.plantHistory
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
        }) { errorString in
            Toast.show(message: "There was an error while fetching the plant history. Please try again.", controller: self)
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
        }
    }

    private func numberOfRequiredRows() -> Int {
        var numberOfRows = 1
        numberOfRows += model?.history != nil ? 3 : 0
        return numberOfRows
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditForm", let plantToEdit = model?.plant {
            (segue.destination as? EditPlantFormViewController)?.plantModel = plantToEdit
        }
    }
}

extension DetailViewController: UITableViewDelegate {

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRequiredRows()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlantOverviewTableViewCell", for: indexPath)
            if let potCell = cell as? PlantOverviewTableViewCell {
                potCell.model = PlantOverviewTableViewCell.Model(plant: model?.plant, imageName: plantImage, expanded: true, hideExpandButton: true)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
            if let potCell = cell as? ChartTableViewCell {
                let cellModel = ChartTableViewCell.Model(title: "Soil Humidity", measurements: model?.history?.humiditySoil, treshold: model?.plant.humidityTreshold)
                potCell.model = cellModel
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
            if let potCell = cell as? ChartTableViewCell {
                let cellModel = ChartTableViewCell.Model(title: "Air Humidity", measurements: model?.history?.humidityAir, treshold: model?.plant.humidityTreshold)
                potCell.model = cellModel
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
            if let potCell = cell as? ChartTableViewCell {
                let cellModel = ChartTableViewCell.Model(title: "Temperature", measurements: model?.history?.temperature, treshold: model?.plant.temperatureTreshold)
                potCell.model = cellModel
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlantOverviewTableViewCell", for: indexPath)
            if let potCell = cell as? PlantOverviewTableViewCell {
                potCell.model = PlantOverviewTableViewCell.Model(plant: model?.plant, imageName: plantImage, expanded: true)
            }
            return cell
        }

    }


}
