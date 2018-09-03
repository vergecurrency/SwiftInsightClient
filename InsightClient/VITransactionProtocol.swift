//
//  VITransactionProtocol.swift
//  InsightClient
//
//  Created by Swen van Zanten on 03-09-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation

public protocol VITransactionProtocol {
    
    func getTransaction(id: String, completion: @escaping (_ transaction: VITransaction?) -> Void)
    func getTransactions(byBlockhash: String, completion: @escaping (_ transactions: VITransactionSummary?) -> Void)
    func getTransactions(byAddress: String, completion: @escaping (_ transactions: VITransactionSummary?) -> Void)
    func getTransactions(
        byAddresses: [String],
        from: Int?,
        to: Int?,
        completion: @escaping (_ transactions: VITransactionCollection?) -> Void
    )
    
}
