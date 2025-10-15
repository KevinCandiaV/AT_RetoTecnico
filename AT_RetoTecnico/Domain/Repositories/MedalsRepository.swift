//
//  MedalsRepository.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import Combine

protocol MedalsRepository {
    func getMedals() -> AnyPublisher<[Medal], Error>
    func saveOrUpdate(medals: [Medal]) async throws
    func resetMedals() async throws
    func initializeMedalsIfNeeded() async throws
}
