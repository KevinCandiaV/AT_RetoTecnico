//
//  StopPointsEngineUseCase.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation

final class StopPointsEngineUseCase {
    private let repository: MedalsRepository

    init(repository: MedalsRepository) {
        self.repository = repository
    }

    func execute() {
        repository.stopEngine()
    }
}
