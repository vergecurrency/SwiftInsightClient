//
//  InsightClientTests.swift
//  InsightClientTests
//
//  Created by Swen van Zanten on 28-08-18.
//  Copyright © 2018 Verge Currency. All rights reserved.
//

import XCTest
@testable import InsightClient

class InsightClientTests: XCTestCase {

    var client: Client!
    let session = MockURLSession()

    override func setUp() {
        super.setUp()
        client = Client(urlSession: session, endpoint: "https://blockexplorer.com/api")
    }
    
    func testGetInfo() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json = "{\"info\": {\"version\": 120100,\"protocolversion\": 70012,\"blocks\": 539681,\"timeoffset\": 0," +
            "\"connections\": 108,\"proxy\": \"\",\"difficulty\": 6727225469722.534,\"testnet\": false," +
            "\"relayfee\": 0.00001,\"errors\": \"Warning: unknown new rules activated (versionbit 1)\"," +
            "\"network\": \"livenet\"}}"
        let data = json.data(using: .utf8)!
        session.nextData = data
        session.nextError = nil

        client.getInfo { info in
            XCTAssert(info?.version == 120100)
            XCTAssert(info?.protocolversion == 70012)
            XCTAssert(info?.blocks == 539681)
            XCTAssert(info?.timeoffset == 0)
            XCTAssert(info?.connections == 108)
            XCTAssert(info?.proxy == "")
            XCTAssert(info?.difficulty == 6727225469722.534)
            XCTAssert(info?.testnet == false)
            XCTAssert(info?.relayfee == 0.00001)
            XCTAssert(info?.errors == "Warning: unknown new rules activated (versionbit 1)")
            XCTAssert(info?.network == "livenet")
        }

