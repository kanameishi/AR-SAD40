# calculation-P04-checks-results-2026-08-13

## Section and purpose

«Comprobaciones» y «Resultados y conclusiones». Informar exclusivamente los
controles ejecutados y el alcance de los valores obtenidos.

## Allowed claims

- Los residuos globales normalizados de fuerza y momento son menores o
  iguales que $10^{-9}$.
- Las diferencias máximas frente a CAL-E09 son menores o iguales que
  $10^{-7}$ en la unidad de cada resultante.
- Se usaron 728 ordenadas y 8192 pasos de integración.
- Las conclusiones reproducen los extremos materializados y limitan su
  interpretación al estado biaxial prescrito.

## Excluded claims

- Validación o calibración física.
- Cumplimiento normativo o resistencia del revestimiento.
- Promesas, inventarios de datos requeridos o conclusiones del paper. Los
  resultados Monte Carlo se incorporarán en una sección propia sólo después de
  ejecutar el contrato probabilístico aprobado.

## Equations and sources

- CAL-E06 para equilibrio global.
- CAL-E09 y CAL-E10 para solución cerrada y métrica de comparación.
- `numerical.controls.csv`, clase de evidencia: control matemático interno.

## Tables and figures

- El cuerpo informa la discretización, las tolerancias y los máximos
  observados en prosa.
- La tabla completa de diferencias pertenece al Apéndice B.

## Required terminology

Comprobación de equilibrio, residuo normalizado, solución cerrada, diferencia
máxima absoluta y tolerancia numérica.

## Prohibited internal vocabulary

PASS, FAIL, guardrail, audit, paridad, control de software, validación física,
pendiente y `UNKNOWN`.

## Open UNKNOWN facts

Ninguno para los controles determinísticos declarados. La caracterización
probabilística se gobierna por un ledger separado todavía no cerrado.
