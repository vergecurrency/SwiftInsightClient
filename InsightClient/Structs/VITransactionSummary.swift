//
// Created by Swen van Zanten on 28-08-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct VITransactionSummary: Decodable {
    public let pagesTotal: Int
    public let txs: [VITransaction]
}
