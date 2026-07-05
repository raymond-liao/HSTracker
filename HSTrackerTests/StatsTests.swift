//
//  StatsTests.swift
//  HSTracker
//
//  Created by Matthew Welborn on 6/9/16.
//  Copyright © 2016 Benjamin Michotte. All rights reserved.
//

import XCTest
import Foundation

@testable import HSTracker

class StatsTests: HSTrackerTests {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testErfinv() {
        let values: [[Double]] = [
            [0.91315112686 , 1.21075024057],
            [0.582751704807 , 0.573608137167],
            [0.718243287706 , 0.761116595129],
            [0.00856985966945 , 0.00759498641983],
            [0.51475402072 , 0.493482762145]]
        for i in 0...values.count-1 {
            XCTAssert(fuzzyFloatEquals(a: StatsHelper.erfinv(y: values[i][0]), b: values[i][1]))
        }
    }
    
    func testBinomialProportionConfidenceInterval() {
        let correct_lower = 0.5838606324
        let correct_upper = 0.7914774104
        let results = StatsHelper.binomialProportionCondifenceInterval(wins: 30,
                                                                       losses: 13,
                                                                       confidence: 0.87)

        XCTAssert(fuzzyFloatEquals(a: results.lower, b: correct_lower))
        XCTAssert(fuzzyFloatEquals(a: results.upper, b: correct_upper))
    }
    
    private func fuzzyFloatEquals(a: Double, b: Double) -> Bool {
        let closeEnough = 1e-4
        return abs(a-b) < closeEnough
    }
    
    func testSQL() {
        let lg = LadderGrid()
        guard let games = lg.getGamesToRank(targetRank: 5, stars: 0, bonus: 2 , winp: 0.655) else {
            XCTFail("failed to calculate games")
            return
        }
        XCTAssertGreaterThan(games, 100)
    }

    func testBattlegroundsFinalPlacementPrefersPlayerHeroEntityOverBroadCandidate() {
        let playerId = 1
        let playerEntity = Entity(id: 2)
        playerEntity[.player_id] = playerId
        playerEntity[.hero_entity] = 3

        let wrongCandidate = battlegroundsHeroEntity(id: 1, controller: playerId, placement: 1)
        let canonicalHero = battlegroundsHeroEntity(id: 3, controller: playerId, placement: 3)
        let candidates = [wrongCandidate, canonicalHero]

        let broadSelection = candidates.first { entity in
            entity.has(tag: .player_leaderboard_place) && entity.isControlled(by: playerId)
        }
        let selectedHero = Game.battlegroundsFinalPlacementHero(in: candidates,
                                                                playerEntity: playerEntity,
                                                                playerId: playerId)

        XCTAssertEqual(broadSelection?.id, 1)
        XCTAssertEqual(broadSelection?[.player_leaderboard_place], 1)
        XCTAssertEqual(selectedHero?.id, playerEntity[.hero_entity])
        XCTAssertEqual(selectedHero?[.player_leaderboard_place], 3)
    }

    func testBattlegroundsFinalPlacementFallbackUsesSortedCandidateList() {
        let playerId = 1
        let highIdCandidate = battlegroundsHeroEntity(id: 4, controller: playerId, placement: 4)
        let lowIdCandidate = battlegroundsHeroEntity(id: 1, controller: playerId, placement: 1)

        let selectedHero = Game.battlegroundsFinalPlacementHero(in: [highIdCandidate, lowIdCandidate],
                                                                playerEntity: nil,
                                                                playerId: playerId)

        XCTAssertEqual(selectedHero?.id, lowIdCandidate.id)
        XCTAssertEqual(selectedHero?[.player_leaderboard_place], 1)
    }

    private func battlegroundsHeroEntity(id: Int, controller: Int, placement: Int) -> Entity {
        let entity = Entity(id: id)
        entity[.controller] = controller
        entity[.player_leaderboard_place] = placement
        return entity
    }
}
