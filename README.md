# PastiTrack

**PastiTrack** es una aplicación móvil diseñada para gestionar y enviar recordatorios de medicación para pacientes. Con un enfoque centrado en la región de habla hispana, esta solución integra funcionalidades modernas como sincronización de bases de datos locales y en la nube, notificaciones y gestión de rutinas.

![PastiTrack Logo](https://github.com/jtorsuarz/PastiTrack/blob/main/assets/icon/icon.png) <!-- Agrega un logo si tienes uno -->

---

## 🚀 Características principales

- **Gestión de Medicamentos:** Permite agregar, editar y eliminar medicamentos desde una base de datos local.
- **Recordatorios Personalizados:** Notificaciones para garantizar que nunca olvides tomar tus medicinas.
- **Sincronización Offline/Online:** Los datos se sincronizan automáticamente entre SQLite (local) y Firebase Firestore (remota).
- **Gestión de Rutinas:** Asocia medicamentos a rutinas diarias para facilitar la administración.
- **Soporte Multiplataforma:** Disponible en Android e iOS.
- **Autenticación Segura:** Manejo de usuarios con Firebase Authentication.
- **Diseño Moderno:** Uso de Flutter con Material Design 3.

---

## 🛠️ Tecnologías utilizadas

### **Frontend**
- [Flutter](https://flutter.dev/) - Framework para el desarrollo de aplicaciones móviles.
- [BLoC](https://bloclibrary.dev/) - Gestión de estado.

### **Backend**
- **Firebase**:
  - **Firestore:** Base de datos en la nube.
  - **Firebase Authentication:** Manejo de usuarios.
  - **Firebase Storage:** Almacenamiento de archivos.
- **SQLite:** Base de datos local para almacenamiento offline.

### **Herramientas de desarrollo**
- [Mockito](https://pub.dev/packages/mockito) - Framework para la creación de mocks en tests.

---

## 📱 Capturas de pantalla

> Pronto añadiremos imágenes que muestren la funcionalidad de la app.

---

## 🧪 Pruebas

El proyecto utiliza pruebas unitarias, de integración y de widgets para garantizar la calidad del software. Estas son las herramientas utilizadas:

- **bloc_test:** Validación de la lógica de negocios en los BLoC.
- **mockito:** Mocking de dependencias.
- **integration_test:** Ejecución de pruebas de extremo a extremo.
- **flutter_test:** Pruebas estándar de Flutter.

Ejecuta todas las pruebas con:
```bash
flutter test
