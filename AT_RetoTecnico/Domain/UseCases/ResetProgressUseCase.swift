//
//  ResetProgressUseCase.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation

final class ResetProgressUseCase {
    private let repository: MedalsRepository

    init(repository: MedalsRepository) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.resetMedals()
    }
}
