# Apéndice C. Controles del procedimiento {#sec-calculation-appendix-verification .unnumbered}

Este apéndice distingue los controles de cada rama del cálculo. Los casos no
se combinan con el escenario de diseño: verifican ecuaciones, signos,
coeficientes o reproducciones normativas específicas.

## C.1 Integración directa, solución cerrada y Fourier {.unnumbered}

La carga biaxial uniforme contiene únicamente el modo uniforme $n=0$ y el
modo de ovalización $n=2$. Para esa carga, la solución modal no es una
aproximación truncada: ambos modos reproducen exactamente la forma espacial.
La integración RK4 usa 8192 pasos angulares —no 8192 términos de Fourier— para
controlar de manera independiente las ecuaciones diferenciales y se compara
con la solución cerrada. La
@tbl-calculation-controls informa las diferencias y los residuos del escenario
vigente.

Para cargas radiales discontinuas por sectores, la integración directa
reproduce los ocho pares de fuerza normal y momento de las
tablas XIII y XIV de Baker. Las diferencias máximas normalizadas son
$4{,}97\times10^{-4}$ para fuerza normal y $4{,}23\times10^{-4}$ para momento
[@Baker1968, tablas XIII--XIV, pp. 50--51]. Este control verifica la rama de
carga prescrita y no la interacción con el terreno.

## C.2 Schwartz--Einstein {.unnumbered}

El ejemplo HP97 usa $C^*=0{,}05$, $F^*=100$, $\nu_g=0{,}4$,
$K_{SE}=0{,}5$ y $\theta_{SE}=30^\circ$. El cálculo reproduce los
valores publicados para descarga por excavación y carga externa, con
deslizamiento libre y sin deslizamiento [@SchwartzEinstein1980, ejemplo HP97,
pp. 391--392].

| Secuencia | Interfaz | $T_{SE}/(P_{SE}R)$ publicado | Calculado | $M_{SE}/(P_{SE}R^2)$ publicado | Calculado |
|---|---|---:|---:|---:|---:|
| descarga por excavación | deslizamiento libre | 0,736 | 0,735909 | 0,00774 | 0,007743 |
| descarga por excavación | sin deslizamiento | 0,812 | 0,811806 | 0,00707 | 0,007066 |
| carga externa | deslizamiento libre | 0,887 | 0,887061 | 0,0133 | 0,013274 |
| carga externa | sin deslizamiento | 1,02 | 1,017169 | 0,0121 | 0,012113 |

