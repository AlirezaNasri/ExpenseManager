//
//  AddViewController.swift
//  FinanceManage
//
//  Created by Alireza`s Macbook Pro on 1/29/19.
//  Copyright © 2019 alireza. All rights reserved.
//

import UIKit

protocol AddViewControllerdDelegate: class {
    func submit(transaction: TransactionStructure)
}

enum TransactionType: String, Codable {
    case expense
    case income
}

struct Category: Codable, Equatable {
    let title: String
    let type: TransactionType

    init(title: String, type: TransactionType = .expense) {
        self.type = type
        self.title = title
    }
}

struct TransactionStructure: Codable, Equatable {
    static func == (lhs: TransactionStructure, rhs: TransactionStructure) -> Bool {
        return lhs.type == rhs.type && lhs.amount == rhs.amount && lhs.category == rhs.category
    }

    let type: TransactionType
    let amount: Int
    let category: Category
    let note: String?
}

class AddViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!

    weak var delegate: AddViewControllerdDelegate?
    var categories = DataProvider.shared.categories
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add transaction"

        let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss))
        leftButton.tintColor = .orange
        navigationItem.leftBarButtonItem = leftButton

        hideKeyboardWhenTappedAround()

        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView

        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.borderWidth = 0.5
        noteTextView.layer.cornerRadius = 5
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func submitAction(_ sender: Any) {

        if amountTextField.text?.isEmpty == true || amountTextField.text == "0" || categoryTextField.text?.isEmpty == true {
            showAlert(message: "Fill inputs")
            return
        }

        let category = getNeededCategories()[pickerView.selectedRow(inComponent: 0)]
        let amount = Int(amountTextField.text ?? "0") ?? 0
        let note = noteTextView.text
        let transaction = TransactionStructure(type: category.type, amount: amount, category: category, note: note)
        delegate?.submit(transaction: transaction)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        pickerView.reloadAllComponents()
    }
    
    fileprivate func getNeededCategories() -> [Category] {
        let type: TransactionType = segmentedControl.selectedSegmentIndex == 0 ? .expense : .income

        return categories.filter { (category) -> Bool in
            return category.type == type
        }

    }
}

extension AddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getNeededCategories().count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getNeededCategories()[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = getNeededCategories()[row].title
    }
}
