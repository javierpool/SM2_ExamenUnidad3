# Informe Examen Unidad III - Práctico (Github Actions)

- **Curso:** Desarrollo de Aplicaciones Móviles
- **Fecha:** 23 de Junio de 2026
- **Estudiante:** Javier Pool
- **URL del repositorio:** https://github.com/javierpool/SM2_ExamenUnidad3

## 1. Explicación de lo realizado
En este examen se ha logrado:
1. Copiar el proyecto Flutter al directorio actual para iniciar un nuevo repositorio limpio.
2. Crear la estructura `.github/workflows/` y agregar el archivo `quality-check.yml` que configura GitHub Actions para ejecutar comandos de validación en la nube (Ubuntu).
3. Agregar el archivo `test/main_test.dart` con **3 pruebas unitarias** que evalúan la lógica y el parsing de la clase `UserModel` de la aplicación.
4. Las acciones están configuradas para ejecutarse automáticamente en los eventos de `push` y `pull_request` en la rama `main`.
5. Durante la ejecución en GitHub Actions, se levanta el entorno de Flutter versión 3.19.0, se obtienen las dependencias con `flutter pub get`, se analiza el código con `flutter analyze` y finalmente se ejecutan las pruebas con `flutter test`.

---

## 2. Capturas de pantalla (Evidencias)

### A. Estructura de carpetas `.github/workflows/`
*(Reemplaza esta imagen con la captura de pantalla de la estructura de tus carpetas en Visual Studio Code o en GitHub mostrando la carpeta .github/workflows)*

> ![Estructura de carpetas](ruta/a/tu/captura_estructura.png)

### B. Contenido del archivo `quality-check.yml`
*(Reemplaza esta imagen con la captura de pantalla del código del workflow)*

> ![Contenido quality check](ruta/a/tu/captura_yml.png)

### C. Ejecución del workflow en la pestaña Actions
*(Reemplaza esta imagen con la captura de pantalla donde se vea el check verde "Passed" en la pestaña Actions de tu repositorio en GitHub)*

> ![Ejecución exitosa](ruta/a/tu/captura_actions.png)

---
*Este archivo debe ser convertido a PDF (usando la opción Print -> Save as PDF o alguna extensión de Markdown a PDF en VS Code) y entregado en la plataforma.*
