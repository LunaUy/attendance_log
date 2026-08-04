# Attendance Log

Attendance Log es una webapp para organizar actividades recurrentes, registrar la asistencia diaria y analizar hábitos a lo largo del tiempo.

El objetivo final es que cada usuario pueda definir sus actividades, indicar cuándo ocurren, registrar qué sucedió en cada ocasión y consultar su historial desde cualquier dispositivo.

## Objetivo del producto

La aplicación permitirá administrar actividades que ocurren semanalmente o cada 14 días desde una fecha ancla. Cada actividad podrá tener días y horarios diferentes, pausas, cambios de horario, reprogramaciones y propiedades visibles configurables.

El usuario podrá registrar su asistencia diaria con los estados:

- On Time.
- Late.
- Missed.
- Rescheduled.
- Cancelled.
- N/A.

La aplicación conservará el historial de asistencias, calculará rachas y estadísticas, y permitirá consultar las actividades en vistas diaria, semanal y mensual.

## Objetivo personal del proyecto

Este proyecto también tiene como objetivo personal aprender a programar una webapp que llegue a ser un producto entregable. La intención es experimentar lo que implica llevar un proyecto desde una idea inicial hasta una aplicación terminada y utilizable.

Para poder enfocarme principalmente en la programación y en el funcionamiento de la webapp, utilizaré tecnologías que ya conozco, como HTML, Ruby on Rails y CSS. Tailwind CSS forma parte del stack, aunque todavía no lo conozco y, por lo menos al principio, ChatGPT se encargará de ayudar con la implementación de los estilos para no desviar el foco principal del proyecto.

## Estado actual del repositorio

Actualmente el proyecto es un MVP inicial de Rails que incluye:

- Modelo `Activity`.
- Tabla `activities` en SQLite.
- Campos `name`, `description`, `status`, `start_time`, `end_time` y timestamps.
- `ActivitiesController#index`.
- Ruta `GET /activities`.
- Calendario mensual mediante `simple_calendar`.
- Una actividad de prueba llamada `Gymnastics`.
- Estilos iniciales con Tailwind CSS.

Todavía no están implementados los usuarios, la autenticación, el CRUD completo, la persistencia de estados de asistencia, la sincronización offline, las estadísticas, los planes ni el panel administrativo.

## Primera versión presentable

La primera versión útil deberá priorizar la función principal: registrar la asistencia del día actual.

La aplicación deberá permitir:

1. Mostrar las actividades del día.
2. Seleccionar un estado para cada actividad.
3. Confirmar el día.
4. Bloquear los dropdowns después de confirmar.
5. Reabrir el día mediante un botón `Modificar`.
6. Volver a confirmar después de realizar cambios.
7. Conservar localmente los cambios aunque se cierre la pestaña.

Esta primera versión podrá funcionar con un usuario local único. El diseño deberá dejar preparada la relación entre los datos y un usuario para incorporar cuentas y sincronización posteriormente.

## Flujo de asistencia

Al comienzo de la aplicación se mostrará la sección `Check your attendance here` con las actividades correspondientes al día actual.

Cada actividad tendrá un dropdown con los estados `On Time`, `Late`, `Missed`, `Rescheduled`, `Cancelled` y `N/A`. Al confirmar el día, los valores se almacenarán y los controles quedarán bloqueados. El botón cambiará a `Modificar`; al utilizarlo, el usuario podrá editar los estados, pero deberá confirmar nuevamente para cerrar el día.

### Reprogramación

Cuando el usuario seleccione `Rescheduled`, se solicitará:

- Una fecha nueva.
- Un rango horario opcional.

Si el usuario no conoce la fecha ni el horario, podrá indicarlo explícitamente. La actividad quedará en la categoría `Agendar` hasta que se defina una fecha.

Cuando se establezca una fecha:

- La actividad aparecerá en el día original con un estilo que indique que está inactiva.
- También aparecerá en el día nuevo con un estilo que indique que está allí de forma excepcional.
- La fecha de reprogramación podrá modificarse.

## Actividades recurrentes

Cada usuario podrá crear actividades con:

