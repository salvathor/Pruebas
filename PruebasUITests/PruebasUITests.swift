import XCTest
import XCUIAutomation

final class LoginUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLoginMuestraAvisoDeDemostracion() {
        let app = XCUIApplication()
        app.launch()
        defer { app.terminate() }

        // La pantalla actual expone etiquetas de accesibilidad, no identificadores.
        let correo = app.textFields["Correo electrónico"]
        XCTAssertTrue(correo.waitForExistence(timeout: 5))
        correo.tap()
        correo.typeText("ana@ejemplo.com")

        // SecureField se consulta mediante secureTextFields.
        let password = app.secureTextFields["Contraseña"]
        XCTAssertTrue(password.waitForExistence(timeout: 5))
        password.tap()
        password.typeText("ClavePrueba123")

        let entrar = app.buttons["Iniciar sesión"]
        XCTAssertTrue(entrar.waitForExistence(timeout: 5))
        if !entrar.isHittable {
            app.scrollViews.firstMatch.swipeUp()
        }
        XCTAssertTrue(entrar.isHittable)
        entrar.tap()

        // El login todavía es una demostración: este es su resultado actual.
        let aviso = app.alerts["Vista de demostración"]
        XCTAssertTrue(aviso.waitForExistence(timeout: 5))
        XCTAssertTrue(aviso.staticTexts[
            "El inicio de sesión aún no está conectado. No se enviaron ni guardaron tus datos."
        ].exists)

        aviso.buttons["Entendido"].tap()
        XCTAssertTrue(aviso.waitForNonExistence(timeout: 5))
    }
}
