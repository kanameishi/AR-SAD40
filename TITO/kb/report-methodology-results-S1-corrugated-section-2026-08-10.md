# report-methodology-results-S1-corrugated-section-2026-08-10

## Section

Aplicación numérica preliminar de una sección corrugada al modelo plano del
anillo.

## Report Purpose

Mostrar de forma reproducible cómo los datos seccionales producen $EA$, $EI$
y $\eta$, y cómo esas propiedades ingresan en el cálculo de $N(\theta)$,
$M(\theta)$ y $Q(\theta)$ para un estado de carga declarado.

## Sources Read

- NCSPA (2018), *Corrugated Steel Pipe Design Manual*, 2.ª ed., Tabla 2.6,
  p. impresa 32/PDF 33: lectura dirigida de texto completo.
- Mai (2013), *Assessment of Deteriorated Corrugated Steel Culverts*,
  p. impresa 14/PDF 23: lectura dirigida de texto completo.
- `_chapters/specifications.inspection.es.md`: registro preliminar del proyecto;
  no es geometría conforme a obra.
- `TITO/kb/metodologia-anillo-enterrado.md`: fuente técnica interna del campo
  $K_0$, las ecuaciones del anillo y sus convenciones.
- `TITO/kb/benchmarks/corrugated-section.csv` y
  `TITO/kb/benchmarks/corrugated-k0-extrema.csv`: productos reproducibles del
  generador R auditado.

## Exact Claims Allowed

- NCSPA publica las filas 0.109 y 0.138 in del perfil 3 x 1 in; las
  conversiones a SI son derivadas.
- La fila de 3.000 mm es una interpolación lineal derivada entre espesores base,
  no una propiedad publicada.
- Mai publica $E_s=200$ GPa, $A_p=3.522$ mm²/mm e
  $I_p=1057.25$ mm⁴/mm para otro perfil, 152 x 51 x 3 mm.
- El estado $\sigma'_v=100$ kPa, $K_0=0.5$, $u=0$ y transferencia completa es
  un control numérico declarado, no una demanda del proyecto.
- Bajo tracciones prescritas, la sección entra en el cierre uniforme mediante
  $\eta$; la interacción suelo--estructura puede producir otra dependencia de
  las rigideces absolutas.

## Claims Not Allowed

- Que 76 x 25 x 3 mm o el radio medio sean datos conforme a obra.
- Que la interpolación NCSPA sea una fila publicada o una tolerancia normativa.
- Que el ejemplo de Mai represente la chapa del proyecto.
- Que el estado $K_0$ adoptado sea el relleno real o una envolvente de diseño.
- Cualquier tensión local, capacidad, estado de falla o demanda de pernos.

## Equations Allowed

- $EA=E_sA_p$, $EI=E_sI_p$ y $\eta=I_p/(A_pR^2)$.
- $\bar t=\sqrt{12I_p/A_p}$ y $\bar E=E_sA_p/\bar t$.
- Proyección completa del tensor biaxial y solución cerrada $n=0+n=2$ ya
  documentadas y verificadas en la metodología interna.

## Equations Excluded

- Recuperación de tensiones de la chapa, criterios resistentes y uniones.
- Formulaciones de cáscara ortótropa bidimensional que no intervienen en el
  problema plano actual.

## Vocabulary Allowed

`resultantes`, `sección corrugada equivalente`, `radio de control`,
`interpolación derivada`, `entrada de control`, `tracciones prescritas`.

## Vocabulary Rejected

`propiedad as-built`, `corrección ortótropa`, `demanda del proyecto`,
`validación física`.

## Candidate Public Paragraph Or Section

El caso conecta una sección preliminar 76 x 25 x 3 mm con el modelo de anillo
mediante $A_p$, $I_p$ y $\eta$. La carga se mantiene deliberadamente como un
estado $K_0$ de control. Los resultados son $N$, $M$ y $Q$ con signo y ángulo;
no constituyen una demanda del túnel ni una verificación resistente.

## Candidate Translation Terminology

`thrust` se expresa como fuerza normal circunferencial; `bending moment` como
momento flector; `shear force` como esfuerzo de corte o corte, sin usar
`tensión de corte` para el resultante global.

## Open Gaps

- Radio medio de la chapa: `UNKNOWN` hasta medir la sección.
- Propiedades seccionales exactas del perfil instalado: `UNKNOWN`.
- Estado tensional y distribución probabilística del relleno: `UNKNOWN`.

## Validation

La instrucción del usuario del 10 de agosto de 2026 autoriza comenzar el
capítulo con los datos disponibles. La aritmética se contrasta con las filas
fuente y el ejemplo de Mai; el solver directo se compara con su solución
cerrada y con Fourier. La revisión final debe comprobar sintaxis Markdown,
ejecución R y ausencia de productos fuera de $N$, $M$ y $Q$.
