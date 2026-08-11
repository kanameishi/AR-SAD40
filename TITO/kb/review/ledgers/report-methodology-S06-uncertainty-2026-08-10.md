# report-methodology-S06-uncertainty-2026-08-10

## Section
Tratamiento de incertidumbres y construcción de envolventes.

## Report Purpose
Definir la simulación Monte Carlo directa para incertidumbres paramétricas y la comparación separada de hipótesis de modelo.

## Sources Read
JCSS (2006), §3.7; requisitos explícitos del proyecto.

## Exact Claims Allowed
Muestreo conjunto; preservación de dependencias; cuantiles puntuales; cuantiles de extremos espaciales; envolvente entre hipótesis sin interpretación probabilística conjunta.

## Claims Not Allowed
Distribuciones, rangos, correlaciones o tamaños de muestra universales; probabilidades de hipótesis de modelo sin evidencia.

## Equations Allowed
Cadena muestra--carga--respuesta; cuantiles puntuales y de extremos; envolvente entre hipótesis.

## Equations Excluded
Aproximaciones de confiabilidad linealizadas y funciones de falla, fuera del alcance solicitado.

## Vocabulary Allowed
Simulación Monte Carlo; realización; vector aleatorio; dependencia; cuantil; extremo espacial; envolvente por hipótesis.

## Vocabulary Rejected
Motor Monte Carlo; corrida; prior sin contexto; intervalo probabilístico para escenarios no ponderados.

## Candidate Public Paragraph Or Section
`TITO/kb/review/chapters/methodology.uncertainty.review.es.md` (SHA-256:
`893d4e30705994dcca8962b325f29e245f7a5dce65079ecc3f0bbf76b0b99715`).

## Candidate Translation Terminology
*Sample*: realización cuando designa una evaluación conjunta; muestra cuando designa el conjunto estadístico; *pointwise quantile*: cuantil puntual.

## Open Gaps
Caracterización probabilística del relleno y dependencias.

## Validation
Comprobación de que los extremos se calculan dentro de cada realización antes de obtener cuantiles entre realizaciones.
