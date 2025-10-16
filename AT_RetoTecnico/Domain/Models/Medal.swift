//
//  Medal.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation

struct Medal: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: String
    let rarity: String
    let backgroundColor: String
    let progressColor: String
    var level: Int
    var points: Int
    let maxLevel: Int
    let reward: String
    let unlockedAt: String
    let nextLevelGoal: String
    var isLocked: Bool
    let animationType: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, icon, category, rarity, backgroundColor, progressColor, level, points, maxLevel, reward, unlockedAt, nextLevelGoal, isLocked, animationType
    }
    
    static func == (lhs: Medal, rhs: Medal) -> Bool {
        return lhs.id == rhs.id &&  // ¿Medalla?
        lhs.level == rhs.level &&   // ¿Nivel?
        lhs.points == rhs.points && // ¿Puntos?
        lhs.isLocked == rhs.isLocked // ¿Bloquedo?
    }
}
