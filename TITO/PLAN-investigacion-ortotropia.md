# Plan acotado — sección corrugada equivalente del anillo

Fecha: 10 de agosto de 2026
Estado: revisado después de auditar el prototipo R y sus pruebas.

## 1. Objetivo

Cerrar una única cadena de cálculo:

$$
\text{escenario de suelo}
\longrightarrow
\{P_r(\theta),P_t(\theta)\}
\longrightarrow
\{N(\theta),M(\theta),Q(\theta)\},
$$

usando para la chapa corrugada anular las rigideces seccionales equivalentes

$$
EA=E_sA_p,
\qquad
EI=E_sI_p.
$$

$A_p$ e $I_p$ son, respectivamente, el área y el momento de inercia del perfil
corrugado por unidad de longitud axial proyectada.

El producto del prototipo termina en $N(\theta)$, $M(\theta)$, $Q(\theta)$,
sus extremos y sus envolventes Monte Carlo. No incluye desplazamientos,
$\sigma$, $\tau$, tensiones locales, capacidades ni pernos. La definición y
verificación posterior de estados $\sigma_*$ y $\tau_*$ es otro problema.

## 2. Estado real del prototipo

La suite vigente terminó satisfactoriamente el 10 de agosto de 2026:

```text
PASS: direct mechanics, Fourier, Baker, USACE, FHWA, Nunez,
Schwartz-Einstein, CANDE, Monte Carlo.
```

Ese resultado demuestra las pruebas programadas; no amplía el dominio de cada
método.

| Componente | Estado auditado | Límite actual |
|---|---|---|
| ordenadas verticales y $K_0$ | implementados | el tensor $K_0$ usa una tensión vertical constante elegida por el analista |
| USACE | empuje escalar y sustituto uniforme implementados | USACE no publica la distribución angular usada por el sustituto |
| FHWA | presión de compactación y banda constructiva implementadas | la banda no es una presión residual final medida |
| Núñez | resultantes y equivalencia comparativa implementadas | no es una ley directa de carga para la tubería colocada y rellenada |
| solver directo | $P_r,P_t\rightarrow N,M,Q$ implementado | recibe `sectionRatio`, no $EA$ y $EI$ por separado |
| Fourier | comparador circunferencial implementado con el mismo `sectionRatio` | sigue siendo un control independiente para tracciones prescritas, no el motor de producción |
| Schwartz–Einstein y CANDE | comparadores de interacción implementados | falta cerrar un caso de interacción con una sección corrugada publicada |
| Monte Carlo | cuantiles y envolventes a partir de realizaciones implementados | no define distribuciones ni correlaciones del estudio |
| sección corrugada | $A_p$, $I_p$, $EA$, $EI$, $\eta$ y sección lisa equivalente implementados | la geometría conforme a obra del túnel real sigue `UNKNOWN` |

Por lo tanto, no debe afirmarse todavía que existe una carga única y definitiva
para el relleno real. Existen ramas de carga e interacción auditables que se
combinarán como escenarios, con las incertidumbres que se aprueben.

## 3. Mecánica seccional necesaria

### 3.1 Propiedades del perfil

Para un perfil normalizado, la tabla autorizada debe proporcionar, por longitud
proyectada,

$$
A_p,
\qquad
I_p.
$$

La designación habitual del perfil fija paso, profundidad y radios de
conformado; el espesor selecciona la propiedad correspondiente. Si sólo se
conoce el paso pero no una designación normalizada, la forma no queda definida:
también deben conocerse profundidad y radios.

La integración geométrica del perfil es una ruta alternativa cuando no existe
una tabla autorizada o cuando se desea comprobar una geometría medida. No es
una condición para usar un perfil estándar tabulado.

### 3.2 Rigideces y parámetro del solver

Con acero elástico de módulo $E_s$:

$$
K_N=EA=E_sA_p,
\qquad
K_M=EI=E_sI_p.
$$

El solver directo vigente usa el cociente adimensional

$$
\eta
=
\frac{K_M}{K_NR^2}
=
\frac{I_p}{A_pR^2},
$$

mediante la entrada

```r
sectionRatio = eta
```

Para tracciones perimetrales prescritas, el equilibrio determina $N$, $Q$ y la
parte variable de $M$ en el modelo actual. $\eta$ interviene en el cierre del
momento uniforme. No se aplica ninguna corrección posterior a los resultantes.

### 3.3 Sección lisa equivalente, sólo como identidad de control

Si una interfaz requiere espesor y módulo de una pared lisa, puede usarse

$$
\bar t=\sqrt{\frac{12I_p}{A_p}},
\qquad
\bar E=\frac{E_sA_p}{\bar t}.
$$

