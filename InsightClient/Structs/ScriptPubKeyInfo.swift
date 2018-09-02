//
// Created by Swen van Zanten on 02-09-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct ScriptPubKeyInfo: Decodable {
    public let hex: String
    public let asm: String
}
