//
// Created by Swen van Zanten on 28-08-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct UnspentOutput: Decodable {

    public let address: String
    public let txid: String
    public let vout: Int
    public let scriptPubKey: String
    public let amount: Double
    public let satoshis: Double
    public let height: Int
    public let confirmations: Int

}
