# calculation-P03-application-2026-08-13

## Section and purpose

«Aplicación numérica». Mostrar las sustituciones, estados intermedios,
extremos y diagramas obtenidos desde los productos materializados.

## Allowed claims

- La interpolación produce $A_\theta=3.7304717949$ mm²/mm e
  $I_\theta=287.9021537231$ mm⁴/mm.
- Las rigideces y la razón seccional son las materializadas en
  `section.properties.csv`.
- El estado de acciones tiene $p_m=75$ kPa y
  $\Delta\sigma=50$ kPa.
- Los extremos de $N_\theta$, $M_\theta$ y $Q_\theta$ son los de
  `section.extrema.csv` para $\alpha=0$ y $\alpha=1$.
- Las tres figuras representan resultantes, no una deformada; la
  amplificación es exclusivamente gráfica.

## Excluded claims

- Demanda del revestimiento existente, presión real de contacto, tensión o
  capacidad resistente.
- Datos pendientes, análisis futuros y explicación de arquitectura de código.

## Equations and sources

- Sustituciones de CAL-E02 a CAL-E05.
- Resultados de `section.resultants.csv` y `section.extrema.csv`, clasificados
  como resultados derivados del estudio.

## Tables and figures

- Tabla de extremos con encabezados simbólicos
  $\alpha$, $N_{\min}$, $N_{\max}$, $M_{\min}$, $M_{\max}$ y
  $|Q_\theta|_{\max}$; las unidades se definen en el caption.
- Tres figuras Highcharter independientes para $N_\theta$, $M_\theta$ y
  $Q_\theta$.

## Required terminology

Sustitución numérica, valor derivado, extremo, sección transversal de
referencia, ordenada radial y amplificación gráfica.

## Prohibited internal vocabulary

Caso de prueba de software, widget, renderer, fixture, comparación R/Wolfram,
metadata y validación física.

## Open UNKNOWN facts

Ninguno para las resultantes del escenario adoptado.
