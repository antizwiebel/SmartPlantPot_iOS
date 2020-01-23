//
//  FirstViewController.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var homePage: HomePageResponse?
    private let refreshControl = UIRefreshControl()
    private var selectedPlantIndex = -1
    private let plantImages = ["plant", "botanic_1", "botanic_2", "botanical", "bamboo", "monstera"]

    private var expandedStates = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PlantOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "PlantOverviewTableViewCell")

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPlantData(_:)), for: .valueChanged)
        refreshControl.tintColor = .orange
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Plant Data ...")
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        loadHomePage()
    }

    @objc private func refreshPlantData(_ sender: Any) {
        loadHomePage()
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        refreshPlantData(sender)
    }

    private func loadHomePage() {
        NetworkManager.shared().requestHomePage(success: { plants in
            self.homePage = plants
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { errorString in
            Toast.show(message: "There was an error while fetching the plant data. Please try again.", controller: self)
            self.refreshControl.endRefreshing()
        }
    }

    private func loadJson(filename fileName: String) -> HomePageResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(HomePageResponse.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let selectedPlant = homePage?.plants?[selectedPlantIndex] {
            (segue.destination as? DetailViewController)?.model = DetailPageResponse(plant: selectedPlant)
            (segue.destination as? DetailViewController)?.plantImage = plantImages[selectedPlantIndex % plantImages.count]
        }
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlantIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePage?.plants?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantOverviewTableViewCell", for: indexPath)
        if let potCell = cell as? PlantOverviewTableViewCell {
            potCell.model = PlantOverviewTableViewCell.Model(plant: homePage?.plants?[indexPath.row],
                                                             imageName: plantImages[indexPath.row % plantImages.count], expanded: false)
        }
        return cell
    }

}
