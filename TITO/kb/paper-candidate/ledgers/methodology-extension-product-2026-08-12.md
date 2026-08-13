# Contrato del producto metodológico de ampliación

## Objetivo

Incorporar en un documento candidato independiente los desarrollos posteriores
a la Fase 1 sobre estimación de $K_0$, participación de la acción tangencial,
deterioro de la chapa, propiedades netas, recuperación de tensiones normales y
controles numéricos.

## Decisión sustentada

Establecer qué operaciones pueden ejecutarse desde variables primitivas hasta
la demanda elástica de la chapa, y qué datos y bases normativas deben cerrarse
antes de emitir una verificación resistente del revestimiento existente.

## Audiencia

Ingenieros geotécnicos y estructurales responsables de revisar el procedimiento
de cálculo y la evaluación de un revestimiento circular de acero corrugado.

## Producto metodológico detallado

`_master/methodology.extension.review.es.qmd`, ensamblado mediante
`_index/methodology.extension.review.ES.qmd` a partir de capítulos candidatos
independientes en `TITO/kb/paper-candidate/chapters/`.

## Producto de memoria de cálculo

`_master/calculation.review.es.qmd`, ampliado después de cerrar y auditar el
producto metodológico candidato. La memoria conservará sólo entradas,
operaciones, fórmulas finales, controles, resultados y limitaciones aplicables
al escenario declarado.

## Alcance

- estado lateral efectivo derivado de variables primitivas;
- participación prescrita de la componente tangencial;
- medición y reducción del espesor deteriorado;
- propiedades netas de la corrugación;
- recuperación elástica condicionada de la tensión normal circunferencial;
- distinción entre primera fluencia, pandeo, continuidad, costuras y pernos;
- controles matemáticos y numéricos de las formulaciones incluidas; y
- variables candidatas para una futura simulación de Monte Carlo, sin asignar
  distribuciones.

## Exclusiones

- edición de la Fase 1 congelada;
- resultado resistente del revestimiento existente sin sección neta, acero,
  criterio de curvatura, clasificación del producto y norma aplicable;
- tensión cortante local inferida únicamente desde $Q_\theta$;
- tensión equivalente sin condición longitudinal cerrada;
- capacidad de costuras o pernos;
- simulación probabilística sin marginales y dependencias aprobadas; y
- verificación de shotcrete antes del cierre de la etapa de chapa.

## Línea base aprobada

`_master/methodology.review.es.qmd`, `_index/methodology.review.ES.qmd`,
`TITO/kb/review/` y `html/methodology.review.es/`, con los hashes registrados en
`dev/SoT/METHODOLOGY-PHASE2.md`.

## Aceptación

Usuario.

## Condición observable de terminación

El candidato metodológico y la memoria se renderizan en HTML separado, las
ecuaciones y citas resuelven, las auditorías técnica, editorial y de artefacto
concluyen sin hallazgos materiales, la Fase 1 conserva sus hashes y las
limitaciones por datos `UNKNOWN` permanecen expresas. La verificación de chapa
se considera cerrada para el caso sólo cuando se resuelvan sus entradas y la
base normativa; hasta entonces el producto es una metodología y una evaluación
condicional, no un dictamen resistente.

## Validación

El producto metodológico candidato obtuvo `PASS` para su alcance condicionado.
El HTML auditado tiene SHA-256
`589ce206fa1ca3d679d62f36df28d94da72a3dd7103918105b5e074ffacd0876`;
el dictamen final está en
`/private/tmp/ar-sad40-methodology-extension-closure-final.md`. Este cierre no
resuelve las entradas ni la base normativa requeridas para verificar el caso
existente.
