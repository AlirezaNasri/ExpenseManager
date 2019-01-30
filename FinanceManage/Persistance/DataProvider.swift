//
//  DataProvider.swift
//  FinanceManage
//
//  Created by Alireza`s Macbook Pro on 1/29/19.
//  Copyright © 2019 alireza. All rights reserved.
//

import Foundation


class DataProvider {
    private init() {}
    static let shared = DataProvider()

    let categories: [Category] = [Category(title: "General"),
                                  Category(title: "Drinks"),
                                  Category(title: "Food"),
                                  Category(title: "Car"),
                                  Category(title: "Transport"),
                                  Category(title: "Personal"),
                                  Category(title: "Entertainment"),
                                  Category(title: "Travel"),
                                  Category(title: "Cloting"),
                                  Category(title: "Health"),
                                  Category(title: "Utilities"),
                                  Category(title: "Drinks"),
                                  Category(title: "Salary",type: .income),
                                  Category(title: "Savings",type: .income),
                                  Category(title: "Allowance",type: .income),
                                  Category(title: "General",type: .income)]

    var transactions = [TransactionStructure]() {
        didSet {
            Storage.store(transactions, to: .documents, as: "transactions.json")
        }
    }

}
