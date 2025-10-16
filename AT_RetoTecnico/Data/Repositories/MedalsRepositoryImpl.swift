//
//  MedalsRepositoryImpl.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import Combine
import SwiftData

final class MedalsRepositoryImpl: MedalsRepository {
    
    // MARK: - Propiedades Privadas
    private let localDataSource: SwiftDataLocalDataSource
    private let medalsSubject: CurrentValueSubject<[Medal], Error>
    private let pointsEngine: PointsEngine
    
    // MARK: - Inicializador
    init(localDataSource: SwiftDataLocalDataSource, pointsEngine: PointsEngine) {
            self.localDataSource = localDataSource
            self.pointsEngine = pointsEngine
            self.medalsSubject = CurrentValueSubject([])
            self.pointsEngine.onUpdate = { [weak self] updatedMedals in
                self?.handleEngineUpdate(medals: updatedMedals)
            }
            Task { await loadInitialData() }
        }
    
    // MARK: - Métodos del Protocolo
    func getMedals() -> AnyPublisher<[Medal], Error> {
        return medalsSubject.eraseToAnyPublisher()
    }
    
    func saveOrUpdate(medals: [Medal]) async throws {
        //TODO
    }
    
    func resetMedals() async throws {
        try localDataSource.deleteAll() // Borramos e iniciamos de nuevo
        try await initializeMedalsIfNeeded()
        await loadInitialData() // LLenamos nuevamente
    }
    
    func initializeMedalsIfNeeded() async throws {
        if try localDataSource.isEmpty() {
            let medalsFromJSON = loadMedalsFromJSON()
            let medalEntities = medalsFromJSON.map { MedalMapper.toEntity(domain: $0) }
            try localDataSource.insert(medals: medalEntities)
        }
    }
    
    private func loadInitialData() async {
        do {
            try await initializeMedalsIfNeeded()
            let medalEntities = try localDataSource.fetchMedals()
            // Mapeamos del modelo de datos al modelo de dominio.
            let domainMedals = medalEntities.map { MedalMapper.toDomain(entity: $0) }
            // Enviamos los datos actualizados a todos los suscriptores.
            medalsSubject.send(domainMedals)
        } catch {
            medalsSubject.send(completion: .failure(error))
        }
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
            fatalError("Failed to decode medallas_mock.json: \(error)")
        }
    }
    
    private struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { return nil }
    }
    
    //MARK: - New methods
    func startEngine() {
        Task {
            await pointsEngine.setMedals(medalsSubject.value)
            await pointsEngine.start()
        }
    }
    
    func stopEngine() {
        Task {
            await pointsEngine.stop()
        }
    }
    
    private func handleEngineUpdate(medals: [Medal]) {
        let entities = medals.map { MedalMapper.toEntity(domain: $0) }
        try? localDataSource.deleteAll()
        try? localDataSource.insert(medals: entities)
        medalsSubject.send(medals)
    }
    
}
