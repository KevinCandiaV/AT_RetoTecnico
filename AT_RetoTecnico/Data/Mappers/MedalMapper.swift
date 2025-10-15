//
//  MedalMapper.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation

struct MedalMapper {
    static func toDomain(entity: MedalData) -> Medal {
        return Medal(
            id: entity.id,
            name: entity.name,
            description: entity.medalDescription,
            icon: entity.icon,
            category: entity.category,
            rarity: entity.rarity,
            backgroundColor: entity.backgroundColor,
            progressColor: entity.progressColor,
            level: entity.level,
            points: entity.points,
            maxLevel: entity.maxLevel,
            reward: entity.reward,
            unlockedAt: entity.unlockedAt,
            nextLevelGoal: entity.nextLevelGoal,
            isLocked: entity.isLocked,
            animationType: entity.animationType
        )
    }
    
    static func toEntity(domain: Medal) -> MedalData {
        return MedalData(
            id: domain.id,
            name: domain.name,
            medalDescription: domain.description,
            icon: domain.icon,
            category: domain.category,
            rarity: domain.rarity,
            backgroundColor: domain.backgroundColor,
            progressColor: domain.progressColor,
            level: domain.level,
            points: domain.points,
            maxLevel: domain.maxLevel,
            reward: domain.reward,
            unlockedAt: domain.unlockedAt,
            nextLevelGoal: domain.nextLevelGoal,
            isLocked: domain.isLocked,
            animationType: domain.animationType
        )
    }
}
