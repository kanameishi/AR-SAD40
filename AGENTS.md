# Reglas locales de AR-SAD40

## Autoridad

- Antes de cualquier trabajo material, leer completo
  `/Users/averrik/github/agents/AGENTS.md` y aplicar únicamente los contratos
  que seleccione su router. Este archivo agrega reglas del proyecto; no reduce
  las salvaguardas globales.
- Para trabajos sobre el documento metodológico de referencia, la memoria de
  cálculo, sus apéndices, la aplicación numérica o sus figuras, leer además
  `dev/SoT/METHODOLOGY-PHASE2.md`.
- La aceptación técnica y editorial corresponde al usuario. No promover una
  versión candidata a las rutas públicas sin su aprobación explícita.

## Continuidad

- Al retomar la tarea, leer en este orden: `.codex-task.md`,
  `dev/SoT/METHODOLOGY-PHASE2.md` y el estado real de Git.
- Registrar en la SoT toda decisión nueva del usuario que modifique el alcance,
  la estructura, las fórmulas, los contrastes o los productos gráficos.
- No modificar `dev/SoT/ACTIVE.md`: es el puntero de un trabajo histórico de
  LFS y no gobierna esta investigación.
- No crear un segundo plan de Fase 2 en `TITO/`; la única fuente de verdad de
  esta fase es `dev/SoT/METHODOLOGY-PHASE2.md`.

## Línea base protegida

- La Fase 1 aprobada es el documento metodológico de referencia y se conservará
  como base de un futuro paper. Está congelada en:
  `_master/methodology.review.es.qmd`,
  `_index/methodology.review.ES.qmd`,
  `TITO/kb/review/` y `html/methodology.review.es/`.
- No editar, regenerar, recortar, reorganizar, mover ni reemplazar esos
  archivos durante la Fase 2. La memoria de cálculo es un producto nuevo e
  independiente; no es una revisión abreviada realizada sobre esos archivos.
- No editar el HTML público rechazado como si fuera fuente.
- Conservar todos los PDF y textos fuente recuperados. Nunca eliminar una
  fuente por retirar prosa, ecuaciones o artefactos producidos por el agente.
- No inspeccionar `_ref`: contiene documentación de proyecto fuera del alcance
  metodológico y de tamaño materialmente mayor.

## Alcance técnico y editorial

- La audiencia del informe son ingenieros geotécnicos y estructurales. La
  prosa pública debe emplear terminología disciplinar y excluir narrativa
  interna de software, auditoría o razonamiento del agente.
- En la prosa pública usar «revestimiento circular», «sección transversal»,
  «procedimiento de cálculo» y «resultantes seccionales». Los términos internos
  `Ring`, `solver`, `builder`, «canónico», «no-FEM» y «pipeline» pueden existir
  en código o en la SoT, pero no sustituyen el vocabulario de ingeniería del
  reporte.
- En esta etapa, los productos mecánicos terminan en
  `N_theta(theta)`, `M_theta(theta)` y `Q_theta(theta)`, sus extremos y sus
  envolventes. No calcular tensiones, resistencia de la chapa, capacidad de
  juntas ni solicitaciones de pernos.
- El problema es plano, sin variación longitudinal de cargas. No introducir
  una teoría general de láminas ortótropas ni clases de software que no sean
  necesarias para las rigideces circunferenciales del perfil corrugado.
- La incertidumbre se propaga mediante simulación de Monte Carlo. No introducir
  FORM ni FOSM.
- El cuerpo de la nueva memoria de cálculo contiene el procedimiento de
  cálculo, las entradas, las fórmulas operativas, los controles y la aplicación
  numérica. Un apéndice técnico resume los desarrollos; el documento de Fase 1
  conserva el desarrollo completo. Los contrastes detallados se documentan en
  un apéndice separado.
- No «mover» contenido desde la Fase 1: seleccionar hallazgos comprobados,
  redactar la memoria como producto autónomo y mantener trazabilidad hacia el
  documento de referencia y las fuentes primarias.
- Cada ecuación, tabla y figura tiene una sola definición dentro de cada
  producto renderizado. La memoria mantiene una correspondencia explícita con
  las etiquetas de la Fase 1, sin modificar estas últimas.
- Usar citas Markdown `[@Clave]` respaldadas por `bib/references.bib`. No
  atribuir a una fuente un resultado derivado en este estudio.
- Distinguir siempre datos publicados, resultados publicados reproducidos,
  resultados derivados y controles matemáticos internos. No emplear
  «validación» ni «calibración» cuando la evidencia sólo permite contraste.

## Convenciones del repositorio

- Aplicar la política de nombres PSHA documentada en la SoT: namespace
  semántico en inglés, tokens separados por puntos y sufijo de idioma según la
  capa (`ES` en `_index`, `_fig`, `_tbl` y `_captions`; `es` en `_master`,
  `_chapters` y `_summary`).
- Reservar `.md` para prosa reutilizable y `.qmd` para ensambladores o
  fragmentos que ejecutan Quarto/código.
- Renderizar con el ejecutable instalado `qrt`; no sustituirlo por una llamada
  directa a `quarto`.
- El código R es la implementación de producción. Wolfram se conserva como
  instrumento interno de comprobación.
- No generar PDF del documento metodológico ni de la memoria de cálculo salvo
  una instrucción explícita posterior. La fuente editorial es Markdown/Quarto
  y el producto de revisión vigente es HTML.

## Figuras de resultantes

- Highcharter es el renderer aprobado para la figura de la memoria. La
  alternativa estática `ggplot2` se conserva únicamente en el artefacto de
  comparación y como antecedente de revisión; ambas parten de la misma
  geometría preparada.
- En `ggplot2`, cada ordenada radial es un segmento independiente. En
  Highcharter, las curvas y ordenadas de cada formulación forman un único grupo
  conmutable desde la leyenda. No se conectan extremos de ordenadas
  consecutivas.
- `NGR::buildPlot()` se reserva para gráficos cartesianos ordinarios.
  `NGR::buildSectionResultantsPlot()` representa las curvas y ordenadas ya
  preparadas de `N_theta`, `M_theta` y `Q_theta` sobre la sección circular.
  AR-SAD40 conserva la preparación geométrica, los casos, los signos, las
  escalas y los desfases; NGR no calcula ni interpreta esas magnitudes.
- `scripts/fig/ringParametric.R` permanece como oráculo de transición para la
  paridad de la función de NGR y como proveedor de otros gráficos que aún lo
  utilicen. No retirarlo hasta que esos consumidores hayan sido inventariados
  y el usuario haya aceptado la promoción.
- Fuera del artefacto de comparación no se duplicará una misma figura pública.
- Separar cálculo físico, preparación geométrica, renderer y fragmento Quarto.
  El builder no resuelve cargas, no cambia signos, no elige casos y no calcula
  cuantiles.
- Las bandas sobre la sección representan cuantiles puntuales en cada ángulo.
  Los cuantiles de máximos, mínimos o máximos absolutos espaciales son escalares
  y se muestran en un producto separado, sin asignarles un ángulo ficticio.
- Mantener escala cartesiana 1:1, cierre periódico explícito, unidades físicas
  en la leyenda, caption o tabla accesible, y una escala gráfica fija por
  resultante para todos los casos que se comparen.
