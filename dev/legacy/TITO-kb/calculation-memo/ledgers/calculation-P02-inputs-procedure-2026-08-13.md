# calculation-P02-inputs-procedure-2026-08-13

## Section and purpose

«Datos adoptados» y «Procedimiento de cálculo». Documentar únicamente las
entradas consumidas y la cadena operativa que produjo las resultantes del caso
biaxial determinístico.

## Allowed claims

- El escenario adopta $D_i=2.63$ m, $R=D_i/2$, perfil 76×25 mm,
  $t_b=3.0$ mm y $E_\theta=200$ GPa.
- $K_0=0.5$ y $\sigma'_v=100$ kPa son hipótesis del escenario;
  $\sigma'_h=K_0\sigma'_v=50$ kPa y $\Delta u=0$.
- $A_\theta$ e $I_\theta$ se obtienen por interpolación lineal entre dos
  filas identificadas de NCSPA; las rigideces se calculan con CAL-E05.
- Las acciones se evalúan mediante CAL-E03 para $\alpha=0$ y $\alpha=1$.
- Las resultantes se obtienen integrando CAL-E07 y aplicando las constantes de
  cierre de CAL-E08.

## Excluded claims

- Estimaciones alternativas de $K_0$, compactación, contacto, tapada,
  estratigrafía, presión de clave o cumplimiento AASHTO.
- Monte Carlo, tensiones de chapa, capacidad, juntas, pernos y shotcrete dentro
  de estas secciones determinísticas; sus bloques propios permanecen vigentes
  para una etapa posterior debidamente parametrizada.
- Inventarios de información faltante, estados de desarrollo o narrativa de
  implementación.

## Equations and sources

- CAL-E02 a CAL-E08 del registro interno.
- Propiedades publicadas: NCSPA 2018, tabla 2.6.
- Equilibrio y compatibilidad: Baker (1968) y desarrollo auditado del estudio.

## Tables and figures

- Tabla de entradas: sólo magnitud, símbolo, valor y unidad; sin códigos de
  evidencia, condiciones, identificadores internos ni resultados derivados.
- Ninguna figura en estas secciones.

## Required terminology

Estado biaxial uniforme prescrito, acción perimetral, componente radial,
componente tangencial, rigidez extensional circunferencial, rigidez flexional
circunferencial y resultantes seccionales.

## Prohibited internal vocabulary

`helper`, `solver`, `pipeline`, `builder`, `guardrail`, metadata, oráculo,
paridad, pendiente y `UNKNOWN`.

## Open UNKNOWN facts

Ninguno para el escenario adoptado. Los datos del revestimiento existente no
pertenecen a esta emisión.
