# Registro de evidencia — memoria de cálculo

## Alcance

Este registro gobierna la memoria de cálculo independiente. La metodología
integrada vigente conserva los desarrollos académicos. La memoria utiliza
hallazgos comprobados, fórmulas
operativas y una aplicación numérica, con trazabilidad hacia las fuentes
primarias mediante `bib/references.bib`.

## Fuentes empleadas

- Baker (1968): equilibrio, compatibilidad y valores tabulados para cargas
  radiales por sectores (`Baker1968`).
- Schwartz y Einstein (1980): formulación de interacción suelo--revestimiento,
  secuencias de excavación y carga externa, y caso HP97
  (`SchwartzEinstein1980`).
- AASHTO LRFD Bridge Design Specifications, 10.ª edición (2024): mapa oficial
  de los artículos 12.7, 12.8 y 12.13 y del subartículo 12.8.9; el acceso se limita al índice
  (`AASHTO2024TOC`).
- AASHTO LRFD Bridge Construction Specifications, 4.ª edición: autoridad
  separada para ejecución, con articulado no disponible en el corpus
  (`AASHTOConstruction2017`).
- USACE EM 1110-2-2902 (2020): relación pública de empuje para conductos
  metálicos corrugados y ejemplo D4 (`USACE2020`).
- Anderson et al. (2023): reproducción de disposiciones de la novena edición
  de AASHTO LRFD para pandeo, factor de costura, rigidez del suelo y tapada
  mínima; constituye una fuente secundaria y no reemplaza el articulado
  vigente (`AndersonEtAl2023`).
- CIRSOC 804-4 (2023): contraste métrico basado en una edición anterior de
  AASHTO; no gobierna la comprobación (`CIRSOC8044`).
- CSPI, capítulo 6: resistencia última publicada de la costura longitudinal
  para configuraciones normalizadas de chapa corrugada; la fila 76 x 25 mm,
  espesor 2,8 mm y costura doble remachada se utiliza como comparación de
  referencia (`CSPIHandbookChapter6`).
- ANSI/SDI AISI S100-2024: antecedente de investigación sobre miembros de
  acero conformado en frío; no alimenta la comprobación activa del conducto
  corrugado (`AISIS1002024`).
- ACI CODE-318-25: relación para el módulo elástico del hormigón de peso
  normal y comprobaciones locales de hormigón simple del Capítulo 14
  (`ACI31825`).
- ACI 318.2-14: suplemento histórico usado exclusivamente para la cuantía
  mínima por dirección y la disposición entre caras de la alternativa armada;
  no interviene en la evaluación de hormigón simple (`ACI318214`).
- ACI CODE-318.2-25: autoridad vigente identificada para cáscaras de hormigón;
  el corpus consultado sólo permite confirmar alcance e índice, no ejecutar
  todas sus comprobaciones resistentes (`ACI318225`).
- FHWA-RD-98-191 (1999): acción equivalente de compactación
  (`McGrathEtAl1999`).
- FHWA NHI-05-037 (2006): relaciones de referencia para el coeficiente de
  empuje en reposo (`ChristopherEtAl2006`).
- Mayne y Kulhawy (1982): relaciones entre $K_0$, $\phi'$, OCR y
  $\mathrm{OCR}_{\max}$ para carga primaria, descarga y recarga, y control del
  límite pasivo (`MayneKulhawy1982`).
- Michalowski (2005): forma de 1944 y forma abreviada de la relación de Jáky,
  y revisión crítica de su derivación (`Michalowski2005`).
- FHWA-RD-03-048 (2003) y CANDE-2025: fuentes preservadas sobre leyes de
  contacto y fricción; no sustentan el multiplicador $\alpha$ adoptado en esta
  memoria (`VulovaLeshchinsky2003`; `CANDE2025Formulations`).
- Núñez (2000): ejemplos circulares reproducibles para túneles excavados
  (`Nunez2000`).
- Núñez, Sfriso y Laiún (2014): fuente conservada para la revisión académica,
  retirada de la memoria porque el caso transcrito no permite una reproducción
  independiente completa (`NunezSfrisoLaiun2014`).
