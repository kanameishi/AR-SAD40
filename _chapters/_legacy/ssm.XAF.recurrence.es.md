
Los parámetros de recurrencia de terremotos cuantifican la tasa esperada y la distribución de tamaños de terremotos futuros en cada fuente sísmica. La recurrencia se describe mediante una distribución magnitud-frecuencia (MFD) cuyo tipo y parámetros se especifican por fuente en el modelo. Los tres grupos de fuentes en el modelo XAF corresponden a tres tipos distintos de MFD, cada uno con un enfoque de parametrización diferente [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-recurrence
#| tbl-cap: "Earthquake recurrence parameters by source group."

DT <- data.table::data.table(
  `Source group` = c("Simple fault sources", "MPS/SC (truncated GR)", "BG (arbitrary MFD)"),
  `MFD type` = c("incrementalMFD", "truncGutenbergRichterMFD", "arbitraryMFD"),
  `a-value range` = c("-", "3.13-5.45", "-"),
  `b-value range` = c("-", "0.93-1.16", "-"),
  `Mmin (Mw)` = c("6.05", "4.0-4.5", "-"),
  `Mmax range (Mw)` = c("6.05-7.75", "5.25-9.00", "5.25-9.00"),
  `n` = c(115, 86, 54)
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

Para fuentes de falla, las tasas de actividad se codifican como tasas discretas de ocurrencia incremental por intervalo de magnitud de 0.1 Mw, comenzando en $M_{\min} = 6.05$ Mw; no se definen valores paramétricos $a$ o $b$. Las magnitudes máximas varían de 6.05 a 7.75 Mw en las 115 fuentes de falla [@Poggi2020].

Para las 86 fuentes multipunto con MFD Gutenberg-Richter truncadas, las tasas de terremotos se parametrizan mediante un valor $a$ (rango 3.13 a 5.45) y un valor $b$ (rango 0.93 a 1.16) sujetos a límites explícitos $M_{\min}$ y $M_{\max}$. La incertidumbre epistémica en el valor $b$ se captura mediante los conjuntos de ramas 3 y 4 del árbol lógico, aplicando perturbaciones relativas de $\pm 0.05$ a los grupos de fuentes WAF (grupo MPS) y NAF (grupo SC), respectivamente [@Poggi2020].

Para las 54 fuentes de fondo con MFD arbitrarias, las tasas de ocurrencia se especifican en puntos arbitrarios de magnitud, proporcionando una representación no paramétrica de la sismicidad que no supone una relación Gutenberg-Richter. No se definen valores $a$ o $b$ para estas fuentes [@Poggi2020].
