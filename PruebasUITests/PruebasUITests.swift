
// XCTest organiza el caso y sus aserciones; XCUIAutomation controla la interfaz.
import XCTest
import XCUIAutomation

/// Prueba de UI: ejecuta la app y reproduce acciones de una persona.
/// Comprueba el aviso de demostración; no valida credenciales ni un servidor real.
final class LoginUITest: XCTestCase {
    
    override func setUpWithError() throws {
        // Detener el caso al fallar evita acciones posteriores sobre elementos ausentes.
        continueAfterFailure = false
    }
    
    // Aísla las operaciones de interfaz de este método al actor principal.
    @MainActor
    func testLoginMuestraAvisoDeDemostracion(){
        
        // Arrange: crear el controlador de la aplicación y lanzar su proceso.
        let app = XCUIApplication()
        app.launch()
        // Limpieza al salir de este ámbito; no equivale a borrar datos persistidos.
        defer {
            app.terminate()
        }
        
        // Act: localizar el campo por su etiqueta de accesibilidad.
        // waitForExistence espera como máximo 5 segundos y devuelve Bool.
        // XCTAssertTrue convierte un resultado false en un fallo del test.
        let correo = app.textFields["Correo electrónico"]
        XCTAssertTrue(correo.waitForExistence(timeout: 5))
        correo.tap()
        correo.typeText("salvador@correo.com")
        
        // SecureField se consulta mediante secureTextFields, no textFields.
        let password = app.secureTextFields["Contraseña"]
        XCTAssertTrue(password.waitForExistence(timeout: 5))
        password.tap()
        password.typeText("Clave123")
        
        // Existir en la jerarquía no implica poder recibir un toque.
        // isHittable comprueba que el botón admite la interacción en este momento.
        let boton = app.buttons["Iniciar sesión"]
        XCTAssertTrue(boton.waitForExistence(timeout: 5))
        XCTAssertTrue(boton.isHittable)
        boton.tap()
        
        // Assert: comprobar tanto el título como el mensaje del aviso esperado.
        let aviso = app.alerts["Vista de demostración"]
        XCTAssertTrue(aviso.waitForExistence(timeout: 5))
        XCTAssertTrue(aviso.staticTexts["El inicio de sesión aún no está conectado. No se enviaron ni guardaron tus datos."].exists)
        
        aviso.buttons["Entendido"].tap()
        // Tras cerrar el aviso esperamos su desaparición, no su existencia.
        // Las esperas por condición toleran el tiempo de transición de la interfaz.
        XCTAssertTrue(aviso.waitForNonExistence(timeout: 5))
        
    }
    
}
