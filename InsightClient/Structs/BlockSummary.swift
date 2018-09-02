//
// Created by Swen van Zanten on 28-08-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct BlockSummary: Decodable {
    public let blocks: [BlockInfo]
    public let length: Int
    public let pagination: PaginationInfo
}
