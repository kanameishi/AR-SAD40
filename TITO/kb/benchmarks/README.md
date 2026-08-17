# Benchmarks reproducibles

Estas tablas se regeneran con:

```sh
Rscript scripts/R/runRingBenchmarks.R
```

El script sólo sobrescribe los trece CSV declarados en esta carpeta.

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

Las unidades, convenciones, páginas y limitaciones se explican en la
[metodología vigente](../../../_master/methodology.review.es.qmd).
