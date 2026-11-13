//
//  PruebasTests.swift
//  PruebasTests
//
//  Created by Salvador Lopez on 12/11/26.
//

// XCTest proporciona XCTestCase y las aserciones XCTAssert….
import XCTest
// Permite acceder a miembros internal del módulo compilado con testabilidad habilitada.
// No permite acceder a miembros private.
@testable import Pruebas

/// Pruebas unitarias: llaman a la lógica directamente, sin tocar la interfaz.
/// XCTest descubre métodos sin parámetros cuyo nombre comienza con test.
final class CalculadoraTest: XCTestCase {
    
    // Arrange (preparar): entradas 2 y 3; resultado esperado 5.
    // Act (actuar) y Assert (verificar) están juntos en XCTAssertEqual.
    func testSumaDosNumeros(){
        XCTAssertEqual(Calculadora.suma(2, 3), 5)
    }
    
    // throws permite que XCTest registre como fallo un error inesperado de divide.
    // Esta prueba cubre una división válida; no cubre la división entre cero.
    func testDivisionValida() throws {
        let resultado = try Calculadora.divide(10, 2)
        XCTAssertEqual(resultado, 5)
    }
    
    // Ejemplo de aserciones sobre opcionales. suma devuelve Int: envolverlo en Int?
    // hace que la comprobación de no-nil sea demostrativa, no un caso de ausencia real.
    func testResultadoNoEsNil(){
        let valor: Int? = Calculadora.suma(1,1)
        XCTAssertNotNil(valor)
        // Atención: XCTAssertNotNil registra un fallo, pero no desempaqueta el valor
        // ni garantiza detener la ejecución. Si fuera nil, valor! podría provocar un crash.
        // Para un opcional real, usar try XCTUnwrap en un test marcado throws.
        XCTAssertTrue(valor! > 0)
    }
}

/// Pruebas de un objeto con estado: cada método debe comenzar con un carrito nuevo.
final class CarritoTests: XCTestCase {
    
    var sut: Carrito! // SUT = System Under Test: sistema u objeto bajo prueba.
    // El opcional implícito depende de que setUpWithError lo inicialice antes de usarlo.
    
    // XCTest lo ejecuta antes de CADA prueba, evitando compartir productos entre casos.
    override func setUpWithError() throws {
        sut = Carrito()
    }
    
    // XCTest lo ejecuta después de cada prueba para liberar el estado de preparación.
    // No debe dependerse del orden en que se ejecutan los métodos test….
    override func tearDownWithError() throws {
        sut = nil
        try  super.tearDownWithError()
    }
    
    // Verifica el estado inicial creado por setUpWithError.
    func testCarritoEmpiezaVacio() {
        XCTAssertTrue(sut.productos.isEmpty)
    }
    
    // Act: agregar dos productos. Assert: comprobar el total acumulado exacto.
    func testAgregarIncrementaElTotal() {
        sut.agregar(Producto(nombre: "Refresco", precio: 30))
        sut.agregar(Producto(nombre: "Doritos", precio: 20))
        XCTAssertEqual(sut.total, 50)
    }
    
    func testBuscarProductoExistente() throws {
        sut.agregar(Producto(nombre: "Café", precio: 30))
        // XCTUnwrap devuelve Producto si existe; si es nil, registra el fallo y lanza
        // un error. Con try y throws se abandona el método sin usar un valor inexistente.
        let producto = try XCTUnwrap(sut.buscar("Café"))
        XCTAssertEqual(producto.precio, 30)
    }
    
}
