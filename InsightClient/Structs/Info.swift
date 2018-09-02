//
// Created by Swen van Zanten on 28-08-18.
// Copyright (c) 2018 Verge Currency. All rights reserved.
//

import Foundation

public struct Info: Decodable {

    /// Overriding the property names, with custom property names
    /// when the json field is different, requires defining a `CodingKeys`
    /// enum and providing a case for each property. The case itself should
    /// match the property, and its rawValue of type string, should correspond
    /// to the JSON field name.
    enum CodingKeys: String, CodingKey {
        case version
        case protocolversion
        case blocks
        case timeoffset
        case connections
        case proxy
        case difficulty
        case testnet
        case relayfee
        case errors
        case network
    }

    /// Nested Fields require defining a custom CodingKey enum
    /// for each nested field, to allow you to manually pull out
    /// the values from the key in the `Decodable` initializer.
    enum InfoKeys: String, CodingKey {
        case info
    }

    /// Nested Properties inside a keypath
    /// such as "products" key containing all of the
    /// properties for a product, requires overriding the
    /// `Decodable` protocol's initializer and manually
    /// pulling out the values from the top level key, and then
    /// manually decoding each value and providing their type.
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: InfoKeys.self)
        let infoValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .info)
        version = try infoValues.decode(Int.self, forKey: .version)
        protocolversion = try infoValues.decode(Int.self, forKey: .protocolversion)
        blocks = try infoValues.decode(Int.self, forKey: .blocks)
        timeoffset = try infoValues.decode(Int.self, forKey: .timeoffset)
        connections = try infoValues.decode(Int.self, forKey: .connections)
        proxy = try infoValues.decode(String.self, forKey: .proxy)
        difficulty = try infoValues.decode(Double.self, forKey: .difficulty)
        testnet = try infoValues.decode(Bool.self, forKey: .testnet)
        relayfee = try infoValues.decode(Double.self, forKey: .relayfee)
        errors = try infoValues.decode(String.self, forKey: .errors)
        network = try infoValues.decode(String.self, forKey: .network)
    }

    public let version: Int
    public let protocolversion: Int
    public let blocks: Int
    public let timeoffset: Int
    public let connections: Int
    public let proxy: String
    public let difficulty: Double
    public let testnet: Bool
    public let relayfee: Double
    public let errors: String
    public let network: String
}
