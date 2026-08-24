# Registro de ecuaciones y fronteras del cálculo

## Estado y alcance

Registro interno. No constituye prosa pública. CAL-E01--CAL-E10 documentan las
relaciones consumidas por `verification-biaxial-uniform`. CAL-L01 y CAL-L02
documentan interfaces implementadas pero no evaluadas para el caso existente
porque sus entradas permanecen `UNKNOWN`. Las ramas no se suman ni se
convierten unas en otras.

La Fase 1 congelada conserva las etiquetas metodológicas originales. Este
registro no las modifica: documenta la correspondencia entre la formulación
auditada, la implementación R, los productos materializados y la futura
memoria.

## Convenciones comunes

- $\theta=0$ en la clave y aumenta en sentido horario.
- $\mathbf e_r$ es positiva hacia el exterior y $\mathbf e_t$ en el sentido
  creciente de $\theta$.
- $P_r>0$ actúa hacia el exterior; $P_t>0$ actúa en el sentido de
  $\mathbf e_t$.
- $N_\theta>0$ corresponde a tracción.
- $M_\theta>0$ produce tracción en la fibra interior.
- $Q_\theta>0$ actúa hacia el centro sobre la cara positiva.
- Con presiones en kPa y longitudes en m, $N_\theta$ y $Q_\theta$ resultan en
  kN/m y $M_\theta$ en kN·m/m.

## Relaciones consumidas

### CAL-E01 — definición de las resultantes seccionales

A $\theta$ fijo, para una franja de ancho longitudinal proyectado $b$ y área
resistente $A_b$,

$$
N_\theta(\theta)=\frac{1}{b}\int_{A_b}\sigma_\theta(\theta,\xi)\,dA,
\qquad
M_\theta(\theta)=\frac{1}{b}\int_{A_b}
\sigma_\theta(\theta,\xi)\,\xi\,dA.
$$

$dA$ es un elemento del área bidimensional de la sección transversal y $\xi$
es su distancia firmada al eje centroidal, positiva hacia la fibra interior.
No existe una segunda integración en $\theta$. La relación define signos y
unidades; no se usa para recuperar tensiones en la ejecución vigente.

La Fase 1 define una coordenada $z$ positiva hacia la fibra exterior y escribe
la definición seccional con el signo opuesto, aunque sus ecuaciones de
equilibrio emplean algebraicamente la convención adoptada aquí. El puente
interno, que no modifica el producto congelado, es

$$
M_\theta^{\mathrm{calc}}
=-M_\theta^{\mathrm{F1,def}}
=M_\theta^{\mathrm{F1,alg}}.
$$

- **Evidencia:** definición seccional de este estudio; correspondencia interna
  con la Fase 1 documentada en
  `_ref/TITO-kb/calculation-memo/equation-traceability.md`.
- **R:** convención de `solveRingDirect()` y
  `summarizeSectionResultants()`.
- **Producto:** `section.resultants.csv` y `section.extrema.csv`.
- **Ubicación pública:** bases y convenciones.

### CAL-E02 — estado efectivo horizontal adoptado

$$
\sigma'_h=K_0\sigma'_v.
$$

El escenario adopta $K_0=0.5$ y $\sigma'_v=100\ \mathrm{kPa}$; por lo tanto,
$\sigma'_h=50\ \mathrm{kPa}$. $K_0$ es una entrada adoptada, no el resultado
de una estimación geotécnica para esta ejecución.

- **Evidencia:** definición metodológica de $K_0$; valor del escenario en
  `calculation.json`.
- **R:** `estimateK0(modelID = "adopted-constant", k0 = 0.5)` y
  `calculateEffectiveStressState()`.
- **Producto:** `stress.state.csv`.
- **Ubicación pública:** datos adoptados y sustitución numérica; no incluir el
  catálogo de ramas alternativas.

### CAL-E03 — acciones perimetrales prescritas

Se definen

$$
p_m=\Delta u+\frac{\sigma'_v+\sigma'_h}{2},
\qquad
\Delta\sigma=\sigma'_v-\sigma'_h,
$$

