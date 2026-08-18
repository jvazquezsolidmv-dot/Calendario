# Política de privacidad y protección de datos

> Documento técnico adaptado a la aplicación de registro de jornada. Debe ser validado y aprobado por el responsable del tratamiento antes de entregarlo como cláusula informativa. No sustituye el registro de actividades de tratamiento, el análisis de riesgos ni, cuando corresponda, el asesoramiento del Delegado de Protección de Datos.

## Aviso de confidencialidad utilizado en las comunicaciones

> La información contenida en este mensaje y/o archivo(s) adjunto(s), enviada desde Solid Machine Vision, S.L., es confidencial o privilegiada y está destinada a ser leída únicamente por la persona o personas a las que va dirigida. Le recordamos que sus datos han sido incorporados al sistema de tratamiento de Solid Machine Vision, S.L. y que, cuando se cumplan los requisitos exigidos por la normativa, podrá ejercer sus derechos de acceso, rectificación, limitación del tratamiento, supresión, portabilidad y oposición, en los términos establecidos por la normativa vigente en materia de protección de datos, dirigiendo su petición a C/ Albert Einstein, 7, 01510 Vitoria-Gasteiz (Álava), España, o mediante correo electrónico a administracion@solidmv.com.

> Si usted lee este mensaje y no es el destinatario señalado, la persona responsable de entregárselo o ha recibido esta comunicación por error, le informamos de que está prohibida cualquier divulgación, distribución o reproducción de esta comunicación. Le rogamos que lo notifique inmediatamente y elimine o devuelva el mensaje original. Gracias.

Este aviso de correo complementa, pero no sustituye, la información específica sobre el tratamiento realizado mediante la aplicación.

## 1. Responsable del tratamiento

- Responsable: **Solid Machine Vision, S.L.**
- NIF/CIF: **B-01505254**.
- Dirección: **C/ Albert Einstein, 7, 01510 Vitoria-Gasteiz (Álava), España**.
- Contacto para privacidad y ejercicio de derechos: **administracion@solidmv.com**.
- Delegado de Protección de Datos: **no se incluyen datos de contacto porque no han sido facilitados; si la entidad dispone de DPD, deberán añadirse antes de aprobar esta política**.

## 2. Datos tratados

La aplicación puede contener nombre y apellidos, DNI, número de afiliación, empresa, horarios de entrada y salida, jornada pactada, vacaciones, permisos, ausencias, bajas y movimientos de la bolsa de horas.

Los datos proceden de la propia persona trabajadora, de los registros incorporados por la empresa y de los documentos laborales importados por una persona autorizada.

Las anotaciones de bajas, hospitalizaciones, intervenciones o visitas médicas pueden revelar datos relativos a la salud. Deben limitarse a la categoría laboral imprescindible, evitando registrar diagnósticos, informes clínicos o detalles personales innecesarios.

No se tratan deliberadamente datos biométricos ni se realizan perfiles. La aplicación efectúa cálculos horarios conforme a las reglas configuradas, pero no adopta decisiones automatizadas que produzcan efectos jurídicos sobre la persona trabajadora. Los resultados deben ser revisados por una persona autorizada.

## 3. Finalidades

- Gestionar y acreditar el registro diario de jornada.
- Calcular horas ordinarias, horas extraordinarias y descansos compensatorios.
- Gestionar vacaciones, permisos y ausencias.
- Generar documentos mensuales, calendarios anuales, resúmenes y copias de seguridad.
- Atender obligaciones legales y posibles requerimientos de autoridades competentes.

Los datos no deben utilizarse para una finalidad incompatible sin informar previamente a las personas afectadas y determinar una base jurídica válida.

## 4. Base jurídica

Para el registro de jornada, la base jurídica habitual es el cumplimiento de una obligación legal aplicable al responsable, conforme al artículo 6.1.c del RGPD y al artículo 34.9 del Estatuto de los Trabajadores. La AEPD indica que, con carácter general, no se requiere el consentimiento de la persona trabajadora para implantar el registro horario, aunque sí debe ser informada del tratamiento.

