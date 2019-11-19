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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PotOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "PotOverviewTableViewCell")
        homePage = loadJson(filename: "homepage_example_response")

    }


    func loadJson(filename fileName: String) -> HomePageResponse? {
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
}

extension HomeViewController: UITableViewDelegate {

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
