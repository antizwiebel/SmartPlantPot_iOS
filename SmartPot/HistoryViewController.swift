//
//  SecondViewController.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var historyPage: HistoryPageResponse?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "History"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartTableViewCell")
        historyPage = loadJson(filename: "history_example_response")

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
    }

    extension HistoryViewController: UITableViewDelegate {

    }

    extension HistoryViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3//(historyPage?.historyObjects.count ?? 0) * 3
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
            if let potCell = cell as? ChartTableViewCell {
                if indexPath.row % 3 == 0 {
                    let model = ChartTableViewCell.Model(title: "Temperature", dataPoints: historyPage?.historyObjects[0].temperatures, treshold: Double(historyPage?.historyObjects[0].temperatureTreshold ?? 0))
                    potCell.model = model
                } else if indexPath.row % 3 == 1 {
                    let model = ChartTableViewCell.Model(title: "Humidity", dataPoints: historyPage?.historyObjects[0].humidities, treshold: Double(historyPage?.historyObjects[0].humidityTreshold ?? 0))
                    potCell.model = model
                } else  {
                    let model = ChartTableViewCell.Model(title: "Water", dataPoints: historyPage?.historyObjects[0].water, treshold: nil)
                    potCell.model = model
                }
            }
            return cell
        }


    }