La organización debe determinar y documentar la base jurídica concreta de cualquier tratamiento adicional. Cuando sea estrictamente necesario tratar datos relativos a la salud para ejercer derechos u obligaciones laborales, deberá comprobarse la condición aplicable del artículo 9.2 del RGPD y aplicarse una confidencialidad reforzada. El consentimiento no debe utilizarse como base por defecto en el ámbito laboral cuando no pueda considerarse libre.

## 5. Destinatarios

Los datos solo deben comunicarse cuando resulte necesario y legítimo, por ejemplo, a la persona trabajadora, la empresa responsable, la representación legal de las personas trabajadoras, proveedores que actúen como encargados del tratamiento o autoridades con competencia legal.

Los proveedores que puedan acceder a los datos por cuenta del responsable deberán estar vinculados por un contrato de encargo del tratamiento conforme al artículo 28 del RGPD. El acceso se limitará a las personas autorizadas que lo necesiten para sus funciones.

Esta aplicación se ejecuta en `127.0.0.1` y no incorpora por sí misma transferencias internacionales ni envíos a servicios externos. Guardar el repositorio o las copias en GitHub, correo electrónico, nube o unidades compartidas constituye una operación distinta que debe evaluarse y protegerse expresamente.

## 6. Conservación

Los registros diarios de jornada se conservarán durante **cuatro años**, conforme al artículo 34.9 del Estatuto de los Trabajadores, y permanecerán a disposición de las personas trabajadoras, sus representantes legales y la Inspección de Trabajo y Seguridad Social.

Los documentos que respondan a otra finalidad o estén sujetos a responsabilidades adicionales podrán requerir plazos distintos, que deberán quedar documentados. Los datos no se conservarán indefinidamente por defecto. Al finalizar el plazo aplicable se bloquearán, eliminarán o anonimizarán de forma segura, salvo que deban conservarse para atender responsabilidades legales.

## 7. Derechos

La persona interesada puede solicitar el acceso, rectificación, supresión, oposición, limitación del tratamiento y portabilidad cuando cada derecho resulte aplicable. Las solicitudes se dirigirán a **administracion@solidmv.com** o por correo postal a **C/ Albert Einstein, 7, 01510 Vitoria-Gasteiz (Álava), España**.

La solicitud deberá permitir identificar a la persona interesada y concretar el derecho ejercido. Si considera que el tratamiento no se ajusta a la normativa, podrá presentar una reclamación ante la [Agencia Española de Protección de Datos](https://www.aepd.es/).

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

Ante pérdida, acceso indebido, publicación accidental o alteración de los registros, deberá informarse inmediatamente al responsable. Este evaluará el riesgo y determinará si procede notificar la violación a la AEPD y, cuando exista un alto riesgo, a las personas afectadas, dentro de los plazos establecidos por el RGPD.

## 10. Normativa y fuentes oficiales

- [Reglamento (UE) 2016/679 General de Protección de Datos](https://eur-lex.europa.eu/legal-content/ES/TXT/?uri=CELEX:32016R0679), especialmente sus artículos 5, 6, 9, 13, 28, 32, 33 y 34.
- [Ley Orgánica 3/2018, de Protección de Datos Personales y garantía de los derechos digitales](https://www.boe.es/buscar/act.php?id=BOE-A-2018-16673).
- [Estatuto de los Trabajadores](https://www.boe.es/buscar/act.php?id=BOE-A-2015-11430), especialmente el artículo 34.9 relativo al registro de jornada.
- [Guía de la AEPD sobre protección de datos y relaciones laborales](https://www.aepd.es/documento/la-proteccion-de-datos-en-las-relaciones-laborales.pdf).
- [Criterio de la AEPD sobre consentimiento e información en el registro horario](https://www.aepd.es/preguntas-frecuentes/3-proteccion-de-datos-en-el-ambito-laboral/FAQ-0311-es-necesario-el-consentimiento-del-trabajador-para-implantar-un-sistema-de-control-horario).

Última revisión técnica de este documento: **18 de agosto de 2026**.
