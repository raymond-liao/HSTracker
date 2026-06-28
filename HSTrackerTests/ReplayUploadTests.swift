//
//  ReplayUploadTests.swift
//  HSTracker
//
//  Created by Istvan Fehervari on 09/05/2017.
//  Copyright © 2017 Benjamin Michotte. All rights reserved.
//

import XCTest

@testable import HSTracker

class ReplayUploadTests: HSTrackerTests {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testMetadataEncoding() {
		let player = UploadMetaData.Player()
		
//		player.rank = 1
//		player.legendRank = 0
		player.stars = 1
		player.wins = 20
		player.losses = 10
		player.deck = ["one", "two"]
		player.deck_id = 12345
		player.cardback = 3
		
		guard let data = try? JSONEncoder().encode(player),
			  let wrappedPlayer = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else {
			XCTFail()
			return
		}
		
//		XCTAssert(wrappedPlayer["rank"] as! Int == player.rank!)
		XCTAssert(wrappedPlayer["cardback"] as! Int == player.cardback!)
		XCTAssert(wrappedPlayer["deck"] as! [String] == player.deck!)
	}
}