$$
P_r(\theta)=-p_m-\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
P_t(\theta)=\alpha\frac{\Delta\sigma}{2}\sin2\theta,
\qquad 0\leq\alpha\leq1.
$$

Para el escenario, $p_m=75\ \mathrm{kPa}$ y
$\Delta\sigma=50\ \mathrm{kPa}$. $\alpha$ es un multiplicador de la
componente tangencial prescrita; no es un coeficiente de fricción ni resuelve
la interacción de contacto.

- **Evidencia:** proyección tensorial derivada en la Fase 1; familia con
  multiplicador documentada en la ampliación metodológica candidata.
- **R:** `biaxialStressTangentialMultiplierLoad()` y
  `calculatePerimeterActions()`.
- **Producto:** `perimeter.loads.csv`.
- **Ubicación pública:** acciones aplicadas y aplicación numérica.

### CAL-E04 — propiedades publicadas del perfil

La ejecución adopta la fila exacta CSPI 76×25 de espesor especificado
$t_s=2.80\ \mathrm{mm}$ y espesor base de diseño
$t_d=2.64\ \mathrm{mm}$:

$$
A_\theta=3.281\ \mathrm{mm^2/mm},\qquad
I_\theta=249.73\ \mathrm{mm^4/mm},\qquad
S_p=17.81\ \mathrm{mm^3/mm}.
$$

No se interpola a 3.0 mm ni se emplea el perfil NCSPA 3×1.

- **Evidencia:** CSPI, figura 2.1 y tabla 2.4.
- **R:** `selectCorrugatedSection()`.
- **Producto:** `section.properties.csv`.
- **Ubicación pública:** propiedades seccionales y aplicación numérica.

### CAL-E05 — rigideces circunferenciales

$$
EA_\theta=E_\theta A_\theta,
\qquad
EI_\theta=E_\theta I_\theta,
\qquad
\eta_s=\frac{EI_\theta}{EA_\theta R^2}
=\frac{I_\theta}{A_\theta R^2}.
$$

La ejecución obtiene $EA_\theta=656200\ \mathrm{kN/m}$,
$EI_\theta=49.946\ \mathrm{kN\,m^2/m}$ y
$\eta_s=4.4016244062\times10^{-5}$.

- **Evidencia:** ley seccional de la Fase 1 y propiedades publicadas del
  perfil.
- **R:** `calculateRingSection()`.
- **Producto:** `section.properties.csv`.
- **Ubicación pública:** procedimiento y aplicación numérica. El espesor y el
  módulo equivalentes que también devuelve el helper no se consumen y se
  excluyen de la memoria.

### CAL-E06 — equilibrio global de las acciones

$$
R\int_0^{2\pi}
\left[P_r(\theta)\mathbf e_r(\theta)
+P_t(\theta)\mathbf e_t(\theta)\right]d\theta=\mathbf0,
\qquad
R^2\int_0^{2\pi}P_t(\theta)\,d\theta=0.
$$

Los residuos que se materializan usan la presión característica evaluada en
los puntos medios $\mathcal M_{1/2}$ de la malla de integración,

$$
p_{\mathrm{ref}}=
\max_{\theta_j\in\mathcal M_{1/2}}
\left\{|P_r(\theta_j)|,|P_t(\theta_j)|\right\},
$$

y las normalizaciones

$$
\varepsilon_{F_x}=\frac{|F_x|}{2\pi R p_{\mathrm{ref}}},
\qquad
\varepsilon_{F_z}=\frac{|F_z|}{2\pi R p_{\mathrm{ref}}},
\qquad
\varepsilon_{M_c}=\frac{|M_c|}{2\pi R^2p_{\mathrm{ref}}}.
$$

Para los dos valores de $\alpha$, los tres residuos deben satisfacer
$\varepsilon\leq10^{-9}$.