- NCSPA (2018): propiedades seccionales de perfiles corrugados de acero
  (`NCSPA2018`).
- Mai (2013): estados de medición del deterioro, conservación de $EA$ y $EI$ y
  mecanismos locales observados en conductos corrugados deteriorados
  (`Mai2013`).
- United States Bureau of Reclamation (1968): diferencia entre las
  distribuciones de tensión de vigas rectas y curvas y límite cualitativo de la
  aproximación lineal (`USBR1968Beggs`).

## Clases internas de evidencia

| Código | Clase | Regla de uso |
|---|---|---|
| PN | parámetro nominal suministrado | se conserva como nominal hasta verificar el registro definitivo |
| HA | hipótesis adoptada | se limita al escenario declarado |
| DP | dato publicado transcrito | conserva fuente, ubicación, unidad y convención |
| RP | resultado publicado reproducido | informa el valor publicado, el recalculado y la diferencia |
| DE | resultado derivado en este estudio | no se atribuye a una referencia |
| CI | comprobación numérica interna | declara caso, discretización, métrica y tolerancia |

Estos códigos pertenecen al registro interno y no se muestran como narrativa
en el informe profesional.

## Evidencia para el empuje circunferencial reglamentario

AASHTO LRFD Bridge Design Specifications, sección 12, constituye la autoridad
de diseño. El índice oficial confirma artículos separados para tubos y arcos
metálicos, estructuras de gran luz de chapas estructurales y chapas de acero
para revestimiento de túneles, además del subartículo de corrugación profunda
[@AASHTO2024TOC]. El articulado vigente no forma
parte del corpus consultado; sus ecuaciones y factores permanecen sin
verificar.

USACE EM 1110-2-2902 reproduce para conductos metálicos corrugados la relación

$$
T_L=\gamma_{DL}\frac{P_{FD}S}{2}
+\gamma_{LL}\frac{P_{FL}C_LF_1}{2}.
$$

El manual define $T_L$ como empuje mayorado por unidad de longitud de pared,
$P_{FD}$ y $P_{FL}$ como presiones verticales en la clave debidas a las cargas
permanente y móvil, y $S$ como luz. $C_L$ y $F_1$ describen la distribución de
la carga móvil. Para carga permanente sola y sin mayorar, la reducción derivada
es $T=P_{FD}S/2$. Las
comprobaciones de área de pared, pandeo y costura se realizan en las secciones
resistentes seleccionadas para la evaluación.

Esta relación corresponde al procedimiento que USACE atribuía a AASHTO en
2020; no se presenta como transcripción certificada de la décima edición.
CIRSOC 804-4 contiene una expresión coincidente basada en una edición anterior
y queda como contraste métrico. El caso se clasifica dentro de la rama 12.7
para un conducto metálico corrugado ordinario; el articulado y las erratas de
la edición vigente permanecen `UNKNOWN`. La implementación conserva por ello
`not-evaluated-specification`, sin sustituir la presión de prisma reglamentaria
por la tensión efectiva en el eje del modelo de interacción.

La tabla 6.4a de CSPI publica $R_n=769$ kN/m para una costura doble remachada
del perfil 76 x 25 mm y espesor nominal 2,8 mm. La tabla A12-7 de CIRSOC 804-4
publica 773,48 kN/m para el perfil 76,2 x 25,4 mm, espesor 2,77 mm y remaches
dobles de 7/16 in. Se adopta el menor valor para la comparación
$\phi_sR_n\geq T_u$. Esta selección no demuestra que la unión abulonada de
1/2 in ASTM A325 observada tenga la misma resistencia; agujeros, bordes,
solape y espesor remanente local permanecen `UNKNOWN`.

La pérdida de diámetro del perno se incorpora mediante una formulación de
sensibilidad derivada en este estudio. Con
$\delta_d=\Delta d/d_0$, el área transversal remanente relativa es
$(1-\delta_d)^2$ y la resistencia de referencia se reduce como
$R_{n,c}=R_{n,0}(1-\delta_d)^2$. Esta relación representa únicamente un
modo proporcional al área del perno; no se atribuye a AASHTO ni resuelve
aplastamiento, desgarro, sección neta o solape. El caso determinístico adopta
$\delta_d=0$. La futura simulación podrá tratarla como variable primitiva,
pero su distribución y su límite superior aún no se han adoptado.

