# Aprender pruebas con Pruebas

Proyecto didáctico con seis pruebas unitarias y una prueba de interfaz escritas con XCTest. La app muestra formularios de acceso, registro y recuperación, todos de demostración: no hay autenticación real ni conexión a un servidor.

## Ruta de lectura

1. Lee los modelos Calculadora, Producto y Carrito al final de Pruebas/ContentView.swift.
2. Abre PruebasTests/PruebasTests.swift para relacionar cada operación con su prueba.
3. Abre PruebasUITests/PruebasUITests.swift para seguir el recorrido por la pantalla.
4. Ejecuta los casos y realiza los ejercicios de esta guía.

PruebasApp.swift inicia la aplicación y presenta ContentView. Los modelos de ejemplo están en el mismo archivo que las vistas, pero sus pruebas no necesitan interactuar con ellas.

## Prueba unitaria frente a prueba de interfaz

| Aspecto | Unitaria | Interfaz (UI) |
| --- | --- | --- |
| Qué verifica | Una operación o comportamiento de un modelo | Un recorrido visible de la app |
| Ejemplo aquí | Agregar productos produce un total de 50 | Tocar Iniciar sesión presenta un aviso |
| Cómo actúa | Llama métodos de Swift directamente | Lanza la app, escribe y toca controles |
| Herramientas | XCTestCase y XCTAssert… | XCTest más XCUIAutomation |
| Dependencias | Datos y objetos del caso | Proceso de la app, pantalla, teclado e idioma |

Una prueba unitaria puede ejecutarse alojada en la app según la configuración del target; eso no la convierte en prueba de UI. La diferencia es qué comportamiento ejercita.

XCTest es el framework; XCTestCase es la clase base que agrupa los casos. En este proyecto, los métodos sin parámetros que empiezan con test son pruebas. Swift Testing es otro framework, con una sintaxis diferente; esta guía explica los ejemplos existentes de XCTest.

## Preparar, actuar y verificar (AAA)

- Arrange: preparar entradas y estado inicial.
- Act: ejecutar la operación que interesa.
- Assert: comparar el resultado real con el esperado.

En testAgregarIncrementaElTotal, setUpWithError prepara un carrito vacío, las llamadas a agregar realizan la acción y XCTAssertEqual(sut.total, 50) verifica el resultado. El valor esperado se escribe explícitamente: calcularlo repitiendo la implementación podría reproducir el mismo error.

SUT significa System Under Test, u objeto bajo prueba. En CarritoTests, sut representa el carrito.

## Ciclo de cada prueba

Para los métodos implementados en CarritoTests, el recorrido es:

`setUpWithError → método test… → tearDownWithError`

setUpWithError crea un carrito nuevo antes de cada caso. tearDownWithError elimina la referencia al terminar. Así, los productos agregados por un caso no afectan al siguiente. Ninguna prueba debe depender del orden de ejecución.

El sufijo WithError permite lanzar errores durante la preparación o limpieza. Asimismo, un método test marcado throws permite que XCTest registre un error inesperado como fallo. Usar throws no significa que la prueba espere un error: para comprobar uno esperado se utiliza una aserción específica.

## Aserciones utilizadas

| API | Qué comprueba | Ejemplo del proyecto |
| --- | --- | --- |
| XCTAssertEqual | Igualdad entre resultado real y esperado | Suma 2 + 3 igual a 5 |
| XCTAssertTrue | Una condición verdadera | El carrito empieza vacío |
| XCTAssertNotNil | Que un opcional contiene valor | Ejemplo didáctico de suma envuelta en Int? |
| XCTUnwrap | Obtiene el valor o registra fallo y lanza un error | Buscar el producto Café |

XCTAssertNotNil no convierte el opcional en un valor no opcional ni garantiza detener la ejecución. El valor! que aparece en el ejemplo existente puede provocar un cierre si el valor es nil. Para comprender una alternativa segura, observa el uso de try XCTUnwrap en testBuscarProductoExistente.

La suma devuelve Int, por lo que convertir su resultado a Int? siempre produce un valor presente. Ese caso enseña la sintaxis, pero no cubre una ausencia real. buscar sí devuelve un opcional que puede ser nil.

## Qué cubren los casos actuales

