//
//  PruebasApp.swift
//  Pruebas
//
//  Created by Salvador Lopez on 12/11/26.
//

import SwiftUI

/// Punto de entrada de la aplicación. La prueba de UI llega a ContentView al lanzarla.
/// Las pruebas unitarias llaman directamente a Calculadora y Carrito.
@main
struct PruebasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
