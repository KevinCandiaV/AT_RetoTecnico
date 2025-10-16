//
//  UpdateMedalUseCase.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation

final class UpdateMedalUseCase {
    private let repository: MedalsRepository

    init(repository: MedalsRepository) {
        self.repository = repository
    }

    func execute(medal: Medal) async throws {
        try await repository.saveOrUpdate(medals: [medal])
    }
}