- Nombre único dentro de su cuenta.
- Descripción.
- Estado.
- Días de la semana.
- Horarios diferentes según el día.
- Recurrencia semanal.
- Recurrencia cada 14 días desde una fecha ancla.
- Fecha de inicio y, opcionalmente, fecha de finalización.

Si se modifica la fecha o el horario de una actividad existente, el usuario deberá indicar desde qué fecha el cambio será efectivo. El historial anterior no deberá alterarse automáticamente.

## Calendarios

La aplicación tendrá vistas:

- Diaria.
- Semanal.
- Mensual.

El usuario podrá cambiar entre ellas. Las actividades aparecerán en el día correspondiente con sus propiedades visibles, sin necesidad de mostrar la fecha como una propiedad adicional.

Desde las vistas semanal y mensual se podrán seleccionar días para consultar o modificar asistencias:

- Las fechas pasadas podrán editarse sin límite.
- Las fechas futuras podrán editarse hasta 30 días después de la fecha actual.

## Pausas, archivo y rachas

Una actividad podrá entrar en modo reposo. Al activar el reposo se solicitarán:

- Motivo.
- Fecha de finalización completa, o
- Mes y año de finalización, o
- Pausa indefinida.

Las actividades que ya no se realicen podrán enviarse a un archivo para conservar su historial. Desde el archivo se podrá reactivar una actividad y elegir entre:

- Continuar la racha anterior.
- Comenzar una nueva racha.

Comenzar una nueva racha no eliminará el historial anterior; únicamente definirá una nueva primera fecha para el cálculo actual.

## Indicador glowing

Junto a `Check your attendance here` habrá un círculo glowing que representará la categoría predominante del día.

Colores:

- On Time: verde.
- Late: amarillo o naranja.
- Rescheduled: azul.
- Missed: rojo.
- Cancelled: pendiente de definir para el indicador y las estadísticas.
- Gris: último recurso, cuando no haya una categoría válida.

`N/A` no participa en el cálculo del color y nunca determina por sí solo el resultado.

Si hay empate entre dos categorías, el círculo se dividirá en dos colores y el glow exterior utilizará esos mismos colores.

Para empates de tres o cuatro categorías se aplicará esta prioridad entre las categorías que tengan color definido:

1. On Time.
2. Late.
3. Rescheduled.
4. Missed.

`Cancelled` queda fuera de esta prioridad hasta definir su comportamiento visual y estadístico. `N/A` tampoco participa.

## Zonas horarias

La aplicación detectará la zona horaria del navegador mediante JavaScript y la enviará al servidor mediante una cookie. Rails utilizará esa zona para calcular el día actual y los horarios de cada usuario.

`America/Montevideo` funcionará como zona horaria de fallback cuando el navegador todavía no haya informado su zona o no se pueda validar el valor recibido. Las fechas se almacenarán en UTC en la base de datos y se mostrarán convertidas a la zona horaria del usuario.

## Estadísticas

Habrá una sección independiente para consultar estadísticas por actividad y período.

Períodos disponibles:

- Total.
- Anual.
- Mensual.
- Semanal.
- Rango personalizado con fecha inicial y final.

Las estadísticas podrán incluir:

- Mejor racha.
- Racha actual.
- Categoría más seleccionada.
- Actividades que se están descuidando.
- Cantidad de faltas.
- Cantidad de llegadas tarde.
- Recuentos por estado.

Los resultados se mostrarán como `n/v`, donde `n` es la cantidad de veces que se cumplió la condición y `v` es la cantidad total de ocasiones en las que la actividad debía ocurrir dentro del período.

Las actividades sin ocurrencias dentro del período elegido no se mostrarán en el recuento. `N/A` no se contabilizará como categoría de asistencia.

## Tutorial y configuración visual

La primera vez que el usuario utilice la aplicación se mostrará un tutorial de introducción. El tutorial guiará la configuración inicial y la creación de actividades mientras explica el funcionamiento de la app.

El tutorial no tendrá una URL pública independiente. Podrá repetirse desde Settings mediante el botón `Repasar tutorial`.

La aplicación comenzará en dark mode. Desde configuración se podrá seleccionar:

- Light.
- Dark.
- System.

La configuración también permitirá definir qué propiedades son visibles para cada actividad. Las propiedades visibles podrán ser diferentes entre actividades.

