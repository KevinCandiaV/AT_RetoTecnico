//
//  DependencyInjector.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import SwiftData

@MainActor
final class DependencyInjector {
    
    // MARK: - Propiedades
    private var modelContainer: ModelContainer
    
    // MARK: - Dependencias de la Capa de Datos
    private lazy var localDataSource: SwiftDataLocalDataSource = {
        SwiftDataLocalDataSource(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var pointsEngine: PointsEngine = {
        PointsEngine()
    }()
    
    private lazy var medalsRepository: MedalsRepository = {
        MedalsRepositoryImpl(localDataSource: localDataSource, pointsEngine: pointsEngine)
    }()
    
    // MARK: - Dependencias de la Capa de Dominio (Casos de Uso)
    private lazy var getMedalsUseCase: GetMedalsUseCase = {
        GetMedalsUseCase(repository: medalsRepository)
    }()
    
    private lazy var startPointsEngineUseCase: StartPointsEngineUseCase = {
        StartPointsEngineUseCase(repository: medalsRepository)
    }()
    
    private lazy var stopPointsEngineUseCase: StopPointsEngineUseCase = {
        StopPointsEngineUseCase(repository: medalsRepository)
    }()
    
    // MARK: - Inicializador
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // MARK: - Fábrica de ViewModels
    func makeProfileViewModel() -> ProfileViewModel {
            // Le pasamos los nuevos casos de uso al ViewModel.
            return ProfileViewModel(
                getMedalsUseCase: getMedalsUseCase,
                startPointsEngineUseCase: startPointsEngineUseCase,
                stopPointsEngineUseCase: stopPointsEngineUseCase
            )
        }
}
