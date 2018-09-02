//
// Created by Swen van Zanten on 02-09-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct PaginationInfo: Decodable {
    public let next: String
    public let prev: String
    public let currentTs: Int
    public let current: String
    public let isToday:Bool
    public let more: Bool
    public let moreTs: Int
}
