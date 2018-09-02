//
// Created by Swen van Zanten on 02-09-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct BlockInfo: Decodable {
    public let height: Int
    public let size: Int
    public let hash: String
    public let time: Int
    public let txlength: Int
    public let poolInfo: PoolInfo
}