## Usuarios y autenticación

El registro inicial requerirá:

- Email.
- Nombre completo.
- Confirmación del email.

Cada usuario tendrá un ID único autogenerado, configuración, plan actual y dispositivos registrados.

Después del primer registro, el usuario podrá iniciar sesión mediante:

- Email y contraseña, según la implementación elegida.
- Passkeys mediante WebAuthn.
- 2FA si lo activó.

Las passkeys deberán ser compatibles con 1Password. La passkey se configurará desde Settings; antes de configurarla, el usuario no podrá utilizarla.

## Funcionamiento offline y sincronización

La primera funcionalidad offline será limitada a los dropdowns de asistencia. Sin conexión, el usuario podrá:

- Seleccionar estados.
- Modificar estados de asistencia pendientes.
- Confirmar el registro diario.

Inicialmente no se permitirá offline:

- Crear o editar actividades.
- Cambiar recurrencias.
- Cambiar configuración.
- Realizar operaciones administrativas.

El almacenamiento local del navegador conservará los cambios desde el inicio. Para datos estructurados se recomienda IndexedDB en lugar de utilizar `localStorage` como una base de datos completa.

En la versión multi-dispositivo:

- El servidor será la fuente persistente compartida.
- El almacenamiento local funcionará como caché y cola de cambios pendientes.
- No se subirá todo el almacenamiento local de una sola vez.
- Se sincronizarán registros u operaciones individuales.
- Cada cambio tendrá un identificador, dispositivo de origen, fecha de modificación y estado de sincronización.
- Los reintentos no deberán crear asistencias duplicadas.

Cada usuario tendrá sus dispositivos registrados. El usuario podrá definir un dispositivo principal. Si no lo define, la prioridad se determinará por el orden de inicio de sesión.

Si el dispositivo principal no tiene cambios pendientes, no bloqueará los cambios de otros dispositivos. Cuando existan modificaciones incompatibles, se utilizará la prioridad registrada de dispositivos para obtener un resultado determinista. Como mejora futura se podrá incorporar resolución manual de conflictos.

La sincronización deberá considerar conectividad real con el servidor, reintentos, estados pendientes o fallidos, zonas horarias y fechas locales.

## Exportaciones y backups

La primera versión utilizará exportaciones locales:

- CSV.
- SQLite.

El usuario descargará los archivos y será responsable de conservarlos. El servidor no almacenará backups completos durante el MVP inicial.

En el futuro se podrán agregar backups server-side manuales y automáticos, con fecha del último backup, retención y eliminación de datos según el estado de la cuenta.

También se podrá investigar el uso de:

- Servidor propio.
- Almacenamiento compatible con S3.
- WebDAV.
- Servicios externos.
- Servidor privado configurado por el usuario.

Un destino privado requerirá autenticación, permisos, cifrado, reintentos y manejo de errores. No se considera necesario resolverlo antes de que la aplicación principal sea funcional.

## Planes y pagos

Habrá dos planes:

- Gratis, con límites.
- Pago, con funcionalidad completa.

También habrá un trial de 14 días.

Mientras el proveedor de pagos no esté definido, el pago será simulado:

1. El usuario presiona `Pagar`.
2. Aparece un popup de confirmación.
3. La acción se registra en SQLite.
4. Se guarda el usuario, el plan, el estado y la fecha.
5. Se habilita el plan pago sin una transacción real.
6. Se evita registrar el mismo pago simulado más de una vez.

El proveedor de pagos queda pendiente de definición. La arquitectura deberá separar los conceptos de `Plan`, `Subscription` y `PaymentSimulation` para facilitar una integración real posterior.

## Administración

El panel admin tendrá inicialmente prioridad en la administración de usuarios, no en el diseño ni en la integración de pagos.

El admin podrá:

- Ver usuarios.
- Revocar el acceso.
- Marcar cuentas para eliminación.
- Gestionar cuentas durante el período de recuperación.
- Cambiar manualmente el plan de suscripción de los usuarios.
- Asignar gratuitamente el plan pago.
- Consultar los pagos simulados.

Mientras el pago sea falso, el admin podrá cambiar libremente el plan de cualquier usuario desde el panel.

