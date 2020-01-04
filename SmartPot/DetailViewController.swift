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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(UINib(nibName: "PotOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "PotOverviewTableViewCell")
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartTableViewCell")
        if let jsonModel = loadJson(filename: "detailpage_example_response") {
            model = jsonModel
        }

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPlantData(_:)), for: .valueChanged)
        refreshControl.tintColor = .orange
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Plant Data ...")
    }

    override func viewWillAppear(_ animated: Bool) {
        title = model?.plant.name
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    @objc private func refreshPlantData(_ sender: Any) {
        defer {
            self.activityIndicatorView.stopAnimating()
        }
        self.activityIndicatorView.startAnimating()

        guard let jsonModel = loadJson(filename: "detailpage_example_response") else { return }

        model = jsonModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func loadJson(filename fileName: String) -> DetailPageResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(DetailPageResponse.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    private func numberOfRequiredRows() -> Int {
        var numberOfRows = 1
        numberOfRows += model?.history?.humidities == nil ? 0 : 1
        numberOfRows += model?.history?.temperatures == nil ? 0 : 1
        numberOfRows += model?.history?.water == nil ? 0 : 1
        return numberOfRows
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PotOverviewTableViewCell", for: indexPath)
            if let potCell = cell as? PotOverviewTableViewCell {
                potCell.model = model?.plant
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
            if let potCell = cell as? ChartTableViewCell {
                potCell.model = ChartTableViewCell.Model(title: "Temperatures", dataPoints: model?.history?.temperatures, treshold: model?.history?.temperatureTreshold)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PotOverviewTableViewCell", for: indexPath)
            if let potCell = cell as? PotOverviewTableViewCell {
                potCell.model = model?.plant
            }
            return cell
        }

    }


}
