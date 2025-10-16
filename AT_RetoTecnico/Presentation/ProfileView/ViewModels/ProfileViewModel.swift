//
//  ProfileViewModel.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    
    // MARK: - Propiedades Publicadas
    @Published var medals: [Medal] = []
    @Published var errorMessage: String?
    
    // MARK: - Dependencias
    private let getMedalsUseCase: GetMedalsUseCase
    private let startPointsEngineUseCase: StartPointsEngineUseCase
    private let stopPointsEngineUseCase: StopPointsEngineUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(getMedalsUseCase: GetMedalsUseCase,
         startPointsEngineUseCase: StartPointsEngineUseCase,
         stopPointsEngineUseCase: StopPointsEngineUseCase) {
        self.getMedalsUseCase = getMedalsUseCase
        self.startPointsEngineUseCase = startPointsEngineUseCase
        self.stopPointsEngineUseCase = stopPointsEngineUseCase
        
        bindMedals()
    }
    
    func onAppear() {
        startPointsEngineUseCase.execute()
    }
    
    func onDisappear() {
        stopPointsEngineUseCase.execute()
    }
    
    // MARK: - Métodos Privados
    private func bindMedals() {
        getMedalsUseCase.execute()
            .receive(on: DispatchQueue.main) // Actualiza la ui en el hilo principal
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Error al cargar medallas: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] medals in
                self?.medals = medals
            })
            .store(in: &cancellables)
    }
}
