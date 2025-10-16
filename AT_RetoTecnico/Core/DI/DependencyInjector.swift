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
    private let modelContainer: ModelContainer
    
    // MARK: - Dependencias de la Capa de Datos
    
    private lazy var localDataSource: SwiftDataLocalDataSource = {
        SwiftDataLocalDataSource(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var medalsRepository: MedalsRepository = {
        MedalsRepositoryImpl(localDataSource: localDataSource)
    }()
    
    // MARK: - Dependencias de la Capa de Dominio (Casos de Uso)
    
    private lazy var getMedalsUseCase: GetMedalsUseCase = {
        GetMedalsUseCase(repository: medalsRepository)
    }()
    
    // MARK: - Inicializador
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // MARK: - Fábrica de ViewModels
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(getMedalsUseCase: getMedalsUseCase)
    }
}