Estas definiciones conservan

$$
\bar E\bar t=E_sA_p,
\qquad
\frac{\bar E\bar t^3}{12}=E_sI_p.
$$

Las variables primarias siguen siendo $A_p$, $I_p$, $E_sA_p$ y $E_sI_p$.

### 3.4 Interacción suelo–anillo

Schwartz–Einstein y CANDE sí usan las rigideces extensional y flexional por
separado. Sus interfaces existentes reciben $E_s$, $A_p$ e $I_p$, o los
cocientes derivados de esas magnitudes. Esta comprobación es posterior al
benchmark seccional y no bloquea la definición de $EA$ y $EI$.

## 4. Trabajo completado y remanente

Quedaron implementados y reproducibles:

1. dos filas publicadas del perfil NCSPA $3\times1\ \mathrm{in}$ y el ejemplo
   $152\times51\times3\ \mathrm{mm}$ de Mai (2013), con fuente, página y
   unidades;
2. el cálculo explícito de $EA$, $EI$, $\eta$, $\bar t$ y $\bar E$;
3. la entrada `sectionRatio = eta` en `solveRingDirect()`;
4. el mismo cierre uniforme en el comparador Fourier;
5. la paridad directo–Fourier para una carga $K_0$ equilibrada;
6. una aplicación numérica que termina en extremos de $N$, $M$ y $Q$ sin
   recuperar tensiones locales.

Resta cerrar SC-06: pasar una sección corrugada publicada por una rama de
interacción Schwartz–Einstein/CANDE y documentar las mismas convenciones en
ambas formulaciones. Esto no bloquea el hito R0 de tracciones prescritas.

En Monte Carlo la sección se mantendrá fija mientras su geometría sea conocida;
sólo se recalculará si el espesor o la geometría se declaran explícitamente
como variables aleatorias. No se necesita otro solver.

## 5. Benchmarks y criterios de aceptación

| ID | Control | Criterio | Estado |
|---|---|---|---|
| SC-01 | una fila del manual NCSPA | reproducción de $A_p$ e $I_p$ con las mismas unidades y longitud de proyección | implementado |
| SC-02 | Mai, perfil $152\times51\times3\ \mathrm{mm}$ | $A_p=3.522\ \mathrm{mm^2/mm}$, $I_p=1057.25\ \mathrm{mm^4/mm}$, $\bar t=60\ \mathrm{mm}$ y $\bar E=11.74\ \mathrm{GPa}$ dentro del redondeo publicado | implementado |
| SC-03 | identidades de sección equivalente | conservación numérica de $EA$ y $EI$ | implementado |
| SC-04 | solver directo | respuesta válida con $\eta=I_p/(A_pR^2)$ y cierre numérico satisfactorio | implementado |
| SC-05 | directo frente a Fourier | paridad de $N$, $M$ y $Q$ usando el mismo $\eta$ | implementado |
| SC-06 | interacción, etapa posterior | mismos $E_s$, $A_p$ e $I_p$ en Schwartz–Einstein y CANDE, con convenciones documentadas | pendiente |

Fuentes base ya preservadas:

- NCSPA, *Corrugated Steel Pipe Design Manual*, 2.ª ed., tabla 2.6,
  p. impresa 32/PDF 33: propiedades de sección por longitud proyectada;
- Mai (2013), p. impresa 14/PDF 23: condición plana y sección lisa
  equivalente;
- CANDE-2025, PDF pp. 9–10: parámetros de interacción con $E$, $A$ e $I$.

## 6. Datos todavía `UNKNOWN`

Para el benchmark genérico no hace falta conocer el túnel real. Para su
aplicación sí faltan:

- designación completa del perfil corrugado;
- espesor nominal, de diseño o medido que deba usarse;
- confirmación de que la corrugación es anular;
- fuente autorizada de $A_p$ e $I_p$;
- escenarios, distribuciones y dependencias del suelo para Monte Carlo.

Mientras estos datos sean `UNKNOWN`, se usarán únicamente casos publicados o
paramétricos y no se presentarán resultados como demandas del túnel real.

## 7. Fuera de alcance del prototipo

No forman parte de este trabajo:

- matrices $ABD$ o una teoría general de cáscara;
- modos axiales o doble Fourier longitudinal;
- un modelo FEM del túnel;
- desplazamientos como producto de aceptación;
- recuperación de $\sigma$, $\tau$ o tensiones locales en la onda;
- capacidad, costuras o pernos.

Esos temas sólo podrán abrirse como trabajos posteriores y separados. El
prototipo actual termina al producir y auditar los resultantes globales
$N(\theta)$, $M(\theta)$ y $Q(\theta)$ y sus envolventes.