- **Evidencia:** equilibrio vectorial; formulación de la Fase 1.
- **R:** diagnósticos de `solveRingDirect()`.
- **Producto:** `numerical.controls.csv`, con residuos globales normalizados
  por caso; la memoria informa el valor obtenido junto al procedimiento, sin
  una sección genérica de controles.
- **Ubicación pública:** procedimiento de cálculo.

### CAL-E07 — sistema diferencial de equilibrio

$$
\frac{d}{d\theta}
\begin{bmatrix}N_\theta\\Q_\theta\\M_\theta\end{bmatrix}
=
\begin{bmatrix}
Q_\theta-RP_t\\
RP_r-N_\theta\\
RQ_\theta
\end{bmatrix}.
$$

- **Evidencia:** Baker para carga radial y extensión por equilibrio vectorial
  de este estudio para $P_t$.
- **R:** `solveRingDirect()` por medio de
  `calculateSectionResultants()`.
- **Producto:** `section.resultants.csv`.
- **Ubicación pública:** fórmula operativa en el cuerpo; desarrollo en el
  Apéndice A.

### CAL-E08 — solución equilibrada y cierre por compatibilidad

Sea $(\widetilde N,\widetilde Q,\widetilde M)$ la solución particular con
valores iniciales nulos. La solución compatible es

$$
\begin{aligned}
N_\theta&=\widetilde N+\lambda_c\cos\theta+\lambda_s\sin\theta,\\
Q_\theta&=\widetilde Q-\lambda_c\sin\theta+\lambda_s\cos\theta,\\
M_\theta&=\widetilde M+R\lambda_c\cos\theta
+R\lambda_s\sin\theta+\lambda_0,
\end{aligned}
$$

$$
\lambda_c=-\frac{1}{\pi R}\int_0^{2\pi}
\widetilde M\cos\theta\,d\theta,
\qquad
\lambda_s=-\frac{1}{\pi R}\int_0^{2\pi}
\widetilde M\sin\theta\,d\theta,
$$

$$
\lambda_0=R\frac{\eta_s}{1+\eta_s}\,
\overline{\widetilde N}-\overline{\widetilde M},
\qquad
\overline f=\frac{1}{2\pi}\int_0^{2\pi}f(\theta)\,d\theta.
$$

- **Evidencia:** relaciones de viga curva de Baker y derivación auditada de la
  Fase 1.
- **R:** constantes calculadas en `solveRingDirect()`.
- **Producto:** `section.resultants.csv` y diagnósticos numéricos.
- **Ubicación pública:** constantes finales en el cuerpo sólo si son necesarias
  para reproducir el procedimiento; derivación completa en el Apéndice A.

### CAL-E09 — solución cerrada del escenario biaxial

$$
M_m=-R^2p_m\frac{\eta_s}{1+\eta_s},
$$

$$
\begin{aligned}
N_\theta&=-Rp_m
+R\Delta\sigma\frac{1+2\alpha}{6}\cos2\theta,\\
M_\theta&=M_m
+R^2\Delta\sigma\frac{2+\alpha}{12}\cos2\theta,\\
Q_\theta&=-R\Delta\sigma\frac{2+\alpha}{6}\sin2\theta.
\end{aligned}
$$

- **Evidencia:** solución derivada en este estudio a partir de CAL-E03,
  CAL-E07 y CAL-E08; no se atribuye a una fuente externa.
- **R:** `solveBiaxialTangentialMultiplierClosed()`.
- **Producto:** `numerical.controls.csv`.
- **Ubicación:** control matemático interno conservado fuera del master de la
  memoria; desarrollo en la ampliación metodológica.

### CAL-E10 — métrica del control numérico

Para $X\in\{N_\theta,M_\theta,Q_\theta\}$,

$$
\varepsilon_X=\max_{\theta_i}
\left|X_{\mathrm{directo}}(\theta_i)
-X_{\mathrm{cerrado}}(\theta_i)\right|.
$$

La ejecución usa 728 ordenadas, 8192 pasos de integración y acepta
$\varepsilon_X\leq10^{-7}$ en la unidad de cada resultante. Los seis controles
calculados presentan errores del orden de $10^{-12}$.

