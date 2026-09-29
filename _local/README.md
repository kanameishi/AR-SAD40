# Contenido local del proyecto

Los archivos de esta carpeta pertenecen al proyecto, no al scaffold
compartido. `psha` nunca los sobrescribe ni los retira: son el único lugar
donde el contenido propio del sitio sobrevive a una rehidratación.

Todo lo que esté fuera de `_local/` —`_chapters/`, `_results/`, `_fig/`,
`_tbl/`, `_captions/`, `_book/`, `_docx/`, `_revealjs/` y `scripts/`— puede contener material
compartido. La hidratación actualiza las rutas homónimas del scaffold y
preserva los archivos adicionales del proyecto.

## Lo que el proyecto debe escribir

Las plantillas de esta carpeta se entregan en blanco y **el proyecto debe
escribir su contenido**: cada capítulo se incluye en el reporte solo cuando
su archivo tiene texto. Un archivo en blanco no deja encabezado ni rastro;
un proyecto que no escriba estas plantillas renderiza sin esas secciones.

| Archivo | Contenido esperado |
|---|---|
| `intro.background.es.md` / `.md` | Antecedentes del encargo: quién contrató el estudio, el activo evaluado, su historia y el motivo de la evaluación. |
| `bib/references.bib` | Referencias propias del sitio. Se entrega vacío; el reporte lo declara siempre junto a la bibliografía compartida. |

## Lo que no va en esta carpeta

Las secciones regionales del capítulo de fuentes sísmicas —marco
sismotectónico, sismicidad histórica y neotectónica— son contenido
**regional**, no del sitio: viven en `_chapters/ssm.<sección>.<REGIÓN>.es.md`
del scaffold y el reporte las incluye automáticamente según la región
declarada en `params.yml` (`params.ssm`: `ARB`, `AUS`, `IND`, `SAM` o `XAF`).
No las copies aquí: si falta el capítulo de la región declarada, el render
se detiene con error y la corrección corresponde al scaffold, no al proyecto.

El capítulo recorre un embudo: primero lo regional, después el modelo que
alimenta el cálculo de amenaza. Los builders `_book/ssm.*` y `_docx/sha.*`
son dueños de los títulos y de sus niveles; los archivos de esta carpeta
contienen únicamente contenido local.

El nombre de cada archivo empieza por el capítulo que lo recibe, de modo que
su ubicación en el reporte se lee del propio nombre. Las figuras propias del
proyecto siguen la misma regla y conservan la extensión de su tipo:
`ssm.faults.ES.qmd`.

Las referencias propias del proyecto se declaran en `_local/bib/references.bib`.
