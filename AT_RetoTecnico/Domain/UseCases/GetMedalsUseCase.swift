//
//  GetMedalsUseCase.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import Combine

class GetMedalsUseCase {
    private let repository: MedalsRepository
    
    init(repository: MedalsRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Medal], Error> {
        return repository.getMedals()
    }
}