- **Evidencia:** control matemático interno.
- **R:** adaptador de controles en `buildCalculationData()`.
- **Producto:** `numerical.controls.csv`.
- **Ubicación:** control matemático interno conservado fuera del master de la
  memoria y documentado en la ampliación metodológica. No se denomina
  validación física.

### CAL-E11 — cota superior nominal de flexión

Para la celda periódica simétrica del perfil adoptado,

$$
c=\frac{I_\theta}{S_f},
\qquad
Z_f\leq A_\theta c,
\qquad
\overline M_n
=F_y\max\!\left(1.25S_f,\,A_\theta c\right).
$$

La fila CSPI 2,8/2,64 y la hipótesis $F_y=250\ \mathrm{MPa}$ producen
$c=14.0218978\ \mathrm{mm}$ y
$\overline M_n=11.5014617\ \mathrm{kN\,m/m}$. Los máximos absolutos de
14.4159166 y 21.6210208 kN·m/m dan cocientes 1.2533987 y 1.8798498.

- **Evidencia:** AISI S100-2024 F1--F4 para los límites prescriptivos; la
  desigualdad $Z_f\leq A_\theta c$ y la cota común son derivaciones de este
  estudio. La fila seccional es un dato publicado de CSPI y $F_y$ es una
  hipótesis adoptada.
- **R:** `screenAisiFlexuralDemand()` y el adaptador de
  `buildCalculationData()`.
- **Producto:** `sheet.flexural.bound.csv`, una fila por caso con la demanda
  concurrente, ambas cotas parciales y el cociente.
- **Ubicación pública:** fórmula y resultado en la aplicación; desarrollo
  geométrico en el Apéndice A; formulación completa en la ampliación
  metodológica.
- **Límite:** es un descarte nominal unilateral de F2--F4. No suministra
  $M_a$, no alimenta H1/H2, no cubre A1.2.6/K2 y no transforma el estado de
  referencia en una combinación ASD/LRFD.

### CAL-E12 — pérdida paramétrica de diámetro en la costura

Sea $d_0$ el diámetro nominal del perno, $\Delta d$ su pérdida diametral
y $\delta_d=\Delta d/d_0$. El diámetro remanente, la relación de áreas
y la resistencia de referencia reducida son

$$
d_r=d_0(1-\delta_d),
\qquad
\rho_d=(1-\delta_d)^2,
\qquad
R_{n,c}=\rho_d R_{n,0}.
$$

La utilización y el límite analítico de pérdida son

$$
U_s(\delta_d)
=\frac{T_u}{\phi_sR_{n,0}(1-\delta_d)^2},
\qquad
\delta_{d,lim}
=1-\sqrt{\frac{T_u}{\phi_sR_{n,0}}}.
$$

- **Evidencia:** formulación de sensibilidad derivada de la relación entre las
  áreas circulares remanente y nominal; no es una ecuación AASHTO.
- **R:** `evaluateAashto127CorrugatedConduit()` y el adaptador de
  `evaluateCoverConfiguration()`.
- **Entradas:** `fastenerDiameterMm` y `fastenerDiameterLossRatio`; el caso
  determinístico adopta 12,7 mm y cero pérdida.
- **Productos:** `aashto.inputs.csv`, `aashto.calculation.csv`,
  `aashto.checks.csv` y `aashto.summary.csv`.
- **Ubicación pública:** ecuación operativa en el cuerpo y desarrollo en el
  Apéndice C.2.
- **Límite:** sólo representa una reducción proporcional al área del perno. No
  verifica agujeros, aplastamiento, desgarro, sección neta, solape ni la
  equivalencia de la unión existente con la costura publicada de referencia.

### CAL-E13 — sección y resistencia local del hormigón proyectado simple

Para una franja rectangular de ancho unitario,