La ecuación anterior determina una resultante circunferencial escalar y no una
distribución angular. El ejemplo D4 adopta $P_{FD}=\gamma H$ como presión de
prisma en la clave. Este cálculo no demuestra arqueo. FHWA define
$\mathrm{VAF}=W_p/W_{sp}$ para instalaciones SIDD de tubos rígidos y adopta
$\mathrm{VAF}=1.0$ para la teoría de compresión anular de tubos flexibles; los
factores SIDD no se transfieren al conducto metálico.

## Evidencia para la alternativa de hormigón proyectado

La alternativa se calcula como un revestimiento autónomo, sin acción compuesta
con la chapa. Para una franja de ancho unitario, las propiedades geométricas
$A_c=t_c$ e $I_c=t_c^3/12$ son resultados derivados de la sección rectangular.
El módulo de hormigón de peso normal se estima mediante
$E_c=4700\sqrt{f'_c}$, con $E_c$ y $f'_c$ expresados en MPa, conforme a ACI
318-25, sección 19.2.2.1(b). Esta relación sólo sustenta $EA_c$ y $EI_c$ para el
análisis elástico con sección bruta, no una resistencia de diseño.

La alternativa declarada pertenece a la rama de hormigón simple del Capítulo
14 de ACI 318-25. Para una franja de ancho $b$, las acciones se obtienen de
filas concurrentes mediante $P_u=-N_\theta b$, $M_u=|M_\theta|b$ y
$V_u=|Q_\theta|b$. La cara traccionada se comprueba con la Tabla 14.5.4.1(a),
el corte unidireccional con 14.5.5.1(a) y $\phi=0.60$. La resistencia axial y
la cara comprimida dependen de la longitud documentada $\ell_c$ de 14.5.3.1.
La cuantía de armadura no interviene en la rama de hormigón simple y un área
de acero nula no constituye por sí misma un incumplimiento.

ACI 318-25, sección 1.4.4, remite el diseño integral de cáscaras delgadas a
ACI CODE-318.2-25. La memoria informa las comprobaciones locales calculadas
del Capítulo 14; no extrapola esas comprobaciones a la rama de cáscara armada.

La alternativa armada declara una misma malla en ambas caras y en las
direcciones circunferencial y ortogonal. El área por cara y dirección se
deriva de $A_s=(\pi\phi_b^2/4)(1000/s_b)$, y la posición de cada capa se
obtiene del espesor, el recubrimiento libre relativo y el radio de la barra.
ACI 318.2-14, 6.1.3, sustenta
$A_{s,\min}=0.0018bt_c$ para Grade 60 en cada dirección; 6.1.9 sustenta la
consideración de ambas superficies. La adopción de una malla igual en ambas
caras es una decisión del caso, no una propiedad publicada ni una aprobación
del detalle constructivo.

El dominio local $P$--$M$ se construye por compatibilidad y equilibrio con
los factores $\phi$ de ACI 318-25, Tabla 21.2.2 y artículos 21.2.2.3, 22.2.1
y 22.2.2. La utilización es la relación radial entre la demanda concurrente y
el dominio de diseño. El corte, la acción longitudinal, el detallado, la
estabilidad global, la durabilidad, el servicio y la fisuración no se deducen
de ese dominio.

## Evidencia para la interacción elástica externa

Schwartz--Einstein define las razones $C^*$ y $F^*$ y publica las soluciones
de carga externa con deslizamiento completo y ausencia de deslizamiento en las
ecuaciones A.49--A.54. La fuente considera esta secuencia apropiada para un
conducto instalado antes de aplicar las tensiones del relleno. Las expresiones
proporcionan $T_{SE}$ y $M_{SE}$; la fuerza cortante se deriva por equilibrio,
$V_{SE}=R^{-1}dM_{SE}/d\theta_{SE}$.

El modelo supone medio y revestimiento elásticos lineales, terreno homogéneo e
isótropo, deformación plana, tensiones uniformes sobre el diámetro y medio
infinito o profundidad suficiente. No representa colocación por tongadas,
superficie libre somera, plasticidad ni una interfaz intermedia. La adaptación
a la convención de la memoria invierte los signos de $T_{SE}$ y $M_{SE}$ y
conserva $V_{SE}$ después de transformar
$\theta_{SE}=\pi/2-\theta$. El caso HP97 reproduce las razones publicadas para
ambos límites de interfaz; constituye un control de transcripción y no una
calibración del caso existente.

## Evidencia para la estimación de $K_0$

$K_0$ se define mediante tensiones efectivas,
$K_0=\sigma'_h/\sigma'_v$. Salvo cuando exista una medición directa o se
declare un escenario analítico adoptado, será una magnitud derivada y no una
entrada independiente.

Las ramas respaldadas para el primer módulo operativo son:

| Rama | Expresión | Variables primitivas | Dominio documentado |
|---|---|---|---|
| elasticidad confinada | $K_0=\nu_g/(1-\nu_g)$ | $\nu_g$ | referencia constitutiva elástica isótropa con deformación lateral impedida |
| carga primaria | $K_{0,NC}=1-\sin\phi'$ | $\phi'$ | suelos no cohesivos y suelos cohesivos normalmente consolidados |
| descarga primaria | $K_{0,OC}=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'}$ | $\phi'$, OCR | descarga desde la rama de compresión virgen; el ajuste original se obtuvo generalmente para $\mathrm{OCR}<15$ |
| descarga y recarga | $K_0=(1-\sin\phi')\left[\mathrm{OCR}/\mathrm{OCR}_{\max}^{1-\sin\phi'}+(3/4)(1-\mathrm{OCR}/\mathrm{OCR}_{\max})\right]$ | $\phi'$, OCR, $\mathrm{OCR}_{\max}$ | trayectoria de descarga y recarga con historia máxima identificable; evidencia de recarga limitada |

