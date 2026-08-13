# Contrato del producto metodológico de ampliación

## Objetivo

Incorporar en un documento candidato independiente los desarrollos posteriores
a la Fase 1 sobre estimación de $K_0$, participación de la acción tangencial,
deterioro de la chapa, propiedades netas, recuperación de tensiones normales y
comprobación seccional de una alternativa autónoma de hormigón proyectado.

## Decisión sustentada

Establecer qué operaciones pueden ejecutarse desde variables primitivas hasta
la demanda elástica de la chapa y hasta la comprobación seccional del hormigón
proyectado, y qué datos y bases normativas deben cerrarse antes de emitir una
verificación resistente del revestimiento existente o de una alternativa.

## Audiencia

Ingenieros geotécnicos y estructurales responsables de revisar el procedimiento
de cálculo y las alternativas de revestimiento circular.

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
- base reglamentaria condicionada y clasificación seccional del hormigón
  proyectado;
- flexocompresión y corte de una franja de hormigón simple o armado;
- evaluación de materiales y geometría de una estructura existente;
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
- acción compuesta entre la chapa y el hormigón proyectado sin un modelo de
  interfaz, secuencia constructiva y transferencia de acciones;
- resultados resistentes del hormigón proyectado sin jurisdicción, base
  reglamentaria, clasificación, geometría, armaduras, resistencia equivalente
  y combinaciones aprobadas; y
- contribución postfisuración de fibras sin propiedades residuales y
  formulación normativa aplicable.

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
condicional, no un dictamen resistente. La alternativa de hormigón proyectado
se traslada a la memoria únicamente después de cerrar sus decisiones de
aplicabilidad y sus datos del caso.

## Validación

La versión anterior del producto metodológico obtuvo `PASS` para la chapa y el
estado lateral. La ampliación con la alternativa de hormigón proyectado obtuvo
`PASS` en las reauditorías técnica y editorial registradas en
`/private/tmp/ar-sad40-shotcrete-candidate-technical-reaudit.md` y
`/private/tmp/ar-sad40-shotcrete-candidate-editorial-reaudit.md`. El render
integrado produjo `html/methodology.extension.review.es/index.html`, SHA-256
`3858ea25a3ff863f9be9d95f9c93382c9f141bd3b8cdcc63207f30b6063dfe43`,
sin modificar la Fase 1.
