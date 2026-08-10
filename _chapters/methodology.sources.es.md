# Referencias auditadas y orden de lectura

## Lectura prioritaria para esta fase

1. **Baker (1968), pp. PDF 19–31 y 53–55.** Base del equilibrio, la solución
   por Fourier para carga radial y los benchmarks del anillo. [PDF
   abierto](https://archive.org/download/comparisonoffini00bake/comparisonoffini00bake.pdf).
2. **USACE EM 1110-2-2902 (2020), §4.12, Ec. 4-20 y ejemplo D4.** Regla de
   empuje para CMP, factores y ejemplo aritmético; no contiene curvas
   $N,M,Q$. [Registro
   oficial](https://www.publications.usace.army.mil/USACE-Publications/Engineer-Manuals/u43544q/32393032/udt_43544_param_direction/ascending/udt_43544_param_orderby/Title/).
3. **McGrath et al. (1999), FHWA-RD-98-191, §2 y §5.2.** Carga de prisma,
   VAF, secuencia de compactación y Ec. 5.1. Es un informe de investigación,
   no una norma. [PDF USDOT](https://rosap.ntl.bts.gov/view/dot/48814/dot_48814_DS1.pdf).
4. **Núñez (2000), pp. PDF 10–15, y Núñez–Sfriso–Laiún (2014),
   pp. PDF 4–7.** Formulación, ejemplos y discrepancias entre versiones para
   túneles excavados. [2000](https://web.archive.org/web/20160501075011id_/http://saig.org.ar/wp-content/uploads/2015/02/ART-20.pdf) y
   [2014](https://dxi97tvbmhbca.cloudfront.net/upload/user/image/ASfriso_JLaiun_WTC_Nunez_NATM_support_201420200228194514862.pdf).
5. **Schwartz y Einstein (1980), §2 y Apéndice A.** Referencia para separar
   descarga por excavación de carga exterior y entender la interacción
   acoplada por rigidez relativa. [PDF
   USDOT](https://rosap.ntl.bts.gov/view/dot/11562/dot_11562_DS1.pdf).
6. **CANDE-2025, manual de formulaciones.** Contraste FE 2D, interfaz y
   construcción incremental; no forma parte del motor no-FEM. [Descargas
   oficiales](https://www.candeforculverts.com/download.html).
7. **NCSPA (2018), *Corrugated Steel Pipe Design Manual*, 2.ª ed., Tabla
   2.6, p. impresa 32/PDF 33.** Propiedades del perfil corrugado
   $3\times1\ \mathrm{in}$ por unidad de proyección. [PDF
   NCSPA](https://ncspa.org/wp-content/uploads/2022/08/NCSPA-CSP-Design-Manual-2nd-Edition-042018SECURED-1.pdf).
8. **Mai (2013), *Assessment of Deteriorated Corrugated Steel Culverts*,
   p. impresa 14/PDF 23.** Ejemplo de homogenización que conserva $EA$ y
   $EI$ para un perfil $152\times51\times3\ \mathrm{mm}$. [PDF
   preservado por Library and Archives Canada](https://www.collectionscanada.gc.ca/obj/thesescanada/vol2/OKQ/TC-OKQ-7780.pdf).

## Fuentes preservadas

Las copias locales, sus páginas, procedencia y SHA-256 están en
`TITO/kb/MANIFEST.md`. El manifiesto contiene 31 PDF.
Los documentos fuente se preservan en `TITO/kb/sources/`; ninguna salida
generada se guarda en ese directorio.

## Clasificación de evidencia usada

| Etiqueta | Significado en este documento |
|---|---|
| **FUENTE** | ecuación o valor localizado en página verificada |
| **DERIVACIÓN** | resultado algebraico mostrado y probado por equilibrio |
| **IMPLEMENTACIÓN** | discretización o adaptador construido a partir de una fuente |
| `UNKNOWN` | dato, corrección o relación no sustentada por la evidencia disponible |
| fuera de dominio | cálculo posible, pero no validado para una tubería instalada y rellenada |

El hecho de archivar una referencia no implica que su método sea aplicable.
Las normas de pago representadas sólo por índices o vistas previas no se usan
para reconstruir ecuaciones ausentes.
