//
//  AT_RetoTecnicoApp.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import SwiftUI
import SwiftData

@main
struct AT_RetoTecnicoApp: App {
    
    private let injector: DependencyInjector
    private let container: ModelContainer // Contenedor del modelo
    
    init() {
        do {
            let modelContainer = try ModelContainer(for: MedalData.self)
                        self.container = modelContainer
                        self.injector = DependencyInjector(modelContainer: modelContainer)
        } catch {
            fatalError("Error en crear el modelo")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ProfileView(viewModel: injector.makeProfileViewModel())
        }
        .modelContainer(container)
    }
}
