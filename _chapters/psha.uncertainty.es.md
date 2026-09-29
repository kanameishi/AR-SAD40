La incertidumbre epistémica se representa mediante los árboles lógicos del modelo regional de fuentes y de los GMM. Cada rama especifica una caracterización alternativa con un peso no negativo, y los pesos de cada conjunto suman uno. OpenQuake evalúa la integral de amenaza para las realizaciones del árbol y forma los estadísticos solicitados mediante ponderación de las curvas resultantes [@OpenQuakeManual2024]. Los parámetros de recurrencia, geometría y magnitud máxima de cada fuente intervienen en la integral a través de las densidades de magnitud y distancia. Los árboles GMM representan por separado los regímenes tectónicos activos y ponderan sus modelos de predicción; la variabilidad aleatoria registro a registro permanece en la desviación estándar de cada GMM.

```{r}
#| echo: false
#| results: asis
SOURCE.BRANCH <- if (is.finite(Hazard.config$ssmBranches) && Hazard.config$ssmBranches > 1L) {
  sprintf(", cuyo árbol lógico comprende %s ramas", Hazard.config$ssmBranches)
} else {
  ""
}
GMM.COUNTS <- GMM.active[, sprintf(
  "**%s** (%s ramas)",
  TRT,
  lengths(models)
)]
OUTPUT.STAT <- if (length(Hazard.config$rockQuantiles)) {
  sprintf(
    "la media y los cuantiles %s",
    paste(Hazard.config$rockQuantiles, collapse = ", ")
  )
} else if (isTRUE(Hazard.config$rockMean)) {
  "la curva media"
} else {
  "los estadísticos solicitados por la configuración"
}
MODEL.LABEL <- if (!is.na(Hazard.config$ssmLabel) && nzchar(Hazard.config$ssmLabel)) {
  sprintf("se adoptó el modelo **%s**%s", Hazard.config$ssmLabel, SOURCE.BRANCH)
} else {
  "se adoptó el modelo regional de fuentes"
}
cat(sprintf(
  paste0(
    "En esta evaluación, %s; los árboles GMM ",
    "comprenden %s. La salida probabilística en roca de referencia ",
    "($V_{S30}=760$ m/s) reporta %s.\n"
  ),
  MODEL.LABEL,
  paste(GMM.COUNTS, collapse = ", "),
  OUTPUT.STAT
))
rm(SOURCE.BRANCH, GMM.COUNTS, OUTPUT.STAT, MODEL.LABEL)
```
