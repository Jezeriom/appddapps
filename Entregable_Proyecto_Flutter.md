# Informe Técnico y Entregable del Proyecto: Aplicación de Gestión de Notas Móvil y Web con Flutter, Material 3 y SharedPreferences

**Equipo de Desarrollo Flutter**  
Facultad de Ingeniería de Sistemas y Computación  
Asignatura: Desarrollo de Aplicaciones Móviles  
Docente: Evaluador del Proyecto Académico  
Octubre de 2026  

---

## Resumen

El presente informe documenta de manera exhaustiva el diseño arquitectónico, las características técnicas, las funcionalidades operativas, el proceso de ejecución y las herramientas tecnológicas empleadas en el desarrollo de la aplicación **AppDDA**. La solución es un sistema multiplataforma (móvil y web) construido sobre el framework **Flutter** y el lenguaje de programación **Dart**. La aplicación incorpora una arquitectura limpia en capas (*Clean Layered Architecture*), persistencia local desacoplada mediante **SharedPreferences**, una interfaz de usuario moderna regida por los estándares de **Material 3** con una paleta índigo/azul noche y bordes redondeados estandarizados a 12 puntos, un menú lateral interactivo tipo **Drawer** con cabecera de perfil **UserAccountsDrawerHeader**, cuadros de diálogo modales interactivos **AlertDialog** para confirmar transacciones críticas, notificaciones contextuales **SnackBar** y la compilación automatizada de íconos adaptativos mediante **flutter_launcher_icons**. Los resultados del control de calidad arrojaron 0 advertencias en el análisis estático (*flutter analyze*), un 100% de éxito en las pruebas automatizadas (*flutter test*) y una compilación web completamente verificada.

*Palabras clave:* Flutter, Material 3, SharedPreferences, Clean Architecture, Dart, Gestión de Notas, Desarrollo Móvil.

---

## 1. Introducción y Objetivos del Proyecto

El desarrollo de software moderno demanda herramientas que faciliten la entrega ágil de aplicaciones con alto rendimiento nativo y consistencia visual multiplataforma. En este contexto, el proyecto **AppDDA** fue concebido como una plataforma de notas y productividad personal orientada a cumplir con requerimientos académicos rigurosos mediante el uso del framework Flutter.

Los objetivos primordiales alcanzados en este desarrollo comprenden:
1. **Adopción de Material 3:** Configurar el tema global de la aplicación (`ThemeData`) utilizando `useMaterial3: true`, estableciendo una paleta cromática armónica basada en la semilla índigo/azul noche (`Color(0xFF1A237E)`) y radios de curvatura consistentes (`BorderRadius.circular(12)`) en entradas de formulario, botones y tarjetas.
2. **Persistencia Local Desacoplada:** Diseñar un servicio de persistencia (`PreferencesService`) fundamentado en `shared_preferences` para almacenar y consultar de manera asíncrona la sesión del usuario activo y los registros de notas serializados en formato JSON.
3. **Control de Flujo y Navegación:** Implementar una pantalla de autenticación (`LoginScreen`) y un panel principal (`HomeScreen`), conectados a través de navegación declarativa con reemplazo de ruta (`pushReplacementNamed`) y un menú lateral de navegación (`Drawer`) con desconexión segura.
4. **Interacción y Notificaciones:** Proveer cuadros de diálogo modales interactivos (`AlertDialog`) para confirmar acciones críticas de guardado y eliminación, así como avisos contextuales flotantes (`SnackBar`) para dar retroalimentación inmediata al usuario.
5. **Identidad Visual y Lanzadores:** Configurar `flutter_launcher_icons` para procesar y compilar los íconos adaptativos de la aplicación en las diferentes densidades de pantalla de Android (`mipmap-*`) e iOS.

---

## 2. Arquitectura de Software y Estructura del Código

Para garantizar modularidad, bajo acoplamiento y alta cohesión, el código fuente fue organizado bajo los principios de **Clean Layered Architecture** (Arquitectura en Capas Limpia):

