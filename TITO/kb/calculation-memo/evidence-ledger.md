# Registro de evidencia — memoria de cálculo

## Alcance

Este registro gobierna la memoria de cálculo independiente. El documento
metodológico aprobado de Fase 1 permanece congelado y conserva los desarrollos
académicos completos. La memoria utiliza hallazgos comprobados, fórmulas
operativas y una aplicación numérica, con trazabilidad hacia las fuentes
primarias mediante `bib/references.bib`.

## Fuentes empleadas

- Baker (1968): equilibrio, compatibilidad y valores tabulados para cargas
  radiales por sectores (`Baker1968`).
- Schwartz y Einstein (1980): formulación de interacción suelo--revestimiento y
  caso HP97 para túneles excavados (`SchwartzEinstein1980`).
- AASHTO LRFD Bridge Design Specifications, 10.ª edición (2024): mapa oficial
  de los artículos 12.7, 12.8 y 12.13 y del subartículo 12.8.9; el acceso se limita al índice
  (`AASHTO2024TOC`).
- AASHTO LRFD Bridge Construction Specifications, 4.ª edición: autoridad
  separada para ejecución, con articulado no disponible en el corpus
  (`AASHTOConstruction2017`).
- USACE EM 1110-2-2902 (2020): relación pública de empuje para conductos
  metálicos corrugados y ejemplo D4 (`USACE2020`).
- CIRSOC 804-4 (2023): contraste métrico basado en una edición anterior de
  AASHTO; no gobierna la comprobación (`CIRSOC8044`).
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
- Mai (2013): estados de medición del deterioro, conservación de $EA$ y $EI$,
  recuperación elástica y mecanismos locales no representados por la tensión
  normal homogeneizada (`Mai2013`).
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
T_L=P_F\frac{S}{2}.
$$

El manual define $T_L$ como empuje mayorado por unidad de longitud de pared,
$P_F$ como presión vertical mayorada en la clave debida al suelo y las
sobrecargas, y $S$ como luz. USACE EM 1110-2-2902, ecuación 4-20, reproduce la
misma relación y explicita las contribuciones de carga permanente y móvil. Las
comprobaciones de área de pared, pandeo y costura se realizan en las secciones
resistentes seleccionadas para la evaluación.

Esta relación corresponde al procedimiento que USACE atribuía a AASHTO en
2020; no se presenta como transcripción certificada de la décima edición.
CIRSOC 804-4 contiene una expresión coincidente basada en una edición anterior
y queda como contraste métrico. La clasificación del producto existente, el
articulado AASHTO aplicable, $P_F$ y la luz reglamentaria permanecen
`UNKNOWN`. La implementación materializa por ello la rama AASHTO como
`not-evaluated`, sin sustituir esas entradas por la tensión efectiva en el eje
o por el diámetro interior del escenario analítico.

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
- La tensión normal circunferencial de una sección neta homogeneizada puede
  recuperarse condicionalmente mediante
  $\sigma_\theta=N_\theta/\bar A_n+1000M_\theta\xi/\bar I_n$, con $\xi$
  positiva hacia el interior y unidades consistentes.
- La recuperación se evalúa en ambas fibras sólo cuando la sección neta y el
  criterio de aplicabilidad frente a la curvatura están definidos.
- $Q_\theta$ permanece como resultante hasta adoptar una distribución local de
  flujo cortante compatible con la corrugación.
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
- No se evalúa $T_L$ mientras el producto, $P_F$ y $S$ permanezcan sin
  confirmar.
- No se informan tensiones del revestimiento existente mientras no se conozcan
  la sección neta, las fibras y la aplicabilidad frente a la curvatura.
- No se presenta una utilización normativa, un factor de seguridad, una
  tensión equivalente ni una comprobación de pandeo, costuras, juntas o
  pernos.
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
verticales; empuje circunferencial reglamentario; ramas excluyentes de $K_0$
derivadas de sus variables primitivas; proyección biaxial analítica;
multiplicador de la componente tangencial; acción temporal FHWA;
equilibrio global; sistema diferencial de primer orden; constantes de
compatibilidad; solución cerrada en función de $\alpha$; rigideces
circunferenciales; resultantes y extremos espaciales; y recuperación
condicionada de la tensión normal circunferencial. El Apéndice A resume los
desarrollos necesarios para comprobarlas.

## Hechos requeridos no resueltos

- clasificación del producto estructural y artículos reglamentarios
  aplicables;
- presión vertical mayorada en clave, luz y combinaciones de acciones;
- radio centroidal y estado geométrico medido;
- categoría de espesor y propiedades seccionales confirmadas;
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
- producto, norma, acero, combinaciones y estados límite para la comprobación
  resistente de la chapa;
- recuperación local de la tensión cortante y relación con las demandas de
  juntas y pernos; y
- distribuciones marginales, dependencias, truncamientos, cuantiles de interés
  y criterios de estabilidad de Monte Carlo.

## Estado

La aplicación determinística y sus contrastes son aptos para la memoria como
escenario biaxial analítico de comprobación. La rama reglamentaria está
implementada como relación de empuje seccional, pero permanece sin evaluar por falta de
entradas confirmadas. La relación de recuperación normal está establecida
pero no se evalúa con las propiedades nominales del escenario. La evaluación
probabilística y la comprobación resistente del revestimiento existente
permanecen pendientes de la caracterización indicada. Las formulaciones
operativas de $K_0$ y sus controles están integradas al contrato reproducible
de datos; no asignan distribuciones ni ejecutan Monte Carlo.