Cuando exista pago real, esta opción continuará disponible para usuarios de prueba, incluyendo:

- Cuentas utilizadas para desarrollo y testing.
- Usuarios internos de programación.
- Personas invitadas a probar la app y dar feedback.

Para usuarios reales, el plan deberá mantenerse sincronizado con el proveedor de pagos.

Los precios y límites de los planes podrán ser editados desde administración, pero esta función tendrá menor prioridad que la administración de usuarios.

## Eliminación y recuperación de cuentas

Cuando un usuario o un admin elimine una cuenta:

1. El acceso se revoca.
2. La cuenta queda en estado de eliminación pendiente.
3. Los datos se conservan durante 10 días.
4. Se envía un email informativo.
5. Si el usuario intenta entrar durante ese período, se le explica cómo recuperar la cuenta.
6. La recuperación requiere confirmar nuevamente el email.
7. Después de 10 días se eliminan definitivamente los datos server-side y los backups server-side asociados.
8. Se envía un email indicando que los datos se perdieron.
9. Los accesos posteriores muestran que la cuenta fue eliminada y que debe crearse una nueva.

Los archivos exportados localmente permanecen bajo responsabilidad del usuario y no pueden ser eliminados por la aplicación.

## Diseño técnico y objetos del dominio

La aplicación seguirá una arquitectura MVC de Rails.

### Objetos actuales

- `ApplicationRecord`: clase base de los modelos Active Record.
- `Activity`: representa una actividad.
- `ApplicationController`: controller base.
- `ActivitiesController`: carga las actividades del mes actual.
- Vista `activities/index`: presenta la interfaz actual y el calendario.

### Objetos propuestos para el producto final

- `User`: identidad, email, nombre, autenticación, configuración, plan y dispositivos.
- `Device`: dispositivo registrado y prioridad de sincronización.
- `Activity`: definición de una actividad.
- `ActivitySchedule`: reglas de recurrencia y horarios.
- `ScheduleVersion`: cambios de horario con fecha efectiva.
- `ActivityOccurrence`: instancia concreta de una actividad en una fecha.
- `Attendance`: estado registrado para una ocurrencia.
- `AttendanceSyncEvent`: cambio pendiente de sincronización.
- `PausePeriod`: período de reposo.
- `Reschedule`: relación entre una ocurrencia original y su fecha excepcional.
- `ActivityProperty`: propiedad configurable.
- `ActivityVisibilityPreference`: propiedades visibles para una actividad.
- `Streak`: cálculo o representación de rachas.
- `StatisticsQuery`: consulta de estadísticas por período.
- `Plan`: definición del plan gratis o pago.
- `Subscription`: plan actual y estado de la suscripción.
- `PaymentSimulation`: registro del pago preliminar falso.
- `TrialPeriod`: período inicial de prueba.
- `Backup`: registro de backups futuros.
- `Export`: generación de archivos CSV o SQLite.
- `Admin`: permisos administrativos.

Estos objetos representan el diseño futuro y no significan que todas las clases estén implementadas actualmente.

## Roadmap

### Fase 1 — Registro diario de asistencia

- Completar la interfaz de asistencia existente.
- Mostrar las actividades del día.
- Implementar los cinco estados.
- Confirmar y bloquear el día.
- Implementar el modo modificar.
- Guardar los cambios localmente.
- Mantener dark mode como apariencia inicial.

### Fase 2 — Persistencia local y offline limitado

- Conservar estados aunque se cierre la pestaña.
- Permitir cambios offline únicamente en dropdowns.
- Crear cola local de cambios.
- Evitar duplicados al reintentar.
- Preparar IDs y metadatos para sincronización futura.

### Fase 3 — Actividades y recurrencias

- Completar CRUD.
- Validar nombres únicos.
- Crear actividades pasadas, actuales y futuras.
- Agregar recurrencias semanales y cada 14 días.
- Permitir horarios diferentes por día.
- Agregar cambios con fecha efectiva.

### Fase 4 — Calendarios

- Implementar vistas diaria, semanal y mensual.
- Permitir alternar entre vistas.
- Mostrar propiedades configurables.
- Permitir editar historial.
- Permitir editar hasta 30 días futuros.

### Fase 5 — Reprogramaciones, pausas y rachas

