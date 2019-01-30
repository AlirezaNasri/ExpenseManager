//
//  AppDelegate.swift
//  FinanceManage
//
//  Created by Alireza`s Macbook Pro on 1/29/19.
//  Copyright © 2019 alireza. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if Storage.fileExists("transactions.json", in: .documents) {
            DataProvider.shared.transactions = Storage.retrieve("transactions.json", from: .documents, as: [TransactionStructure].self)
        }

        UIBarButtonItem.appearance().tintColor = .orange

        return true
    }
}

