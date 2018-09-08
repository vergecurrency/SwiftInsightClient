//
//  VIClientProtocol.swift
//  InsightClient
//
//  Created by Swen van Zanten on 28-08-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation

public protocol VIClientProtocol: VIAccountProtocol, VIBlockProtocol, VITransactionProtocol {
    
    /**
     * Broadcasts transaction and returns the transaction id
     */
    func postTransaction(rawTransaction: String, completion: @escaping (_ transactionId: String?) -> Void)
    
    /**
     * All infos in one
     */
    func getInfo(completion: @escaping (_ info: VIInfo?) -> Void)
    func getDifficulty(completion: @escaping (_ difficulty: Double?) -> Void)
    func getBestBlockHash(completion: @escaping (_ hash: String?) -> Void)
    func getLastBlockHash(completion: @escaping (_ hash: VILastBlockIdentity?) -> Void)
    
}