: Reproducción del ejemplo HP97 en la convención de Schwartz--Einstein. {#tbl-calculation-se-hp97}

Este es el benchmark de la rama que genera las demandas de diseño. La
conversión a la convención de signos de la memoria se realiza después de
calcular los coeficientes de la fuente.

## C.3 Reconstrucción modal y gradiente equilibrado {.unnumbered}

Las resultantes Schwartz--Einstein del campo uniforme contienen los modos
$n=0,2$. Para cada una de las tres secciones y ambos límites de interfaz, se
reconstruyen sus tracciones equivalentes y se resuelven con Fourier y con la
integración directa de la @eq-calculation-first-order-system. La diferencia
máxima normalizada es inferior a $10^{-12}$ para Fourier y a $10^{-7}$ para
la integración directa. Este control verifica la transferencia de
coeficientes; la interacción por rigidez sigue procediendo de
Schwartz--Einstein.

La corrección de gradiente contiene los modos $n=1,3$. La reacción radial de
la @eq-calculation-appendix-gradient-reaction reduce la resultante vertical a
cero dentro de la precisión numérica. La @tbl-calculation-hybrid-controls
compara Fourier con una integración RK4 de 8192 pasos angulares y controla además
que la presión normal prescrita permanezca en compresión.

```{r}
#| label: tbl-calculation-hybrid-controls
#| tbl-cap: "Controles del gradiente equilibrado para las tres secciones."
#| echo: false
HybridControls <- read.csv(
  "TITO/kb/benchmarks/project-hybrid-gradient-verification.csv",
  check.names = FALSE
)
HybridLiningNames <- c(
  steel = "chapa corrugada",
  shotcrete = "shotcrete de 100 mm",
  reinforcedConcrete = "shotcrete de 150 mm"
)
HybridControlTable <- data.frame(
  Revestimiento = unname(HybridLiningNames[HybridControls$liningID]),
  `Diferencia Fourier--RK4` = formatC(
    HybridControls$fourierDirectMaximumNormalizedDifference,
    format = "e",
    digits = 1
  ),
  `Residuo de equilibrio` = formatC(
    HybridControls$fourierMaximumNormalizedEquilibriumResidual,
    format = "e",
    digits = 1
  ),
  `Compresión mínima [kPa]` = formatC(
    HybridControls$minimumPrescribedCompressivePressureKPa,
    format = "f",
    digits = 0
  ),
  Estado = ifelse(
    HybridControls$parityStatus == "satisfied" &
      HybridControls$equilibriumStatus == "satisfied" &
      HybridControls$prescribedCompressionStatus == "satisfied",
    "satisface",
    "no satisface"
  ),
  check.names = FALSE
)
knitr::kable(HybridControlTable, align = c("l", "r", "r", "r", "c"))
```

Los tres controles satisfacen. La reacción es una restricción de equilibrio,
no un resorte calibrado; por eso no se informa un valor de $k_r$ ni un
desplazamiento asociado.

## C.4 AASHTO/USACE, FHWA y Núñez {.unnumbered}

El ejemplo D4 de USACE, con un conducto de 36 in, 30 ft de tapada y
$120\ \mathrm{lb/ft^3}$, produce una fuerza normal sin factores de
$5400\ \mathrm{lb/ft}$ y reproduce la fuerza factorizada publicada de
$10530\ \mathrm{lb/ft}$ [@USACE2020, ap. D4, pp. 332--333]. Este control
corresponde al empuje escalar AASHTO/USACE y no valida una distribución angular
de momentos o cortes.

{{< include /_tbl/Calculation.usace.reference.ES.qmd >}}

La tabla separa los valores publicados de los derivados. El ejemplo D4
identifica la expresión de empuje como ecuación 4-24, aunque la relación
mostrada corresponde a la ecuación 4-20. El modificador 1,10 pertenece al
ejemplo de aluminio; la ecuación 4-21 indica 1,05 para conductos metálicos
corrugados. Ninguno se transfiere al liner existente sin acreditar la
disposición aplicable.

La correlación de FHWA-RD-98-191 representa el efecto lateral del equipo de
compactación mediante la presión equivalente

$$
n_p=1.3P\left(1-\sin\phi\right)^3
\left(\frac{970}{d_c-250}\right)^2,
$$ {#eq-calculation-fhwa-compaction}

donde $P$ es la fuerza total del equipo en kN, $\phi$ el ángulo de fricción en
estado suelto y $d_c$ el diámetro centroidal en mm
[@McGrathEtAl1999, ec. 5.1, pp. 176--178]. Los
casos publicados controlan la evaluación aritmética para distintas fuerzas del
compactador, diámetros y ángulos de fricción; no se suman a la acción de diseño
sin información sobre el relleno y el procedimiento constructivo.

{{< include /_tbl/Calculation.fhwa.reference.ES.qmd >}}

Ocho filas coinciden con la presión publicada al redondear a 0,1 kPa. La fila
9 conserva el ángulo impreso y el ángulo alternativo coherente con las demás
filas de piedra; la discrepancia se informa sin ajustar la ecuación.

Núñez desarrolla una formulación para revestimientos de túneles excavados. La
especialización circular sin presión de agua utilizada en sus ejemplos define
[@Nunez2000, pp. 13--15]

$$
a_N=\frac{16}{\chi_N}\frac{\bar E_\ell}{\bar E_g}
\left(\frac{e}{D}\right)^3,
\qquad
A_N=\frac{a_N}{1+a_N},
$$

$$
p_0=\gamma H+q,
\qquad
p_d=\eta_N(1-K_0)p_0,
\qquad
p_h=\frac{p_d}{1+a_N},
$$

$$
M_{\max}=\frac{p_dD^2}{16}A_N,
\qquad
N_C=\frac{D}{2}(K_0p_d+p_h),
\qquad
N_A=\frac{D}{2}(\eta_N\gamma H+q).
$$ {#eq-calculation-nunez-reference}

$N_C$ corresponde a la clave y $N_A$ al punto lateral del diámetro horizontal;
Núñez adopta la compresión como positiva. Los ejemplos usan $D=10\ \mathrm{m}$,
$H=15\ \mathrm{m}$, $\gamma=1,9\ \mathrm{tf/m^3}$,
$q=1\ \mathrm{tf/m^2}$ y $K_0=0,5$.

{{< include /_tbl/Calculation.nunez.reference.ES.qmd >}}

Los valores no redondeados de $a_N$ son entradas de la reproducción porque la
fuente no suministra todas las propiedades necesarias para recalcularlos. A
partir de ellos se obtienen $A_N$, $M_{\max}$, $N_C$ y $N_A$. El parámetro
$\eta_N$ representa la relajación asociada a la excavación.

USACE y FHWA controlan relaciones de acciones dentro de sus dominios;
Schwartz--Einstein y Núñez controlan formulaciones de interacción para sus
condiciones de referencia. Las formulaciones de Núñez de 2000 y de Núñez,
Sfriso y Laiún de 2014 no reemplazan la carga externa de Schwartz--Einstein en
este liner colocado en zanja y no se promedian con ella
[@Nunez2000; @NunezSfrisoLaiun2014].
