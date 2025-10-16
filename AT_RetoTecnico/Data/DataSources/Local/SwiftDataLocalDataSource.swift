//
//  SwiftDataLocalDataSource.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 15/10/25.
//

import Foundation
import SwiftData

final class SwiftDataLocalDataSource {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchMedals() throws -> [MedalData] {
        let descriptor = FetchDescriptor<MedalData>(sortBy: [SortDescriptor(\.id)])
        return try modelContext.fetch(descriptor)
    }
    
    func insert(medals: [MedalData]) throws {
        for medal in medals {
            modelContext.insert(medal)
        }
        try modelContext.save()
    }
    
    func deleteAll() throws {
        try modelContext.delete(model: MedalData.self)
    }
    
    func isEmpty() throws -> Bool {
        let medals = try fetchMedals()
        return medals.isEmpty
    }
}