Para la revisión académica, Michalowski (2005, ec. 8) transcribe la forma de
1944 como

$$
K_{0,\mathrm{J\acute{a}ky\,1944}}
=(1-\sin\phi')
\frac{1+\frac{2}{3}\sin\phi'}{1+\sin\phi'}.
$$

La inspección vectorial de la ecuación 8 ubica el carácter `2` sobre el `3`
de la fracción $2/3$, antes de $\sin\phi'$. Una transcripción anterior con
$\sin^2\phi'$ fue retirada; no corresponde a la fuente.

La forma abreviada $1-\sin\phi'$ corresponde a la simplificación posterior de
1948. Michalowski cuestiona que el campo tensional del prisma de arena de la
derivación original represente una trayectoria general de deformación lateral
nula. Por ese motivo, la memoria empleará la expresión abreviada como
correlación respaldada por datos, y la forma de 1944 quedará en la comparación
académica, no como una rama probabilística adicional. El mismo artículo
reproduce $K_0=0.95-\sin\phi'$ como ajuste de Brooker--Ireland para arcillas;
al no haberse recuperado aún el texto completo original, esa relación no se
habilita como formulación operativa.

La relación de descarga se controla frente a

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'},
\qquad
\mathrm{OCR}_{\lim}
=\left[\frac{1+\sin\phi'}{(1-\sin\phi')^2}\right]^{1/\sin\phi'}.
$$

Al alcanzar ese límite, la hipótesis de estado en reposo deja de ser
aplicable; el valor no se recorta silenciosamente. Este $K_p$ es un control de
dominio dentro de la idealización de Mayne--Kulhawy, no una ley de interfaz ni
una capacidad general del relleno contra el revestimiento.

La ecuación 5.39 de FHWA NHI-05-037 imprime el segundo término de la ecuación
de recarga como $(3/4)\,\mathrm{OCR}/\mathrm{OCR}_{\max}$. La ecuación 18 del
artículo primario contiene
$(3/4)(1-\mathrm{OCR}/\mathrm{OCR}_{\max})$. La versión del manual no recupera
$K_{0,NC}$ cuando $\mathrm{OCR}=\mathrm{OCR}_{\max}=1$; por lo tanto queda
excluida del código y gobierna la fuente primaria.

La compactación no se incorpora automáticamente incrementando $K_0$. Se
mantienen como alternativas excluyentes: representar una historia de carga
mediante una relación aplicable de $K_0$, o componer un estado base con una
tensión horizontal residual $\Delta\sigma'_{h,c}$ sustentada por un modelo
específico. No se combinan ambas rutas mientras no exista evidencia que
demuestre que no contabilizan dos veces el mismo efecto.

La implementación R conserva una función pequeña por relación y un control
separado de dominio: `k0NormallyConsolidated()`, `k0ElasticConfined()`,
`k0MayneKulhawyUnloading()`, `k0MayneKulhawyReload()` y
`checkK0PassiveDomain()`. El control devuelve el estado del dominio, $K_p$ y
$\mathrm{OCR}_{\lim}$; las relaciones rechazan la frontera pasiva sin limitar
artificialmente $K_0$. `resolveCalculationK0()` selecciona una única rama desde
`calculation.json`, rechaza variables ajenas a esa rama y materializa por
separado `k0Input`, `k0Derived` y `k0Applied`.

El archivo primario preservado es
`TITO/kb/sources/mayne_kulhawy_1982_k0_ocr_relationships.pdf`, SHA-256
`3e6cf544178882cb9acb2d48c53a4c9908c851dc8903d32e047334734a178e60`.
Las ecuaciones fueron verificadas en las páginas impresas 852--867. Las
formas de Jáky fueron comprobadas además en
`TITO/kb/sources/michalowski_2005_coefficient_earth_pressure_at_rest.pdf`,
SHA-256
`ba20eb1b9a953068a55858f448431c925aa9a65162e371ba54ef732486716b2e`.
Las correlaciones de Brooker--Ireland y Mesri--Hayat, y un modelo cuantitativo de
presión residual de compactación para un revestimiento circular flexible,
permanecen pendientes y no se habilitan como ecuaciones operativas.

## Afirmaciones admitidas

- La solicitación reglamentaria se determina con la rama AASHTO del producto;
  en las ramas que emplean empuje, USACE documenta su obtención desde la
  presión vertical mayorada en clave y la luz.
- En el escenario biaxial analítico, las tensiones vertical y lateral efectivas
  se proyectan sobre el contorno para obtener una presión normal efectiva y una
  tracción tangencial disponible.
- La acción tangencial se prescribe como $P_t=\alpha p_t^*$, con
  $0\leq\alpha\leq1$. $\alpha$ es un multiplicador de la componente
  tangencial proyectada y no un coeficiente de fricción.
- $\alpha=0$ y $\alpha=1$ son los extremos de sensibilidad del escenario
  biaxial analítico de
  comprobación; la respuesta intermedia se obtiene por superposición lineal.
- Para acciones perimetrales prescritas y autoequilibradas, el equilibrio y la
  compatibilidad determinan $N_\theta(\theta)$, $M_\theta(\theta)$ y
  $Q_\theta(\theta)$.
- En el problema plano, el perfil corrugado interviene mediante
  $EA_\theta$ y $EI_\theta$.
- La comparación resistente activa reproduce la rama AASHTO 12.7 documentada
  por USACE y Anderson et al. para empuje, fluencia de pared, pandeo,
  flexibilidad, tapada y costura. Su estado numérico se informa bajo las
  propiedades y factores adoptados; no constituye comprobación de la décima
  edición.
- Las propiedades $A$ e $I$ corresponden a la fila publicada CSPI 76 x 25,
  2,8/2,64 mm. $F_y=250$ MPa, $F_u=400$ MPa y $E=200000$ MPa son hipótesis
  del escenario y permanecen sujetas a confirmación documental.
- La resistencia de costura de 769 kN/m es una comparación publicada para una
  costura doble remachada. No establece la capacidad de la unión abulonada
  existente.
- La circunferencia de referencia y los diagramas radiales no representan una
  deformada. $A_g$ modifica exclusivamente la longitud gráfica de las
  ordenadas.
- La evaluación probabilística del revestimiento existente no fue ejecutada.
  El código estadístico disponible constituye una comprobación de interfaces
  de software con muestras fijas, no una simulación del proyecto.

## Afirmaciones excluidas

- No se identifica $K_0\sigma'_v$ con la presión horizontal de contacto de un
  conducto flexible sin una formulación de interacción aplicable.
- No se atribuyen $M_\theta$ ni $Q_\theta$ a la ecuación reglamentaria escalar
  de empuje.
- No se presenta la comparación numérica AASHTO como cumplimiento de la
  décima edición mientras su articulado, erratas y aplicabilidad permanezcan
  sin verificar.
- No se identifica la resistencia de la costura doble remachada publicada con
  la resistencia de los pernos de 1/2 in ASTM A325 observados.
- No se presenta la reducción proporcional al área del perno como ecuación
  AASHTO ni como comprobación de agujeros, aplastamiento, desgarro, sección
  neta o solape.
- No se asignan distribuciones, dependencias o probabilidades de escenarios
  sin una caracterización aprobada.
- No se atribuye retención permanente a la acción FHWA sin evidencia de obra.
- No se denomina validación o calibración a una reproducción o a una
  comprobación numérica.
- CANDE no se presenta como biblioteca R/Python ni como contraste cuantitativo
  cerrado.
- Núñez, Sfriso y Laiún (2014) no se emplea como benchmark de la memoria.

## Ecuaciones admitidas

Las ecuaciones operativas de la memoria comprenden: profundidad y tensiones
verticales; ramas excluyentes de $K_0$ derivadas de sus variables primitivas;
interacción elástica externa; rigideces circunferenciales; resultantes y
extremos espaciales; empuje circunferencial AASHTO reproducido; comprobaciones
de pared, pandeo, flexibilidad y tapada; comparación con la costura publicada;
y reducción paramétrica de esta última por pérdida de diámetro. Los apéndices
separan los desarrollos, los controles matemáticos y los contrastes.

## Hechos requeridos no resueltos

- confirmación documental del producto estructural y del artículo
  reglamentario aplicable;
- confirmación del radio centroidal, la luz y el estado geométrico medido;
- confirmación de la categoría de espesor y de las propiedades seccionales;
- estratigrafía, clasificación, pesos unitarios, humedad y compactación;
- estado tensional, historia de carga y evidencia para $K_0$;
- aplicabilidad de una rama NC, de descarga o de recarga al relleno existente;
- formulación y magnitud de una eventual tensión horizontal residual de
  compactación;
- formulación de interacción suelo--conducto aplicable para determinar la
  distribución de presiones de contacto;
- rango y representación probabilística o por escenarios de $\alpha$;
- niveles de agua exterior e interior;
- espesores actuales, variación espacial de la corrosión y modelo de pérdida
  de sección;
- propiedades netas $\bar A_n$, $\bar I_n$, coordenadas de fibras, regla para
  representar su variación angular y criterio de aplicabilidad frente a la
  curvatura;
- propiedades resistentes del acero existente y combinaciones aplicables;
- geometría completa de la unión, estado de agujeros y bordes, solape,
  espesor remanente local y equivalencia de la costura publicada; y
- distribuciones marginales, dependencias, truncamientos, cuantiles de interés
  y criterios de estabilidad de Monte Carlo.

## Estado

La aplicación determinística de 8 m de tapada está materializada y es
reproducible. La comparación AASHTO arroja estados numéricos para pared,
pandeo, flexibilidad, tapada y costura de referencia con las propiedades y
factores adoptados. El estado global permanece
`not-evaluated-specification`: no se ha verificado el articulado ni las erratas
de la edición vigente, las propiedades resistentes del acero requieren
confirmación y la costura publicada no demuestra la capacidad de la unión
abulonada existente. La evaluación probabilística no fue ejecutada; no se han
asignado distribuciones a $K_0$, a las propiedades del relleno, a la pérdida
de espesor de chapa ni a $\delta_d$.