| Caso | Resultado esperado |
| --- | --- |
| testSumaDosNumeros | 2 + 3 = 5 |
| testDivisionValida | 10 / 2 = 5, sin error |
| testResultadoNoEsNil | La suma envuelta en opcional existe y es positiva |
| testCarritoEmpiezaVacio | productos está vacío al crear el carrito |
| testAgregarIncrementaElTotal | Los precios 30 y 20 suman 50 |
| testBuscarProductoExistente | Café existe y cuesta 30 |
| testLoginMuestraAvisoDeDemostracion | El aviso aparece con su mensaje y desaparece al cerrarlo |

Estos casos no demuestran que todo el proyecto sea correcto. No cubren todavía división entre cero, búsquedas sin coincidencia, registro, recuperación ni el botón para mostrar la contraseña.

## Leer la prueba de UI

XCUIApplication representa la aplicación bajo control; launch la abre. defer programa terminate al salir del ámbito del método. Terminar la app no borra automáticamente sus datos persistidos.

La prueba busca los campos por las etiquetas de accesibilidad «Correo electrónico» y «Contraseña». Las consultas dependen del idioma y del texto actual. En una ampliación del proyecto se pueden usar identificadores de accesibilidad estables para evitar depender de las traducciones.

waitForExistence(timeout: 5) espera hasta que el elemento exista o se agote el límite. No es una pausa fija de cinco segundos. exists consulta la existencia en ese momento; isHittable comprueba si el elemento puede recibir interacción. Tras cerrar el aviso, waitForNonExistence espera a que desaparezca.

continueAfterFailure = false evita continuar el caso después de una aserción fallida. @MainActor aísla el método al actor principal para las operaciones de interfaz.

El test verifica un aviso de demostración: escribir un correo y una contraseña no demuestra un inicio de sesión válido.

## Ejecutar e interpretar resultados en Xcode

1. Selecciona el esquema Pruebas y un simulador compatible.
2. Abre el navegador de pruebas con Command + 6.
3. Usa el control junto a un método o clase para ejecutar solo esos casos.
4. Usa Product > Test (Command + U) para ejecutar las pruebas habilitadas en el esquema.
5. Revisa el resultado de cada caso y su línea de fallo. El navegador de informes permite consultar ejecuciones anteriores.

Si no aparecen los casos, revisa que los targets PruebasTests y PruebasUITests estén incluidos en la acción Test del esquema o en su plan de pruebas.

Compilar no equivale a ejecutar: una compilación correcta solo confirma que el código puede construirse. Una aserción fallida indica que el resultado observado no coincide con el esperado; primero revisa los datos, la expectativa y la implementación. En UI también revisa idioma, elemento buscado y estado de la pantalla.

Ejercicio de diagnóstico: cambia temporalmente el resultado esperado de la suma a 6, ejecuta solo esa prueba, lee el fallo y restaura 5. El objetivo es reconocer cómo se informa una regresión.

## Ejercicios siguientes (no implementados)

1. División entre cero: comprobar que divide(10, 0) lanza ErrorMath.divisionPorCero; investigar XCTAssertThrowsError y verificar también el tipo de error.
2. División entera: comprobar que divide(7, 2) devuelve 3; el resultado no es decimal.
3. Búsqueda ausente: buscar un nombre no agregado y verificar nil con XCTAssertNil.
4. Carrito vacío: comprobar que total es cero.
5. Precios decimales: agregar importes creados con Decimal y comprobar su suma.
6. Opcionales: sustituir el desempaquetado forzado del ejemplo por XCTUnwrap en un método throws.
7. UI: comprobar mostrar/ocultar contraseña o navegar a registro, con un caso independiente por comportamiento.

Carrito permite productos repetidos y precios negativos; buscar distingue mayúsculas y minúsculas y devuelve la primera coincidencia. Decide primero el comportamiento deseado antes de escribir nuevas expectativas. Calculadora no maneja desbordamientos de Int.

## Referencias de Apple

- [XCTest](https://developer.apple.com/documentation/xctest)
- [Preparación y limpieza de pruebas](https://developer.apple.com/documentation/xctest/set-up-and-tear-down-state-in-your-tests)
- [XCUIAutomation](https://developer.apple.com/documentation/xcuiautomation)
