//
//  ContentView.swift
//  Pruebas
//
//  Created by Salvador Lopez on 12/11/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            AuthPage {
                AuthHeader(
                    title: "Bienvenido",
                    subtitle: "Inicia sesión para continuar."
                )
                LoginForm()
                NavigationLink("Crear una cuenta") {
                    RegistrationView()
                }
                .font(.subheadline.weight(.medium))
                .frame(minHeight: 44)
            }
            .navigationTitle("Bienvenida")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.indigo)
    }
}

private struct AuthPage<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                content
            }
            .frame(maxWidth: 460)
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemBackground))
    }
}

private struct AuthHeader: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showsNotice = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            EmailField(email: $email)
            PasswordField(title: "Contraseña", password: $password)

            NavigationLink("¿Olvidaste tu contraseña?") {
                PasswordRecoveryView()
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .trailing)

            Button {
                showsNotice = true
            } label: {
                Text("Iniciar sesión")
                    .frame(maxWidth: .infinity, minHeight: 32)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }

        .alert("Vista de demostración", isPresented: $showsNotice) {
            Button("Entendido", role: .cancel) { }
        } message: {
            Text("El inicio de sesión aún no está conectado. No se enviaron ni guardaron tus datos.")
        }
    }
}

private struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmation = ""
    @State private var showsNotice = false

    var body: some View {
        AuthPage {
            AuthHeader(
                title: "Crea tu cuenta",
                subtitle: "Completa tus datos para registrarte."
            )

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nombre completo")
                        .font(.subheadline.weight(.semibold))
                    TextField("Tu nombre y apellidos", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .authFieldStyle()
                        .accessibilityLabel("Nombre completo")
                }
                EmailField(email: $email)
                PasswordField(title: "Contraseña", password: $password, isNewPassword: true)
                Text("Al menos 8 caracteres.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                PasswordField(
                    title: "Confirmar contraseña",
                    password: $confirmation,
                    isNewPassword: true
                )

                Button {
                    showsNotice = true
                } label: {
                    Text("Crear cuenta")
                        .frame(maxWidth: .infinity, minHeight: 32)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }


        }
        .navigationTitle("Registro")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Vista de demostración", isPresented: $showsNotice) {
            Button("Entendido", role: .cancel) { }
        } message: {
            Text("Este formulario es solo una interfaz. No se creó ninguna cuenta ni se guardaron tus datos.")
        }
    }
}

private struct PasswordRecoveryView: View {
    @State private var email = ""
    @State private var showsNotice = false

    var body: some View {
        AuthPage {
            AuthHeader(
                title: "Recupera tu acceso",
                subtitle: "Ingresa el correo de tu cuenta."
            )
            VStack(alignment: .leading, spacing: 24) {
                EmailField(email: $email)
                Button {
                    showsNotice = true
                } label: {
                    Text("Enviar enlace")
                        .frame(maxWidth: .infinity, minHeight: 32)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }

        }
        .navigationTitle("Recuperar contraseña")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Vista de demostración", isPresented: $showsNotice) {
            Button("Entendido", role: .cancel) { }
        } message: {
            Text("La recuperación aún no está conectada. No se envió ningún correo.")
        }
    }
}

private struct EmailField: View {
    @Binding var email: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Correo electrónico")
                .font(.subheadline.weight(.semibold))
            TextField("nombre@ejemplo.com", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .authFieldStyle()
                .accessibilityLabel("Correo electrónico")
        }
    }
}

private struct PasswordField: View {
    let title: LocalizedStringKey
    @Binding var password: String
    var isNewPassword = false
    @State private var isVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            HStack(spacing: 8) {
                Group {
                    if isVisible {
                        TextField("Escribe tu contraseña", text: $password)
                    } else {
                        SecureField("Escribe tu contraseña", text: $password)
                    }
                }
                .textContentType(isNewPassword ? .newPassword : .password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .accessibilityLabel(title)

                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .frame(minWidth: 44, minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .accessibilityLabel(isVisible ? "Ocultar contraseña" : "Mostrar contraseña")
            }
            .authFieldStyle()
        }
    }
}

private extension View {
    func authFieldStyle() -> some View {
        self
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .frame(minHeight: 52)
            .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))

    }
}

#Preview {
    ContentView()
}

#Preview("Registro") {
    NavigationStack {
        RegistrationView()
    }
    .tint(.indigo)
}

enum Calculadora {
    enum ErrorMath: Error, Equatable {
        case divisionPorCero
    }
    static func suma(_ a: Int, _ b: Int) -> Int {
       a + b
    }
    static func divide(_ a: Int, _ b: Int) throws -> Int {
        guard b != 0 else {
            throw ErrorMath.divisionPorCero
        }
        return a / b
    }
}
