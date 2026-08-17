# Reglas locales de AR-SAD40

## Trabajo sin sobrecarga

- No leer routers globales, handoffs, planes históricos ni registros completos
  como paso de arranque.
- Consultar `dev/SoT/METHODOLOGY-PHASE2.md` sólo cuando la tarea afecte la
  metodología, la memoria o Wolfram; contiene únicamente el estado vigente.
- No crear archivos `.codex-task*`, handoffs, planes paralelos, auditorías en
  cascada ni subagentes salvo solicitud explícita del usuario.
- No repetir tests, renders o evaluaciones Wolfram que ya pasaron si no cambió
  su superficie relevante.

## Productos únicos

- Metodología: `_master/methodology.review.es.qmd`,
  `_index/methodology.review.ES.qmd` y `html/methodology.review.es/`.
- Memoria: `_master/calculation.review.es.qmd`,
  `_index/calculation.review.ES.qmd` y `html/calculation.review.es/`.
- Wolfram: únicamente `scripts/wolfram/calculation.workbook.nb` y
  `scripts/wolfram/calculationWorkbookSupport.wl`.
- No recrear variantes `extension`, una segunda metodología ni notebooks
  alternativos.

## Implementación y edición

- R es la implementación de producción. Wolfram consume su frontera pública y
  no duplica las ecuaciones.
- La fuente humana de entradas es `calculation.json`.
- Renderizar HTML con `qrt`; no generar PDF salvo pedido explícito.
- La respuesta activa usa integración directa del revestimiento circular;
  solución cerrada y Fourier son controles, Schwartz--Einstein es contraste,
  AASHTO gobierna la chapa y AISI es sólo antecedente.
- Preservar cambios ajenos del worktree. No preparar, confirmar ni publicar
  cambios sin pedido explícito.

## Salvaguardas

- No inspeccionar `_ref`.
- Conservar PDF y textos fuente bajo `TITO/kb/sources/`.
- La prosa pública usa terminología de ingeniería y excluye narrativa interna
  de software o auditoría.
- No inventar datos faltantes; marcarlos `UNKNOWN` o mantener las hipótesis
  provisionales expresamente declaradas.
