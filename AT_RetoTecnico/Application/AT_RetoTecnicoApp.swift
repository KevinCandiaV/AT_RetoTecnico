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
    let container: ModelContainer // Contenedor del modelo
    
    init() {
        do {
            container = try ModelContainer(for: MedalData.self)
        } catch {
            fatalError("Error en crear el modelo")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Text("demo")
        }
        .modelContainer(container)
    }
}
