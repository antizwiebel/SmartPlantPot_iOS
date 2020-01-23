//
//  EditPlantFormViewController.swift
//  SmartPot
//
//  Created by Mark on 19.01.20.
//  Copyright © 2020 Mark. All rights reserved.
//

import UIKit
import Eureka

class EditPlantFormViewController: FormViewController {

    var plantModel: Plant?
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateForModel()
    }

    private func updateForModel() {
        guard let plant = plantModel else { return }

        form +++ Section("Plant Data")
            <<< TextRow("plantTitleTextRow"){ row in
                row.title = "Plant Name"
                row.add(rule: RuleMaxLength(maxLength: 20, msg: "Plant name can be no longer than 20 characters!", id: "titleMaxLengthRule"))
                row.placeholder = plant.name ?? "Enter name here"
                row.validationOptions = .validatesOnChange

            }
            .onRowValidationChanged { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                }
            }
            <<< LabelRow("plantTitleErrorTextRow") { row in
                row.hidden = Condition.function(["plantTitleTextRow"], { form in
                    return ((form.rowBy(tag: "plantTitleTextRow") as? TextRow)?.isValid ?? false)
                })
                row.title = "Title can't be more than 20 characters!"
                row.disabled = true
            }.cellUpdate{ (cell, row) in
                cell.tintColor = .orange
            }
        +++ Section("Lower Tresholds")
            <<< StepperRow("temperatureStepper"){
                $0.title = "Temperature Treshold"
                $0.value = Double(plant.temperatureTreshold ?? 15)
                $0.displayValueFor = { value in
                    guard let value = value else { return nil }
                    return "\(Int(value)) °C"
                }
            }
            <<< StepperRow("humidityStepper"){
                $0.title = "Humidity Treshold"
                $0.value = Double(plant.humidityTreshold ?? 20)
                $0.displayValueFor = { value in
                    guard let value = value else { return nil }
                    return "\(Int(value)) %"
                }
            }
        +++ Section()
            <<< ButtonRow("doneButton") {  row in
                row.title = "Done"
                row.disabled = Condition.function(["plantTitleTextRow"], { form in
                    let shouldBeDisabled = !((form.rowBy(tag: "plantTitleTextRow") as? TextRow)?.isValid ?? false)
                    self.doneBarButton?.isEnabled = !shouldBeDisabled
                    return shouldBeDisabled
                })
                row.onCellSelection { cell, row in
                    if !row.isDisabled {
                        self.doneButtonTapped(self)
                    }
                }
            }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {

        if let plantTitle = (form.rowBy(tag: "plantTitleTextRow") as? TextRow)?.value {
            plantModel?.name = plantTitle
        }
        plantModel?.temperatureTreshold = Float((form.rowBy(tag: "temperatureStepper") as? StepperRow)?.value ?? 12)
        plantModel?.humidityTreshold = Float((form.rowBy(tag: "humidityStepper") as? StepperRow)?.value ?? 25)
        if let plant = plantModel {
            NetworkManager.shared().requestPlantUpdate(withPlantModel: plant, success: {
                Toast.show(message: "Successfully updated the plant data.", controller: self)
            }, failure: { error in
                Toast.show(message: "There was an error while updating the plant data. Please try again later.", controller: self)
            })
        }
        navigationController?.popViewController(animated: true)
    }


}
