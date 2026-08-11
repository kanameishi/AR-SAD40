# report-methodology-S04-model-2026-08-10

## Section
Formulación estructural de la sección transversal.

## Report Purpose
Definir las ecuaciones que transforman cargas perimetrales prescritas en $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$.

## Sources Read
Baker (1968), capítulos II--IV y tablas XIII--XIV; derivación de equilibrio verificada en el prototipo.

## Exact Claims Allowed
Ecuaciones de equilibrio; condiciones de equilibrio global; integración directa; cierre por periodicidad y compatibilidad; solución de Fourier para $n\geq2$; solución cerrada del estado $K_0$.

## Claims Not Allowed
Predicción del contacto suelo--revestimiento; respuesta ante una fuerza global sin reacción; independencia de rigidez para todos los modos y condiciones.

## Equations Allowed
Sistema diferencial, solución general homogénea, constantes de compatibilidad, coeficientes de Fourier y soluciones cerradas.

## Equations Excluded
Desplazamientos y tensiones locales; detalles de implementación.

## Vocabulary Allowed
Viga curva circular cerrada; integración directa; periodicidad; compatibilidad; armónico; fuerza resultante; reacción.

## Vocabulary Rejected
Ecuaciones del anillo; solver; comparador modal; malla como objeto de software.

## Candidate Public Paragraph Or Section
`TITO/kb/review/chapters/methodology.model.review.es.md` (SHA-256:
`9950924d79105c8aaf0b211bede4e9b9c0562240c5b9bcf3d87dfc81749e931e`).

## Candidate Translation Terminology
*Ring force*: fuerza normal circunferencial; *radial shear*: fuerza cortante; *mode*: armónico.

## Open Gaps
Ley de reacción para distribuciones que no satisfagan equilibrio global.

## Validation
Equilibrio diferencial, equilibrio global, comparación cerrada $K_0$ y tablas Baker.
