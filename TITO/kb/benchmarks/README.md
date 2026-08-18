# Benchmarks reproducibles

Estas tablas se regeneran con:

```sh
Rscript scripts/R/runRingBenchmarks.R
Rscript scripts/R/runInteractionMethodStudy.R
```

El primer script sólo sobrescribe los trece CSV generales declarados en esta
carpeta. El segundo comprueba la relación entre Schwartz--Einstein, la
corrección equilibrada de gradiente, Fourier y la integración directa para las
entradas vigentes de `calculation.json`; sólo sobrescribe sus cinco CSV.

| Archivo | Contenido | Naturaleza de la referencia |
|---|---|---|
| `ring-mechanics.csv` | presión uniforme y solución cerrada $K_0$ | solución exacta |
| `baker-ring.csv` | parches de 30° y 60° | valores analíticos publicados, tres decimales |
| `usace-d4.csv` | presión, empuje y demanda D4 | ejemplo de diseño publicado |
| `fhwa-equation-5-1.csv` | nueve casos de compactación | ecuación y tabla publicadas |
| `fhwa-constrained-modulus.csv` | tabla 3.6 de $M_s$ | valores recomendados publicados |
| `fhwa-burns-richard-metal.csv` | respuesta de tubería metálica | predicción analítica publicada, no medición |
| `nunez-circular-examples.csv` | ejemplos circulares de 2000 | reproducción aritmética de valores redondeados |
| `nunez-version-difference.csv` | 2000 frente a 2014 | comparación calculada con las mismas entradas |
| `nunez-2014-analytical-fem.csv` | siete casos de tabla 3 | comparación publicada; entradas incompletas |
| `schwartz-einstein-hp97.csv` | cuatro ramas HP97 | $T$ y $M$ publicados; $Q$ derivado por equilibrio |
| `cande-level1-formula.csv` | ambas interfaces y tres ángulos | evaluación numérica derivada de fórmulas publicadas; no es un ejemplo numérico publicado |
| `corrugated-section.csv` | propiedades publicadas, bracket e interpolación preliminar de la sección corrugada | NCSPA y Mai; la fila de 3 mm está rotulada como derivada, no como propiedad publicada |
| `corrugated-k0-extrema.csv` | extremos $N,M,Q$ para el control membranal y dos secciones corrugadas | evaluación reproducible con un estado $K_0$ declarado; no es demanda del proyecto |
| `project-es-fourier-equivalence.csv` | reconstrucción modal $n=0,2$ de las resultantes Schwartz--Einstein | control de equilibrio; Fourier e integración directa no agregan rigidez de suelo |
| `project-uniform-interaction-comparison.csv` | coeficientes normalizados del campo $K_0$ uniforme y de Schwartz--Einstein | comparación metodológica con las entradas vigentes; sólo Schwartz--Einstein realimenta la rigidez |
| `project-depth-gradient-modes.csv` | modos $n=1,3$ del gradiente lineal antes y después de la reacción radial | derivación de equilibrio usada por el modelo híbrido |
| `project-hybrid-gradient-verification.csv` | equilibrio, paridad Fourier--integración y compresión de contacto | control numérico del modelo híbrido para las tres secciones |
| `project-hybrid-resultant-comparison.csv` | máximos E--S uniformes frente a máximos híbridos | comparación de la corrección de gradiente para las entradas vigentes |

Las unidades, convenciones, páginas y limitaciones se explican en la
[metodología vigente](../../../_master/methodology.review.es.qmd).
