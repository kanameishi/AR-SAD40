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
- USACE EM 1110-2-2902 (2020): fuerza normal de conductos metálicos corrugados
  y ejemplo D4 (`USACE2020`).
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
\frac{1+\frac{2}{3}\sin^2\phi'}{1+\sin\phi'}.
$$

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

- Las tensiones vertical y lateral efectivas se proyectan sobre el contorno
  para obtener una presión normal efectiva y una tracción tangencial
  disponible.
- La acción tangencial se prescribe como $P_t=\alpha p_t^*$, con
  $0\leq\alpha\leq1$. $\alpha$ es un multiplicador de la componente
  tangencial proyectada y no un coeficiente de fricción.
- $\alpha=0$ y $\alpha=1$ son los extremos de sensibilidad del escenario de
  comprobación; la respuesta intermedia se obtiene por superposición lineal.
- Para acciones perimetrales prescritas y autoequilibradas, el equilibrio y la
  compatibilidad determinan $N_\theta(\theta)$, $M_\theta(\theta)$ y
  $Q_\theta(\theta)$.
- En el problema plano, el perfil corrugado interviene mediante
  $EA_\theta$ y $EI_\theta$.
- La circunferencia de referencia y los diagramas radiales no representan una
  deformada. $A_g$ modifica exclusivamente la longitud gráfica de las
  ordenadas.
- La evaluación probabilística del revestimiento existente no fue ejecutada.
  El código estadístico disponible constituye una comprobación de interfaces
  de software con muestras fijas, no una simulación del proyecto.

## Afirmaciones excluidas

- No se informan tensiones de la chapa, capacidad resistente, solicitaciones
  de juntas ni pernos.
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
proyección del estado tensional;
multiplicador de la componente tangencial; comparación uniforme USACE; acción temporal FHWA;
equilibrio global; sistema diferencial de primer orden; constantes de
compatibilidad; solución cerrada en función de $\alpha$; rigideces
circunferenciales; resultantes y extremos espaciales. El Apéndice A resume los
desarrollos necesarios para comprobarlas.

## Hechos requeridos no resueltos

- radio centroidal y estado geométrico medido;
- categoría de espesor y propiedades seccionales confirmadas;
- estratigrafía, clasificación, pesos unitarios, humedad y compactación;
- estado tensional, historia de carga y evidencia para $K_0$;
- aplicabilidad de una rama NC, de descarga o de recarga al relleno existente;
- formulación y magnitud de una eventual tensión horizontal residual de
  compactación;
- rango y representación probabilística o por escenarios de $\alpha$;
- niveles de agua exterior e interior;
- espesores actuales, variación espacial de la corrosión y modelo de pérdida
  de sección;
- recuperación de tensiones normales y cortantes en la chapa y relación con
  las demandas de juntas y pernos; y
- distribuciones marginales, dependencias, truncamientos, cuantiles de interés
  y criterios de estabilidad de Monte Carlo.

## Estado

La aplicación determinística y sus contrastes son aptos para la memoria como
escenario de comprobación. La evaluación probabilística del revestimiento
existente permanece pendiente de la caracterización y de las relaciones
resistentes indicadas. Las formulaciones operativas de $K_0$ y sus controles
están implementados e integrados al contrato reproducible de datos. No
sustituyen el valor adoptado del escenario vigente sin información del
relleno; tampoco asignan distribuciones ni ejecutan Monte Carlo.
