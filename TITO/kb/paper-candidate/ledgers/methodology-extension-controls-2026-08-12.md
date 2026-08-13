# Registro de sección — controles y casos de referencia

## Section

Controles matemáticos y numéricos de la ampliación metodológica.

## Report Purpose

Documentar qué comparaciones respaldan la implementación y cuál es su clase de
evidencia, sin confundirlas con una verificación física del revestimiento.

## Sources Read

- Mai (2013), tablas 2.1 y E.1 y ecuaciones 4-2 a 4-5.
- Productos determinísticos auditados del escenario biaxial uniforme.
- Notebook Wolfram G10.7 y sus auditorías matemática y de usabilidad.

## Exact Claims Allowed

La solución cerrada, la integración directa y la descomposición modal producen
resultados concordantes para el escenario de comprobación. El límite de presión
uniforme con $\eta=0$ recupera $N=-pR$ y $M=Q=0$. Los datos de Mai permiten
contrastar propiedades y conservación de rigideces, pero no constituyen un caso
de validación del revestimiento actual.

## Claims Not Allowed

No llamar validación física a una paridad numérica. No presentar CANDE como
método aplicado. No trasladar resultados de carga viva, falla o distribución
longitudinal al problema plano geostático.

## Equations Allowed

Residuos y diferencias máximas de los controles ejecutados; relaciones de
equivalencia seccional ya definidas en el cuerpo.

## Equations Excluded

Detalles de implementación, nombres de funciones, rutas, comandos y
serialización de productos.

## Vocabulary Allowed

Control matemático interno; resultado publicado; resultado reproducido;
resultado derivado; diferencia máxima; tolerancia.

## Vocabulary Rejected

Benchmark para un control interno; calibración sin observaciones; validación
física; conclusión normativa derivada de paridad entre implementaciones.

## Candidate Public Paragraph Or Section

`TITO/kb/paper-candidate/chapters/methodology.extension.controls.es.md`.

## Candidate Translation Terminology

None — redacción original en español.

## Open Gaps

Reproducción automatizada de los contrastes seccionales M1 y M2 y selección de
casos resistentes después de identificar la rama normativa.

## Validation

PASS. La auditoría de cierre inicial detectó la mezcla de unidades y la
ausencia de los datos publicados de Mai. La reauditoría comprobó la separación
por familia dimensional, la identidad completa del escenario —incluido el
incremento horizontal residual no determinado y no incluido— y la transcripción
de las tablas 2.1 y E.1. Dictamen final en
`/private/tmp/ar-sad40-methodology-extension-closure-final.md`; HTML auditado
SHA-256
`589ce206fa1ca3d679d62f36df28d94da72a3dd7103918105b5e074ffacd0876`.
