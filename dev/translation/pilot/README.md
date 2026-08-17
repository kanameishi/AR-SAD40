# Piloto terminológico de la memoria de cálculo

## Qué se revisa

El piloto cubre únicamente el título, el objeto y alcance, los datos comunes,
las convenciones seccionales y el estado tensional hasta la definición de
$K_0$. Los dos textos candidatos son:

- `calculation.pilot.review.es.md`;
- `calculation.pilot.review.en.md`.

La versión inglesa controla el significado de la española. No reemplaza las
fuentes técnicas ni constituye todavía un master público.

## Cómo auditarlo

1. leer primero `../terminology.sources.md`;
2. revisar en `../terminology.ledger.csv` las filas `provisional`;
3. comparar los dos candidatos por párrafos; y
4. ejecutar desde la raíz del repositorio:

```sh
Rscript dev/translation/checkTranslationPilot.R
```

El control exige igualdad de identificadores, citas, matemática, números y
unidades, y rechaza el vocabulario prohibido registrado en el ledger.

## Decisiones solicitadas

Antes de promover el piloto deben aprobarse o reemplazarse:

1. `altura de relleno sobre la clave` frente al uso regional `tapada`;
2. `coeficiente de presión de tierras en reposo` para $K_0$;
3. `interfaz con deslizamiento libre` e `interfaz sin deslizamiento`;
4. `memoria de cálculo` ↔ `calculation report`; y
5. la fuente primaria de la edición AASHTO aplicable.

Para el escenario piloto, $\gamma'=19\ \mathrm{kN/m^3}$ es el peso unitario
asignado directamente al cálculo de tensiones efectivas. El caso no incorpora
una acción hidráulica y no permite reclasificar ese dato como peso total o
flotante. Una condición con agua requerirá entradas distintas y una nueva
revisión.

No se modificarán `_master/calculation.review.es.qmd`, los capítulos públicos
ni la Fase 1 hasta recibir esa revisión.
