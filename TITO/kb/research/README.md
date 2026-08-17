# Investigaciones internas de G10

Esta carpeta conserva candidatos técnicos y sus auditorías independientes.
No es contenido público de la memoria ni implica adopción normativa,
aceptación técnica o habilitación de código.

Una rama puede pasar al diseño de implementación sólo cuando:

1. la investigación corregida tiene trazabilidad a fuentes preservadas;
2. la auditoría cruzada concluye `PASS`;
3. los datos no resueltos permanecen identificados como `UNKNOWN`; y
4. el usuario acepta la formulación y su dominio de aplicación.

El estado vigente y el orden de ejecución están en
`dev/SoT/METHODOLOGY-PHASE2.md`, sección 28.

## Inventario vigente

| Rama | Investigación | Auditoría | Estado |
|---|---|---|---|
| chapa corrugada | `g10.corrugated.steel.verification.es.md` | `g10.corrugated.steel.verification.audit.es.md` | evidencia `PASS`; recuperación normal condicional aceptada e implementada en G10.2; aplicación al caso y resistencia bloqueadas por datos `UNKNOWN` |
| $K_0$ y compactación | `g10.k0.compaction.es.md` | `g10.k0.compaction.audit.es.md`; reauditoría `g10.k0.formulations.reaudit.es.md` | ecuaciones operativas `PASS`; cierre global condicionado por alcance empírico, fuente Mesri--Hayat no preservada y comparación parametrizada pendiente |
| hormigón proyectado | `g10.shotcrete.section.verification.es.md` | `g10.shotcrete.section.verification.audit.es.md` | evidencia `PASS`; implementación bloqueada por aplicabilidad y datos `UNKNOWN` |

## Mai (2013) y deterioro

- `g10.mai.2013.thesis.extraction.en.md` conserva la extracción integral de
  las 233 páginas con localizadores por página física;
- `g10.mai.2013.deterioration.analysis.es.md` clasifica la evidencia y define
  el plan Mai.1--Mai.10; y
- `g10.mai.2013.deterioration.audit.es.md` documenta el `FAIL` inicial, sus
  tres correcciones y el `PASS` final.

El dictamen es **aporta condicionalmente**: la fuente sustenta mediciones de
espesor, propiedades $EA/EI$, recuperación elástica y límites por deterioro,
pero no habilita distribuciones probabilísticas, resistencia local ni
resultados del revestimiento existente. El orden de incorporación está en la
sección 29 de la SoT.

`g10.equations.register.es.md` reúne las ecuaciones candidatas, entradas,
unidades, dominios y controles. No reemplaza los informes ni sus fuentes.

`g10.sheet.stress.correspondence.audit.es.md` documenta el `FAIL` inicial y el
`PASS` final de la correspondencia entre G10.2, su implementación R y el plan
Wolfram. La función está implementada pero no produce tensiones del escenario
vigente mientras sus entradas netas permanezcan `UNKNOWN`.
