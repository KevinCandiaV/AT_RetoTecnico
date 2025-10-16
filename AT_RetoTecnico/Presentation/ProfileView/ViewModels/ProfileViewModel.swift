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
    
    private let resetProgressUseCase: ResetProgressUseCase
    private var avatarTapCount = 0
    
    // MARK: - Init
    init(getMedalsUseCase: GetMedalsUseCase,
         startPointsEngineUseCase: StartPointsEngineUseCase,
         stopPointsEngineUseCase: StopPointsEngineUseCase,
         resetProgressUseCase: ResetProgressUseCase) {
        self.getMedalsUseCase = getMedalsUseCase
        self.startPointsEngineUseCase = startPointsEngineUseCase
        self.stopPointsEngineUseCase = stopPointsEngineUseCase
        self.resetProgressUseCase = resetProgressUseCase
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
    
    func avatarTapped() {
        avatarTapCount += 1
        if avatarTapCount >= 5 {
            Task {
                stopPointsEngineUseCase.execute()
                do {
                    try await resetProgressUseCase.execute()
                    avatarTapCount = 0
                } catch {
                    errorMessage = "Error al reiniciar el progreso: \(error.localizedDescription)"
                    avatarTapCount = 0
                    startPointsEngineUseCase.execute()
                }
            }
        }
    }
}
