//
//  Client.swift
//  InsightClient
//
//  Created by Swen van Zanten on 28-08-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Client: ClientProtocol {

    var urlSession: URLSession!
    var endpoint: String!

    public init(urlSession: URLSession, endpoint: String) {
        self.urlSession = urlSession
        self.endpoint = endpoint
    }

    public func postTransaction(rawTransaction: String, completion: @escaping (String?) -> Void) {
        let parameterDictionary = ["rawtx" : rawTransaction]
        let url = self.url("/api/tx/send")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody

        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let _ = error{
                return completion(nil)
            }

            if data == nil {
                return completion(nil)
            }

            guard let json = try? JSON(data: data!) else {
                return completion(nil)
            }

            completion(json["txid"].stringValue)
        }

        task.resume()
    }

    public func getInfo(completion: @escaping (Info?) -> Void) {
        get(url: url("/status?q=getInfo")) { data in
            completion(self.decodeJson(Info.self, from: data, default: []) as? Info)
        }
    }

    public func getDifficulty(completion: @escaping (String?) -> Void) {
        get(url: url("/status?q=getDifficulty")) { data in
            guard let json = try? JSON(data: data ?? Data()) else {
                return completion(nil)
            }

            completion(json["difficulty"].stringValue)
        }
    }

    public func getBestBlockHash(completion: @escaping (String?) -> Void) {
        get(url: url("/status?q=getBestBlockHash")) { data in
            guard let json = try? JSON(data: data ?? Data()) else {
                return completion(nil)
            }

            completion(json["bestblockhash"].stringValue)
        }
    }

    public func getLastBlockHash(completion: @escaping (LastBlockIdentity?) -> Void) {
        get(url: url("/status?q=getLastBlockHash")) { data in
            completion(self.decodeJson(LastBlockIdentity.self, from: data, default: []) as? LastBlockIdentity)
        }
    }

    public func getAddressValidation(address: String, completion: @escaping (Bool) -> Void) {
        get(url: url("/addr-validate/\(address)")) { data in
            completion(String(data: data ?? Data(), encoding: .utf8) == "true")
        }
    }

    public func getAddressDetails(
        address: String,
        showTransactions: Bool? = true,
        from: Int? = 0,
        to: Int? = 0,
        completion: @escaping (AddressSummary?) -> Void
    ) {
        let noTxList = (showTransactions ?? true) ? "0" : "1"
        let f = from ?? 0
        let t = to ?? 0

        get(url: url("/addr/\(address)?from=\(f)&to=\(t)&noTxList=\(noTxList)")) { data in
            completion(self.decodeJson(AddressSummary.self, from: data, default: []) as? AddressSummary)
        }
    }

    public func getBalance(address: String, completion: @escaping (Int?) -> Void) {
        get(url: url("/addr/\(address)/balance")) { data in
            completion(Int(String(data: data ?? Data(), encoding: .utf8) ?? "0"))
        }
    }

    public func getTotalReceived(address: String, completion: @escaping (Int?) -> Void) {
        get(url: url("/addr/\(address)/totalReceived")) { data in
            completion(Int(String(data: data ?? Data(), encoding: .utf8) ?? "0"))
        }
    }

    public func getTotalSent(address: String, completion: @escaping (Int?) -> Void) {
        get(url: url("/addr/\(address)/totalSent")) { data in
            completion(Int(String(data: data ?? Data(), encoding: .utf8) ?? "0"))
        }
    }

    public func getUnconfirmedBalance(address: String, completion: @escaping (Int?) -> Void) {
        get(url: url("/addr/\(address)/unconfirmedBalance")) { data in
            completion(Int(String(data: data ?? Data(), encoding: .utf8) ?? "0"))
        }
    }

    public func getUnspentOutputs(address: String, completion: @escaping ([UnspentOutput]) -> Void) {
        get(url: url("/addr/\(address)/utxo")) { data in
            completion(self.decodeJson([UnspentOutput].self, from: data, default: []) as! [UnspentOutput])
        }
    }

    public func getUnspentOutputsFormMultipleAddresses(
        addresses: [String],
        completion: @escaping ([UnspentOutput]) -> Void
    ) {
        get(url: url("/addrs/\(addresses.joined(separator: ","))/utxo")) { data in
            completion(self.decodeJson([UnspentOutput].self, from: data, default: []) as! [UnspentOutput])
        }
    }

    public func getBlock(hash: String, completion: @escaping (Block?) -> Void) {
        get(url: url("/block/\(hash)")) { data in
            completion(self.decodeJson(Block.self, from: data, default: nil) as? Block)
        }
    }

    public func getBlock(index: Int, completion: @escaping (Block?) -> Void) {
        getBlockHash(index: index) { hash in
            if let hash = hash {
                self.getBlock(hash: hash) { block in
                    completion(block)
                }
            }

            completion(nil)
        }
    }

    public func getBlocks(date: Date, limit: Int = 0, completion: @escaping (BlockSummary?) -> Void) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"

        var url = "/blocks?blockDate=\(dateformatter.string(from: date))"
        if limit > 0 {
            url += "&limit=\(limit)"
        }

        get(url: self.url(url)) { data in
            completion(self.decodeJson(BlockSummary.self, from: data, default: nil) as? BlockSummary)
        }
    }

    public func getBlockHash(index: Int, completion: @escaping (String?) -> Void) {
        get(url: url("/block-index/\(index)")) { data in
            do {
                if let data = data {
                    let json = try JSON(data: data)
                    completion(json["blockHash"].stringValue)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error info: \(error)")
                completion(nil)
            }
        }
    }

    public func getTransaction(id: String, completion: @escaping (Transaction?) -> Void) {
        get(url: self.url("/tx/\(id)")) { data in
            completion(self.decodeJson(Transaction.self, from: data, default: nil) as? Transaction)
        }
    }

    public func getTransactions(byBlockhash: String, completion: @escaping (TransactionSummary?) -> Void) {
        get(url: self.url("/txs?block=\(byBlockhash)")) { data in
            completion(self.decodeJson(TransactionSummary.self, from: data, default: nil) as? TransactionSummary)
        }
    }

    public func getTransactions(byAddress: String, completion: @escaping (TransactionSummary?) -> Void) {
        get(url: self.url("/txs?address=\(byAddress)")) { data in
            completion(self.decodeJson(TransactionSummary.self, from: data, default: nil) as? TransactionSummary)
        }
    }

    public func getTransactions(
        byAddresses: [String],
        from: Int? = 0,
        to: Int? = 10,
        completion: @escaping (TransactionCollection?) -> Void
    ) {
        var url = "/addrs/\(byAddresses.joined(separator: ","))/txs"
        if let from = from {
            url += "?from=\(from)&to=\(to ?? from + 10)"
        }

        get(url: self.url(url)) { data in
            completion(self.decodeJson(TransactionCollection.self, from: data, default: nil) as? TransactionCollection)
        }
    }

    private func decodeJson<T: Decodable>(_ type: T.Type, from: Data?, default: Any?) -> Any? {
        do {
            if let data = from {
                return try JSONDecoder().decode(type, from: data)
            }

            return `default`
        } catch {
            print("Error info: \(error)")
            return `default`
        }
    }

    private func get(url: URL, completion: @escaping (_ data: Data?) -> Void) {
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                return completion(nil)
            }

            completion(data)
        }

        task.resume()
    }

    // Create the url with the added uri.
    private func url(_ uri: String) -> URL {
        return URL(string: "\(endpoint!)\(uri)")!
    }
}
