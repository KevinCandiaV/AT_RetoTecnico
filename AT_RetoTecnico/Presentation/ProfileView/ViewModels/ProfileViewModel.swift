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
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(getMedalsUseCase: GetMedalsUseCase) {
        self.getMedalsUseCase = getMedalsUseCase
        bindMedals()
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
