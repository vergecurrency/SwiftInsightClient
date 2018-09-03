//
//  VIAccountProtocol.swift
//  InsightClient
//
//  Created by Swen van Zanten on 03-09-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation

public protocol VIAccountProtocol {
    
    func getAddressValidation(address: String, completion: @escaping (_ valid: Bool) -> Void)
    
    func getAddressDetails(
        address: String,
        showTransactions: Bool?,
        from: Int?,
        to: Int?,
        completion: @escaping (_ summary: VIAddressSummary?) -> Void
    )
    
    func getBalance(address: String, completion: @escaping (_ amount: Int?) -> Void)
    func getTotalReceived(address: String, completion: @escaping (_ amount: Int?) -> Void)
    func getTotalSent(address: String, completion: @escaping (_ amount: Int?) -> Void)
    func getUnconfirmedBalance(address: String, completion: @escaping (_ amount: Int?) -> Void)
    
    func getUnspentOutputs(address: String, completion: @escaping (_ outputs: [VIUnspentOutput]) -> Void)
    func getUnspentOutputsFormMultipleAddresses(
        addresses: [String],
        completion: @escaping (_ outputs: [VIUnspentOutput]) -> Void
    )
    
}
