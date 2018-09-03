//
// Created by Swen van Zanten on 02-09-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct VITransactionCollection: Decodable {
    public let totalItems: Int
    public let from: Int
    public let to: Int
    public let items: [VITransaction]
}