```text
appdda/
|-- assets/
|   `-- icon/
|       `-- app_icon.png                   # Asset original (1024x1024 px) para lanzadores
|-- lib/
|   |-- core/
|   |   |-- constants/
|   |   |   `-- app_keys.dart              # Claves de almacenamiento y constantes de rutas
|   |   `-- theme/
|   |       `-- app_theme.dart             # Definición universal del tema Material 3
|   |-- models/
|   |   `-- note_model.dart                # Modelo de datos y serialización JSON de notas
|   |-- services/
|   |   `-- preferences_service.dart       # Fachada desacoplada para SharedPreferences
|   |-- screens/
|   |   |-- home_screen.dart               # Panel de notas, formulario y menú lateral
|   |   `-- login_screen.dart              # Formulario de autenticación y validación
|   `-- main.dart                          # Punto de entrada, inicialización y MaterialApp
|-- test/
|   |-- home_screen_test.dart              # Pruebas de widgets del panel principal
|   |-- login_screen_test.dart             # Pruebas de validación y navegación de login
|   `-- preferences_service_test.dart      # Pruebas unitarias de persistencia
`-- pubspec.yaml                           # Especificación de dependencias y configuración
```

### Descripción de las Capas del Sistema
- **Capa Core (`lib/core/`):** Centraliza la configuración visual y constantes globales. `AppTheme` define el esquema de colores a partir de `ColorScheme.fromSeed`, los estilos de bordes y la tipografía. `AppKeys` previene el uso de cadenas mágicas en la persistencia.
- **Capa de Modelos (`lib/models/`):** `NoteModel` representa la entidad inmutable de una nota con sus atributos `title`, `content` y `updatedAt`, implementando serialización y deserialización bidireccional (`toMap`, `fromMap`, `toJson`, `fromJson`).
- **Capa de Servicios (`lib/services/`):** `PreferencesService` actúa como fachada sobre el plugin `shared_preferences`, abstrayendo la manipulación directa de almacenamiento en disco para el usuario activo y las notas guardadas.
- **Capa de Presentación (`lib/screens/`):** Contiene las pantallas interactivas de usuario (`LoginScreen` y `HomeScreen`), las cuales gestionan el ciclo de vida de los controladores de texto, el estado reactivo y la interacción con los servicios.

---

## 3. Tecnologías, Herramientas y Recursos Empleados

Tabla 1  
*Especificación de Tecnologías, Paquetes y Recursos del Sistema*

| Componente | Versión / Tipo | Función Técnica en la Aplicación |
| :--- | :--- | :--- |
| **Flutter SDK** | ^3.13.5 | Framework base para compilación multiplataforma (AOT móvil y CanvasKit/HTML web). |
| **Dart SDK** | 3.x | Lenguaje de desarrollo fuertemente tipado con soporte nativo de null-safety y asincronía. |
| **shared_preferences** | ^2.2.2 | Plugin oficial para almacenamiento local clave-valor persistente en disco del dispositivo. |
| **flutter_launcher_icons** | ^0.13.1 | Utilidad de desarrollo para generar automáticamente iconos adaptativos en Android e iOS. |
| **Material 3 Design** | Nativo Flutter | Sistema de diseño de Google con esquemas cromáticos dinámicos y bordes redondeados. |
| **Material Symbols** | Icons.* | Catálogo oficial de íconos vectoriales (person, lock, save, delete, refresh, logout). |

*Nota.* Todas las librerías fueron declaradas en el manifiesto `pubspec.yaml` y resueltas satisfactoriamente.

---

## 4. Características Técnicas y Visuales de la Aplicación

La aplicación se distingue por un conjunto de características visuales y técnicas de alto nivel:
- **Diseño con Material 3:** Habilitado mediante `ThemeData(useMaterial3: true)`. Ofrece una experiencia visual contemporánea con contrastes definidos y transiciones suaves.
- **Paleta Cromática Índigo / Azul Noche:** Configurada con `Color(0xFF1A237E)` como color semilla, derivando tonalidades armónicas para superficies, barras de navegación y botones de acción.
- **Estandarización de Bordes a 12 Puntos:** Se definió un radio universal `BorderRadius.circular(12)` en `InputDecorationTheme` (estados habilitado, enfocado y con error), en `ElevatedButtonThemeData`, `FilledButtonThemeData` y en las tarjetas `CardThemeData`.
- **Iconografía Contextual Integrada:** Cada campo de entrada y botón de acción incorpora un ícono descriptivo de la colección oficial `Icons.*` de Flutter, reforzando la usabilidad y legibilidad de la interfaz.

---

## 5. Descripción Funcional y Flujos Operativos

### 5.1 Módulo de Autenticación (`LoginScreen`)
La pantalla de inicio de sesión gestiona el acceso mediante un formulario reactivo controlado por `GlobalKey<FormState>`:
- **Validaciones Reactivas:** Verifica que el nombre de usuario no esté vacío y contenga un mínimo de 3 caracteres; paralelamente, valida que la clave no esté vacía y cuente con al menos 6 caracteres. Si los datos no cumplen estas condiciones, la interfaz bloquea el avance y despliega mensajes de advertencia.
- **Alternancia de Visibilidad:** El campo de clave dispone de un botón interactivo (`Icons.visibility` / `Icons.visibility_off`) para alternar la visibilidad del texto mediante la propiedad `obscureText`.
- **Mecanismo de Login:** Una vez superada la validación de formato, el sistema almacena dinámicamente el nombre en `SharedPreferences` bajo la clave `logged_user` y redirige al panel principal con `Navigator.pushReplacementNamed`, asegurando que el botón físico de retroceso no regrese al login.
- **Aclaración sobre el Modelo de Credenciales:** La aplicación implementa autenticación simulada en el cliente (*Client-Side Mock Auth*) sin base de datos externa, permitiendo que cualquier usuario evaluador ingrese su nombre y compruebe su perfil en la interfaz. La arquitectura desacoplada permite incorporar con facilidad una lista blanca de usuarios autorizados o autenticación remota si fuese requerido.

### 5.2 Módulo de Gestión de Notas (`HomeScreen`)
El panel principal centraliza las capacidades operativas de la aplicación:
- **Recepción de Datos de Sesión:** Al inicializarse, recupera el nombre del usuario activo desde `PreferencesService` y lo expone en la interfaz.
- **Formulario de Registro:** Provee campos de texto con bordes redondeados para ingresar el título de la nota y su contenido descriptivo multilínea.
- **Diálogo Modal de Confirmación:** Al pulsar el botón "Guardar Nota", se dispara un diálogo interactivo `AlertDialog` que solicita confirmar la operación antes de persistir los datos en disco local.
- **Notificación Contextual (SnackBar):** Tras guardar satisfactoriamente, se genera una notificación flotante `SnackBar` que informa al usuario sobre el éxito de la acción.
- **Listado y Eliminación:** Las notas se listan dinámicamente con su fecha y hora de registro. Cada elemento cuenta con un botón de eliminación que también solicita confirmación modal vía `AlertDialog` para prevenir borrados accidentales.

### 5.3 Menú Lateral de Navegación (`Drawer`)
- **Cabecera de Perfil (`UserAccountsDrawerHeader`):** Despliega un avatar circular estilizado con la inicial en mayúscula del usuario, su nombre y una cuenta institucional de ejemplo.
- **Navegación y Cierre de Sesión:** Incluye accesos directos al panel principal y un botón de desconexión (`Icons.logout`). Este último limpia las credenciales almacenadas en `SharedPreferences` y redirige al usuario a la pantalla de login.

---

## 6. Proceso de Ejecución y Metodología Colaborativa

El desarrollo fue coordinado por el **Arquitecto de Software Lead**, descomponiendo la implementación en tareas atómicas asignadas a los agentes especialistas del equipo:

1. **Paso 1 (Programador):** Integración de dependencias `shared_preferences: ^2.2.2` y `flutter_launcher_icons: ^0.13.1` en `pubspec.yaml`; resolución con `flutter pub get`.
2. **Paso 2 (Programador):** Construcción de la capa core (`app_keys.dart`), servicio de persistencia (`preferences_service.dart`), tema Material 3 (`app_theme.dart`) e inicialización asíncrona en `main.dart`.
3. **Paso 5 (Codex CLI):** Procesamiento del asset base `assets/icon/app_icon.png` (1024x1024 px) y ejecución de `dart run flutter_launcher_icons` para generar mipmaps de Android e iOS.
4. **Paso 3 (Antigravity):** Implementación integral de `LoginScreen` con validaciones reactivas, alternancia de visibilidad de clave, iconos oficiales y persistencia de sesión.
5. **Paso 4 (Programador):** Desarrollo de `HomeScreen` con formulario de notas, persistencia local con timestamp, menú `Drawer` con `UserAccountsDrawerHeader`, modales `AlertDialog` y avisos `SnackBar`.
6. **Paso 6 (Auditor QA):** Ejecución de la auditoría de calidad, verificación de linter, ejecución de la suite de pruebas y validación de compilación Web.

---

## 7. Resultados de Aseguramiento de Calidad (QA)

Tabla 2  
*Resultados de la Auditoría de Calidad y Pruebas del Sistema*

| Herramienta / Prueba | Comando Ejecutado | Criterio de Aceptación | Resultado Oficial |
| :--- | :--- | :--- | :--- |
| **Linter de Dart** | `flutter analyze` | 0 errores y 0 advertencias | **Aprobado** (Clean analysis) |
| **Pruebas Automatizadas** | `flutter test` | 100% de pruebas exitosas | **Aprobado** (9 de 9 pruebas pasadas) |
| **Compilación Web** | `flutter build web --debug` | Artefactos HTML/JS compilados | **Aprobado** (Build exitoso) |
| **Generación de Lanzadores** | `dart run flutter_launcher_icons` | Recursos mipmap generados | **Aprobado** (Iconos adaptativos) |

*Nota.* Datos certificados por el agente Auditor QA en el ciclo de entrega.

---

## 8. Evidencias Visuales de Ejecución

Figura 1  
*Panel de Notas de AppDDA en Ejecución Web con Material 3*

*(Imagen del sistema insertada a continuación)*

*Nota.* Captura de pantalla oficial de la aplicación ejecutándose en navegador Web. Se evidencia la cabecera "Panel de Notas", el menú de hamburguesa, los campos de entrada redondeados (`BorderRadius.circular(12)`), el botón de guardado en tono índigo y el listado de notas persistidas localmente con su respectiva marca de tiempo.

---

## 9. Conclusiones y Recomendaciones

La aplicación **AppDDA** satisface en su totalidad los requerimientos funcionales, arquitectónicos y estéticos estipulados. La integración armoniosa de **Material 3** ofrece una experiencia de usuario moderna y atractiva, la persistencia con **SharedPreferences** brinda almacenamiento confiable en disco local, y la estructura en capas limpias garantiza mantenibilidad y extensibilidad para incorporar futuras funcionalidades como sincronización en la nube o bases de datos relacionales locales.

---

## 10. Referencias Bibliográficas

- Flutter. (2026). *Material Design 3 in Flutter*. Flutter Documentation. https://docs.flutter.dev/ui/design/material
- Google. (2026). *Material Design: The Material 3 Design System*. https://m3.material.io
- Mark, B. (2024). *flutter_launcher_icons: A package which simplifies the task of updating your Flutter app's launcher icon*. pub.dev. https://pub.dev/packages/flutter_launcher_icons
- The Flutter Team. (2024). *shared_preferences package: Flutter plugin for reading and writing simple key-value pairs*. pub.dev. https://pub.dev/packages/shared_preferences
