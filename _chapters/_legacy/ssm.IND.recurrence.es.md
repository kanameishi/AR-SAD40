
Las 108 áreas fuente emplean la MFD Gutenberg-Richter truncada (`truncGutenbergRichterMFD`), parametrizada por un valor $a$ y un valor $b$ con límites explícitos $M_{\min}$ y $M_{\max}$. La magnitud mínima es 4.5 Mw para áreas fuente en entornos de Corteza Superficial Activa, Corteza Continental Estable e Interfaz de Subducción; las fuentes de Subducción Intraplaca de Profundidad Intermedia abarcan un rango de valores $M_{\min}$ de 4.5 a 7.5 Mw que refleja la profundidad variable de las zonas profundas de la placa subducida. La incertidumbre epistémica en el valor $b$ se captura mediante el conjunto de ramas 3 del árbol lógico, que aplica perturbaciones relativas simultáneas de $-0.1$, $0.0$ y $+0.1$ (pesos 0.32, 0.36, 0.32); el tratamiento de la incertidumbre de $M_{\max}$ se aborda en la sección Magnitud máxima siguiente. Las dos mallas de fuentes puntuales de sismicidad suavizada heredan la misma parametrización Gutenberg-Richter de las zonas areales de origen, distribuida sobre una malla espacial regular; los nodos individuales de la malla tienen asignados valores $a$ redistribuidos espacialmente derivados de las tasas de las zonas de origen, y no de estadísticas de catálogo ajustadas de forma independiente [@NathThingbaijam2012].

@tbl-ssm-ind-recurrence resume los parámetros de recurrencia para las 108 áreas fuente agrupadas por tipo de región tectónica. Los valores $M_{\max}$ son estimaciones base (centrales) antes de la aplicación de la perturbación de árbol lógico de $M_{\max}$.

```{r}
#| include: true
#| label: tbl-ssm-ind-recurrence
#| tbl-cap: "Earthquake recurrence parameters by tectonic region type (108 area sources, base values)."

DT <- data.table::data.table(
  `Tectonic region` = c("Active Shallow Crust (ASC)", "Stable Continental Crust (SCC)", "Subduction Interface (SIF)", "Subduction Intraslab (SIS)"),
  `MFD type` = c("truncGR", "truncGR", "truncGR", "truncGR"),
  `a-value range` = c("2.73-7.08", "1.58-4.84", "3.12-5.40", "3.22-7.33"),
  `b-value range` = c("0.72-1.37", "0.63-1.19", "0.72-1.24", "0.80-1.57"),
  `Mmin (Mw)` = c("4.5", "4.5", "4.5", "4.5-7.5"),
  `Mmax range (Mw)` = c("7.0-8.8", "6.0-8.2", "6.5-9.4", "6.5-8.6"),
  `n` = c("29", "17", "27", "35")
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
