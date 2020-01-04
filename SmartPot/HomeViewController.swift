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

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    private var homePage: HomePageResponse?
    private let refreshControl = UIRefreshControl()
    private var selectedPlantIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PotOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "PotOverviewTableViewCell")
        loadHomePage()

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPlantData(_:)), for: .valueChanged)
        refreshControl.tintColor = .orange
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Plant Data ...")
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc private func refreshPlantData(_ sender: Any) {
        // Fetch Weather Data
        self.activityIndicatorView.startAnimating()
        loadHomePage()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
        }
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        refreshPlantData(sender)
    }

    private func loadHomePage() {
        NetworkManager.shared().requestHomePage(success: { plants in
            Toast.show(message: plants.plants?.first?.name ?? "BLA", controller: self)
            self.homePage = plants
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
        }) { errorString in
            Toast.show(message: errorString ?? "Error occurred", controller: self)
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
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
            (segue.destination as? DetailViewController)?.model = DetailPageResponse(plant: selectedPlant,
                                                                                     history: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PotOverviewTableViewCell", for: indexPath)
        if let potCell = cell as? PotOverviewTableViewCell {
            potCell.model = homePage?.plants?[indexPath.row]
        }
        return cell
    }


}
