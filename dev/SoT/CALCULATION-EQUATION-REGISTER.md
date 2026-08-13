# Registro de ecuaciones del escenario determinístico

## Estado y alcance

Registro interno de P34.1. No constituye prosa pública. Contiene únicamente las
relaciones consumidas por `verification-biaxial-uniform`; las alternativas de
$K_0$, las acciones USACE/FHWA, la interacción suelo--conducto, Monte Carlo,
la recuperación de tensiones y las verificaciones resistentes se excluyen de
esta puerta.

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
  `TITO/kb/calculation-memo/equation-traceability.md`.
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

### CAL-E04 — interpolación de las propiedades del perfil

Para una propiedad $X$ tabulada en dos espesores base $t_1<t_b<t_2$,

$$
\lambda=\frac{t_b-t_1}{t_2-t_1},
\qquad
X(t_b)=(1-\lambda)X_1+\lambda X_2.
$$

La relación se aplica por separado a $A_\theta$ e $I_\theta$ con las dos filas
de la tabla NCSPA que encierran $t_b=3.0\ \mathrm{mm}$. La ejecución obtiene
$\lambda=0.4518473652$, $A_\theta=3.7304717949\ \mathrm{mm^2/mm}$ e
$I_\theta=287.9021537231\ \mathrm{mm^4/mm}$.

- **Evidencia:** datos publicados en NCSPA, tabla 2.6; interpolación lineal
  derivada en este estudio.
- **R:** `interpolateCorrugatedSection()`.
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

La ejecución obtiene $EA_\theta=746094.35897\ \mathrm{kN/m}$,
$EI_\theta=57.580430745\ \mathrm{kN\,m^2/m}$ y
$\eta_s=4.4630283681\times10^{-5}$.

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
- **Ubicación pública:** resultado resumido del contraste en el cuerpo y
  desarrollo autónomo en el Apéndice B.

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
- **Ubicación pública:** conclusión breve en el cuerpo y tabla completa en el
  Apéndice B. No se denomina validación física.

## Relaciones excluidas de la memoria vigente

- estimaciones alternativas de $K_0$;
- empuje circunferencial USACE/AASHTO;
- distribución FHWA de compactación;
- Schwartz--Einstein, CANDE y Núñez;
- Fourier, excepto como comprobación interna del notebook;
- Monte Carlo y distribuciones probabilísticas;
- recuperación de tensión normal, resistencia, juntas y pernos; y
- shotcrete.

Estas relaciones pueden permanecer en la metodología o en código de
investigación con sus propias pruebas. Su existencia no las convierte en
entradas ni resultados del escenario.

## Puerta P34.1

P34.1 se considera cerrada cuando una auditoría independiente confirme:

1. identidad de signos entre CAL-E03, CAL-E07, CAL-E08 y R;
2. identidad dimensional de CAL-E01, CAL-E04 y CAL-E05;
3. correspondencia de CAL-E09 con las curvas completas materializadas;
4. clasificación correcta de fuentes y resultados derivados; y
5. ausencia de relaciones no consumidas en el primer paquete público.
