//
//  HearthstoneNetworkConnectionInspectorTests.swift
//  HSTracker
//
//  Created by Hermes Agent on 04/07/2026.
//  Copyright © 2026 Benjamin Michotte. All rights reserved.
//

import XCTest
import Foundation

@testable import HSTracker

class HearthstoneNetworkConnectionInspectorTests: HSTrackerTests {

    func testPrefersValidCurrentTargetOverValidFreshTarget() {
        let provider = CountingTargetProvider(currentTarget: HearthstoneNetworkTarget(address: "current.example.com", port: 1119),
                                              freshTarget: HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
        let inspector = HearthstoneNetworkConnectionInspector(provider: provider)

        XCTAssertEqual(inspector.preferredTarget(), HearthstoneNetworkTarget(address: "current.example.com", port: 1119))
        XCTAssertEqual(provider.currentTargetCalls, 1)
        XCTAssertEqual(provider.freshTargetCalls, 0)
    }

    func testUsesFreshTargetWhenCurrentTargetIsNil() {
        let provider = TestTargetProvider(currentTarget: nil,
                                          freshTarget: HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
        let inspector = HearthstoneNetworkConnectionInspector(provider: provider)

        XCTAssertEqual(inspector.preferredTarget(), HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
    }

    func testUsesFreshTargetWhenCurrentTargetHasEmptyAddress() {
        let provider = TestTargetProvider(currentTarget: HearthstoneNetworkTarget(address: "", port: 1119),
                                          freshTarget: HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
        let inspector = HearthstoneNetworkConnectionInspector(provider: provider)

        XCTAssertEqual(inspector.preferredTarget(), HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
    }

    func testUsesFreshTargetWhenCurrentTargetHasNonPositivePort() {
        let provider = TestTargetProvider(currentTarget: HearthstoneNetworkTarget(address: "current.example.com", port: 0),
                                          freshTarget: HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
        let inspector = HearthstoneNetworkConnectionInspector(provider: provider)

        XCTAssertEqual(inspector.preferredTarget(), HearthstoneNetworkTarget(address: "fresh.example.com", port: 2229))
    }

    func testReturnsNilWhenCurrentAndFreshTargetsAreInvalid() {
        let provider = TestTargetProvider(currentTarget: HearthstoneNetworkTarget(address: "", port: 1119),
                                          freshTarget: HearthstoneNetworkTarget(address: "fresh.example.com", port: -1))
        let inspector = HearthstoneNetworkConnectionInspector(provider: provider)

        XCTAssertNil(inspector.preferredTarget())
    }

    func testTrimsWhitespaceAddressWhenValidatingTarget() {
        let provider = TestTargetProvider(currentTarget: HearthstoneNetworkTarget(address: "   current.example.com   ", port: 1119),
                                          freshTarget: nil)
        let inspector = HearthstoneNetworkConnectionInspector(provider: provider)

        XCTAssertEqual(inspector.preferredTarget(), HearthstoneNetworkTarget(address: "current.example.com", port: 1119))
    }
}

private struct TestTargetProvider: HearthstoneNetworkConnectionTargetProviding {
    let currentTarget: HearthstoneNetworkTarget?
    let freshTarget: HearthstoneNetworkTarget?
}

private final class CountingTargetProvider: HearthstoneNetworkConnectionTargetProviding {
    private let storedCurrentTarget: HearthstoneNetworkTarget?
    private let storedFreshTarget: HearthstoneNetworkTarget?
    private(set) var currentTargetCalls = 0
    private(set) var freshTargetCalls = 0

    init(currentTarget: HearthstoneNetworkTarget?, freshTarget: HearthstoneNetworkTarget?) {
        storedCurrentTarget = currentTarget
        storedFreshTarget = freshTarget
    }

    var currentTarget: HearthstoneNetworkTarget? {
        currentTargetCalls += 1
        return storedCurrentTarget
    }

    var freshTarget: HearthstoneNetworkTarget? {
        freshTargetCalls += 1
        return storedFreshTarget
    }
}
