
El árbol lógico del modelo de fuentes codifica incertidumbre epistémica mediante tres conjuntos de ramas, produciendo colectivamente $3 \times 3 \times 3 = 27$ ramas finales. Cada conjunto de ramas aborda un tipo distinto de incertidumbre epistémica; las ramas dentro de cada conjunto tienen asignados pesos que reflejan la credibilidad relativa de cada alternativa [@GemInd2012].

El conjunto de ramas 1 aborda la selección del modelo de fuentes, ofreciendo tres modelos de fuentes alternativos que representan la sismicidad regional. La rama `b1m1` selecciona el modelo de áreas fuente de 108 zonas; las ramas `b1m2` y `b1m3` seleccionan mallas de fuentes puntuales espacialmente suavizadas con umbrales $M_{\min}$ de 4.5 Mw y 5.5 Mw respectivamente.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs1
#| tbl-cap: "Branch set 1: source-model selection."

DT <- data.table::data.table(
  `Branch` = c("b1m1", "b1m2", "b1m3"),
  `Model file` = c("nt2012_areal_source_model_v1.xml", "nt2012_smoothed_source_model_v1_mmin4.5.xml", "nt2012_smoothed_source_model_v1_mmin5.5.xml"),
  `Weight` = c("0.40", "0.27", "0.33")
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

El conjunto de ramas 2 aplica perturbaciones relativas simultáneas a la $M_{\max}$ base de todas las fuentes. Las ramas laterales simétricas ($\pm 0.3$ Mw) tienen asignado un peso de 0.32 cada una; la rama central sin perturbación tiene asignado el peso mayor de 0.36, reflejando mayor credibilidad atribuida a la estimación nominal del parámetro.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs2
#| tbl-cap: "Branch set 2: maximum magnitude perturbation."

DT <- data.table::data.table(
  `Branch` = c("b2m1", "b2m2", "b2m3"),
  `Perturbation (Mw)` = c("-0.3", "0.0", "+0.3"),
  `Weight` = c("0.32", "0.36", "0.32")
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

El conjunto de ramas 3 aplica perturbaciones relativas simultáneas al valor $b$ de Gutenberg-Richter de todas las fuentes, con la misma estructura de pesos simétrica que el conjunto de ramas 2.

```{r}
#| include: true
#| label: tbl-ssm-ind-bs3
#| tbl-cap: "Branch set 3: b-value perturbation."

DT <- data.table::data.table(
  `Branch` = c("b3m1", "b3m2", "b3m3"),
  `Perturbation` = c("-0.1", "0.0", "+0.1"),
  `Weight` = c("0.32", "0.36", "0.32")
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

Los pesos combinados dentro de cada conjunto de ramas suman la unidad: las ramas de modelo de fuentes suman $0.40 + 0.27 + 0.33 = 1.00$; ambos conjuntos de ramas de perturbación suman $0.32 + 0.36 + 0.32 = 1.00$.
