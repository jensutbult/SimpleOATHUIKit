//
//  AccountTable.swift
//  SimpleOATHUIKit
//
//  Created by Jens Utbult on 2020-06-03.
//  Copyright © 2020 Jens Utbult. All rights reserved.
//


import UIKit

class AccountTable: UITableViewController {
    
    struct Account {
        let name: String
        let issuer: String
    }
    
    var accounts = [Account]()
    
    override func viewWillAppear(_ animated: Bool) {
        accounts.append(Account(name: "Yubikey", issuer: "jens.utbult@yubikey.com"))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = account.issuer
        return cell
    }

}
