# Baseline histórico — cargas, anillo circular y envolventes

Fecha de actualización: 2026-08-09
Estado: **baseline computacional histórico; sustituido como plan operativo**.

El plan vigente de producción, sus nombres canónicos y la puerta del primer
render están en
[`PLAN-capitulos-integridad.md`](PLAN-capitulos-integridad.md). Este archivo se
preserva para registrar el estado alcanzado por el prototipo el 9 de agosto;
no gobierna la documentación pública ni autoriza un render. En particular,
`html/methodology.es/index.html` fue generado posteriormente por el hito R0;
el HTML anterior bajo `html/metodologia.es/` no representa las fuentes
actuales.

## 1. Alcance cerrado en esta entrega

Se implementó un procedimiento agnóstico a la geometría del caso para un
anillo circular liso, isótropo y lineal:

$$
\text{fuente de carga}
\longrightarrow
\{P_r(\theta),P_t(\theta)\}\ \text{o salida escalar/puntual}
\longrightarrow
\{N(\theta),M(\theta),Q(\theta)\}.
$$

La ortotropía de la chapa y las uniones empernadas permanecen fuera de esta
fase. El procedimiento isotrópico es un producto válido y autónomo; cerrar una
extensión ortótropa no condiciona su aceptación. No se usaron dimensiones ni
propiedades del proyecto, no se inspeccionó `_ref` y no se generó un PDF del
informe.

## 2. Arquitectura aprobada

| Rama | Contrato implementado | Restricción |
|---|---|---|
| campo $K_0$ | tensor constante al eje $\rightarrow P_r,P_t$ | campo libre, no contacto acoplado |
| USACE 2020 CMP | presión en clave y empuje escalar | proyección $N_0$ solamente; $M,Q=\mathrm{NA}$ |
| FHWA prisma/VAF | carga global y empuje de springline | no produce curva angular |
| FHWA compactación | Ec. 5.1 + banda publicada de 300 mm por etapa | retención final `UNKNOWN` |
| Núñez 2000/2014 | resultantes puntuales directos | túnel excavado; fuera de dominio |
| Núñez 2014 proyectado | derivación simétrica $n=0+n=2$ | no es una curva publicada |
| anillo de Fourier | tracciones completas $\rightarrow N,M,Q$ | exige equilibrio global |

USACE, FHWA y Núñez no se promedian. Las ramas con salidas diferentes no
se fuerzan a pasar por una interfaz común que invente $M$ o $Q$.

## 3. Productos implementados

- `scripts/R/ringFourier.R`: transformada, solución modal, equilibrio,
  reconstrucción y extremos.
- `scripts/R/ringLoads.R`: perfil vertical, $K_0$ y adaptadores de fuente.
- `scripts/R/ringMonteCarlo.R`: muestreo declarado, curvas, cuantiles
  puntuales, cuantiles de extremos y envolvente constructiva muestra por
  muestra antes de calcular cuantiles.
- `scripts/R/testRingMethod.R`: pruebas de regresión y equilibrio.
- `scripts/R/runRingBenchmarks.R`: regeneración de tablas auditables.
- `scripts/R/runRingFigures.R`: figuras determinísticas declaradas.
- `scripts/wolfram/0.nb`: notebook Wolfram autocontenido de prototipado, con
  entradas editables, casos uniforme y $K_0$, explorador interactivo,
  benchmarks de fuente y simulación Monte Carlo.
- `_master/methodology.es.qmd`: master Quarto en reconciliación.
- `html/methodology.es/index.html`: artefacto R0 generado por el plan vigente;
  el HTML previo bajo `html/metodologia.es/` queda como artefacto derivado
  anterior y no se editará manualmente.

## 4. Benchmarks cerrados

| Benchmark | Estado |
|---|---|
| Baker (1968), Tablas XII–XIV | reproducido dentro del redondeo a tres decimales |
| USACE 2020, ejemplo D4 | $P_{FD}$, empuje factorizado y demanda modificada reproducidos |
| FHWA-RD-98-191, Tabla 5.5 | nueve valores reproducidos a 0.1 kPa; errata de la última fila preservada |
| Núñez (2000), dos revestimientos | ejemplos aritméticos reproducidos; no validan tubería rellenada |
| Núñez et al. (2014), Tabla 3 | sólo comparación: datos insuficientes para reproducción independiente |

## 5. Controles obligatorios antes de un Monte Carlo de proyecto

1. declarar unidades y fuente de cada variable;
2. definir perfiles de capas, agua y sobrecarga;
3. justificar $K_0$ directamente o por $\phi'$ y $OCR$;
4. separar $K_0$ compactado de un incremento residual para evitar doble conteo;
5. tratar `fullTraction` y `normalOnly` como escenarios si no hay modelo de
   interfaz;
6. definir lifts y equipo para la envolvente constructiva FHWA;
7. no aplicar una retención final de compactación sin una fuente externa;
8. verificar convergencia angular, modal y de cuantiles;
9. informar envolventes por modelo salvo que existan pesos documentados.

## 6. Incertidumbres abiertas

- propiedades y distribuciones del relleno real;
- correlaciones entre $\gamma'$, $\phi'$, $K_0$, $OCR$ y compactación;
- contacto final y transferencia tangencial;
- presión residual después de retirar el compactador;
- respuesta somera donde el gradiente y la superficie libre sean importantes;
- validación de una rama acoplada no-FEM para suelo–anillo;
- propiedades ortótropas y transferencia de resultantes a chapa/pernos.

Cada punto permanece `UNKNOWN` hasta incorporar datos o una referencia
verificada.

## 7. Backlog histórico

La secuencia siguiente queda sustituida por la Puerta M0 y el hito R0 del plan
vigente. Se conserva sólo para explicar el origen de las ramas implementadas;
no fija el orden de trabajo actual.

1. auditar y, si se aprueba, implementar la rama de **carga exterior** de
   Schwartz–Einstein/Peck–Hoeg como solución acoplada no-FEM;
2. acordar un registro de distribuciones del relleno y ejecutar las primeras
   envolventes de proyecto;
3. contrastar con un benchmark externo CANDE sin convertir CANDE en requisito
   operativo;
4. formular, sólo después, una extensión ortótropa general y determinar qué
   cambia respecto del anillo isotrópico;
5. particularizar esa extensión para la chapa ondulada mediante sus rigideces
   ortótropas y, únicamente si la derivación lo exige, corregir la solución;
6. transferir finalmente los resultantes a tensiones locales, costuras y
   pernos.

No se aplicará un factor ortótropo empírico a $N$, $M$ o $Q$. Para tracciones
prescritas, primero se distinguirá entre magnitudes fijadas por equilibrio y
magnitudes constitutivas —deformaciones, curvaturas y recuperación de
tensiones—. La ortotropía sólo podrá alterar las cargas si se incorpora una
interacción suelo–estructura dependiente de la rigidez.
