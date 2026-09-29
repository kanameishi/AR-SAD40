
La magnitud máxima ($M_{\max}$) define el límite superior de la MFD para cada fuente y es un parámetro crítico que controla la cola de la curva de amenaza. Para las 108 áreas fuente, los valores base de $M_{\max}$ varían de 6.0 a 9.4 Mw en los cuatro tipos de región tectónica, reflejando ambientes que abarcan desde corteza continental estable hasta entornos de megathrust de subducción. Los valores base más altos de $M_{\max}$ corresponden a zonas de Interfaz de Subducción, como los sistemas Sumatra e Himalaya-Main Frontal Thrust, donde se considera posible la ocurrencia de grandes terremotos que superan $M$ 8.5. Los valores $M_{\max}$ se asignan por zona a partir del estudio de caracterización sismotectónica de Nath y Thingbaijam [@NathThingbaijam2012] y se establecen como parámetros explícitos dentro de la especificación `truncGutenbergRichterMFD`.

La incertidumbre epistémica en $M_{\max}$ se captura mediante el conjunto de ramas 2 del árbol lógico (`maxMagGRRelative`), que aplica perturbaciones simultáneas de $\Delta = -0.3$, $0.0$ y $+0.3$ Mw a todas las fuentes (pesos 0.32, 0.36, 0.32). Para las mallas de fuentes puntuales de sismicidad suavizada, $M_{\max}$ se hereda de la parametrización de la zona areal de origen; los valores $M_{\max}$ de fuentes puntuales no están restringidos de manera independiente y siguen el mismo esquema global de perturbación.

@tbl-ssm-ind-mmax resume los rangos base de $M_{\max}$ por tipo de región tectónica junto con los límites epistémicos derivados.

```{r}
#| include: true
#| label: tbl-ssm-ind-mmax
#| tbl-cap: "Maximum magnitude characterisation by tectonic region type (base and epistemic bounds, area sources)."

DT <- data.table::data.table(
  `Tectonic region` = c("ASC", "SCC", "SIF", "SIS"),
  `Base Mmax (Mw)` = c("7.0-8.8", "6.0-8.2", "6.5-9.4", "6.5-8.6"),
  `Low (delta -0.3, Mw)` = c("6.7-8.5", "5.7-7.9", "6.2-9.1", "6.2-8.3"),
  `High (delta +0.3, Mw)` = c("7.3-9.1", "6.3-8.5", "6.8-9.7", "6.8-8.9"),
  `Derivation method` = c("truncGutenbergRichterMFD", "truncGutenbergRichterMFD", "truncGutenbergRichterMFD", "truncGutenbergRichterMFD")
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
