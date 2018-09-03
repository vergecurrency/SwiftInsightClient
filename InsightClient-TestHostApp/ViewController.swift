//
//  ViewController.swift
//  InsightClient-TestHostApp
//
//  Created by Swen van Zanten on 28-08-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import UIKit
import InsightClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlSession = URLSession(configuration: .default)
        let client = VIClient(urlSession: urlSession, endpoint: "https://blockexplorer.com/api")

        let address = "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY"

        client.getInfo { info in
            print("Info: ", info ?? "-")
        }

        client.getDifficulty { difficulty in
            print("Difficulty: ", difficulty ?? "-")
        }

        client.getBestBlockHash { hash in
            print("Best Block Hash: ", hash ?? "-")
        }

        client.getLastBlockHash { hash in
            print("Last Block Hash: ", hash ?? "-")
        }

        client.getBalance(address: address) { balance in
            print("Balance: ", balance ?? "-")
        }

        client.getTotalReceived(address: address) { received in
            print("Total received: ", received ?? "-")
        }

        client.getTotalSent(address: address) { sent in
            print("Total sent: ", sent ?? "-")
        }

        client.getUnconfirmedBalance(address: address) { balance in
            print("Unconfirmed balance: ", balance ?? "-")
        }

        client.getAddressValidation(address: address) { valid in
            print("Valid address: ", valid)
        }

        client.getAddressDetails(address: address, showTransactions: true, from: 0, to: 10) { summary in
            print("Address summary: ", summary ?? "-")
        }

        client.getUnspentOutputs(address: address) { outputs in
            print("Outputs: ", outputs)
        }

        client.getUnspentOutputsFormMultipleAddresses(addresses: [address, address]) { outputs in
            print("Multiple outputs: ", outputs)
        }

        let hash = "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a"

        client.getBlock(hash: hash) { block in
            print("Block by hash: ", block ?? "-")
        }

        client.getBlock(index: 539537) { block in
            print(block ?? "-")
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2016-04-22")

        client.getBlocks(date: date!, limit: 3) { summary in
            print(summary ?? "-")
        }

        let id = "d48ef0abb15d56ec94830fe2bf7b1b4a623651536e39b5885a54f2adb1896bb3"

        client.getTransaction(id: id) { transaction in
            print("Transaction: ",  transaction ?? "-")
        }

        client.getTransactions(byBlockhash: hash) { transactions in
            print("Transactions bt hash: ",  transactions ?? "-")
        }

        client.getTransactions(byAddress: address) { transactions in
            print("Transactions bt address: ",  transactions ?? "-")
        }

        client.getTransactions(byAddresses: [address], from: 0, to: 10) { transactions in
            print(transactions ?? "-")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

