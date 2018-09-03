//
//  VIBlockProtocol.swift
//  InsightClient
//
//  Created by Swen van Zanten on 03-09-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation

public protocol VIBlockProtocol {
    
    func getBlock(hash: String, completion: @escaping (_ block: VIBlock?) -> Void)
    func getBlock(index: Int, completion: @escaping (_ block: VIBlock?) -> Void)
    func getBlocks(date: Date, limit: Int, completion: @escaping (_ summary: VIBlockSummary?) -> Void)
    func getBlockHash(index: Int, completion: @escaping (_ hash: String?) -> Void)
    
}
