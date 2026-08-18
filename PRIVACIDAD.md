# Política de privacidad y protección de datos

> Documento de apoyo para adaptar antes de utilizar la aplicación en una organización. Los campos entre corchetes deben completarse. No sustituye el asesoramiento profesional ni el registro interno de actividades de tratamiento.

## 1. Responsable del tratamiento

- Responsable: **[nombre o razón social]**.
- NIF/CIF: **[identificador]**.
- Dirección: **[dirección postal]**.
- Contacto de privacidad: **[correo electrónico o dirección]**.
- Delegado de Protección de Datos, si procede: **[datos de contacto]**.

## 2. Datos tratados

La aplicación puede contener nombre y apellidos, DNI, número de afiliación, empresa, horarios de entrada y salida, jornada pactada, vacaciones, permisos, ausencias, bajas y movimientos de la bolsa de horas.

Las anotaciones de bajas, hospitalizaciones, intervenciones o visitas médicas pueden revelar datos relativos a la salud. Deben limitarse a la categoría laboral imprescindible, evitando registrar diagnósticos, informes clínicos o detalles personales innecesarios.

## 3. Finalidades

- Gestionar y acreditar el registro diario de jornada.
- Calcular horas ordinarias, horas extraordinarias y descansos compensatorios.
- Gestionar vacaciones, permisos y ausencias.
- Generar documentos mensuales, calendarios anuales, resúmenes y copias de seguridad.
- Atender obligaciones legales y posibles requerimientos de autoridades competentes.

Los datos no deben utilizarse para una finalidad incompatible sin informar previamente a las personas afectadas y determinar una base jurídica válida.

## 4. Base jurídica

Para el registro de jornada, la base jurídica habitual es el cumplimiento de una obligación legal aplicable al responsable, conforme al artículo 6.1.c del RGPD y al artículo 34.9 del Estatuto de los Trabajadores. La AEPD indica que, con carácter general, no se requiere el consentimiento de la persona trabajadora para implantar el registro horario, aunque sí debe ser informada del tratamiento.

La organización debe determinar y documentar la base jurídica concreta de cualquier tratamiento adicional. La presencia de datos de salud exige además comprobar las condiciones aplicables a las categorías especiales de datos.

## 5. Destinatarios

Los datos solo deben comunicarse cuando resulte necesario y legítimo, por ejemplo, a la persona trabajadora, la empresa responsable, la representación legal de las personas trabajadoras, proveedores que actúen como encargados del tratamiento o autoridades con competencia legal.

Esta aplicación se ejecuta en `127.0.0.1` y no incorpora por sí misma transferencias internacionales ni envíos a servicios externos. Guardar el repositorio o las copias en GitHub, correo electrónico, nube o unidades compartidas constituye una operación distinta que debe evaluarse y protegerse expresamente.

## 6. Conservación

El responsable debe fijar y documentar los plazos concretos de conservación según la normativa laboral y las posibles responsabilidades aplicables. Los datos no deben conservarse indefinidamente por defecto. Al finalizar el plazo, deben bloquearse, eliminarse o anonimizarse de manera segura según corresponda.

## 7. Derechos

La persona interesada puede solicitar el acceso, rectificación, supresión, oposición, limitación del tratamiento y portabilidad cuando cada derecho resulte aplicable. Las solicitudes se dirigirán a **[canal de ejercicio de derechos]**. También puede presentarse una reclamación ante la Agencia Española de Protección de Datos.

## 8. Medidas de seguridad incorporadas

- El servidor escucha únicamente en la dirección local `127.0.0.1`.
- El acceso requiere usuario y contraseña.
- La contraseña no se guarda en texto claro: se deriva mediante PBKDF2-HMAC-SHA256 con sal aleatoria y 210.000 iteraciones.
- La sesión utiliza una cookie `HttpOnly`, limitada a ocho horas y mantenida únicamente en memoria.
- El archivo local de credenciales está excluido de Git mediante `.gitignore`.
- Los recursos y documentos no se entregan antes de iniciar sesión.
- Las respuestas de acceso evitan caché e incorporan cabeceras básicas de seguridad.

## 9. Responsabilidades del usuario y de la organización

- Utilizar una contraseña única y robusta y mantener bloqueada la sesión de Windows.
- Guardar las copias en ubicaciones cifradas y con permisos restringidos.
- No publicar en Git repositorios que contengan fichajes, documentos laborales o identificadores personales.
- No anotar diagnósticos ni información médica innecesaria.
- Revisar periódicamente usuarios, copias, permisos, plazos de conservación e incidentes.
- Comunicar y gestionar cualquier violación de seguridad conforme al procedimiento aplicable.

## 10. Normativa y fuentes oficiales

- Reglamento (UE) 2016/679 General de Protección de Datos, especialmente sus artículos 5, 6, 9, 13 y 32.
- Ley Orgánica 3/2018, de Protección de Datos Personales y garantía de los derechos digitales.
- Estatuto de los Trabajadores, especialmente el artículo 34.9 relativo al registro de jornada.
- Guía de la AEPD sobre protección de datos y relaciones laborales.

Última revisión técnica de este documento: **18 de agosto de 2026**.