        XCTAssert(session.lastURL?.absoluteString == "https://blockexplorer.com/api/status?q=getInfo")
    }

    func testGetNoInfo() {
        session.nextData = nil
        client.getInfo { info in
            XCTAssert(info == nil)
        }
    }

    func testGetDifficulty() {
        let json = "{\"difficulty\": 6727225469722.534}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getDifficulty { difficulty in
            XCTAssert(difficulty == "6727225469722.534")
        }
    }

    func testGetNoDifficulty() {
        session.nextData = nil

        client.getDifficulty { difficulty in
            XCTAssert(difficulty == nil)
        }
    }

    func testGetBestBlockHash() {
        let json = "{\"bestblockhash\": \"0000000000000000001e70e39910e8b724879ad20c01d86f53621827e31d7b80\"}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getBestBlockHash { hash in
            XCTAssert(hash == "0000000000000000001e70e39910e8b724879ad20c01d86f53621827e31d7b80")
        }
    }

    func testGetNoBestBlockHash() {
        session.nextData = nil

        client.getBestBlockHash { hash in
            XCTAssert(hash == nil)
        }
    }

    func testGetLastBlockHash() {
        let json = "{\"syncTipHash\": \"0000000000000000001d729a8cb87e9454a502927eaed316c4ab823d9ef38d85\"," +
            "\"lastblockhash\": \"0000000000000000001d729a8cb87e9454a502927eaed316c4ab823d9ef38d85\"}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getLastBlockHash { identity in
            XCTAssert(identity?.syncTipHash == "0000000000000000001d729a8cb87e9454a502927eaed316c4ab823d9ef38d85")
            XCTAssert(identity?.lastblockhash == "0000000000000000001d729a8cb87e9454a502927eaed316c4ab823d9ef38d85")
        }
    }

    func testGetNoLastBlockHash() {
        session.nextData = nil

        client.getLastBlockHash { identity in
            XCTAssert(identity == nil)
        }
    }

    func testGetAddressValidatedTrue() {
        let json = "true"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getAddressValidation(address: "1234") { valid in
            XCTAssert(valid == true)
        }
    }

    func testGetAddressValidatedFalse() {
        let json = "false"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getAddressValidation(address: "1234") { valid in
            XCTAssert(valid == false)
        }
    }

    func testGetAddressValidatedFalseFromNil() {
        session.nextData = nil

        client.getAddressValidation(address: "1234") { valid in
            XCTAssert(valid == false)
        }
    }

    func testGetAddressDetails() {
        let json = "{\"addrStr\":\"19SokJG7fgk8iTjemJ2obfMj14FM16nqzj\",\"balance\":0,\"balanceSat\":0," +
            "\"totalReceived\":112.91089695,\"totalReceivedSat\":11291089695,\"totalSent\":112.91089695," +
            "\"totalSentSat\":11291089695,\"unconfirmedBalance\":0,\"unconfirmedBalanceSat\":0," +
            "\"unconfirmedTxApperances\":0,\"txApperances\":364," +
            "\"transactions\":[\"a2afb522edeba67ae593c683154da45b231d59ffccd18806cec38ecd21994a2d\"," +
            "\"28ccc7fe617451a4d15b8cea64a6ac222600e2877073ba543d83225a354975ac\"]}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getAddressDetails(address: "1234") { summary in
            XCTAssert(summary?.addrStr == "19SokJG7fgk8iTjemJ2obfMj14FM16nqzj")
            XCTAssert(summary?.balance == 0)
            XCTAssert(summary?.balanceSat == 0)
            XCTAssert(summary?.totalReceived == 112.91089695)
            XCTAssert(summary?.totalReceivedSat == 11291089695)
            XCTAssert(summary?.totalSent == 112.91089695)
            XCTAssert(summary?.totalSentSat == 11291089695)
            XCTAssert(summary?.unconfirmedBalance == 0)
            XCTAssert(summary?.unconfirmedBalanceSat == 0)
            XCTAssert(summary?.unconfirmedTxApperances == 0)
            XCTAssert(summary?.txApperances == 364)
            XCTAssert(summary?.transactions?.first == "a2afb522edeba67ae593c683154da45b231d59ffccd18806cec38ecd21994a2d")
            XCTAssert(summary?.transactions?.last == "28ccc7fe617451a4d15b8cea64a6ac222600e2877073ba543d83225a354975ac")

            XCTAssert(self.session.lastURL?.absoluteString == "https://blockexplorer.com/api/addr/1234?from=0&to=0&noTxList=0")
        }
    }

    func testGetAddressDetailsWithoutTransactions() {
        let json = "{\"addrStr\":\"19SokJG7fgk8iTjemJ2obfMj14FM16nqzj\",\"balance\":0,\"balanceSat\":0," +
            "\"totalReceived\":112.91089695,\"totalReceivedSat\":11291089695,\"totalSent\":112.91089695," +
            "\"totalSentSat\":11291089695,\"unconfirmedBalance\":0,\"unconfirmedBalanceSat\":0," +
            "\"unconfirmedTxApperances\":0,\"txApperances\":364}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getAddressDetails(address: "1234", showTransactions: false) { summary in
            XCTAssert(summary?.addrStr == "19SokJG7fgk8iTjemJ2obfMj14FM16nqzj")
            XCTAssert(summary?.balance == 0)
            XCTAssert(summary?.balanceSat == 0)
            XCTAssert(summary?.totalReceived == 112.91089695)
            XCTAssert(summary?.totalReceivedSat == 11291089695)
            XCTAssert(summary?.totalSent == 112.91089695)
            XCTAssert(summary?.totalSentSat == 11291089695)
            XCTAssert(summary?.unconfirmedBalance == 0)
            XCTAssert(summary?.unconfirmedBalanceSat == 0)
            XCTAssert(summary?.unconfirmedTxApperances == 0)
            XCTAssert(summary?.txApperances == 364)
            XCTAssert(summary?.transactions == nil)

            XCTAssert(self.session.lastURL?.absoluteString == "https://blockexplorer.com/api/addr/1234?from=0&to=0&noTxList=1")
        }
    }

    func testGetAddressDetailsFiltered() {
        let json = "{\"addrStr\":\"19SokJG7fgk8iTjemJ2obfMj14FM16nqzj\",\"balance\":0,\"balanceSat\":0," +
            "\"totalReceived\":112.91089695,\"totalReceivedSat\":11291089695,\"totalSent\":112.91089695," +
            "\"totalSentSat\":11291089695,\"unconfirmedBalance\":0,\"unconfirmedBalanceSat\":0," +
            "\"unconfirmedTxApperances\":0,\"txApperances\":364}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getAddressDetails(address: "1234", showTransactions: false, from: 12, to: 22) { summary in
            XCTAssert(self.session.lastURL?.absoluteString == "https://blockexplorer.com/api/addr/1234?from=12&to=22&noTxList=1")
        }
    }

    func testGetNoAddressDetails() {
        session.nextData = nil

        client.getAddressDetails(address: "1234") { summary in
            XCTAssert(summary == nil)
        }
    }

    func testGetBalance() {
        let json = "323223"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getBalance(address: "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY") { balance in
            XCTAssert(balance == 323223)
        }
    }

    func testGetNoBalance() {
        session.nextData = nil

        client.getBalance(address: "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY") { balance in
            XCTAssert(balance == nil)
        }
    }

    func testGetTotalReceived() {
        let json = "23453454"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getTotalReceived(address: "1234") { received in
            XCTAssert(received == 23453454)
        }
    }

    func testGetNoTotalReceived() {
        session.nextData = nil

        client.getTotalReceived(address: "1234") { received in
            XCTAssert(received == nil)
        }
    }

    func testGetTotalSent() {
        let json = "23453454"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getTotalSent(address: "1234") { sent in
            XCTAssert(sent == 23453454)
        }
    }

    func testGetNoTotalSent() {
        session.nextData = nil

        client.getTotalSent(address: "1234") { sent in
            XCTAssert(sent == nil)
        }
    }

    func testGetUnconfirmedBalance() {
        let json = "23453454"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getUnconfirmedBalance(address: "1234") { balance in
            XCTAssert(balance == 23453454)
        }
    }

    func testGetNoUnconfirmedBalance() {
        session.nextData = nil

        client.getUnconfirmedBalance(address: "1234") { balance in
            XCTAssert(balance == nil)
        }
    }

    func testGetUnspentOutputs() {
        let json = "[{\"address\":\"1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY\"," +
            "\"txid\":\"0f5e48bdd5c07f1b667d2be102bc90479995695de76ba8db21740a842e865d79\",\"vout\":0," +
            "\"scriptPubKey\":\"76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac\",\"amount\":12.86780324," +
            "\"satoshis\":1286780324,\"height\":539805,\"confirmations\":8}," +
            "{\"address\":\"1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY\"," +
            "\"txid\":\"73c6542e8c4b3bb0ff91f1d26fb258439316b6d24a715aa73d5c5120df24a85c\",\"vout\":0," +
            "\"scriptPubKey\":\"76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac\",\"amount\":13.1123148," +
            "\"satoshis\":1311231480,\"height\":539794,\"confirmations\":19}]"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getUnspentOutputs(address: "1234") { outputs in
            XCTAssert(outputs.first?.address == "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY")
            XCTAssert(outputs.first?.txid == "0f5e48bdd5c07f1b667d2be102bc90479995695de76ba8db21740a842e865d79")
            XCTAssert(outputs.first?.vout == 0)
            XCTAssert(outputs.first?.scriptPubKey == "76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac")
            XCTAssert(outputs.first?.amount == 12.86780324)
            XCTAssert(outputs.first?.satoshis == 1286780324)
            XCTAssert(outputs.first?.height == 539805)
            XCTAssert(outputs.first?.confirmations == 8)

            XCTAssert(outputs.last?.address == "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY")
            XCTAssert(outputs.last?.txid == "73c6542e8c4b3bb0ff91f1d26fb258439316b6d24a715aa73d5c5120df24a85c")
            XCTAssert(outputs.last?.vout == 0)
            XCTAssert(outputs.last?.scriptPubKey == "76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac")
            XCTAssert(outputs.last?.amount == 13.1123148)
            XCTAssert(outputs.last?.satoshis == 1311231480)
            XCTAssert(outputs.last?.height == 539794)
            XCTAssert(outputs.last?.confirmations == 19)
        }
    }

    func testGetNoUnspentOutputs() {
        session.nextData = nil

        client.getUnspentOutputs(address: "1234") { outputs in
            XCTAssert(outputs.count == 0)
        }
    }

    func testGetUnspentOutputsFormMultipleAddresses() {
        let json = "[{\"address\":\"1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY\"," +
            "\"txid\":\"0f5e48bdd5c07f1b667d2be102bc90479995695de76ba8db21740a842e865d79\",\"vout\":0," +
            "\"scriptPubKey\":\"76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac\",\"amount\":12.86780324," +
            "\"satoshis\":1286780324,\"height\":539805,\"confirmations\":8}," +
            "{\"address\":\"1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY\"," +
            "\"txid\":\"73c6542e8c4b3bb0ff91f1d26fb258439316b6d24a715aa73d5c5120df24a85c\",\"vout\":0," +
            "\"scriptPubKey\":\"76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac\",\"amount\":13.1123148," +
            "\"satoshis\":1311231480,\"height\":539794,\"confirmations\":19}]"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getUnspentOutputsFormMultipleAddresses(addresses: ["1234","2345"]) { outputs in
            XCTAssert(outputs.first?.address == "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY")
            XCTAssert(outputs.first?.txid == "0f5e48bdd5c07f1b667d2be102bc90479995695de76ba8db21740a842e865d79")
            XCTAssert(outputs.first?.vout == 0)
            XCTAssert(outputs.first?.scriptPubKey == "76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac")
            XCTAssert(outputs.first?.amount == 12.86780324)
            XCTAssert(outputs.first?.satoshis == 1286780324)
            XCTAssert(outputs.first?.height == 539805)
            XCTAssert(outputs.first?.confirmations == 8)

            XCTAssert(outputs.last?.address == "1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY")
            XCTAssert(outputs.last?.txid == "73c6542e8c4b3bb0ff91f1d26fb258439316b6d24a715aa73d5c5120df24a85c")
            XCTAssert(outputs.last?.vout == 0)
            XCTAssert(outputs.last?.scriptPubKey == "76a914c825a1ecf2a6830c4401620c3a16f1995057c2ab88ac")
            XCTAssert(outputs.last?.amount == 13.1123148)
            XCTAssert(outputs.last?.satoshis == 1311231480)
            XCTAssert(outputs.last?.height == 539794)
            XCTAssert(outputs.last?.confirmations == 19)
        }
    }

    func testGetNoUnspentOutputsFormMultipleAddresses() {
        session.nextData = nil

        client.getUnspentOutputsFormMultipleAddresses(addresses: ["1234"]) { outputs in
            XCTAssert(outputs.count == 0)
        }
    }

    func testGetBlockByHash() {
        let json = "{\"hash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\",\"size\":479," +
            "\"height\":371623,\"version\":3,\"merkleroot\":\"01a5f8b432e06c11a32b3f30e6cc9a12da207b9237fddf77850801275cf4fe01\"," +
            "\"tx\":[\"ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888\"," +
            "\"29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10\"],\"time\":1440604813," +
            "\"nonce\":3431621579,\"bits\":\"181443c4\",\"difficulty\":54256630327.88996," +
            "\"chainwork\":\"0000000000000000000000000000000000000000000998b7adec271cd0ea7258\"," +
            "\"confirmations\":168192,\"previousblockhash\":\"0000000000000000027d0985fef71cbc05a5ee5cdbdc4c6baf2307e6c5db8591\"," +
            "\"nextblockhash\":\"000000000000000013677449d7375ed22f9c66a94940328081412179795a1ac5\",\"reward\":25," +
            "\"isMainChain\":true,\"poolInfo\":{}}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getBlock(hash: "1234") { block in
            XCTAssert(block?.hash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(block?.size == 479)
            XCTAssert(block?.height == 371623)
            XCTAssert(block?.version == 3)
            XCTAssert(block?.merkleroot == "01a5f8b432e06c11a32b3f30e6cc9a12da207b9237fddf77850801275cf4fe01")
            XCTAssert(block?.tx == [
                "ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888",
                "29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10"
            ])
            XCTAssert(block?.time == 1440604813)
            XCTAssert(block?.nonce == 3431621579)
            XCTAssert(block?.bits == "181443c4")
            XCTAssert(block?.difficulty == 54256630327.88996)
            XCTAssert(block?.chainwork == "0000000000000000000000000000000000000000000998b7adec271cd0ea7258")
            XCTAssert(block?.confirmations == 168192)
            XCTAssert(block?.previousblockhash == "0000000000000000027d0985fef71cbc05a5ee5cdbdc4c6baf2307e6c5db8591")
            XCTAssert(block?.nextblockhash == "000000000000000013677449d7375ed22f9c66a94940328081412179795a1ac5")
            XCTAssert(block?.reward == 25)
            XCTAssert(block?.isMainChain == true)
        }
    }

    func testGetNoBlockByHash() {
        session.nextData = nil

        client.getBlock(hash: "1234") { block in
            XCTAssert(block == nil)
        }
    }

    func testGetBlockHash() {
        let json = "{\"blockHash\":\"00000000000000000009b799741b20493b39de585d19d014422beb81699f4761\"}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getBlockHash(index: 12344) { hash in
            XCTAssert(hash == "00000000000000000009b799741b20493b39de585d19d014422beb81699f4761")
        }
    }

    func testGetNoBlockHash() {
        session.nextData = nil

        client.getBlockHash(index: 1234) { hash in
            XCTAssert(hash == nil)
        }
    }

    func testGetTransaction() {
        let json = "{\"txid\":\"d48ef0abb15d56ec94830fe2bf7b1b4a623651536e39b5885a54f2adb1896bb3\",\"version\":2," +
            "\"locktime\":0,\"blockhash\":\"000000000000000000252a1786431c52d79bd3472e84732eeff006fa2c70d6b3\"," +
            "\"blockheight\":538763,\"confirmations\":1056,\"time\":1535393382,\"blocktime\":1535393382," +
            "\"isCoinBase\":true,\"valueOut\":12.51316263,\"size\":254}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getTransaction(id: "1234") { transaction in
            XCTAssert(transaction?.txid == "d48ef0abb15d56ec94830fe2bf7b1b4a623651536e39b5885a54f2adb1896bb3")
            XCTAssert(transaction?.version == 2)
            XCTAssert(transaction?.locktime == 0)
            XCTAssert(transaction?.blockhash == "000000000000000000252a1786431c52d79bd3472e84732eeff006fa2c70d6b3")
            XCTAssert(transaction?.blockheight == 538763)
            XCTAssert(transaction?.confirmations == 1056)
            XCTAssert(transaction?.time == 1535393382)
            XCTAssert(transaction?.blocktime == 1535393382)
            XCTAssert(transaction?.isCoinBase == true)
            XCTAssert(transaction?.valueOut == 12.51316263)
            XCTAssert(transaction?.size == 254)
        }
    }

    func testGetNoTransaction() {
        session.nextData = nil

        client.getTransaction(id: "1234") { transaction in
            XCTAssert(transaction == nil)
        }
    }

    func testGetTransactionsByBlockHash() {
        let json = "{\"pagesTotal\":1,\"txs\":[{\"txid\":\"ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888\"," +
            "\"version\":1,\"locktime\":0,\"blockhash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\"," +
            "\"blockheight\":371623,\"confirmations\":168197,\"time\":1440604813,\"blocktime\":1440604813," +
            "\"isCoinBase\":true,\"valueOut\":25,\"size\":172},{\"txid\":\"29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10\"," +
            "\"version\":1,\"locktime\":0,\"blockhash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\"," +
            "\"blockheight\":371623,\"confirmations\":168197,\"time\":1440604813,\"blocktime\":1440604813,\"valueOut\":0.3689," +
            "\"size\":226,\"valueIn\":0.3689,\"fees\":0}]}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getTransactions(byBlockhash: "hash") { summary in
            XCTAssert(summary?.pagesTotal == 1)

            XCTAssert(summary?.txs.first?.txid == "ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888")
            XCTAssert(summary?.txs.first?.version == 1)
            XCTAssert(summary?.txs.first?.locktime == 0)
            XCTAssert(summary?.txs.first?.blockhash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(summary?.txs.first?.blockheight == 371623)
            XCTAssert(summary?.txs.first?.confirmations == 168197)
            XCTAssert(summary?.txs.first?.time == 1440604813)
            XCTAssert(summary?.txs.first?.blocktime == 1440604813)
            XCTAssert(summary?.txs.first?.isCoinBase == true)
            XCTAssert(summary?.txs.first?.valueOut == 25)
            XCTAssert(summary?.txs.first?.size == 172)

            XCTAssert(summary?.txs.last?.txid == "29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10")
            XCTAssert(summary?.txs.last?.version == 1)
            XCTAssert(summary?.txs.last?.locktime == 0)
            XCTAssert(summary?.txs.last?.blockhash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(summary?.txs.last?.blockheight == 371623)
            XCTAssert(summary?.txs.last?.confirmations == 168197)
            XCTAssert(summary?.txs.last?.time == 1440604813)
            XCTAssert(summary?.txs.last?.blocktime == 1440604813)
            XCTAssert(summary?.txs.last?.isCoinBase == nil)
            XCTAssert(summary?.txs.last?.valueOut == 0.3689)
            XCTAssert(summary?.txs.last?.size == 226)
            XCTAssert(summary?.txs.last?.valueIn == 0.3689)
            XCTAssert(summary?.txs.last?.fees == 0)
        }
    }

    func testGetNoTransactionsByBlockHash() {
        session.nextData = nil

        client.getTransactions(byBlockhash: "hash") { summary in
            XCTAssert(summary == nil)
        }
    }

    func testGetTransactionsByAddress() {
        let json = "{\"pagesTotal\":1,\"txs\":[{\"txid\":\"ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888\"," +
            "\"version\":1,\"locktime\":0,\"blockhash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\"," +
            "\"blockheight\":371623,\"confirmations\":168197,\"time\":1440604813,\"blocktime\":1440604813," +
            "\"isCoinBase\":true,\"valueOut\":25,\"size\":172},{\"txid\":\"29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10\"," +
            "\"version\":1,\"locktime\":0,\"blockhash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\"," +
            "\"blockheight\":371623,\"confirmations\":168197,\"time\":1440604813,\"blocktime\":1440604813,\"valueOut\":0.3689," +
            "\"size\":226,\"valueIn\":0.3689,\"fees\":0}]}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getTransactions(byAddress: "address") { summary in
            XCTAssert(summary?.pagesTotal == 1)

            XCTAssert(summary?.txs.first?.txid == "ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888")
            XCTAssert(summary?.txs.first?.version == 1)
            XCTAssert(summary?.txs.first?.locktime == 0)
            XCTAssert(summary?.txs.first?.blockhash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(summary?.txs.first?.blockheight == 371623)
            XCTAssert(summary?.txs.first?.confirmations == 168197)
            XCTAssert(summary?.txs.first?.time == 1440604813)
            XCTAssert(summary?.txs.first?.blocktime == 1440604813)
            XCTAssert(summary?.txs.first?.isCoinBase == true)
            XCTAssert(summary?.txs.first?.valueOut == 25)
            XCTAssert(summary?.txs.first?.size == 172)

            XCTAssert(summary?.txs.last?.txid == "29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10")
            XCTAssert(summary?.txs.last?.version == 1)
            XCTAssert(summary?.txs.last?.locktime == 0)
            XCTAssert(summary?.txs.last?.blockhash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(summary?.txs.last?.blockheight == 371623)
            XCTAssert(summary?.txs.last?.confirmations == 168197)
            XCTAssert(summary?.txs.last?.time == 1440604813)
            XCTAssert(summary?.txs.last?.blocktime == 1440604813)
            XCTAssert(summary?.txs.last?.isCoinBase == nil)
            XCTAssert(summary?.txs.last?.valueOut == 0.3689)
            XCTAssert(summary?.txs.last?.size == 226)
            XCTAssert(summary?.txs.last?.valueIn == 0.3689)
            XCTAssert(summary?.txs.last?.fees == 0)
        }
    }

    func testGetNoTransactionsByAddress() {
        session.nextData = nil

        client.getTransactions(byAddress: "address") { summary in
            XCTAssert(summary == nil)
        }
    }

    func testGetTransactionsByAddresses() {
        let json = "{\"totalItems\":2,\"from\":0,\"to\":2,\"items\":[{\"txid\":\"ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888\"," +
            "\"version\":1,\"locktime\":0,\"blockhash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\"," +
            "\"blockheight\":371623,\"confirmations\":168197,\"time\":1440604813,\"blocktime\":1440604813," +
            "\"isCoinBase\":true,\"valueOut\":25,\"size\":172},{\"txid\":\"29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10\"," +
            "\"version\":1,\"locktime\":0,\"blockhash\":\"0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a\"," +
            "\"blockheight\":371623,\"confirmations\":168197,\"time\":1440604813,\"blocktime\":1440604813,\"valueOut\":0.3689," +
            "\"size\":226,\"valueIn\":0.3689,\"fees\":0}]}"
        let data = json.data(using: .utf8)

        session.nextData = data

        client.getTransactions(byAddresses: ["adress"], from: 0, to: 2) { collection in
            XCTAssert(collection?.totalItems == 2)
            XCTAssert(collection?.from == 0)
            XCTAssert(collection?.to == 2)

            XCTAssert(collection?.items.first?.txid == "ee6bc0e5f95a4ccd0f00784eab850ff8593f9045de96c6656df41c8f9f9c0888")
            XCTAssert(collection?.items.first?.version == 1)
            XCTAssert(collection?.items.first?.locktime == 0)
            XCTAssert(collection?.items.first?.blockhash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(collection?.items.first?.blockheight == 371623)
            XCTAssert(collection?.items.first?.confirmations == 168197)
            XCTAssert(collection?.items.first?.time == 1440604813)
            XCTAssert(collection?.items.first?.blocktime == 1440604813)
            XCTAssert(collection?.items.first?.isCoinBase == true)
            XCTAssert(collection?.items.first?.valueOut == 25)
            XCTAssert(collection?.items.first?.size == 172)

            XCTAssert(collection?.items.last?.txid == "29c59ec39fc19afd84d928272b3290bbe54558f7b51f75feb858b005dea49c10")
            XCTAssert(collection?.items.last?.version == 1)
            XCTAssert(collection?.items.last?.locktime == 0)
            XCTAssert(collection?.items.last?.blockhash == "0000000000000000079c58e8b5bce4217f7515a74b170049398ed9b8428beb4a")
            XCTAssert(collection?.items.last?.blockheight == 371623)
            XCTAssert(collection?.items.last?.confirmations == 168197)
            XCTAssert(collection?.items.last?.time == 1440604813)
            XCTAssert(collection?.items.last?.blocktime == 1440604813)
            XCTAssert(collection?.items.last?.isCoinBase == nil)
            XCTAssert(collection?.items.last?.valueOut == 0.3689)
            XCTAssert(collection?.items.last?.size == 226)
            XCTAssert(collection?.items.last?.valueIn == 0.3689)
            XCTAssert(collection?.items.last?.fees == 0)
        }
    }

    func testGetNoTransactionsByAddresses() {
        session.nextData = nil

        client.getTransactions(byAddresses: ["address"], from: 0, to: 2) { collection in
            XCTAssert(collection == nil)
        }
    }
}

class MockURLSession: URLSession {
    var lastURL: URL?
    var nextData: Data?
    var nextError: Error?
    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        lastURL = url
        completionHandler(nextData, URLResponse(), nextError)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {}
}
