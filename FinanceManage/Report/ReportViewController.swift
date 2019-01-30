//
//  ReportViewController.swift
//  FinanceManage
//
//  Created by Alireza`s Macbook Pro on 1/29/19.
//  Copyright © 2019 alireza. All rights reserved.
//

import UIKit
import PieCharts

class ReportViewController: UIViewController {

    @IBOutlet weak var chartView: PieChart!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
        chartView.delegate = self
        createModels()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        createModels()
    }

    fileprivate func createModels() {
        chartView.clear()
        chartView.layers = [createPlainTextLayer()]
        let model = getNeededTransations().map { (transaction) -> PieSliceModel in
            return PieSliceModel(value: Double(transaction.amount), color: UIColor().randomColor, obj: transaction)
        }
        chartView.models = model
    }

    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {

        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 75
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }

        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }

    fileprivate func getNeededTransations() -> [TransactionStructure] {
        let type: TransactionType = segmentedControl.selectedSegmentIndex == 0 ? .expense : .income
        var sameCatTransactions: [String: [TransactionStructure]] = [:]

        let transactions = DataProvider.shared.transactions.filter { (transaction) -> Bool in
            return transaction.type == type
        }

        for transaction in transactions {
            sameCatTransactions[transaction.category.title] = [TransactionStructure]()
        }

        for transaction in transactions {
            sameCatTransactions[transaction.category.title]?.append(transaction)
        }

        let returnValue = sameCatTransactions.map { (key, value) -> TransactionStructure in
            let amount = value.reduce(0, { (result, tr) -> Int in
                return result + tr.amount
            })
            return TransactionStructure(type: type, amount: amount, category: Category(title: key, type: type), note: nil)
        }

        return returnValue
    }

}

extension ReportViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNeededTransations().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = getNeededTransations()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = transaction.category.title
        cell.detailTextLabel?.text = "\(transaction.amount)"
        cell.detailTextLabel?.textColor = transaction.type == .expense ? .red : .green
        return cell
    }
}

extension ReportViewController: PieChartDelegate {
    func onSelected(slice: PieSlice, selected: Bool) {
        guard let transaction = slice.data.model.obj as? TransactionStructure else { return }
        
        let index = getNeededTransations().firstIndex { (tr) -> Bool in
            return tr == transaction
        }

        if let index = index {
            let indexPath = IndexPath(row: index, section: 0)
            if selected {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

    }
}


extension UIColor {
    var randomColor: UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
