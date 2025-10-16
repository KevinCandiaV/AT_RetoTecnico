//
//  ConfettiAnimationView.swift
//  AT_RetoTecnico
//
//  Created by Kevin Candia Villagómez on 16/10/25.
//

import SwiftUI

struct ConfettiAnimationView: View {
    
    @State private var animate = false
    var medal: Medal
    var onFinish: () -> Void // Callback para avisar que la animación terminó.
    
    var body: some View {
        ZStack {
            // Fondo oscuro semitransparente.
            Color.black.opacity(0.6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("¡Subiste de Nivel!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Image(systemName: "star.fill") // Aquí podrías usar el ícono de la medalla: medal.icon
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: medal.progressColor))
                
                Text("\(medal.name)\nalcanzó el Nivel \(medal.level)")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            // Efecto de escala y aparición.
            .scaleEffect(animate ? 1 : 0.5)
            .opacity(animate ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                animate = true
            }
            
            // Después de 3 segundos, la animación termina y se notifica a la vista principal.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onFinish()
            }
        }
    }
}
