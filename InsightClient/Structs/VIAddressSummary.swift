//
// Created by Swen van Zanten on 28-08-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct VIAddressSummary: Decodable {

    enum AddressSummaryKeys: String, CodingKey {
        case addrStr
        case balance
        case balanceSat
        case totalReceived
        case totalReceivedSat
        case totalSent
        case totalSentSat
        case unconfirmedBalance
        case unconfirmedBalanceSat
        case unconfirmedTxApperances
        case txApperances
        case transactions = "transaction"
    }

    public let addrStr: String
    public let balance: Double
    public let balanceSat: Int
    public let totalReceived: Double
    public let totalReceivedSat: Int
    public let totalSent: Double
    public let totalSentSat: Int
    public let unconfirmedBalance: Double
    public let unconfirmedBalanceSat: Int
    public let unconfirmedTxApperances: Int
    public let txApperances: Int
    public let transactions: [String]?
}