- Implementar `Rescheduled`.
- Crear `Agendar`.
- Mostrar actividades reprogramadas en ambos días.
- Agregar reposo, archivo y reactivación.
- Mantener historial y permitir continuar o reiniciar rachas.

### Fase 6 — Experiencia de usuario

- Crear tutorial inicial.
- Agregar `Repasar tutorial`.
- Agregar configuración de propiedades visibles.
- Agregar light/dark/system.
- Implementar el círculo glowing y sus reglas de prioridad.

### Fase 7 — Estadísticas

- Racha actual y mejor racha.
- Categoría más utilizada.
- Actividades descuidadas.
- Faltas y llegadas tarde.
- Filtros temporales.
- Recuentos `n/v`.
- Exclusión de actividades sin ocurrencias y de N/A.

### Fase 8 — Exportaciones y backups

- Exportación CSV.
- Exportación SQLite.
- Registro del último backup local.
- Diseño de backups server-side futuros.
- Evaluación de almacenamiento privado o externo.

### Fase 9 — Usuarios y seguridad

- Registro y login.
- Confirmación por email.
- Passkeys WebAuthn.
- Compatibilidad con 1Password.
- 2FA.
- Recuperación de cuentas.
- Asociación de todos los datos con usuarios.
- Registro de dispositivos.

### Fase 10 — Sincronización multi-dispositivo

- Servidor como fuente persistente.
- IndexedDB como almacenamiento offline.
- Cola de cambios.
- Sincronización por registro.
- Dispositivo principal.
- Prioridad por orden de login si no se define uno.
- Manejo de conflictos y reintentos.

### Fase 11 — Eliminación y recuperación

- Revocación de acceso.
- Retención de 10 días.
- Emails de aviso.
- Recuperación por confirmación de email.
- Purga definitiva.

### Fase 12 — Planes y administración

- Plan gratis.
- Plan pago.
- Trial de 14 días.
- Pago simulado.
- Cambio manual de plan por admin.
- Asignación gratuita del plan pago.
- Soporte para usuarios de prueba.
- Cancelación.
- Panel administrativo básico.
- Integración de pagos reales cuando se defina el proveedor.

## Stack

### Desarrollo web

- Ruby on Rails 8.1.3.
- Ruby.
- Active Record.
- SQLite3.
- Puma.
- HTML y ERB.
- Tailwind CSS.
- Propshaft.
- Importmap.
- Turbo Rails.
- Stimulus.
- Simple Calendar.

### Almacenamiento y sincronización futura

- SQLite para persistencia server-side inicial.
- IndexedDB para datos estructurados offline en el navegador.
- Posibles destinos futuros S3-compatible, WebDAV, servidor propio o almacenamiento externo.

### Calidad y despliegue

- Minitest.
- Brakeman.
- Bundler Audit.
- Docker.
- Kamal.

### Diseño visual

- Tailwind CSS para estilos de la interfaz.
- Figma para wireframes, componentes y diseño de interfaces.
- Procreate para ilustraciones, personajes, iconos o elementos visuales.

## Criterios de aceptación

El producto documentado deberá cumplir conceptualmente con lo siguiente:

- El usuario puede registrar el día actual antes de contar con calendarios completos.
- Los estados de asistencia se guardan localmente desde el inicio.
- Los estados disponibles son On Time, Late, Missed, Rescheduled, Cancelled y N/A.
- Offline solo afecta los dropdowns de asistencia.
- La aplicación evita sobrescribir silenciosamente datos de varios dispositivos.
- Existe un dispositivo principal o una prioridad basada en el orden de login.
- Las actividades pueden repetirse y tener horarios diferentes.
- Los cambios de horario conservan el historial anterior.
- Las actividades pueden pausarse, archivarse, reactivarse y reprogramarse.
- Las estadísticas respetan los períodos y las reglas de exclusión.
- El pago preliminar queda registrado y puede ser modificado por administración.
- El admin puede cambiar el plan de cualquier usuario mientras el pago sea simulado.
- Después de implementar pagos reales, esa capacidad permanece para usuarios de prueba.
- La eliminación definitiva ocurre después de 10 días.
- El README diferencia claramente el estado actual, el MVP y el producto final.
