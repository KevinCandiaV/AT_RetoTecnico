//
//  MedalsRepositoryImpl.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import Combine
import SwiftData

class MedalsRepositoryImpl: MedalsRepository {
    
    private let modelContainer: ModelContainer
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: MedalData.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    func getMedals() -> AnyPublisher<[Medal], any Error> {
        return Just(loadMedalsFromJSON())
            .mapError { _ in fatalError("Error COntrolado") }
            .eraseToAnyPublisher()
    }
    
    func saveOrUpdate(medals: [Medal]) async throws {
        //TODO
    }
    
    func resetMedals() async throws {
        //TODO
    }
    
    func initializeMedalsIfNeeded() async throws {
        //TODO
    }
    
    private func loadMedalsFromJSON() -> [Medal] {
        guard let url = Bundle.main.url(forResource: "medallas_mock", withExtension: "json") else {
            fatalError("Failed to find data.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data.")
        }
        
        do {
            let decoder = JSONDecoder()
            let medals = try decoder.decode([Medal].self, from: data)
            return medals
        } catch {
            fatalError("Failed to decode json: \(error)")
        }
    }
}
