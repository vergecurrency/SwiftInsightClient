//
// Created by Swen van Zanten on 28-08-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct VIBlock: Decodable {
    public let hash: String
    public let size: Int
    public let height: Int
    public let version: Int
    public let merkleroot: String
    public let tx: [String]
    public let time: Int
    public let nonce: Int
    public let bits: String
    public let difficulty: Double
    public let chainwork: String
    public let confirmations: Int
    public let previousblockhash: String
    public let nextblockhash: String
    public let reward: Int
    public let isMainChain: Bool
    public let poolInfo: VIPoolInfo
}
