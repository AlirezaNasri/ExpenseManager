//
//  TransactionTableViewCell.swift
//  FinanceManage
//
//  Created by Alireza`s Macbook Pro on 1/29/19.
//  Copyright © 2019 alireza. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func update(transaction: TransactionStructure) {
        colorView.backgroundColor = transaction.type == .expense ? .red : .green
        categoryLabel.text = transaction.category.title
        noteLabel.text = transaction.note ?? ""
        priceLabel.text = "\(transaction.amount)"
    }
    
}
