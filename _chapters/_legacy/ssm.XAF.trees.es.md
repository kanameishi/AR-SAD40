
El árbol lógico del modelo de fuentes codifica la incertidumbre epistémica definiendo realizaciones alternativas del SSM. Cada conjunto de ramas aborda una fuente específica de incertidumbre; las ramas dentro de cada conjunto tienen asignados pesos que reflejan la credibilidad relativa de cada alternativa. El árbol lógico primario contiene cinco conjuntos de ramas que producen $2 \times 3 \times 3 \times 3 \times 3 = 162$ ramas finales [@Poggi2020].

El conjunto de ramas 1 gobierna la selección del modelo de fuentes y se aplica a todas las fuentes. Comprende dos ramas: `naf_faults` (peso 0.50), que incorpora `FaultSources.xml`, `GridMultiSources_C_L50_BG.xml` y los archivos colapsados de fuentes multipunto WAF y SSA; y `naf_smooth` (peso 0.50), que reemplaza las fuentes de falla explícitas por una representación puramente de sismicidad suavizada usando `GridMultiSources_C.xml` junto con los mismos archivos regionales colapsados [@Poggi2020].

Los conjuntos de ramas 2 y 3 se aplican a las fuentes del grupo de África Occidental (WAF) `MPS-1` a MPS-6. El conjunto de ramas 2 (`mmax_waf`, tipo `maxMagGRRelative`) aplica perturbaciones de magnitud máxima de $+0.2$, $0.0$ y $-0.2$ Mw con pesos 0.25, 0.50 y 0.25 respectivamente. El conjunto de ramas 3 (`bval_waf`, tipo `bGRRelative`) aplica perturbaciones del valor $b$ de $+0.05$, $0.0$ y $-0.05$ con la misma distribución de pesos [@Poggi2020].

Los conjuntos de ramas 4 y 5 se aplican a las fuentes de sismicidad suavizada de África del Norte (NAF) SC_1 a SC_54. El conjunto de ramas 4 (`naf_b`, tipo `bGRRelative`) aplica perturbaciones del valor $b$ de $+0.05$, $0.0$ y $-0.05$ con pesos 0.25, 0.50 y 0.25. El conjunto de ramas 5 (`naf_m`, tipo `maxMagGRRelative`) aplica perturbaciones de $M_{\max}$ de $+0.2$, $0.0$ y $-0.2$ Mw con los mismos pesos. La estructura de perturbación para el grupo NAF es estructuralmente idéntica a la del grupo WAF [@Poggi2020].

La tabla siguiente resume la estructura completa del árbol lógico de `ssmLT_XAF.xml`.

```{r}
#| include: true
#| label: tbl-ssm-xaf-lt
#| tbl-cap: "Logic-tree structure of ssmLT_XAF.xml."

DT <- data.table::data.table(
  `Branch set` = c(1, 2, 3, 4, 5),
  `ID` = c("sourceModel", "mmax_waf", "bval_waf", "naf_b", "naf_m"),
  `Type` = c("Source model selection", "maxMagGRRelative", "bGRRelative", "bGRRelative", "maxMagGRRelative"),
  `Applies to` = c("All sources", "`MPS-1` to MPS-6", "`MPS-1` to MPS-6", "SC_1 to SC_54", "SC_1 to SC_54"),
  `Branches (perturbation / weight)` = c(
    "`naf_faults` (- / 0.50); `naf_smooth` (- / 0.50)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)"
  )
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
