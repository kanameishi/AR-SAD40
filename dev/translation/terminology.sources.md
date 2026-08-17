# Fuentes y decisiones del piloto terminológico

## Alcance

Este registro gobierna el piloto definido en la SoT §69: título, objeto y
alcance, datos comunes, convenciones seccionales y estado tensional hasta la
definición de $K_0$. No aprueba el resto de la memoria y no modifica la Fase 1.

La versión inglesa es un control semántico. Las ecuaciones, los datos y las
fuentes técnicas conservan la autoridad. Una pareja EN--ES marcada
`provisional` o `unknown` no puede promoverse a los masters públicos sin una
decisión del usuario o evidencia adicional.

## Jerarquía aplicada

1. decisiones explícitas del usuario y reglas terminológicas del proyecto;
2. normas y manuales oficiales en español para el mismo concepto;
3. fuentes técnicas primarias en inglés;
4. definiciones descriptivas del estudio, identificadas como tales; y
5. `unknown` cuando el corpus no permite cerrar una equivalencia.

## Fuentes leídas

| Clave | Fuente | Uso en este piloto | Límite |
|---|---|---|---|
| `PROJECT` | `AGENTS.md` y SoT §§68.1--69 | vocabulario aprobado por el usuario, alcance y términos rechazados | no constituye autoridad normativa externa |
| `CIRSOC8044` | INTI-CIRSOC (2023), *Estructuras enterradas y revestimientos para túneles*, capítulos 12 y A12 | terminología española de relleno, clave/corona, conductos corrugados, empuje de pared, costuras, flexibilidad y recubrimiento | reproduce una edición anterior de AASHTO; no sustituye la norma gobernante |
| `CIRSOC20125` | INTI-CIRSOC (2025), *Estructuras de hormigón*, glosario y notación | parejas shotcrete--hormigón proyectado, plain concrete--hormigón simple, reinforced concrete--hormigón armado y tensión de corte | se usa como autoridad terminológica, no como norma de diseño del caso ACI |
| `USACE2020` | USACE EM 1110-2-2902, §5.6.3.5.1 | vertical effective stress, at-rest earth-pressure coefficient, unit weight and cover depth | fuente inglesa; no demuestra por sí sola una traducción española |
| `Mai2013` | Mai (2013), pp. 21, 26, 34 y 74--75 | K0, propiedades elásticas, crown, cover depth, thrust y no-slip interface | terminología inglesa y contexto técnico |
| `CSPIHandbookChapter2` | CSPI, *Handbook of Steel Drainage & Highway Construction Products*, capítulo 2 | geometría y productos de chapa corrugada | manual sectorial en inglés |
| `CSPIHandbookChapter6` | CSPI, *Handbook of Steel Drainage & Highway Construction Products*, capítulo 6 | corrugated steel conduit, ring compression, seam strength, minimum cover | manual sectorial en inglés |
| `McGrathEtAl1999` | FHWA-RD-98-191, *Pipe Interaction with the Backfill Envelope*, §5.2.1 | acción temporal del equipo de compactación | no demuestra una tensión residual permanente |
| `ACI31825` | ACI CODE-318-25, edición SI | interacción axial--flexión y hormigón simple/armado en la formulación resistente | no gobierna la traducción regional por sí solo |
| `ACI318214` | ACI 318.2-14, §§6.1.3 y 6.1.9 | minimum area of shell reinforcement y acciones internas de cáscaras | antecedente normativo usado por la rama armada; no se presenta como ACI 318.2-25 |
| `SchwartzEinstein1980` | Schwartz y Einstein (1980) | identidad de la secuencia de carga externa y estados de interfaz | fuente inglesa primaria |

Los PDF se preservan en `TITO/kb/sources/` y sus identidades se registran en
`TITO/kb/MANIFEST.md`. No se empleó `_ref`.

## Decisiones cerradas

- `revestimiento circular`, `sección transversal`, `procedimiento de cálculo`
  y `resultantes seccionales` son términos del proyecto.
- `clave` es el término seleccionado para el punto superior de la sección.
- `presión vertical debida al peso del relleno` reemplaza a `carga de prisma` y
  `carga vertical de prisma`; ambas expresiones quedan rechazadas.
- $\tau_{\theta\xi}$ se denomina `tensión de corte`, porque es la componente
  integrada para obtener $Q_\theta$ y las fuentes ACI/CIRSOC la identifican
  como *shear stress*.
- $z_{ref}$ es una `profundidad de referencia`, positiva desde la superficie;
  no se denomina `cota`.
- El requisito de ACI 318.2-14 se describe como `área mínima de armadura para
  cáscaras`, no como `cuantía mínima de cáscara`.
- El procedimiento de conductos corrugados se identifica por su fuente:
  `procedimiento AASHTO reproducido en CIRSOC 804-4`; se retira la frase opaca
  `base AASHTO reproducida`.

## Decisiones provisionales del candidato

Estas selecciones permiten leer el piloto, pero requieren aprobación humana
antes de promoverlo:

| Concepto | Candidato español | Motivo |
|---|---|---|
| cover above crown | altura de relleno sobre la clave | coincide con la formulación descriptiva de CIRSOC 804-4; `tapada` no apareció en la fuente oficial leída |
| at-rest earth-pressure coefficient | coeficiente de presión de tierras en reposo | expresa una razón de tensiones; el corpus actual alterna `presión` y `empuje` |
| full slip / no slip | interfaz con deslizamiento libre / interfaz sin deslizamiento | define los dos extremos sin sugerir un estado límite resistente ni una adherencia química |
| free-field stress state | estado tensional del terreno en ausencia del revestimiento | definición física explícita que evita un calco abreviado |
| unit weight used in the effective-stress calculation | peso unitario adoptado para el cálculo en tensiones efectivas | el escenario usa $19\ \mathrm{kN/m^3}$, no incorpora acción hidráulica y no permite reclasificar el dato como peso total o flotante |
| calculation report | memoria de cálculo | el español está aceptado como producto; el nombre inglés sigue siendo editorialmente provisional |

## Vacíos que impiden aprobar el piloto

1. confirmar si el reporte conservará `tapada` por uso regional o adoptará
   `altura de relleno sobre la clave`;
2. aprobar la denominación española de $K_0$;
3. aprobar las dos denominaciones de interfaz;
4. confirmar el título inglés del producto; y
5. fijar la cita primaria exacta de la edición AASHTO aplicable cuando esté
   disponible, manteniendo hasta entonces la reproducción identificada.

## Instantánea de entrada

La cartografía semántica se realizó sobre:

- `_master/calculation.review.es.qmd`, SHA-256
  `4736a1d5a12752c156447d70400fb38186e181eb96b17f2b51c3059da048c265`;
- `calculation.basis.review.es.md`, SHA-256
  `c309e71c93079df5bb352a62ffa07ef4eb126e046c38a338dd82576d958eda19`;
- `calculation.actions.review.es.md`, SHA-256
  `090430289c31c7638115480949b77ff65ab633e29eb186f72c33323cf017bd74`.

Los candidatos del piloto son artefactos de revisión en `dev/translation/`;
no son la fuente pública de la memoria.
