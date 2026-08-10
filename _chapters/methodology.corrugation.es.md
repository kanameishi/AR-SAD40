# Rigidez equivalente de la sección corrugada

## 1. Alcance

En el problema plano, la corrugación anular se representa mediante el área y
el momento de inercia del perfil por unidad de longitud axial proyectada:

$$
A_p,
\qquad
I_p.
$$

Estas propiedades se introducen en el cálculo antes de resolver el anillo. No
se modifican posteriormente $N(\theta)$, $M(\theta)$ o $Q(\theta)$ mediante un
factor empírico.

El producto de esta etapa son únicamente los resultantes globales del anillo y
sus extremos/envolventes. La recuperación de $\sigma$, $\tau$, estados
$\sigma_*$ o $\tau_*$, capacidades y demandas de pernos queda fuera de este
capítulo.

## 2. Propiedades de sección y rigideces

Para acero elástico de módulo $E_s$:

$$
EA=E_sA_p,
\qquad
EI=E_sI_p.
$$

En la notación que usa $J$ para el segundo momento de área, $EJ$ y $EI$ son la
misma rigidez flexional. El parámetro que recibe el solver directo es

$$
\eta
=
\frac{EI}{EA R^2}
=
\frac{I_p}{A_pR^2}.
$$ {#eq-corrugation-eta}

La sección lisa equivalente que conserva ambas rigideces es

$$
\bar t=\sqrt{\frac{12I_p}{A_p}},
\qquad
\bar E=\frac{E_sA_p}{\bar t},
$$ {#eq-corrugation-equivalent}

de modo que

$$
\bar E\bar t=E_sA_p,
\qquad
\frac{\bar E\bar t^3}{12}=E_sI_p.
$$

$\bar t$ y $\bar E$ son una representación de entrada equivalente; las
propiedades primarias continúan siendo $A_p$ e $I_p$.

## 3. Fuentes seccionales de control

### 3.1 Perfil $3\times1\ \mathrm{in}$

**[PUBLICADO]** La Tabla 2.6 del manual NCSPA, p. impresa 32/PDF 33, presenta
las propiedades del perfil $3\times1\ \mathrm{in}$, anular o helicoidal, por
pie de proyección. Para obtener $A_p$ por pulgada de proyección debe dividirse
la columna de área por 12; la columna $I_p$ ya se publica en
$\mathrm{in^4/in}$.

Las dos filas que acotan un espesor base de $3.000\ \mathrm{mm}$ son:

| Espesor especificado (in) | Espesor base (mm) | $A_p$ (mm²/mm) | $I_p$ (mm⁴/mm) | Evidencia |
|---:|---:|---:|---:|---|
| 0.109 | 2.65684 | 3.30200 | 252.36079 | fila publicada; conversión SI derivada |
| 0.138 | 3.41630 | 4.25027 | 331.01869 | fila publicada; conversión SI derivada |

**[DATO PRELIMINAR DEL PROYECTO]** El registro disponible identifica un perfil
aproximado $76\times25\times3\ \mathrm{mm}$ y un diámetro interior aproximado
de $2.63\ \mathrm{m}$. No se interpreta todavía como geometría conforme a obra.

La tabla no contiene una fila exacta para un espesor base de
$3.000\ \mathrm{mm}$. Para la primera evaluación se adopta una interpolación
lineal, rotulada como **[DERIVADO]**:

$$
\lambda
=
\frac{3.000-2.65684}{3.41630-2.65684}
=0.451847,
$$

$$
A_p=A_{p,1}+\lambda(A_{p,2}-A_{p,1})
=3.73047\ \mathrm{mm^2/mm},
$$

$$
I_p=I_{p,1}+\lambda(I_{p,2}-I_{p,1})
=287.90215\ \mathrm{mm^4/mm}.
$$

**[ENTRADAS DE CONTROL]** Para esta evaluación se adopta
$E_s=200\ \mathrm{GPa}$. También se usa $R=1.315\ \mathrm{m}$, obtenido como
la mitad del diámetro interior preliminar. Las ecuaciones requieren el radio
medio de la sección; por ello este valor es provisional hasta confirmar la
geometría de la corrugación y la posición de su eje centroidal.

Con esas entradas:

$$
EA=746\,094.36\ \mathrm{kN/m},
\qquad
EI=57.58043\ \mathrm{kN\,m^2/m},
$$

$$
\eta=4.46303\times10^{-5},
\qquad
\bar t=30.43205\ \mathrm{mm},
\qquad
\bar E=24.51673\ \mathrm{GPa}.
$$

La interpolación se sustituirá por propiedades tabuladas o calculadas de la
geometría medida cuando se confirme el perfil y el espesor base.

### 3.2 Perfil $152\times51\times3\ \mathrm{mm}$ de Mai

**[PUBLICADO]** Mai (2013), p. impresa 14/PDF 23, usa

$$
E_s=200\ \mathrm{GPa},
\qquad
A_p=3.522\ \mathrm{mm^2/mm},
\qquad
I_p=1057.25\ \mathrm{mm^4/mm}.
$$

La aplicación de @eq-corrugation-equivalent produce

$$
\bar t=60.01845\ \mathrm{mm},
\qquad
\bar E=11.73639\ \mathrm{GPa},
$$

que reproducen los valores publicados redondeados de $60\ \mathrm{mm}$ y
$11.74\ \mathrm{GPa}$. Usando el mismo radio de control
$R=1.315\ \mathrm{m}$,

$$
\eta=1.73595\times10^{-4}.
$$

Este segundo perfil es un benchmark seccional; no se atribuye al túnel real.

## 4. Uso en el prototipo

El flujo implementado es:

1. calcular $EA$, $EI$ y $\eta$ con `calculateRingSection()`;
2. resolver las tracciones prescritas con
   `solveRingDirect(..., sectionRatio = eta)`;
3. verificar el mismo cierre con
   `solveRingSpectrum(..., uniformMoment = "section", sectionRatio = eta)`;
4. suministrar $E_s$, $A_p$ e $I_p$ a las ramas de interacción que requieren
   las rigideces absolutas;
5. mantener la sección fija en Monte Carlo salvo que se apruebe incertidumbre
   de geometría o espesor.

Las tablas reproducibles se guardan en
`TITO/kb/benchmarks/corrugated-section.csv`. Su productor es
`scripts/R/runRingBenchmarks.R`.
