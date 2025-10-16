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
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: - Sección del Avatar
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    viewModel.avatarTapped()
                                }
                            
                            Text("Toca 5 veces para reiniciar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    // Elimina el fondo de la celda para que se integre mejor.
                    .listRowBackground(Color.clear)
                }
                
                // MARK: - Sección de Medallas
                Section(header: Text("Medallas")) {
                    ForEach(viewModel.medals) { medal in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(medal.name)
                                .font(.headline)
                            
                            Text(medal.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            ProgressView(value: Float(medal.points), total: 100)
                                .tint(Color(hex: medal.progressColor))
                            
                            Text("NIVEL: \(medal.level)  |  Puntos: \(medal.points)/100")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color(hex: medal.backgroundColor).opacity(0.4))
                    }
                }
            }
            .navigationTitle("Perfil de Usuario")
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                viewModel.onAppear()
            } else if newPhase == .inactive || newPhase == .background {
                viewModel.onDisappear()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// No olvides tu PreviewProvider para seguir diseñando la UI fácilmente.
#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    @MainActor
    static func makeInjectedViewModel() -> ProfileViewModel {
        class MockMedalsRepository: MedalsRepository {
            func getMedals() -> AnyPublisher<[Medal], Error> {
                let mockMedals: [Medal] = [
                    .init(id: "m1", name: "Apostador Novato", description: "Alcanza tus primeros 100 puntos.", icon: "", category: "Progreso", rarity: "Common", backgroundColor: "#E6F4FF", progressColor: "#2196F3", level: 1, points: 50, maxLevel: 5, reward: "10 monedas", unlockedAt: "", nextLevelGoal: "", isLocked: false, animationType: ""),
                    .init(id: "m2", name: "Cazafijas", description: "Gana apuestas consecutivas.", icon: "", category: "Racha", rarity: "Rare", backgroundColor: "#FFF4E6", progressColor: "#FF9800", level: 3, points: 95, maxLevel: 10, reward: "20 monedas", unlockedAt: "", nextLevelGoal: "", isLocked: false, animationType: "")
                ]
                return Just(mockMedals).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            func saveOrUpdate(medals: [Medal]) async throws {}
            func resetMedals() async throws { print("Reset") }
            func initializeMedalsIfNeeded() async throws {}
            func startEngine() {}
            func stopEngine() {}
        }
        
        let mockRepo = MockMedalsRepository()
        
        let getMedalsUseCase = GetMedalsUseCase(repository: mockRepo)
        let startEngineUseCase = StartPointsEngineUseCase(repository: mockRepo)
        let stopEngineUseCase = StopPointsEngineUseCase(repository: mockRepo)
        let resetProgressUseCase = ResetProgressUseCase(repository: mockRepo)
        
        return ProfileViewModel(
            getMedalsUseCase: getMedalsUseCase,
            startPointsEngineUseCase: startEngineUseCase,
            stopPointsEngineUseCase: stopEngineUseCase,
            resetProgressUseCase: resetProgressUseCase
        )
    }
    
    static var previews: some View {
        ProfileView(viewModel: makeInjectedViewModel())
    }
}
#endif
