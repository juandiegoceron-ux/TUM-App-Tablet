# T.U.M. Web (Tecnología y Oso Andino en Movimiento)

¡Bienvenido al repositorio de **T.U.M. Web**! Esta plataforma interactiva está diseñada para la educación ambiental y la conservación del oso andino (u oso de anteojos) mediante mecánicas lúdicas de gamificación dirigidas a exploradores de 8 a 23 años.

Este documento sirve como **guía de inicio rápido y manual de arquitectura** tanto para desarrolladores como para agentes de Inteligencia Artificial que colaboren en el proyecto.

---

## 📋 1. HISTORIA DEL PROYECTO Y MIGRACIÓN

El proyecto se concibió inicialmente como una aplicación nativa para tabletas móviles utilizando **Flutter** con base de datos en **Firebase**. Sin embargo, para mejorar el despliegue escolar y la compatibilidad con navegadores, el proyecto se migró a una **Aplicación Web Responsiva**.

### 🔄 Resumen de Cambios Clave:
* **Lenguaje y Framework:** Reemplazo de Dart/Flutter por **React 18 + JavaScript**.
* **Compilación y Servidor:** Uso de **Vite** en reemplazo del compilador nativo de Flutter.
* **Persistencia:** Remoción de Firebase en el frontend. La integración futura se realizará con una base de datos **PostgreSQL** administrada de forma independiente por el equipo de desarrollo de backend.
* **Diseño:** Implementación de estilos a medida con **Vanilla CSS** (sin Tailwind u otros frameworks) para replicar exactamente la identidad visual de la marca forestal.

---

## 🔗 2. CONTROL DE VERSIONES (GIT)

El proyecto está vinculado a dos repositorios remotos:

* **Origin (Tu repositorio):** `https://github.com/juandiegoceron-ux/TUM-App-Tablet.git`
* **Upstream (Repositorio principal):** `https://github.com/Anfeli52/TUM-App.git`
* **Rama de Trabajo activa:** `main`

### 💻 Flujo de Trabajo Git Recomendado:
Para registrar y subir cambios desde la terminal local:
```bash
git add -A
git commit -m "Descripción clara de las modificaciones realizadas"
git push origin main
```

---

## 🛠️ 3. REQUISITOS PREVIOS Y EJECUCIÓN

### Requisitos del Sistema:
* **Node.js:** Versión 18.0.0 o superior (Recomendado v24.18.0 LTS).
* **NPM:** Versión 9.0.0 o superior (instalado con Node.js).

### Comandos de Configuración Rápida:

1. **Instalar Dependencias:**
   ```bash
   npm install
   ```

