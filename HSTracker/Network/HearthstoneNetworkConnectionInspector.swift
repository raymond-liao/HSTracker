//
//  HearthstoneNetworkConnectionInspector.swift
//  HSTracker
//
//  Created by Hermes Agent on 04/07/2026.
//  Copyright © 2026 Benjamin Michotte. All rights reserved.
//

import Foundation
import HearthMirror

struct HearthstoneNetworkTarget: Equatable {
    let address: String
    let port: Int
}

protocol HearthstoneNetworkConnectionTargetProviding {
    var currentTarget: HearthstoneNetworkTarget? { get }
    var freshTarget: HearthstoneNetworkTarget? { get }
}

struct HearthstoneNetworkConnectionInspector {
    private let provider: HearthstoneNetworkConnectionTargetProviding

    init(provider: HearthstoneNetworkConnectionTargetProviding) {
        self.provider = provider
    }

    func preferredTarget() -> HearthstoneNetworkTarget? {
        if let currentTarget = provider.currentTarget,
           let validatedCurrentTarget = Self.validatedTarget(currentTarget) {
            return validatedCurrentTarget
        }

        if let freshTarget = provider.freshTarget,
           let validatedFreshTarget = Self.validatedTarget(freshTarget) {
            return validatedFreshTarget
        }

        return nil
    }

    private static func validatedTarget(_ target: HearthstoneNetworkTarget) -> HearthstoneNetworkTarget? {
        let address = target.address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !address.isEmpty, target.port > 0 else {
            return nil
        }
        return HearthstoneNetworkTarget(address: address, port: target.port)
    }
}

struct HearthstoneMirrorNetworkConnectionTargetProvider: HearthstoneNetworkConnectionTargetProviding {
    private let currentGameServerInfoProvider: () -> MirrorGameServerInfo?
    private let freshGameServerInfoProvider: () -> MirrorGameServerInfo?

    init(game: Game) {
        self.init(currentGameServerInfoProvider: { game.serverInfo },
                  freshGameServerInfoProvider: MirrorHelper.getGameServerInfo)
    }

    init(currentGameServerInfoProvider: @escaping () -> MirrorGameServerInfo?,
         freshGameServerInfoProvider: @escaping () -> MirrorGameServerInfo?) {
        self.currentGameServerInfoProvider = currentGameServerInfoProvider
        self.freshGameServerInfoProvider = freshGameServerInfoProvider
    }

    var currentTarget: HearthstoneNetworkTarget? {
        return currentGameServerInfoProvider().map(HearthstoneNetworkTarget.init)
    }

    var freshTarget: HearthstoneNetworkTarget? {
        return freshGameServerInfoProvider().map(HearthstoneNetworkTarget.init)
    }
}

private extension HearthstoneNetworkTarget {
    init(gameServerInfo: MirrorGameServerInfo) {
        self.init(address: gameServerInfo.address,
                  port: gameServerInfo.port as? Int ?? 0)
    }
}
