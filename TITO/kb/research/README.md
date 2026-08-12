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
| $K_0$ y compactación | `g10.k0.compaction.es.md` | `g10.k0.compaction.audit.es.md` | evidencia `PASS`; no requiere código nuevo con el dominio actual |
| hormigón proyectado | `g10.shotcrete.section.verification.es.md` | `g10.shotcrete.section.verification.audit.es.md` | evidencia `PASS`; implementación bloqueada por aplicabilidad y datos `UNKNOWN` |

`g10.equations.register.es.md` reúne las ecuaciones candidatas, entradas,
unidades, dominios y controles. No reemplaza los informes ni sus fuentes.

`g10.wolfram.methodology.followup.plan.es.md` define la puerta diferida G10.7:
auditoría de correspondencia metodológica y recuperación de un único notebook
Wolfram para un escenario fijo después de implementar las ramas aceptadas.