2. **Iniciar Servidor de Desarrollo:**
   ```bash
   npm run dev
   ```
   *El servidor local por defecto arrancará en:* [http://localhost:5173/](http://localhost:5173/)

3. **Construir para Producción (Build):**
   ```bash
   npm run build
   ```

---

## 📂 4. ARQUITECTURA DEL CÓDIGO Y ESTRUCTURA

La estructura actual del espacio de trabajo es la siguiente:

```text
TUM-App/
├── assets/                     # Recursos de imágenes y logos
│   ├── fondo.png               # Fondo del bosque/páramo para el inicio
│   ├── osito (2)-Photoroom.png # Oso sentado con fondo transparente (Inicio/Registro)
│   ├── osito1.png              # Oso asomado con fondo transparente (Login)
│   ├── google.png / apple.png  # Iconos para botones de autenticación
│   ├── 8-11age.png             # Insignia de rango Explorador Curioso (8-11 años)
│   ├── 12-15age.png            # Insignia de rango Aprendiz STEM (12-15 años)
│   ├── 16-19age.png            # Insignia de rango Joven Innovador (16-19 años)
│   └── 20-23age.png            # Insignia de rango Mente Creativa (20-23 años)
├── node_modules/               # Dependencias del motor de Node
├── src/                        # Código fuente
│   ├── components/             # Componentes modulares de la interfaz
│   │   ├── Welcome.jsx         # Vista inicial de Bienvenida
│   │   ├── Welcome.css         # Estilos visuales de Bienvenida
│   │   ├── Login.jsx           # Formulario de credenciales de acceso (vacío por defecto)
│   │   ├── Login.css           # Estilos visuales del Login
│   │   ├── Register.jsx        # Pantalla de creación de cuenta y Modal de Rangos
│   │   ├── Register.css        # Estilos visuales del Registro y Modal
│   │   ├── Dashboard.jsx       # Panel de control de minijuegos
│   │   └── Dashboard.css       # Estilos visuales del Dashboard (Casita)
│   ├── App.jsx                 # Controlador de rutas ('welcome', 'login', 'register', 'dashboard')
│   ├── index.css               # Tokens de diseño CSS global y resets
│   └── main.jsx                # Punto de entrada de renderizado de React
├── .gitignore                  # Exclusiones de Git (node_modules, dist, etc.)
├── index.html                  # Contenedor HTML principal y Google Fonts
├── package.json                # Gestión de paquetes y dependencias npm
└── vite.config.js              # Configuración del compilador Vite
```

---

## 🎨 5. SISTEMA DE DISEÑO VISUAL (DESIGN SYSTEM)

Los colores y el comportamiento visual están regidos por variables nativas en `src/index.css`:

* **Fondo general:** `#E2EFE0` a `#83A98B` (Degradado bosque/páramo).
* **Color Primario Oscuro:** `#2E4A3F` (Verde pino para textos y botones).
* **Campos de Entrada (Inputs):** `#233A31` (Verde oscuro integrado).
* **Cabecera del Dashboard:** `#5B4332` (Marrón café para simular un ambiente rústico natural).
* **Acentos:** `#F4C430` (Amarillo oro para elementos seleccionados y avatares).
* **Errores:** `#FF5A5A` (Mensajes en rojo para inputs con validación fallida).
* **Fuente Principal:** **Outfit** de Google Fonts, cargada en `index.html`.

---

## 🧩 6. GUÍA DE COMPONENTES E INTERACCIONES

### 6.1 `App.jsx` (Enrutador de Estado)
Controla qué vista se muestra actualmente al usuario a través del estado reactivo `page` (`'welcome'`, `'login'`, `'register'`, o `'dashboard'`). Adicionalmente, almacena los datos de sesión en el estado `user` tras la autenticación.

### 6.2 `Welcome.jsx` (Bienvenida)
* **Visual:** Muestra la imagen del oso sentado (`osito (2)-Photoroom.png`) con animación de balanceo vertical suave (`bounceSlow`), el badge *"Aprende jugando"* y el botón *"Comenzar"*.
* **Interacción:** El botón *"Comenzar"* cambia el estado de `page` a `'login'`.

### 6.3 `Login.jsx` (Acceso)
* **Visual:** Cuenta con un oso saludando a la izquierda (`osito1.png`) y el formulario a la derecha. Los campos de texto inician completamente vacíos por defecto.
* **Interacción:** 
  * El formulario valida las credenciales introducidas y deriva el nombre del usuario a partir de su correo.
  * El botón *"Crea tu cuenta"* redirige a la vista `'register'`.
  * El botón de **Google** simula un inicio de sesión exitoso usando el correo institucional `juan_diego.ceron@uao.edu.co`.

### 6.4 `Register.jsx` (Registro)
* **Visual:** Muestra un formulario de registro a la izquierda (con inputs de Nombre/correo, Edad, Contraseña y Confirmar Contraseña) y la imagen del oso (`osito (2)-Photoroom.png`) en el panel lateral a la derecha.
* **Validación y Errores:**
  * Al intentar finalizar, comprueba un correo válido, una edad numérica comprendida entre 8 y 23 años, y contraseñas coincidentes de longitud mínima de 8 caracteres.
  * Los mensajes de error de validación fallida se renderizan en color rojo directamente bajo el campo correspondiente.
* **Modal de Rangos (ⓘ):** El botón de información al lado de *"ELIGE TU RANGO"* abre un diálogo modal superpuesto con los detalles de los rangos (*Explorador Curioso*, *Aprendiz STEM*, *Joven Innovador*, *Mente Creativa*) utilizando los recursos gráficos cargados en `assets/`.

### 6.5 `Dashboard.jsx` (Panel Principal / "Casita")
* **Cabecera:** Barra superior de color marrón con el avatar del usuario, saludo personalizado y tres badges interactivos:
  1. **Batería (65%):** Barra de progreso verde.
  2. **Estado ("Sentado"):** Icono de accesibilidad.
  3. **Conectividad ("T.U.M. conectado"):** Icono de señal Wi-Fi activa.
* **Rejilla de Juegos (4x4):** Contiene un catálogo de 16 tarjetas.
  * Las primeras 10 tarjetas corresponden a minijuegos activos (ej. *El Comienzo*, *Guía a T.U.M.*, *¿Como me siento?*). Al hacer clic sobre ellos, se resalta su borde en color amarillo y se abre una ventana modal de simulación de juego.
  * Las últimas 6 tarjetas muestran un candado cerrado y la etiqueta *"Próximamente"*.
* **Navegación Flotante Inferior:** Barra en forma de píldora que se desplaza horizontalmente. Permite alternar la visualización del contenido entre las secciones:
  * **Inicio:** Muestra la rejilla de juegos.
  * **Conoce a T.U.M.:** Muestra un texto explicativo del proyecto.
  * **Perfil:** Resumen de progreso del explorador.
  * **Ajustes:** Habilitación de sonido/música y opción de Cerrar Sesión.

---

## 🤖 7. DIRECTRICES PARA FUTUROS AGENTES DE IA

Si eres un agente de IA continuando este desarrollo, ten en cuenta las siguientes pautas:

1. **Integración de Base de Datos:**
   El frontend está listo para comunicarse con la base de datos PostgreSQL de backend. Reemplaza el controlador de login y registro estático en `src/components/Login.jsx` y `src/components/Register.jsx` por llamadas asíncronas (`fetch` o `axios`) a los endpoints del servidor una vez que estén definidos por el compañero de equipo.
2. **Adición de Nuevos Minijuegos:**
   Para habilitar más juegos en la cuadrícula, modifica el arreglo `gameCards` en `src/components/Dashboard.jsx`. Cambia las propiedades `active: false, lock: true` a `active: true` y asígnale un ícono de la librería `lucide-react`.
3. **Mantenimiento del Diseño:**
   No utilices Tailwind CSS ni otras utilidades utilitarias en línea. Todos los nuevos diseños deben declararse en los archivos `.css` correspondientes usando las variables de diseño del archivo `src/index.css`.