$$
A_c=t_c,
\qquad
I_c=\frac{t_c^3}{12},
\qquad
E_c=4700\sqrt{f'_c},
\qquad
EA_c=E_cA_c,
\qquad
EI_c=E_cI_c,
$$

donde $E_c$ y $f'_c$ se expresan en MPa. Para una franja de ancho $b$ y
espesor de cálculo $h_d$,

$$
P_u=-N_\theta b,
\qquad
M_u=|M_\theta|b,
\qquad
V_u=|Q_\theta|b,
$$

$$
A_g=bh_d,
\qquad
S_m=\frac{bh_d^2}{6},
\qquad
\phi=0.60.
$$

Las comprobaciones locales de ACI 318-25, Capítulo 14, son

$$
U_t=
\frac{\max(0,M_u/S_m-P_u/A_g)}
{\phi\,0.42\lambda\sqrt{f'_c}},
$$

$$
U_c=
\frac{M_u}{\phi\,0.85f'_cS_m}
+\frac{P_u}{\phi P_n},
\qquad
P_n=0.60f'_cA_g
\left[1-\left(\frac{\ell_c}{32h_d}\right)^2\right],
$$

$$
U_v=
\frac{V_u}{\phi\,0.11\lambda\sqrt{f'_c}\,bh_d}.
$$

- **Evidencia:** ACI 318-25, sección 19.2.2.1(b), para el módulo del hormigón
  de peso normal; 21.2.1, 14.5.3.1, 14.5.4.1 y 14.5.5.1(a), para las
  comprobaciones locales. $A_c$, $I_c$, $A_g$ y $S_m$ son resultados
  geométricos derivados.
- **R:** `calculateAci31825NormalWeightConcreteModulus()`,
  `mapAciShellActions()`, `evaluateAci31825PlainConcreteStrip()` y la rama
  `additionalLinings.shotcrete` de `evaluateCoverConfiguration()`.
- **Entradas:** radio exterior, $t_c$, $f'_c$, $\nu_c$, $\lambda$, ancho de
  franja, condición de colocación contra suelo, $\ell_c$ y condiciones de
  aplicabilidad del Capítulo 14.
- **Productos:** `shotcrete.section.properties.csv`,
  `shotcrete.interaction.parameters.csv`,
  `shotcrete.section.resultants.csv`, `shotcrete.section.extrema.csv`,
  `shotcrete.numerical.controls.csv`, `shotcrete.checks.csv` y
  `shotcrete.summary.csv`.
- **Ubicación pública:** rigideces, resultantes y comprobaciones locales de
  tracción y corte en la aplicación numérica; la compresión se publica cuando
  se documente $\ell_c$.
- **Límite:** la rama simple no aplica cuantía mínima de armadura. El cálculo
  local no sustituye la estabilidad global, el servicio, la durabilidad, las
  juntas, las aberturas ni el procedimiento de una cáscara armada.

### CAL-E14 — cuantía y resistencia local del hormigón proyectado armado

Para una franja de ancho $b$ y espesor $t_c$, la cuantía mínima total Grade
60 en cada dirección es

$$
A_{s,\min}=0.0018bt_c.
$$

La alternativa activa distribuye ese total en dos capas simétricas. Para cada
fila concurrente se forman

$$
P_u=-N_\theta b,
\qquad
M_u=M_\theta b,
$$

y se evalúa la relación radial

$$
U_{NM}=
\frac{\lVert(P_u,M_u)\rVert}
{\lVert(\phi P_n,\phi M_n)\rVert_{\mathrm{rayo}}}.
$$

- **Evidencia:** ACI 318.2-14, 6.1.3 y 6.1.9, para la cuantía total y la
  consideración de ambas superficies; ACI 318-25, Tabla 21.2.2 y artículos
  21.2.2.3, 22.2.1 y 22.2.2, para el dominio local $P$--$M$.
- **Hipótesis derivada:** el reparto 50/50 entre caras define la sección
  candidata y no constituye un detalle constructivo aprobado.
- **R:** `checkAci318214SymmetricShellReinforcement()`,
  `buildAci31825ReinforcedSectionDomains()`,
  `evaluateAci31825ReinforcedSectionDemand()` y
  `evaluateAci31825ReinforcedShellStrip()`.
- **Entradas:** $t_c$, $b$, $f'_c$, capas circunferenciales y longitudinales,
  coordenadas, $f_y$, $E_s$, combinación, interfaz y resultantes concurrentes.
- **Productos:** las filas `liningID=reinforcedConcrete` de los siete productos
  `shotcrete.*.csv` y sus tablas y figuras identificadas por alternativa.
- **Límite:** la comprobación publicada es local $P$--$M$. No comprende corte,
  acción longitudinal, detallado, estabilidad, durabilidad, servicio ni un
  dictamen integral de ACI 318.2-25.

## Interfaces de carga no evaluadas para el caso existente

### CAL-L01 — carga de prisma y empuje escalar USACE

$$
P_{FD}=\gamma H_0,
\qquad
T_L=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2}.
$$

- **Evidencia:** USACE EM 1110-2-2902, ecuación 4-20 y ejemplo D4.
- **R:** `calculatePrismThrust()`.
- **Salida:** presión en clave y empujes escalares con combinación, etapa y
  base de cada cantidad, base de factores y estado de cálculo explícitos. El
  factor de distribución viva se obtiene de $C_L=l_w\le S$,
  $F_1=\max(0.75S/l_w,0.381/S,1)$ cuando las longitudes se expresan en metros.
- **Límite:** no genera presión angular, $M_\theta$ ni $Q_\theta$.

### CAL-L02 — interacción externa Schwartz--Einstein

$$
C^*=\frac{E_gR(1-\nu_\ell^2)}{E_\ell A_\ell(1-\nu_g^2)},
\qquad
F^*=\frac{E_gR^3(1-\nu_\ell^2)}{E_\ell I_\ell(1-\nu_g^2)},
$$

$$
\begin{aligned}
N_\theta&=-P_{SE}Rt_0+P_{SE}Rt_2\cos2\theta,\\
M_\theta&=P_{SE}R^2m_2\cos2\theta,\\
Q_\theta&=-2P_{SE}Rm_2\sin2\theta.
\end{aligned}
$$

- **Evidencia:** Schwartz--Einstein, ecuaciones 2.1--2.2 y A.49--A.54.
- **R:** `calculateExternalInteraction()`; las ecuaciones fuente permanecen
  en `schwartzEinsteinResultants()`.
- **Estado de referencia:**
  $P_{SE}=\sigma'_v(z_{ref})$ y
  $K_{SE}=\sigma'_h(z_{ref})/P_{SE}$ en una cota declarada; ambas tensiones
  son efectivas. La acción hidráulica se conserva separada y no se incluye en
  esta primera interfaz.
- **Salida:** `thetaRad`, `thetaDeg`, `normalForceKnPerM`,
  `bendingMomentKnMPerM`, `shearForceKnPerM`, `combinationID`, `stageID` y
  `forceEffectStatus`, por metro axial proyectado; los extremos se evalúan en
  forma analítica y no dependen de la malla angular.
- **Límite:** `fullSlip` y `noSlip` son escenarios discretos. Una eventual
  envolvente exterior es una envolvente de escenarios de modelo, no una cota
  física demostrada. $\alpha$ pertenece sólo al estado biaxial prescrito.

Las alternativas de $K_0$, la compactación FHWA, CANDE, Núñez, Fourier,
Monte Carlo, resistencia integral, juntas y pernos conservan sus productos y
puertas propias. No son resultados de `verification-biaxial-uniform`.

## Puerta P34.1

P34.1 se considera cerrada cuando una auditoría independiente confirme:

1. identidad de signos entre CAL-E03, CAL-E07, CAL-E08 y R;
2. identidad dimensional de CAL-E01, CAL-E04 y CAL-E05;
3. correspondencia de CAL-E09 con las curvas completas materializadas;
4. clasificación correcta de fuentes y resultados derivados; y
5. ausencia de relaciones no consumidas en el primer paquete público.
