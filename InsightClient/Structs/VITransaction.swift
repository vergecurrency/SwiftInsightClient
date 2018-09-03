//
//  Transaction.swift
//  InsightClient
//
//  Created by Swen van Zanten on 28-08-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct VITransaction: Decodable {
    public let txid: String
    public let version: Int
    public let locktime: Int
    public let blockhash: String
    public let blockheight: Int
    public let confirmations: Int
    public let time: Int
    public let blocktime: Int
    public let isCoinBase: Bool?
    public let valueOut: Double
    public let size: Int
    public let valueIn: Double?
    public let fees: Int?
}
