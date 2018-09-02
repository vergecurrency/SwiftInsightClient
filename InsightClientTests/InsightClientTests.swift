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
