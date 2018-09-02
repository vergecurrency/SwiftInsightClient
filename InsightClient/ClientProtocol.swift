//
//  ClientProtocol.swift
//  InsightClient
//
//  Created by Swen van Zanten on 28-08-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation

public protocol ClientProtocol: AccountProtocol, BlockProtocol, TransactionProtocol {
    
    /**
     * Broadcasts transaction and returns the transaction id
     */
    func postTransaction(rawTransaction: String, completion: @escaping (_ transactionId: String?) -> Void)
    
    /**
     * All infos in one
     */
    func getInfo(completion: @escaping (_ info: Info?) -> Void)
    func getDifficulty(completion: @escaping (_ difficulty: String?) -> Void)
    func getBestBlockHash(completion: @escaping (_ hash: String?) -> Void)
    func getLastBlockHash(completion: @escaping (_ hash: LastBlockIdentity?) -> Void)
    
}

public protocol TransactionProtocol {
    
    func getTransaction(id: String, completion: @escaping (_ transaction: Transaction?) -> Void)
    func getTransactions(byBlockhash: String, completion: @escaping (_ transactions: TransactionSummary?) -> Void)
    func getTransactions(byAddress: String, completion: @escaping (_ transactions: TransactionSummary?) -> Void)
    func getTransactions(
        byAddresses: [String],
        from: Int?,
        to: Int?,
        completion: @escaping (_ transactions: TransactionCollection?) -> Void
    )
    
}

public protocol BlockProtocol {
    
    func getBlock(hash: String, completion: @escaping (_ block: Block?) -> Void)
    func getBlock(index: Int, completion: @escaping (_ block: Block?) -> Void)
    func getBlocks(date: Date, limit: Int, completion: @escaping (_ summary: BlockSummary?) -> Void)
    func getBlockHash(index: Int, completion: @escaping (_ hash: String?) -> Void)
    
}

public protocol AccountProtocol {

    func getAddressValidation(address: String, completion: @escaping (_ valid: Bool) -> Void)

    func getAddressDetails(
        address: String,
        showTransactions: Bool?,
        from: Int?,
        to: Int?,
        completion: @escaping (_ summary: AddressSummary?) -> Void
    )
    
    func getBalance(address: String, completion: @escaping (_ amount: Int?) -> Void)
    func getTotalReceived(address: String, completion: @escaping (_ amount: Int?) -> Void)
    func getTotalSent(address: String, completion: @escaping (_ amount: Int?) -> Void)
    func getUnconfirmedBalance(address: String, completion: @escaping (_ amount: Int?) -> Void)
    
    func getUnspentOutputs(address: String, completion: @escaping (_ outputs: [UnspentOutput]) -> Void)
    func getUnspentOutputsFormMultipleAddresses(
        addresses: [String],
        completion: @escaping (_ outputs: [UnspentOutput]) -> Void
    )
    
}
