//
//  MedalData.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import SwiftData

@Model
final class MedalData {
    @Attribute(.unique) var id: String
    var name: String
    var medalDescription: String
    var icon: String
    var category: String
    var rarity: String
    var backgroundColor: String
    var progressColor: String
    var level: Int
    var points: Int
    var maxLevel: Int
    var reward: String
    var unlockedAt: String
    var nextLevelGoal: String
    var isLocked: Bool
    var animationType: String
    
    init(id: String, name: String, medalDescription: String, icon: String, category: String, rarity: String, backgroundColor: String, progressColor: String, level: Int, points: Int, maxLevel: Int, reward: String, unlockedAt: String, nextLevelGoal: String, isLocked: Bool, animationType: String) {
        self.id = id
        self.name = name
        self.medalDescription = medalDescription
        self.icon = icon
        self.category = category
        self.rarity = rarity
        self.backgroundColor = backgroundColor
        self.progressColor = progressColor
        self.level = level
        self.points = points
        self.maxLevel = maxLevel
        self.reward = reward
        self.unlockedAt = unlockedAt
        self.nextLevelGoal = nextLevelGoal
        self.isLocked = isLocked
        self.animationType = animationType
    }
}
