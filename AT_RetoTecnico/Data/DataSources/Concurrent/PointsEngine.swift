//
//  PointsEngine.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation

actor PointsEngine {
    
    private var pointIncrementTask: Task<Void, Error>?
    
    var onUpdate: (([Medal]) -> Void)?
    
    private var currentMedals: [Medal] = []

    func setMedals(_ medals: [Medal]) {
        self.currentMedals = medals
    }
    
    func updateMedals(_ medals: [Medal]) {
        self.currentMedals = medals
    }

    func start() {
        guard pointIncrementTask == nil else { return }
        
        pointIncrementTask = Task {
            while !Task.isCancelled {
//                try await Task.sleep(for: .seconds(.random(in: 1...3)))
                try await Task.sleep(for: .seconds(2))
                incrementRandomMedalPoints() // incremento de puntos
                onUpdate?(currentMedals) // notifica los nuevos datos
            }
        }
    }

    func stop() {
        pointIncrementTask?.cancel()
        pointIncrementTask = nil
    }
    
    private func incrementRandomMedalPoints() {
        let eligibleMedals = currentMedals.filter { $0.level < $0.maxLevel }
        
        // Si no hay medallas elegibles, no hace nada.
        guard let randomMedal = eligibleMedals.randomElement(),
              let index = currentMedals.firstIndex(where: { $0.id == randomMedal.id }) else {
            return
        }
        
        // Incrementa los puntos de forma aleatoria (ej. entre 1 y 100).
        currentMedals[index].points += Int.random(in: 1...100)
        
        // Comprueba si la medalla sube de nivel.
        if currentMedals[index].points >= 100 {
            currentMedals[index].level += 1
            // Si no ha alcanzado el nivel máximo, reinicia los puntos.
            if currentMedals[index].level < currentMedals[index].maxLevel {
                currentMedals[index].points -= 100
            } else {
                // Si alcanzó el nivel máximo, los puntos se quedan en 0 y no suben más.
                currentMedals[index].points = 0
            }
        }
    }
}
