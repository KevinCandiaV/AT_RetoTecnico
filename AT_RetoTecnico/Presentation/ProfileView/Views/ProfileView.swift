//
//  ProfileView.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var body: some View {
        NavigationView {
            List(viewModel.medals) { medal in
                VStack(alignment: .leading, spacing: 8) {
                    Text(medal.name)
                        .font(.headline)
                    Text(medal.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    ProgressView(value: Float(medal.points), total: 100)
                    Text("NIVEL: \(medal.level)  |  Puntos: \(medal.points)/100")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Perfil de Usuario")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    @MainActor
    static func makeInjectedViewModel() -> ProfileViewModel {
        
        // Fake Repo
        class MockMedalsRepository: MedalsRepository {
            func getMedals() -> AnyPublisher<[Medal], Error> {
                let mockMedals: [Medal] = [
                    .init(id: "m1", name: "Medalla de Prueba 1", description: "Esta es una medalla de prueba.", icon: "", category: "", rarity: "", backgroundColor: "", progressColor: "", level: 1, points: 50, maxLevel: 5, reward: "", unlockedAt: "", nextLevelGoal: "", isLocked: false, animationType: ""),
                    .init(id: "m2", name: "Medalla de Prueba 2", description: "Esta medalla está casi completa.", icon: "", category: "", rarity: "", backgroundColor: "", progressColor: "", level: 3, points: 95, maxLevel: 5, reward: "", unlockedAt: "", nextLevelGoal: "", isLocked: false, animationType: "")
                ]
                
                return Just(mockMedals)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            func saveOrUpdate(medals: [Medal]) async throws {}
            func resetMedals() async throws {}
            func initializeMedalsIfNeeded() async throws {}
        }
        
        let mockRepository = MockMedalsRepository()
        let getMedalsUseCase = GetMedalsUseCase(repository: mockRepository)
        
        return ProfileViewModel(getMedalsUseCase: getMedalsUseCase)
    }
    
    static var previews: some View {
        ProfileView(viewModel: makeInjectedViewModel())
    }
}
