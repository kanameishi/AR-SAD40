# Fuente de verdad — memoria de cálculo ejecutiva, Fase 2

**Estado:** memoria profesional revisada y auditada; pendiente de revisión del usuario
**Fecha de corte:** 2026-08-11
**Aceptación:** usuario
**Producto aprobado de referencia:** documento metodológico de Fase 1, futuro paper

## 1. Autoridad y recuperación

Esta nota es la única fuente de verdad de la Fase 2: la preparación de una
memoria de cálculo ejecutiva derivada del documento metodológico. No
sustituye el router global `/Users/averrik/github/agents/AGENTS.md` ni las
reglas locales `AGENTS.md`.

Después de una compactación o al retomar el trabajo:

1. leer el router global;
2. leer `.codex-task.md`;
3. leer esta nota completa;
4. comprobar el estado real de Git y los archivos nombrados aquí;
5. continuar desde «Próxima acción», sin repetir trabajo aprobado.

`dev/SoT/ACTIVE.md` apunta a `dev/plan/lfs-bootstrap/active.md` y pertenece a
un flujo histórico de LFS. No debe modificarse ni interpretarse como selector
de esta metodología.

## 2. Estado comprobado

### 2.1 Aprobado y terminado

- La Fase 1 fue aprobada por el usuario como base técnica y editorial. Se
  conservará íntegra y podrá desarrollarse posteriormente como paper.
- El candidato pasó las auditorías técnica/matemática, de lenguaje profesional
  y bibliográfica.
- Las referencias usan citas `[@Clave]` y `bib/references.bib`.
- El HTML separado de revisión fue renderizado correctamente.
- Los PDF y textos fuente recuperados se conservan; no deben eliminarse.

### 2.2 Rechazado

- `html/methodology.es/index.html` y los capítulos públicos que lo alimentaron
  no son un producto técnico aceptado. Sólo sirven para rastrear contenido que
  ya haya sido verificado de manera independiente.
- No se corregirá el HTML derivado directamente ni se reutilizará su prosa
  rechazada.

### 2.3 Pendiente

- Revisar con el usuario el HTML candidato independiente.
- Confirmar los datos del revestimiento, el relleno, el agua, las etapas y las
  distribuciones conjuntas antes de ejecutar una simulación de Monte Carlo
  representativa del caso existente.
- Incorporar resultados probabilísticos del caso sólo después de aprobar esas
  entradas; las muestras fijas de prueba disponibles comprueban interfaces de
  software y no constituyen una simulación del proyecto.
- Promover el candidato a las rutas públicas sólo después de la aprobación
  explícita del usuario.

## 3. Línea base congelada de Fase 1

No editar, regenerar, mover ni reemplazar durante la Fase 2:

| Componente | Ruta | SHA-256 o control |
|---|---|---|
| master | `_master/methodology.review.es.qmd` | `ae3db1c42fe7626c8233ac3fb4c77da7743172bdfff3b51ef762c139cf27d1ef` |
| index | `_index/methodology.review.ES.qmd` | `0eee73a9c7e7ed90104a7b3074e3e93bbd57254a568ba302861135a3568b4baa` |
| capítulos | `TITO/kb/review/chapters/` | hashes por archivo en `TITO/kb/review/ledgers/` |
| HTML | `html/methodology.review.es/index.html` | `0d46a5f6e437056adf809ef57ec16975631af6b2bad0206bf5c572f8fce4cb54` |

Hashes de los capítulos congelados:

| Archivo | SHA-256 |
|---|---|
| `methodology.scope.review.es.md` | `22669e15f17bb4d3cf5ad3a7d7cbccdbaf573d1a9a3a9dbfdd91a11dc080be39` |
| `methodology.practice.review.es.md` | `6ed609e125108b71dac6cbc678be74366187c133fb358535ca368545894a08bf` |
| `methodology.pressures.review.es.md` | `1f47c9da4c97b0a99448393752f1071d73518597d213819963c6d88e17658259` |
| `methodology.corrugation.review.es.md` | `e4b15af4ff6bb1f41e46ac2108f6bd628fa54307d01e4b08470c382ecf92c166` |
| `methodology.model.review.es.md` | `9950924d79105c8aaf0b211bede4e9b9c0562240c5b9bcf3d87dfc81749e931e` |
| `methodology.uncertainty.review.es.md` | `893d4e30705994dcca8962b325f29e245f7a5dce65079ecc3f0bbf76b0b99715` |
| `methodology.results.review.es.md` | `237b4b8af42c594a7a07c9bf3f8280a687867dfe05391bf77793e70d81e7c73c` |
| `methodology.verification.review.es.md` | `4a4c960418dc3985bafb66dff6bd76309580008d92decb71578bf4081a882b96` |
| `methodology.limitations.review.es.md` | `414e78b0da3bea24b8009c200c70e00c9b5e126b082b33d610007b56fb1f0fc3` |
| `methodology.appendix.review.es.md` | `da8a46ad2d72114850547e2980f6bd37b3a8c6c1e38c6d0b7df0dafa229f8c9c` |

## 4. Objetivo observable de Fase 2

Producir una memoria de cálculo ejecutiva e independiente que use los hallazgos
comprobados del documento metodológico sin modificarlo. El cuerpo debe exponer
un procedimiento completo y fácil de auditar: datos de entrada, hipótesis, estados
de carga, fórmulas operativas, controles, resultantes, extremos, envolventes y
aplicación numérica. El Apéndice A sintetiza los desarrollos indispensables;
el documento de Fase 1 conserva las demostraciones completas. El Apéndice B
documenta los contrastes numéricos y su nivel de evidencia.

La fase estará terminada cuando:

1. el cuerpo sea autosuficiente para seguir y auditar la secuencia de cálculo
   sin reproducir las demostraciones completas;
2. cada ecuación, tabla y figura tenga una única definición dentro de la
   memoria renderizada;
3. todas las citas y referencias cruzadas resuelvan;
4. los contrastes indiquen con precisión el nivel de evidencia;
5. los diagramas reproduzcan los valores físicos de sus tablas fuente;
6. el plan probabilístico distinga cuantiles puntuales y cuantiles de extremos
   sin presentar resultados antes de aprobar las entradas;
7. exista un HTML de la memoria separado y auditado; y
8. el usuario apruebe la versión antes de su promoción pública.

## 5. Alcance técnico

### 5.1 Productos de esta etapa

- acciones perimetrales normales y tangenciales sobre la sección circular;
- fuerza normal circunferencial `N_theta(theta)`;
- momento flector circunferencial `M_theta(theta)`;
- fuerza cortante circunferencial `Q_theta(theta)`;
- posiciones y valores de extremos;
- plan de caracterización y propagación mediante Monte Carlo, sin resultados de
  proyecto hasta aprobar variables, distribuciones y dependencias.

### 5.2 Exclusiones

- tensiones locales `sigma_*` y `tau_*`;
- verificaciones resistentes de la chapa;
- capacidad de juntas y solicitaciones de pernos;
- variación longitudinal de las cargas;
- teoría general de láminas ortótropas o una jerarquía de clases de software;
- FORM, FOSM o linealización de una función de falla;
- conclusiones específicas del túnel mientras no se caractericen sus datos de
  suelo, construcción, geometría y condición hidráulica.

### 5.3 Rigidez del perfil corrugado

La ortotropía no se introducirá como una corrección posterior de una solución
isótropa. Dentro del problema plano, la respuesta circunferencial se resolverá
con las rigideces seccionales que correspondan al perfil corrugado,
`EA_theta = E A_p` y `EI_theta = E I_p`, o con sus valores medidos/adoptados.
No se requiere una clase ortótropa general. Las rigideces longitudinales y los
acoplamientos de una lámina tridimensional quedan fuera de esta etapa porque
no hay variación longitudinal de cargas.

## 6. Arquitectura de productos y promoción

### 6.1 Producto A — documento metodológico de referencia

La Fase 1 permanece en las rutas congeladas de la sección 3. Es la fuente
técnica extensa y la base del futuro paper. No se usa como área de trabajo de
la memoria y no se modifica para hacerla más breve.

### 6.2 Producto B — memoria de cálculo ejecutiva

La memoria se desarrollará en rutas independientes. El usuario aprobó el
namespace `calculation.*`; el candidato se construirá en:

```text
_master/calculation.review.es.qmd
_index/calculation.review.ES.qmd
TITO/kb/calculation-memo/chapters/
html/calculation.review.es/index.html
_master/calculation.resultants.review.es.qmd
_index/calculation.resultants.review.ES.qmd
html/calculation.resultants.review.es/index.html
```

Los archivos fuente del candidato usarán el namespace `calculation.*`. No se
incluirán capítulos de `TITO/kb/review/chapters/` mediante referencias vivas:
la memoria debe ser estable aunque el futuro paper evolucione.

### 6.3 Destinos públicos después de la aprobación

El patrón propuesto, sujeto a la decisión del namespace, es:

```text
_master/calculation.es.qmd
_index/calculation.ES.qmd
_index/calculation.appendix.ES.qmd
_chapters/calculation.<section>.es.md
_chapters/calculation.<section>.es.qmd
```

Reglas de nombres:

- namespace semántico en inglés y antes de la sección;
- tokens separados por puntos;
- `ES` mayúsculo en `_index`, `_fig`, `_tbl` y `_captions`;
- `es` minúsculo en `_master`, `_chapters` y `_summary`;
- `.md` para prosa reutilizable;
- `.qmd` sólo para ensambladores o fragmentos que ejecutan código/Quarto;
- el primer token identifica el capítulo receptor;
- el idioma cambia el sufijo y el contenido, no traduce el identificador.

## 7. Reglas editoriales para la memoria y sus apéndices

### 7.1 Cuerpo principal

El cuerpo debe:

1. declarar objeto, alcance, datos, hipótesis, coordenadas, signos y unidades;
2. presentar el procedimiento de cálculo como una secuencia de entradas, transformaciones,
   controles y salidas;
3. construir las acciones geotécnicas mediante relaciones operativas finales;
4. resolver las resultantes mediante las ecuaciones finales del algoritmo;
5. definir las rigideces circunferenciales del perfil corrugado;
6. establecer la simulación de Monte Carlo y las envolventes;
7. desarrollar la aplicación numérica y sus controles de consistencia;
8. resumir el grado de contraste en una sola tabla; y
9. cerrar con resultados, información faltante, límites y conclusiones.

No debe contener una revisión bibliográfica extensa, demostraciones completas,
álgebra modal extensa, tablas completas de benchmarks, operaciones de
reproducción bibliográfica ni narrativa de implementación de software. Las
fuentes se citan donde sustentan una decisión o fórmula.

### 7.2 Apéndices

Un hallazgo del documento metodológico se sintetiza en el Apéndice A cuando:

- demuestra una fórmula ya disponible en forma operativa en el cuerpo;
- desarrolla una transformación de coordenadas o signos de otra fuente;
- presenta coeficientes extensos de una formulación comparativa;
- documenta la construcción geométrica auxiliar de una carga;
- documenta estimadores estadísticos y controles de precisión.

Un hallazgo se documenta en el Apéndice B cuando:

- transcribe datos o resultados publicados;
- reproduce un resultado publicado;
- calcula errores o comparaciones derivados en este estudio; o
- constituye un control matemático interno con caso, discretización, métrica y
  tolerancia declarados.

El contenido original permanece intacto en la Fase 1. No se «mueve» ningún
bloque desde el documento metodológico: se redacta una síntesis autónoma y se
registra su correspondencia con las ecuaciones fuente.

Cada apéndice debe comenzar con su objeto y relación con el cuerpo, conservar
las unidades y convenciones de la fuente, y terminar con el alcance de la
evidencia. Un apéndice no debe introducir silenciosamente una nueva rama de la
metodología.

### 7.3 Definición única y referencias cruzadas

- Una etiqueta `eq-*`, `tbl-*` o `fig-*` se define una sola vez dentro de cada
  producto renderizado.
- Las 77 etiquetas de Fase 1 permanecen intactas en el documento metodológico.
- La memoria mantiene una tabla de correspondencia entre sus fórmulas y las
  etiquetas fuente; no necesita reproducir las 77 ecuaciones.
- Toda síntesis matemática conserva símbolos, supuestos, unidades y dominio.
- El cuerpo conserva una frase de enlace y una referencia al apéndice de la
  memoria cuando la justificación resumida sea necesaria.
- La memoria no depende mediante `include` de un capítulo del futuro paper.
- Los apéndices se incorporan al master antes de auditar referencias.
- La auditoría debe detectar etiquetas duplicadas, referencias sin definición
  y definiciones sin consumidor.

### 7.4 Citas y evidencia

- Toda atribución bibliográfica usa `[@Clave]` y una entrada verificable en
  `bib/references.bib`.
- No se remite al lector a «una tabla del PDF» sin identificar tabla, página,
  variable, unidad y función dentro del cálculo.
- Se distingue explícitamente:
  1. dato publicado transcrito;
  2. resultado publicado reproducido;
  3. resultado derivado en este estudio;
  4. control matemático interno.
- «Validación» y «calibración» se reservan para evidencia que efectivamente las
  sustente. En los casos actuales corresponden «reproducción», «contraste»,
  «transcripción» o «control interno».

## 8. Estructura del cuerpo de la memoria

| Orden | Sección | Contenido |
|---:|---|---|
| 1 | Resumen ejecutivo | objeto, alcance, resultados disponibles y límites de esta etapa |
| 2 | Bases y datos de entrada | geometría, relleno, agua, construcción, sección corrugada, coordenadas, signos y unidades |
| 3 | Procedimiento de cálculo | diagrama de flujo, casos, etapas, controles y productos de cada paso |
| 4 | Acciones del relleno | fórmulas finales para tensiones verticales, `K_0`, compactación, agua, proyección perimetral, USACE y FHWA |
| 5 | Resultantes seccionales | ecuaciones operativas de integración/compatibilidad y soluciones cerradas de control |
| 6 | Rigidez circunferencial | `EA_theta`, `EI_theta`, `eta_s` y datos seccionales requeridos |
| 7 | Incertidumbres | variables, dependencias, Monte Carlo, extremos, cuantiles y envolventes de modelos |
| 8 | Aplicación numérica | casos, etapas, acciones, curvas, extremos, cuantiles y controles de consistencia |
| 9 | Resultados y límites | síntesis de contrastes, información faltante, alcance y conclusiones |

La revisión del estado de la práctica permanece en el documento metodológico.
La memoria sólo conserva la base normativa y bibliográfica necesaria para
justificar cada rama del procedimiento de cálculo.

### 8.1 Procedimiento de cálculo que debe gobernar el cuerpo

La memoria se redactará alrededor de la secuencia siguiente y la denominará
«procedimiento de cálculo» o «secuencia de cálculo».

| Paso | Entradas | Operación | Salidas | Control obligatorio |
|---:|---|---|---|---|
| 0 | geometría confirmada, unidades, convención angular y signos | definir casos, etapas y alternativas de modelación | registro de casos y etapas | no mezclar datos confirmados con escenarios nominales |
| 1 | estratigrafía, pesos unitarios, nivel de agua y tapada | calcular profundidad perimetral, tensiones verticales efectivas y presión intersticial | `sigma_v'(theta)`, `u(theta)`, `sigma_v(theta)` | valores de clave, eje y solera; continuidad entre estratos |
| 2 | condición del relleno, historia tensional y compactación | definir `K_0` o presión residual de compactación mediante alternativas excluyentes | `sigma_h'(theta)` y parámetros de cada alternativa | no muestrear dos veces variables dependientes ni sumar parametrizaciones incompatibles |
| 3 | estado tensional vertical/horizontal y agua | proyectar el tensor de tensiones sobre el contorno | acciones normales y tangenciales permanentes | equilibrio global y convención de signos |
| 4 | equipos, tongadas, secuencia constructiva y fuentes USACE/FHWA | construir acciones por etapa y ramas de modelo | `P_r(theta,s)`, `P_t(theta,s)` por etapa/modelo | no sumar ramas alternativas ni presumir que una acción temporaria queda retenida |
| 5 | perfil corrugado, módulo, `A_p` e `I_p` | calcular rigideces circunferenciales | `EA_theta`, `EI_theta`, `eta_s` | unidades y procedencia de propiedades; espesor condicional identificado |
| 6 | acciones perimetrales y rigideces | integrar equilibrio y compatibilidad; aplicar soluciones cerradas cuando correspondan | `N_theta(theta)`, `M_theta(theta)`, `Q_theta(theta)` | equilibrio global, periodicidad y comparación con casos cerrados |
| 7 | curvas por etapa y modelo | localizar mínimos, máximos y máximos absolutos por tramos | valor, signo, ángulo y etapa gobernante por realización | incluir extremos interiores, discontinuidades y límites de tramo |
| 8 | distribuciones y dependencias aprobadas | ejecutar Monte Carlo para cada alternativa de modelación | curvas y extremos por realización | convergencia, conteo de cola y reproducibilidad de la corrida |
| 9 | resultados de todas las realizaciones | calcular cuantiles puntuales, cuantiles de extremos y envolvente exterior de modelos | bandas angulares, intervalos escalares y casos gobernantes | no equiparar cuantiles puntuales con cuantiles de extremos |
| 10 | tablas finales y metadatos | producir figuras, tablas y síntesis ejecutiva | memoria auditable y productos reproducibles | igualdad entre valores representados y tablas fuente |

El cuerpo puede agrupar pasos para mejorar la lectura, pero no omitir sus
entradas, decisiones, controles o productos. Toda alternativa debe conservar
un identificador de modelo hasta la formación de la envolvente final.

## 9. Apéndices de la memoria

La memoria tendrá dos apéndices principales. Pueden mantenerse en capítulos
fuente separados para facilitar la edición, pero el lector debe percibir una
estructura compacta, no la reproducción del futuro paper.

| Apéndice | Nombre previsto | Contenido |
|---|---|---|
| A | `calculation.appendix.derivations.es.*` | síntesis de notación, acciones, equilibrio/compatibilidad, formulación modal, rigidez corrugada y estimadores de Monte Carlo |
| B | `calculation.appendix.benchmarks.es.*` | Baker, USACE D4, FHWA, Schwartz--Einstein, Núñez, controles internos documentados y comparación seccional verificada |

El Apéndice A presenta las etapas esenciales de cada desarrollo y llega a las
fórmulas usadas en el cuerpo; no replica todas las demostraciones de Fase 1.
El Apéndice B conserva tablas, datos, unidades, errores y clasificación de la
evidencia. La extensión será `.md` salvo que el archivo ejecute código o
construya tablas, en cuyo caso será `.qmd`.

Si la extensión ejecutable resulta necesaria, el ensamblador público propuesto
será `_index/calculation.appendix.ES.qmd` y ordenará los apéndices; el master no
debe duplicar ese orden.

## 10. Índice de trazabilidad de ecuaciones

La Fase 1 contiene 77 etiquetas `eq-*` únicas y permanece intacta. Este índice
no ordena un traslado: identifica qué hallazgos alimentan la memoria. De ellos,
44 fórmulas operativas son candidatas para el cuerpo, 27 desarrollos se
sintetizan en el Apéndice A y 6 expresiones específicas alimentan la aplicación
o el Apéndice B.

### 10.1 Fórmulas fuente candidatas para el cuerpo de la memoria (44)

**Alcance y signos**

- `eq-resultant-signs`

**Acciones del relleno**

- `eq-depth-theta`
- `eq-control-depths`
- `eq-effective-vertical`
- `eq-pore-pressure`
- `eq-k0-definition`
- `eq-k0-elastic`
- `eq-k0-jaky`
- `eq-compaction-history`
- `eq-mean-difference`
- `eq-normal-pressure`
- `eq-tangential-traction`
- `eq-usace-thrust`
- `eq-usace-crown`
- `eq-equivalent-uniform`
- `eq-fhwa-compaction`
- `eq-fhwa-band`
- `eq-fhwa-perimeter-load`

**Respuesta estructural**

- `eq-ring-equilibrium-m`
- `eq-ring-equilibrium-r`
- `eq-ring-equilibrium-t`
- `eq-global-equilibrium`
- `eq-first-order-system`
- `eq-general-resultants`
- `eq-section-ratio`
- `eq-compatibility-conditions`
- `eq-compatibility-constants`
- `eq-mean-moment`
- `eq-k0-full-response`
- `eq-k0-normal-response`
- `eq-cover-k0`
- `eq-cover-sensitivity`

**Rigidez circunferencial**

- `eq-sectional-constitutive-law`
- `eq-corrugated-rigidities`
- `eq-corrugated-ratio`

**Monte Carlo y envolventes**

- `eq-monte-carlo-chain`
- `eq-construction-extremes`
- `eq-spatial-stationarity`
- `eq-pointwise-quantile`
- `eq-maximum-quantile`
- `eq-quantile-distinction`
- `eq-model-envelope`
- `eq-monte-carlo-convergence`
- `eq-monte-carlo-tail`

### 10.2 Desarrollos fuente que se sintetizan en el Apéndice A (27)

**Formulaciones de referencia**

- `eq-se-stiffness`
- `eq-se-response`
- `eq-se-coordinate-normal-conversion`
- `eq-nunez-flexibility`
- `eq-nunez-2000-resultants`
- `eq-nunez-2014-resultants`

**Construcción auxiliar de acciones**

- `eq-fhwa-nodal-force`
- `eq-fhwa-prism`

**Desarrollo modal**

- `eq-load-fourier`
- `eq-load-coefficients`
- `eq-modal-resultants`
- `eq-uniform-mode`
- `eq-first-mode-balance`

**Rigidez y equivalencias**

- `eq-sectional-virtual-work`
- `eq-equivalent-smooth-section`

**Estimadores estadísticos**

- `eq-quantile-estimator`
- `eq-monte-carlo-precision`
- `eq-monte-carlo-frequency-precision`

**Desarrollos del apéndice actual**

- `eq-modal-algebra`
- `eq-fhwa-band-angles`
- `eq-fhwa-discontinuities`
- `eq-se-resultant-conversion`
- `eq-se-shear`
- `eq-se-excavation-slip`
- `eq-se-excavation-bonded`
- `eq-se-external-slip`
- `eq-se-external-bonded`

### 10.3 Expresiones fuente para la aplicación o el Apéndice B (6)

**Aplicación numérica**

- `eq-section-interpolation`
- `eq-adopted-section`
- `eq-example-stress`
- `eq-example-load`

**Apéndice de benchmark estructural**

- `eq-baker-normalization`
- `eq-baker-errors`

### 10.4 Cadena mínima que debe quedar visible

1. `eq-depth-theta` → `eq-effective-vertical` + `eq-pore-pressure`.
2. `eq-k0-definition` + alternativa `eq-k0-elastic` /
   `eq-k0-jaky` / `eq-compaction-history`.
3. `eq-mean-difference` → `eq-normal-pressure` +
   `eq-tangential-traction`.
4. `eq-fhwa-compaction` → `eq-fhwa-band` →
   `eq-fhwa-perimeter-load`.
5. `eq-usace-crown` + `eq-usace-thrust` →
   `eq-equivalent-uniform`.
6. `eq-sectional-constitutive-law` + `eq-corrugated-rigidities` →
   `eq-corrugated-ratio` / `eq-section-ratio`.
7. `eq-global-equilibrium` → `eq-first-order-system` →
   `eq-general-resultants` → `eq-compatibility-conditions` →
   `eq-compatibility-constants`.
8. `eq-mean-moment` + `eq-k0-full-response` /
   `eq-k0-normal-response` → `eq-cover-sensitivity`.
9. `eq-monte-carlo-chain` → `eq-construction-extremes` +
   `eq-spatial-stationarity` → `eq-pointwise-quantile` /
   `eq-maximum-quantile` → `eq-model-envelope` →
   `eq-monte-carlo-convergence` + `eq-monte-carlo-tail`.

La memoria puede reducir el número de ecuaciones visibles, pero no puede romper
esta cadena causal. Cada paso omitido del cuerpo debe quedar encapsulado en una
fórmula final definida o explicado en el Apéndice A.

## 11. Síntesis y documentación de los contrastes en la memoria

El cuerpo de la memoria conservará solamente:

- un párrafo que explique el objeto de los contrastes;
- una tabla nueva `tbl-calculation-verification-summary`, elaborada para la
  memoria a partir de evidencia comprobada; y
- referencias a los apéndices correspondientes.

Los contrastes detallados se organizan así:

| Caso | Destino | Clasificación y regla |
|---|---|---|
| Baker [@Baker1968] | Apéndice B, contraste estructural | valores tabulados publicados; valores recalculados y errores derivados en este estudio |
| USACE D4 [@USACE2020] | Apéndice B, contraste de cargas | `3600`, `10530` y `11583` publicados; `5400` es derivado y no debe presentarse como publicado |
| FHWA-RD-98-191 [@McGrathEtAl1999] | Apéndice B, contraste de cargas | ocho de nueve filas reproducidas; la novena discrepancia se conserva y se excluye de cualquier ajuste |
| Schwartz--Einstein HP97 [@SchwartzEinstein1980] | Apéndice B, contraste de interacción | reproducción de fuerza normal y momento; no hay valor publicado de fuerza cortante |
| Núñez (2000) [@Nunez2000] | Apéndice B, contraste de interacción | reproducción de ejemplos circulares; diferencia relativa máxima actual `1.31 %` frente a valores redondeados |
| Núñez 2000 frente a 2014 | Apéndice B, contraste de interacción | comparación derivada en este estudio; no es benchmark publicado |
| Núñez, Sfriso y Laiún (2014) [@NunezSfrisoLaiun2014] | Apéndice B, contraste de interacción | transcripción del caso 3; datos insuficientes para una reproducción independiente completa |
| Mai [@Mai2013] | Apéndice B, subsección seccional opcional | verificar en la fuente qué valores son publicados antes de incorporar el bloque |
| integración directa frente a Fourier | control interno opcional | publicar sólo con caso, discretización, modos, norma, tolerancia y resultados documentados |

CANDE se describe como método/programa de análisis acoplado y referencia del
estado de la práctica. No se presentará como benchmark cuantitativo mientras
no exista un caso común reproducido.

## 12. Aplicación numérica

La aplicación numérica es un capítulo del cuerpo, no un apéndice. Debe reunir:

1. geometría y convenciones del caso;
2. propiedades del relleno y condición hidráulica adoptadas;
3. parámetros `K_0` y alternativas de compactación;
4. propiedades `A_p`, `I_p`, `EA_theta`, `EI_theta` y `eta_s`;
5. definición y orden de etapas constructivas;
6. acciones normales y tangenciales por etapa;
7. curvas `N_theta(theta)`, `M_theta(theta)` y `Q_theta(theta)`;
8. extremos, posiciones y etapa gobernante;
9. cuantiles puntuales y cuantiles de extremos; y
10. límites de interpretación.

La aplicación incorpora una formulación autónoma basada en los hallazgos
identificados en Fase 1 como `tbl-ncspa-section`, `eq-section-interpolation` y
`eq-adopted-section`, y registra esa correspondencia. Los objetos congelados no
se mueven ni se alteran. El espesor de `3.0 mm` continúa siendo un escenario
condicional hasta confirmar su categoría; no se generaliza como dato del túnel.

## 13. Plan de figuras y builders

### 13.1 Decisión de renderer

- El usuario seleccionó Highcharter como renderer de la memoria. El HTML
  comparativo `calculation.resultants.review.es` se conserva como registro de
  la selección y presenta las dos alternativas desde la misma geometría y las
  mismas escalas físicas.
- Highcharter es la alternativa de producción: superpone las dos formulaciones
  y permite activar conjuntamente sus curvas y ordenadas en los tres paneles
  mediante la leyenda.
- `ggplot2` queda como antecedente estático de comparación, con las dos
  formulaciones en filas y ordenadas radiales independientes; no se duplica en
  el cuerpo de la memoria.
- `NGR::buildPlot()`: curvas ordinarias contra `theta`, historias por etapa y
  resúmenes cartesianos de cuantiles de extremos.
- `NGR::buildSectionResultantsPlot()`: representación Highcharter de curvas y
  ordenadas ya preparadas para `N_theta`, `M_theta` y `Q_theta` sobre la sección
  circular. La función no resuelve cargas, resultantes, signos, escalas,
  desfases ni cuantiles.
- La duplicación sólo se admite en el artefacto de selección. Cambiar el
  renderer no modifica las resultantes ni la preparación física de los datos.

Runtime comprobado: R `4.6.0`, `ggplot2` `4.0.3`, `ragg` `1.5.2`,
`highcharter` `0.9.5`, Highcharts JS `9.3.1` y el candidato NGR `0.3.10`
instalado en una biblioteca temporal. La instalación general NGR `0.3.9` no
contiene la nueva interfaz y no se modificó. No se incorpora `ggpattern`: las
ordenadas estructurales se resuelven con `geom_segment()`.

### 13.2 Separación de responsabilidades

```text
scripts/R/ringFigureData.R       preparación geométrica pura
scripts/fig/ringStatic.R         renderer estático de resultantes determinísticas
scripts/fig/ringParametric.R     prototipo interactivo, oráculo de paridad y otros consumidores
scripts/fig/Calculation.resultants.R    adaptador de casos determinísticos
scripts/fig/Calculation.envelopes.R     adaptador de cuantiles puntuales
scripts/fig/Calculation.extrema.quantiles.R  adaptador de extremos espaciales
scripts/fig/Calculation.compaction.stages.R  adaptador de etapas constructivas
```

La capa de representación promovida vive en
`NGR::buildSectionResultantsPlot()`. `Calculation.resultants.R` prepara la
geometría y las ordenadas del caso y llama a esa función. El prototipo de
`ringParametric.R` se conserva como referencia ejecutable de comportamiento y
no se elimina porque todavía alimenta otros productos interactivos.

La preparación geométrica:

- valida ángulos, unidades, IDs y convenciones;
- conserva la grilla abierta del solver y añade el cierre sólo para dibujar;
- aplica una escala radial declarada;
- prepara la circunferencia, las curvas cerradas y ordenadas radiales
  independientes a intervalos angulares declarados;
- conserva el signo y los valores físicos sin recalcular las resultantes;
- no conoce el renderer documental.

El renderer estático:

- recibe únicamente tablas geométricas preparadas;
- usa una trayectoria para la sección, segmentos independientes para las
  ordenadas y una trayectoria cerrada para cada resultante;
- mantiene escala cartesiana 1:1;
- no lee resultados, no ejecuta el solver, no calcula cuantiles, no cambia
  signos y no elige casos.

El renderer interactivo recibe la misma geometría. Las dos formulaciones se
distinguen mediante línea continua y discontinua; el azul y el naranja
conservan el signo de las ordenadas. Sus rayos se desfasan $5^\circ$ para que
una serie no oculte a la otra. `linkedTo` vincula cada familia de curvas y rayos
con una única entrada de leyenda por formulación.

Los identificadores internos de cada formulación se derivan de su posición en
la entrada, no de una normalización potencialmente ambigua de su nombre. Las
series de ordenadas declaran `requireSorting = FALSE` porque cada segmento es
independiente y la coordenada cartesiana `x` no es monótona con el ángulo.

El contrato de tamaño sigue el patrón de `NGR::buildPlot()`: ancho responsivo y
altura explícita mediante `hc_size()`. En cada renderizado, el gráfico calcula
en píxeles el mayor cuadrado común que cabe en el área disponible y actualiza
los tres pares de ejes. Así conserva escala cartesiana 1:1 sin fijar un ancho
interno mayor que el contenedor Quarto.

No se necesita una jerarquía S3 ni una clase ortótropa para este trabajo.

### 13.3 Identidad editorial de las figuras

```text
_fig/Calculation.resultants.qmd
_fig/Calculation.resultants.ES.qmd
_captions/fig.Calculation.resultants.md
_captions/fig.Calculation.resultants.ES.md
scripts/fig/Calculation.resultants.R

_fig/Calculation.envelopes.qmd
_fig/Calculation.envelopes.ES.qmd
_captions/fig.Calculation.envelopes.md
_captions/fig.Calculation.envelopes.ES.md
scripts/fig/Calculation.envelopes.R

_fig/Calculation.extrema.quantiles.qmd
_fig/Calculation.extrema.quantiles.ES.qmd
_captions/fig.Calculation.extrema.quantiles.md
_captions/fig.Calculation.extrema.quantiles.ES.md
scripts/fig/Calculation.extrema.quantiles.R

_fig/Calculation.compaction.stages.qmd
_fig/Calculation.compaction.stages.ES.qmd
_captions/fig.Calculation.compaction.stages.md
_captions/fig.Calculation.compaction.stages.ES.md
scripts/fig/Calculation.compaction.stages.R
```

El patrón base + wrapper español + captions separados se conserva. `_fig`
contiene fragmentos Quarto; no es el directorio canónico de CSV ni de imágenes
producidas.

### 13.4 Productos de datos

Los resultados reproducibles de la memoria viven en
`TITO/kb/calculation-memo/results/`; los benchmarks permanecen separados en
`TITO/kb/benchmarks/`.

| Producto | Contenido mínimo |
|---|---|
| `ring-cases.csv` | IDs, modelo, interfaz, nivel de evidencia, convenciones y estado |
| `ring-stages.csv` | ID y orden de etapa, tipo, retención y fuente |
| `ring-curves.csv` | caso, etapa, resultante, índice angular, ángulo, valor, unidad y convenciones |
| `ring-pointwise-quantiles.csv` | probabilidad, ángulo, valor, unidad, tamaño de muestra y `statisticScope=pointwise` |
| `ring-extrema-samples.csv` | realización, resultante, estadístico, valor, valor firmado y ángulo |
| `ring-extrema-quantiles.csv` | resultante, estadístico, probabilidad, valor, unidad, `valueBasis` y `statisticScope=spatialExtremum`; sin ángulo |
| `ring-display-scales.csv` | escala física y amplitud gráfica fija por resultante y conjunto comparado |

El orden paramétrico se rige por `thetaIndex`; nunca por la coordenada `x`.
No se agrega `2 pi` a los CSV canónicos.

### 13.5 Cuantiles: regla no negociable

Para cada resultante `S_i(theta)`:

```text
q_p^pt(theta) = Quantile_p{S_i(theta)}
```

es una función angular y puede formar una banda sobre la sección.

En cambio:

```text
E_i^min = min_theta S_i(theta)
E_i^max = max_theta S_i(theta)
E_i^abs = max_theta |S_i(theta)|
```

produce un escalar por realización. Sus cuantiles no tienen un ángulo único y
se muestran en `Calculation.extrema.quantiles`, no sobre la sección. En general,
`Quantile_p(E_i^max)` no es igual a
`max_theta Quantile_p(S_i(theta))`.

La distribución angular de la posición gobernante, si se necesita, se
construirá desde `ring-extrema-samples.csv` mediante sectores circulares. No se
calculará un cuantil ordinario de ángulos porque el dominio es periódico.

### 13.6 Convenciones gráficas

- `theta = 0` en clave y positivo en sentido horario.
- Ordenada gráfica positiva hacia afuera.
- `N_theta > 0` corresponde a tracción.
- La ordenada radial es una escala de representación, no una deformada.
- Cada panel declara la resultante y sus unidades; la caption y las tablas
  fuente conservan la definición física de las ordenadas.
- Cada resultante posee una escala gráfica fija para todos los casos o etapas
  comparados; no se reescala cada curva de manera independiente.
- Los colores no sustituyen la declaración explícita del signo.
- En la alternativa interactiva, el estilo de línea identifica la formulación
  y el color de las ordenadas identifica el signo.

### 13.7 Pruebas de aceptación de figuras

1. clave, hastiales y solera en las posiciones correctas;
2. cierre periódico desde una grilla sin el punto duplicado `2 pi`;
3. campo nulo y campos constantes sin inestabilidad;
4. cada ordenada comienza exactamente sobre la circunferencia de referencia;
5. la longitud de cada ordenada coincide con el valor y la escala gráfica;
6. cada ordenada es un segmento independiente, sin diagonales entre ángulos;
7. caso `A cos(2 theta)` con cambios de signo y extremos conocidos;
8. escala cartesiana 1:1 y cierre de cada curva por caso y resultante;
9. valores, signos, unidades y ángulos idénticos a la tabla fuente;
10. bandas interactivas, cuando existan, con cuantiles ordenados en cada
    ángulo;
11. archivo de cuantiles de extremos sin columna angular;
12. PNG local determinístico y legible al tamaño de publicación;
13. dos entradas de leyenda interactivas, cada una vinculada a sus curvas y
    ordenadas en los tres paneles;
14. etiquetas no recortadas; y
15. CSV o tabla accesible con los valores representados;
16. paridad exacta de opciones Highcharts, tamaño y dependencias entre el
    prototipo y la función instalada de NGR; y
17. contención completa y paneles cuadrados en vistas de 1440 y 900 píxeles de
    ancho mediante una prueba del DOM renderizado.

## 14. Secuencia de implementación

### F2.0 — Fuente de verdad y congelamiento

- crear `AGENTS.md` y esta SoT;
- registrar hashes de Fase 1;
- aprobar arquitectura, apéndices, IDs y reglas de figuras.

**Salida:** este plan, sin reestructurar todavía la documentación técnica.

### F2.1 — Esqueleto independiente y procedimiento de cálculo

- aprobar el namespace de la memoria y crear sus rutas candidatas;
- redactar desde cero el resumen ejecutivo, las bases y el procedimiento de
  cálculo;
- definir entradas, estados, controles y salidas de cada paso;
- crear la matriz de trazabilidad entre fórmulas de la memoria y etiquetas de
  Fase 1;
- no copiar capítulos mediante `include` ni modificar la línea base;
- comprobar definiciones y referencias cruzadas dentro del nuevo producto.

### F2.2 — Fórmulas operativas y aplicación

- seleccionar de las 44 fórmulas fuente únicamente las necesarias para el
  procedimiento de cálculo de la memoria;
- redactar las transiciones entre carga, respuesta, extremos y envolventes;
- integrar las cuatro expresiones de aplicación en el capítulo numérico;
- mantener una sola tabla de síntesis de contrastes;
- comprobar que la cadena mínima del cálculo siga ejecutable y auditable.

### F2.3 — Apéndices de desarrollos y contrastes

- sintetizar en el Apéndice A las derivaciones indispensables sin reproducir
  el desarrollo completo del futuro paper;
- documentar en el Apéndice B Baker, USACE, FHWA, Schwartz--Einstein y Núñez;
- identificar dato publicado, reproducción, derivación o control interno;
- preservar unidades y convenciones originales;
- no promover Mai hasta verificar la procedencia de cada valor;
- documentar el control directa/Fourier sólo si se completa su evidencia.

### F2.4 — Figura determinística

- fijar schemas, convenciones y escalas;
- implementar la preparación geométrica pura;
- implementar y comparar las alternativas Highcharter y `ggplot2`;
- crear `Calculation.resultants` como artefacto propio de la memoria, usando
  `Ring.resultants` sólo como prototipo y control de valores, sin modificarlo;
- verificar HTML y, si se requieren, SVG/PNG.

### F2.5 — Monte Carlo y etapas

- implementar `Calculation.envelopes` desde cuantiles puntuales;
- implementar `Calculation.extrema.quantiles` sin coordenada angular;
- representar por separado la frecuencia sectorial de posiciones gobernantes,
  si se solicita;
- implementar la comparación de etapas con escalas bloqueadas.

### F2.6 — Integración y auditoría

- ensamblar el candidato de la memoria;
- renderizar con `qrt` a `html/calculation.review.es/`;
- auditar lenguaje profesional, ecuaciones, bibliografía, referencias,
  figuras, accesibilidad y reproducibilidad;
- comprobar nuevamente los hashes de Fase 1.

**Estado al 2026-08-11:** F2.1--F2.6 terminadas dentro de la evidencia
disponible. Los artefactos de cuantiles puntuales, extremos espaciales y etapas
están implementados y comprobados con casos matemáticos. El candidato no
publica cuantiles de proyecto porque las distribuciones, dependencias, etapas y
probabilidades oficiales siguen sin definir; no se fabricaron resultados para
completar esa ausencia.

### F2.7 — Aprobación y promoción

- entregar el HTML separado al usuario;
- aplicar observaciones en la rama candidata;
- promover a las rutas públicas sólo después de aprobación explícita;
- no editar manualmente artefactos HTML derivados.

## 15. Decisiones abiertas y hechos `UNKNOWN`

No deben inferirse dentro del código ni de la prosa:

1. escalas gráficas definitivas para `N_theta`, `M_theta` y `Q_theta`;
2. casos determinísticos que se considerarán control, candidato o resultado
   aprobado;
3. lista de etapas constructivas y si una acción de compactación queda retenida
   en el estado final;
4. probabilidades y tipo de cuantil oficiales;
5. tamaño final de impresión y formatos estáticos obligatorios;
6. licencia de Highcharts aplicable al producto final;
7. categoría del espesor usada en la interpolación del perfil corrugado;
8. procedencia exacta de los valores atribuidos a Mai;
9. metadatos contradictorios y ecuación de agua ilegible en el material de
   Núñez, hasta resolverlos en una fuente legible;
10. si `scripts/fig/*.D`, escrito por el usuario, designa un formato adicional.
    La convención observada y auditada del repositorio es `scripts/fig/*.R`;
    no se creará `.D` sin confirmación;

## 16. Puertas de aceptación

- hashes de Fase 1 sin cambios;
- ningún archivo fuente eliminado;
- ninguna definición duplicada de ecuación, tabla o figura dentro de la
  memoria renderizada;
- ninguna cita o referencia cruzada sin resolver;
- cuerpo organizado como procedimiento de cálculo, con fórmulas operativas y
  aplicación;
- Apéndice A autónomo, con los desarrollos necesarios hasta las ecuaciones
  finales de la memoria; contrastes bibliográficos y CANDE excluidos del
  ensamblado ejecutivo y conservados en la línea académica;
- resultados numéricos reproducibles desde datos declarados;
- diagramas consistentes con las tablas fuente;
- cuantiles puntuales y de extremos tratados como objetos distintos;
- lenguaje profesional para audiencia experta;
- ningún cálculo de tensiones, capacidad o pernos en esta fase;
- ninguna dependencia de FORM/FOSM;
- ninguna promoción pública sin aprobación del usuario.

## 17. Próxima acción

Entregar para revisión la memoria determinística parametrizada en
`html/calculation.review.es/index.html`. No promover el candidato ni iniciar
la simulación de Monte Carlo antes de la aceptación del usuario y de una
definición explícita de variables, marginales y dependencias. La caracterización
de la presión residual de compactación y la rama `measured` de $K_0$
permanecen pendientes de evidencia y esquema propios.

## 18. Registro de decisiones

- **2026-08-10:** la Fase 1 queda aprobada, congelada como referencia y
  preservada íntegramente como base de un futuro paper.
- **2026-08-10:** la Fase 2 no reestructura la Fase 1; produce una memoria de
  cálculo ejecutiva e independiente.
- **2026-08-10:** el cuerpo de la memoria expone el procedimiento de cálculo,
  las fórmulas operativas y la aplicación numérica. El Apéndice A sintetiza los
  desarrollos y el Apéndice B documenta los benchmarks.
- **2026-08-10:** Monte Carlo es el único marco de propagación probabilística;
  FORM y FOSM quedan excluidos.
- **2026-08-10:** la etapa termina en `N_theta`, `M_theta` y `Q_theta`; las
  tensiones y verificaciones resistentes quedan para una fase posterior.
- **2026-08-10:** la rigidez circunferencial del perfil corrugado se incorpora
  mediante `EA_theta` y `EI_theta`; no se desarrolla una clase ortótropa
  general.
- **2026-08-10:** Highcharter es el renderer principal de diagramas
  paramétricos; NGR se reserva para gráficos cartesianos y ggplot2 queda como
  contingencia estática.
- **2026-08-10:** las bandas angulares muestran cuantiles puntuales; los
  cuantiles de extremos espaciales se representan por separado y sin ángulo.
- **2026-08-10:** esta nota es la única SoT de Fase 2; no se duplica el plan en
  `TITO/` y no se modifica `dev/SoT/ACTIVE.md`.
- **2026-08-11:** el usuario aprobó el namespace `calculation.*` y autorizó
  ejecutar F2.1--F2.6 hasta obtener un HTML candidato auditado; la promoción
  pública queda sujeta a una aprobación posterior.
- **2026-08-11:** la normalización del contraste de Baker se fijó como
  $P=2\alpha pRb$, $\overline N=bN_\theta/P$ y
  $\overline M=bM_\theta/(RP)$; los ocho valores tabulados y sus errores fueron
  reauditorados.
- **2026-08-11:** los diagramas Highcharter ajustan los dominios en cada
  renderizado para conservar la misma escala física por píxel en ambos ejes,
  incluso en contenedores rectangulares.
- **2026-08-11:** F2.1--F2.6 quedan terminadas. La simulación de Monte Carlo del
  caso existente permanece condicionada a entradas aprobadas y no se sustituye
  por resultados ficticios.
- **2026-08-11:** el usuario rechazó el primer diagrama Highcharter por carecer
  de ordenadas radiales y pidió comparar una nueva versión interactiva con la
  versión estática `ggplot2`. La selección final queda pendiente. La alternativa
  interactiva agrupa las dos formulaciones mediante `linkedTo`, conserva el
  signo por color y desfasa sus ordenadas $5^\circ$.
- **2026-08-11:** el usuario seleccionó Highcharter. La memoria incorpora la
  alternativa interactiva; `ggplot2` se conserva únicamente en el documento de
  comparación.
- **2026-08-11:** la capa de representación se promovió como
  `NGR::buildSectionResultantsPlot()`. AR-SAD40 conserva la preparación física
  y geométrica; NGR recibe curvas y ordenadas terminadas y sólo las representa.
- **2026-08-11:** el tamaño responsivo adopta el contrato de
  `NGR::buildPlot()` mediante `hc_size()` y añade el cálculo dinámico de tres
  paneles cuadrados para evitar el recorte que producía un ancho interno fijo.
- **2026-08-11:** la nueva interfaz se identifica como NGR `0.3.10`. Los
  renders y pruebas usan una instalación temporal exacta; la instalación
  general `0.3.9` permanece inalterada.

## 19. Registro de cierre del candidato

El producto entregable de revisión está constituido por:

```text
_master/calculation.review.es.qmd
_index/calculation.review.ES.qmd
_index/calculation.appendix.review.ES.qmd
TITO/kb/calculation-memo/chapters/
TITO/kb/calculation-memo/results/
html/calculation.review.es/index.html
```

Controles de cierre del 2026-08-11:

- `Rscript scripts/R/runCalculationMemo.R`: PASS;
- `Rscript scripts/R/testCalculationFigures.R`: PASS; comprueba ordenadas
  independientes, longitudes, cierre, relación 1:1, desfase angular y los dos
  grupos interactivos de formulaciones;
- `Rscript scripts/R/testCalculationMonteCarloOutput.R`: PASS;
- render con `qrt`: PASS, sin referencias ni citas sin resolver;
- auditoría técnica: PASS en
  `/private/tmp/calculation-engineering-audit-v2.md`;
- auditoría editorial: PASS en
  `/private/tmp/calculation-editorial-audit-v2.md`;
- auditoría de artefactos: PASS en
  `/private/tmp/calculation-artifact-audit-v3.md`;
- concordancia exacta entre las seis series representadas y
  `ring-curves.csv`, con diferencia máxima nula en valores y ángulos;
- la memoria contiene un único widget Highcharter construido por
  `NGR::buildSectionResultantsPlot()`; el HTML comparativo contiene un widget
  Highcharter y la figura estática `ggplot2`;
- el widget comparativo serializa dos series maestras de leyenda y 14 series
  vinculadas mediante `linkedTo`;
- la configuración Highcharts, el ancho, la altura y las dependencias de la
  función instalada de NGR son idénticos a los del prototipo;
- `Rscript scripts/R/testCalculationResultantsDom.R`: PASS a 1440 y 900 px;
  los tres paneles son cuadrados y permanecen contenidos, incluida la solera;
- pruebas completas de NGR: 157 PASS; `R CMD build`: PASS;
  `R CMD check --no-manual`: sin errores ni advertencias y con una única nota
  preexistente por la inclusión del directorio `.github`;
- auditoría focalizada de Highcharter: PASS en
  `/private/tmp/highcharter-toggle-final-audit.md`;
- auditoría final de los dos productos renderizados: PASS en
  `/private/tmp/renderer-comparison-final-audit.md`;
- reauditoría final de NGR: PASS en
  `/private/tmp/ngr-section-final-audit-v4.md`;
- reauditoría final de la integración: PASS en
  `/private/tmp/ar-resultants-final-audit-v4.md`;
- auditoría final de continuidad: PASS en
  `/private/tmp/phase2-final-continuity-audit-v4.md`; y
- hashes de la Fase 1 sin cambios respecto de la sección 3.

SHA-256 del HTML candidato:
`d4dd21dc2a0a64758138ba825271489545d88e828ca12b355376a0a499d3c73e`.

SHA-256 del HTML de comparación gráfica:
`40d5c4be71c177ec953c499c74237e92e06fa2f8c4f69592edfa83a96d432049`.

## 20. Capacidad reutilizable

El procedimiento general aprendido en esta fase se empaquetó como el skill
agnóstico `build-technical-methodology` en:

```text
/Users/averrik/github/agents/skills/build-technical-methodology/
```

El skill no sustituye los contratos `RESEARCH.md`, `TECHNICAL-WRITING.md` ni
`EXECUTIVE-SUMMARY.md`: los coordina y agrega la arquitectura de metodología,
memoria independiente, apéndices, registro de ecuaciones, prototipo numérico,
controles y tres auditorías. No contiene referencias a este proyecto ni al
problema de túneles.

Controles ejecutados:

- validador nativo de skills: PASS;
- ensayo con evidencia incompleta: detuvo las ecuaciones dependientes y
  conservó los datos sin unidades como `UNKNOWN`;
- ensayo con una metodología aprobada de viga: produjo una memoria y dos
  apéndices independientes, preservó la línea base y expuso una discrepancia
  numérica sin ajustarla;
- la primera prueba detectó que no se distinguía la autorrevisión de una
  auditoría independiente; el skill ahora deja esas puertas `PENDING` cuando
  no hay revisores independientes y prohíbe usarlas para aceptar o promover;
  y
- auditoría temática: PASS; la capacidad es agnóstica, preserva `UNKNOWN` y la
  frontera de aprobación, según
  `/private/tmp/agnostic-skill-final-audit.md`.

## 21. Revisión profesional de interfaz y análisis probabilístico

Esta sección sustituye, para las materias que trata, las declaraciones previas
de cierre del candidato.

### 21.1 Versión preservada

Antes de la revisión se preservaron:

```text
TITO/kb/calculation-memo-history/2026-08-11-pre-interface/
html/calculation.review.pre-interface.es/
```

El SHA-256 del HTML preservado es
`d4dd21dc2a0a64758138ba825271489545d88e828ca12b355376a0a499d3c73e`.
Esta copia no alimenta el ensamblado vigente.

### 21.2 Diagramas de resultantes

- La circunferencia gris es la geometría de referencia y el origen de las
  ordenadas radiales.
- Las curvas continua y discontinua representan diagramas de
  `N_theta(theta)`, `M_theta(theta)` y `Q_theta(theta)` para dos valores de
  `alpha_delta`; no representan una deformada.
- La línea continua corresponde a `alpha_delta = 1`; la línea discontinua
  corresponde a `alpha_delta = 0`. La circunferencia de referencia utiliza un
  gris discontinuo distinto y no pertenece a ninguna formulación.
- `graphicAmplification` pertenece a la preparación geométrica de AR-SAD40.
  Multiplica sólo la longitud gráfica de las ordenadas; no modifica valores,
  extremos, tablas ni lecturas interactivas.
- La memoria adopta `A_g = 2`. NGR continúa limitado a la representación de
  geometría ya preparada y no interpreta el factor.

### 21.3 Ley de fricción de interfaz

La proyección del estado efectivo define

```text
p_n' = sigma_v' cos(theta)^2 + sigma_h' sin(theta)^2
p_t* = (sigma_v' - sigma_h') sin(theta) cos(theta)
```

La transferencia se limita mediante

```text
alpha_delta = tan(delta)
tau_lim = c_a + alpha_delta max(p_n', 0)
P_r = -(p_n' + Delta_u)
P_t = sign(p_t*) min(abs(p_t*), tau_lim)
```

La forma de Coulomb está sustentada por FHWA-RD-03-048, sec. 3.2.3, ec. 3.3,
y CANDE-2025, secs. 4.3.3--4.4. La presión intersticial no integra la capacidad
friccional efectiva. En esta aplicación se adopta `c_a = 0` por falta de datos.

`alpha_delta` no es un multiplicador arbitrario de `p_t*`. Es el coeficiente
de fricción que determina la capacidad de transferencia. Para el estado
`sigma_v' = 100 kPa`, `sigma_h' = 50 kPa`, el umbral que permite transferir
toda la tracción proyectada es `alpha_delta_req = 0.353553`. Los extremos 0 y 1
se conservan como límites de sensibilidad; los valores intermedios se resuelven
con la misma ley.

El desarrollo académico nuevo se preserva fuera de la Fase 1 congelada en:

```text
TITO/kb/paper-candidate/chapters/methodology.interface.friction.es.md
```

### 21.4 Alcance de los contrastes

- Núñez, Sfriso y Laiún (2014) se retiró de la memoria porque la información
  transcrita no permite una reproducción independiente completa. El PDF y su
  tratamiento académico se conservan.
- Los contrastes numéricos se presentan exclusivamente en el Apéndice B.
- El cuerpo informa sólo el resultado de la comprobación directa contra las
  soluciones cerradas de `alpha_delta = 0` y `1`.
- Fourier, los estimadores estadísticos y la trazabilidad editorial se retiraron
  del Apéndice A de la memoria; permanecen en la Fase 1 aprobada.

### 21.5 Estado real de Monte Carlo

No existe una simulación de Monte Carlo del proyecto. No se han aprobado
variables aleatorias, marginales, dependencias, truncamientos, semilla, tamaño
de muestra, cuantiles objetivo ni criterio de estabilidad. Las pruebas actuales
usan tres o cuatro filas fijadas de antemano y no pueden presentarse como
resultados probabilísticos.

Datos determinísticos a incorporar desde registros definitivos:

- tapada;
- geometría del revestimiento y perfil de la chapa;
- acero; y
- espesor original.

Magnitudes por caracterizar:

- clasificación, estratigrafía, pesos unitarios, humedad y densidad del
  relleno;
- estado lateral, historia de tensiones, rama de `K0` e incremento residual de
  compactación;
- equipo, energía, secuencia y retención de la compactación;
- `delta` o `alpha_delta = tan(delta)`, y eventual `c_a`;
- niveles de agua exterior e interior;
- espesor actual, pérdida por corrosión y su variación espacial; y
- dependencias entre las variables anteriores.

Las tensiones de la chapa y las demandas de pernos son salidas futuras, no
variables aleatorias de entrada. Antes de obtenerlas deben adoptarse la
recuperación de tensiones desde `N_theta` y `M_theta`, el tratamiento local de
`Q_theta`, la sección neta corrugada y la transferencia a juntas y pernos.

### 21.6 Plan de ejecución probabilística

1. **Inventario de datos.** Registrar fuente, unidad, fecha, cobertura espacial
   y calidad de cada medición o antecedente.
2. **Ramas geotécnicas.** Definir por tipo de relleno las relaciones admisibles
   para tensión vertical, `K0`, compactación, agua e interfaz, sin duplicar
   variables dependientes.
3. **Modelo de corrosión.** Relacionar las mediciones de espesor con
   `t_net`, `A_p`, `I_p`, `EA_theta` y `EI_theta`; decidir si la variación
   espacial exige sectores o un campo aleatorio.
4. **Recuperación resistente.** Adoptar las relaciones para tensiones normales,
   cortantes y demandas de uniones. El efecto local de `Q_theta` permanece
   `UNKNOWN` hasta completar esta etapa.
5. **Marginales y alternativas.** Seleccionar cada distribución desde datos,
   ensayos o una fuente aplicable; mantener como escenarios separados las
   alternativas sin probabilidades sustentadas.
6. **Dependencias.** Construir la estructura conjunta entre clasificación,
   densidad, humedad, fricción, compactación, `K0`, interfaz y corrosión. No
   muestrear simultáneamente una variable y otra calculada de ella.
7. **Protocolo de corrida.** Fijar generador, semilla, número inicial y máximo
   de realizaciones, cuantiles objetivo y tolerancias de estabilidad antes de
   ejecutar.
8. **Cálculo por realización.** Conservar las entradas y obtener acciones,
   `N_theta(theta)`, `M_theta(theta)`, `Q_theta(theta)`, extremos y, después de
   la etapa 4, tensiones y demandas de uniones.
9. **Comprobación y reporte.** Verificar equilibrio y compatibilidad en cada
   realización, documentar realizaciones rechazadas y presentar separadamente
   distribuciones puntuales, distribuciones de extremos espaciales y
   envolventes entre escenarios.

FORM y FOSM permanecen excluidos. La próxima decisión técnica corresponde a
las etapas 1--4; no se asignarán distribuciones antes de resolverlas.

### 21.7 Próxima acción

Revisar con el usuario el HTML de la memoria y acordar las etapas 1--4 del plan
probabilístico antes de asignar distribuciones. La promoción a rutas públicas
continúa sujeta a la aprobación explícita del usuario.

### 21.8 Artefacto de revisión

El HTML revisado se renderizó desde las fuentes vigentes en:

```text
html/calculation.review.es/index.html
```

Su SHA-256 es
`9a2f448da9676c06a99e57231c7210b61d7bf4afc3fce018d54d2039dbf82d04`.
Las pruebas determinísticas, de convergencia, de paridad gráfica y del DOM
renderizado concluyeron correctamente. Los trece hashes de la Fase 1 continúan
idénticos a la línea base de la sección 3.

Auditorías independientes del mismo artefacto:

- formulación de interfaz, resultantes y plan probabilístico: PASS en
  `/private/tmp/interface-mc-technical-audit-v2.md`;
- frontera editorial y bibliográfica: PASS en
  `/private/tmp/memo-editorial-boundary-v3.md`; y
- artefacto, tablas, figura y reproducibilidad: PASS en
  `/private/tmp/calculation-artifact-audit-v4.md`.

## 22. Parametrización de la memoria y frontera académica

Esta sección sustituye, para las materias que trata, las decisiones de la
sección 21. En particular, reemplaza la ley de Coulomb de 21.3 y la inclusión
de contrastes bibliográficos en la memoria indicada en 21.4.

### 22.1 Acción tangencial y notación

La acción adoptada es una acción prescrita:

```text
P_t(theta) = alpha p_t*(theta),  0 <= alpha <= 1
```

`alpha` es un multiplicador de la componente tangencial proyectada. No es un
coeficiente de fricción, no se identifica con `tan(delta)` y no introduce una
ley de equilibrio de interfaz. En el futuro análisis de Monte Carlo será una
entrada aleatoria o de escenario junto con las variables que controlan `K0`,
sin asignar todavía distribución ni dependencia.

El símbolo `alpha(y)` empleado en el Apéndice A.3 para una coordenada angular
era un abuso de notación. Se reemplazó por `theta_1(y)` y `theta_2(y)`; estas
coordenadas geométricas no tienen relación con el multiplicador `alpha`.

### 22.2 Estado de reproducibilidad después de K0.7

El diagnóstico previo identificó valores duplicados en el productor, la prosa
y los productos de presentación. K0.7 cerró ese defecto para la corrida
determinística activa:

- `calculation.json` contiene las entradas adoptadas;
- `scripts/R/calculationData.R` genera los productos canónicos;
- `scripts/setup/calculationResults.R` carga una representación documental
  estable;
- resumen, aplicación, conclusiones, tablas y figuras consumen esa
  representación o sus CSV; y
- el antiguo Apéndice B y sus tablas de contraste permanecen fuera del
  ensamblado de la memoria.

Los capítulos metodológicos conservan ecuaciones generales y valores
publicados necesarios para definirlas; no duplican entradas del escenario.

### 22.3 Fuente única de entradas y productos materializados

La arquitectura candidata es:

```text
calculation.json
data/
  reference/
    corrugation.section.properties.csv
  calculation/
    calculation.inputs.csv
    section.properties.csv
    stress.state.csv
    perimeter.loads.csv
    section.resultants.csv
    section.extrema.csv
    numerical.controls.csv
    display.scales.csv
  benchmarks/
    ...
scripts/
  setup/
    setup.R
    utils.R
    calculationResults.R
```

`calculation.json` es la única fuente de los datos adoptados para la corrida.
Los valores tabulados de una publicación no son datos del proyecto y se
conservarán separadamente en `data/reference/`, con clave bibliográfica y
localización en la fuente. `data/calculation/` contendrá únicamente productos
generados. `data/benchmarks/` pertenecerá a la línea académica y no será
consumido por la memoria ejecutiva.

Los productos implementados conservan la política PSHA: namespace semántico en
inglés y tokens separados por puntos. Sus esquemas se registran en 26.6.

### 22.4 Contrato mínimo de `calculation.json`

La primera versión incluye solamente:

1. `schemaVersion` e identificador del escenario;
2. geometría conocida y regla adoptada para el radio de análisis;
3. perfil corrugado y espesor base del escenario;
4. módulo circunferencial o propiedades necesarias para obtener `EA_theta` y
   `EI_theta`;
5. estado de tensiones: tensión vertical efectiva, `K0` y diferencia de
   presión de agua;
6. valores de `alpha` que se evaluarán;
7. discretización, pasos de integración y tolerancias; y
8. parámetros puramente gráficos, entre ellos `graphicAmplification` y número
   de ordenadas.

Las unidades serán explícitas en el esquema y fijas para cada campo. Las
validaciones se limitarán a presencia, tipo, finitud y dominio físico necesario:
dimensiones y rigideces positivas, `0 <= alpha <= 1` y parámetros numéricos
enteros positivos. `K0` no se restringirá artificialmente al intervalo
`[0,1]`. No se agregará todavía un bloque de distribuciones de Monte Carlo.

### 22.5 Productor R y actualización automática

El cálculo se concentra en
`buildCalculationData(configPath, outputDirectory, projectRoot)`, alojada en
`scripts/R/calculationData.R`. Esa función:

1. leerá y validará `calculation.json`;
2. leerá las propiedades tabuladas necesarias desde `data/reference/`;
3. resolverá en memoria las acciones y resultantes;
4. ejecutará los controles matemáticos;
5. escribirá los CSV sólo después de completar correctamente el cálculo; y
6. fallará antes del render si falta una entrada o un control no se satisface.

Como la corrida determinística actual es pequeña, `scripts/setup/setup.R` la
regenera al inicio de cada render. Esta decisión evita resultados obsoletos
sin introducir una caché o un sistema de dependencias prematuro. El productor
también conservará una interfaz ejecutable mediante `Rscript` para pruebas y
uso fuera de Quarto.

`scripts/setup/utils.R` posee únicamente lectura, formateo y
resolución de rutas. No contendrá ecuaciones mecánicas. Los builders de tablas
y figuras leerán los CSV con columnas explícitas; no calcularán resultantes ni
repetirán valores del JSON.

### 22.6 Composición documental mínima

Se adoptó el principio de `_results/` del scaffold PSHA sin reproducir toda su
separación temática:

- la metodología y las fórmulas generales permanecen en capítulos Markdown
  legibles y sin dependencia de una corrida;
- la aplicación numérica puede permanecer en su capítulo actual;
- un único `_results/calculation.results.es.qmd` cargará
  `scripts/setup/calculationResults.R` y expondrá los valores de la corrida
  mediante expresiones breves;
- `_tbl/` y `_fig/` continuarán siendo ensambladores delgados que cargan sus
  respectivos scripts R; y
- la prosa del capítulo no contendrá algoritmos, consultas largas ni valores
  copiados manualmente.

No se crearán varios bloques `_results/` mientras un consumidor real no lo
requiera. Para los diagramas, cada ensamblador público producirá una sola
figura y llamará al mismo adaptador para `N`, `M` o `Q`, siguiendo el patrón
`caption -> _fig -> scripts/fig -> NGR` del scaffold instalado.

### 22.7 Benchmarks y CANDE

Los benchmarks bibliográficos no forman parte de la memoria ejecutiva. El
Apéndice B fue retirado del ensamblado de `_index/calculation.appendix.review.ES.qmd`
y su remisión fue eliminada de las conclusiones. El archivo de trabajo, los
PDF y los scripts se conservan para el paper; no se eliminó ninguna fuente.

CANDE tampoco se mencionará en la memoria: no es base del cálculo, no fue
ejecutado y no aporta un contraste cuantitativo aplicable. Puede conservarse en
la revisión académica del estado de la práctica.

Antes de reutilizar cualquier tabla de contraste en el paper se auditará cada
dato publicado contra la fuente primaria y se distinguirán datos publicados,
resultados reproducidos y resultados derivados. Los controles matemáticos
propios se conservarán en `data/calculation/numerical.controls.csv`; no se
presentarán como benchmarks bibliográficos.

### 22.8 Pruebas de aceptación de la parametrización

La implementación se aceptará sólo si:

1. una modificación controlada de la tensión vertical, `K0`, espesor o
   `alpha` en `calculation.json` actualiza en un único render todos los CSV,
   valores del texto, tablas y figuras afectados;
2. ningún valor adoptado del escenario permanece duplicado en scripts,
   capítulos, captions o ensambladores;
3. las tablas y figuras fallan con un mensaje preciso ante un CSV ausente o un
   esquema incompatible;
4. la corrida reproduce las soluciones cerradas de control dentro de la
   tolerancia declarada;
5. la memoria no contiene CANDE ni tablas de benchmarks externos;
6. el HTML no presenta referencias, citas, unidades ni valores obsoletos;
7. la Fase 1 congelada conserva exactamente sus hashes; y
8. una auditoría independiente confirma la trazabilidad
   `calculation.json -> data/calculation -> _results/_tbl/_fig -> HTML`.

### 22.9 Handoff de NGR

La auditoría y documentación previa a la publicación de
`buildSectionResultantsPlot()` se transfirió a:

```text
/Users/averrik/Cloud/github/libraries/NGR/dev/handoff/
HANDOFF-section-resultants-plot-2026-08-11.md
```

La suite enfocada de la función concluyó con código de salida 0. El handoff
exige auditoría independiente, una vignette pkgdown con ejemplos sintéticos de
uno y tres paneles, instalación temporal y comprobación del consumidor antes
de publicar. No se ejecutaron `stage`, `commit` ni `push`.

## 23. Autonomía del Apéndice A

Esta sección sustituye cualquier redacción anterior que permita cerrar un
desarrollo remitiendo al cuerpo de la memoria. Cada bloque A.1--A.5 debe
declarar sus hipótesis y convenciones, desarrollar las relaciones necesarias y
alcanzar las mismas ecuaciones finales que utiliza el cuerpo. El cuerpo conserva
las fórmulas operativas; el apéndice justifica esas fórmulas sin depender de una
referencia circular al informe.

La memoria adopta $\xi>0$ hacia la fibra interior y
$M_\theta>0$ cuando produce tracción en esa fibra. Con
$Q_\theta>0$ dirigido hacia el centro sobre la cara positiva, esta convención
conduce a $dM_\theta/d\theta=RQ_\theta$. La Fase 1 congelada declara en su
definición seccional el signo opuesto para el momento, aunque sus ecuaciones
usan el signo adoptado por la memoria. Esta diferencia no se corrige editando
la Fase 1: la transformación
$M_\theta^{\mathrm{calc}}=-M_\theta^{\mathrm{F1,def}}$
y la equivalencia con el símbolo algebraico de sus ecuaciones se registran en
`TITO/kb/calculation-memo/equation-traceability.md`.

La sección A.4 define las propiedades y resultantes por unidad de ancho
longitudinal proyectado. En particular,
$N_\theta=b^{-1}\int_{A_b}\sigma_\theta\,dA$ y
$M_\theta=b^{-1}\int_{A_b}\sigma_\theta\xi\,dA$; la densidad local de trabajo
virtual se integra mediante $R\,d\theta$ para obtener el trabajo de la
circunferencia por unidad de ancho. Las rigideces finales permanecen
$EA_\theta=E_\theta A_p$ y $EI_\theta=E_\theta I_p$.

La sección A.5 no es una formulación publicada ni una ley de interfaz. Es una
solución cerrada derivada en esta memoria para el modelo explícitamente
adoptado de acciones prescritas,
$P_t(\theta)=\alpha p_t^*(\theta)$, con geometría y rigideces fijas. Su función
es comprobar la integración directa del estado biaxial uniforme. La
superposición es válida por la linealidad de las ecuaciones de equilibrio y
compatibilidad; no confiere significado físico adicional al multiplicador
$\alpha$.

Los contrastes bibliográficos y CANDE permanecen fuera de la memoria. La
autonomía del Apéndice A no autoriza reintroducir el antiguo Apéndice B ni
presentar este control matemático interno como benchmark externo.

## 24. Consolidación inicial de productos y limpieza

Antes de incorporar las especificaciones técnicas, el repositorio tenía dos
superficies públicas de render:

| Producto | Master | Salida HTML |
|---|---|---|
| memoria técnica | `_master/calculation.review.es.qmd` | `html/calculation.review.es/index.html` |
| documento metodológico y semilla del paper | `_master/methodology.review.es.qmd` | `html/methodology.review.es/index.html` |

La limpieza se ejecuta después de crear y publicar una instantánea Git del
estado auditado. Esa instantánea constituye el punto de recuperación de los
artefactos históricos. La primera pasada retirará únicamente:

1. el master, index y HTML del comparador gráfico
   `calculation.resultants.review`;
2. los HTML y copias de trabajo anteriores a las decisiones vigentes sobre
   interfaz y multiplicador tangencial;
3. el master, index, HTML, capítulos, figuras y tablas de la metodología R0
   rechazada, ya sustituida por el producto `methodology.review`;
4. archivos temporales reproducibles que no sean fuente ni evidencia
   primaria.

En esa primera pasada no se eliminarían `TITO/kb/sources/`, `TITO/kb/review/`,
`TITO/kb/calculation-memo/`, `TITO/kb/paper-candidate/`, los datos de
contraste reservados para investigación, los prototipos Wolfram vigentes ni
ningún archivo bajo `_ref/`. Tampoco se incluirían en commits ni se revertirían
la eliminación ajena de
`_chapters/Especificacion_Inspeccion_UT_Pernos_Seccion.md`, la eliminación
ajena de `scripts/py/0.py` o la modificación ajena de
`scripts/wolfram/0.nb`.

Antes de retirar una segunda categoría de archivos se comprobará que no sea
consumida por ninguno de los masters entonces vigentes ni por sus pruebas.
Después de cada
pasada se renderizará la memoria, se ejecutarán sus pruebas y se verificará
que los PDF y textos fuente permanezcan disponibles. La Fase 1 congelada se
controlará mediante sus hashes y su grafo de inclusiones; no se regenerará sin
una autorización expresa.

### 24.1 Instalación de NGR

AR-SAD40 no comprueba ni prescribe una versión de NGR. El adaptador de la
figura llama directamente a `NGR::buildSectionResultantsPlot()`. NGR se instaló
en la biblioteca general de R mediante la instrucción `devtools::install()` de
`NGR/inst/install.R`; una sesión nueva identificó la versión `0.3.10` y la
exportación de esa función.

La duplicación de aliases detectada durante una ejecución anterior del
instalador quedó resuelta en el árbol de trabajo de NGR mediante anotaciones
roxygen en `R/quartoYaml.R`; el instalador regeneró la documentación y completó
la instalación. Esos cambios, junto con la función, su prueba y los archivos de
integración del paquete, permanecen staged y sin commit hasta que el usuario
resuelva expresamente el alcance que debe publicarse en NGR.

Con la instalación general, `Rscript scripts/R/testCalculationFigures.R`, el
render normal `qrt render _master/calculation.review.es.qmd --profile html` y
la inspección DOM de las tres figuras concluyeron correctamente. El HTML
resultante tiene SHA-256
`3c0dcba3a03ace12de00c9951f6a60df5236524e8a936c04287c3dacee5bd0e7`.

### 24.2 Limpieza ejecutada

El punto de recuperación `851527f` se publicó en `origin/main`, incluidos sus
cuatro objetos PDF administrados por Git LFS. A partir de ese respaldo se
retiraron el comparador `calculation.resultants.review`, la metodología R0
rechazada, las dos copias históricas de la memoria y sus salidas HTML. Esta
decisión sustituye las instrucciones históricas de conservar esos artefactos
como superficies de revisión.

En ese corte, la estructura pública quedó limitada a los dos masters declarados
en la tabla de esta sección. Se conservaron la Fase 1 congelada, la memoria vigente, los
PDF y textos fuente, los insumos del futuro paper, los datos de contraste y
los scripts `ring*` consumidos por las figuras actuales.

La memoria se renderizó después de la limpieza con el master y perfil
documentados. El HTML resultante tiene SHA-256
`e967703af0dc10a5cb670697fd3f8c55adc374d6990d561f9be3b45925dd388d`.
Los hashes protegidos del master, index y HTML de Fase 1 continúan coincidiendo
con la línea base registrada en la sección 1.2.

## 25. Especificaciones técnicas y estructura vigente

La instrucción del 11 de agosto de 2026 amplía la estructura a tres productos
renderizables. Esta sección sustituye únicamente la limitación a dos masters
de la sección 24.2; no modifica la línea base congelada de la Fase 1 ni el
contenido aprobado de la memoria de cálculo.

| Producto | Master | Índice | Estado |
|---|---|---|---|
| Memoria técnica | `_master/calculation.review.es.qmd` | `_index/calculation.review.ES.qmd` | vigente |
| Documento metodológico | `_master/methodology.review.es.qmd` | `_index/methodology.review.ES.qmd` | congelado como referencia |
| Especificaciones técnicas | `_master/specifications.review.es.qmd` | `_index/specifications.review.ES.qmd` | candidato en revisión |

El nuevo master incluye `_chapters/specifications.inspection.es.md`. La
creación del ensamblador no aprueba el contenido técnico del capítulo: sus
referencias normativas, criterios de muestreo, umbrales, terminología y
entregables deberán revisarse antes de promoverlo como especificación emitida.

La versión histórica
`_chapters/Especificacion_Inspeccion_UT_Pernos_Seccion.md` no aporta contenido
adicional: respecto del capítulo con naming vigente sólo difiere por un espacio
final y el salto de línea final. Su eliminación se clasifica como retiro de un
duplicado, no como pérdida de una fuente.

La auditoría de `dev/` debe conservar `dev/SoT/METHODOLOGY-PHASE2.md` como
fuente de verdad vigente y `dev/SoT/ACTIVE.md` conforme a la regla local. Todo
otro retiro exige demostrar que no deja referencias rotas ni elimina evidencia
necesaria para reconstruir un efecto remoto.

La auditoría del 11 de agosto de 2026 clasificó los seis archivos de `dev/`
como conservables, sin rutas eliminables ni desconocidas. El flujo
`dev/plan/lfs-bootstrap/` está cerrado, pero continúa referenciado por el
puntero protegido `dev/SoT/ACTIVE.md`; retirarlo dejaría una cadena de
continuidad rota.

El render
`qrt render _master/specifications.review.es.qmd --profile html` concluyó con
código 0 y produjo `html/specifications.review.es/index.html`, SHA-256
`3611b0b266bf78de1200347ce64e821905f0bf2fb7557d49222d3e4fcc4ce940`.
La falta de red impidió incorporar un polyfill externo durante el render; el
HTML fue creado y su estructura de títulos quedó verificada, pero ese aviso no
constituye una revisión técnica del contenido.

### 25.1 Revisión pendiente del capítulo candidato

La siguiente revisión de `_chapters/specifications.inspection.es.md` debe:

1. separar datos confirmados, antecedentes, hipótesis y requisitos de
   verificación;
2. verificar las normas y ediciones aplicables y agregarlas a
   `bib/references.bib` antes de introducir citas Markdown;
3. justificar o retirar frecuencias de muestreo, porcentajes, categorías y
   umbrales que hoy carecen de procedencia explícita;
4. definir autorización, reposición y control de estabilidad para limpieza,
   aplicación de torque y eventual extracción de pernos;
5. aplicar la terminología geométrica adoptada para una sección circular; y
6. revisar formularios, trazabilidad de mediciones y entregables antes de
   emitir la especificación.

No se crearán claves bibliográficas, criterios de aceptación ni requisitos de
seguridad por inferencia.

## 26. Diseño de la estimación del coeficiente de empuje en reposo

Esta sección sustituye, para $K_0$, el contrato preliminar de entrada directa
descrito en 22.4. K0.3--K0.6 establecieron las formulaciones, variables
primitivas, dominios y controles; K0.7 incorporó ese diseño al contrato
determinístico de la memoria sin introducir distribuciones probabilísticas.

### 26.1 Decisión técnica

El cálculo estructural consume $\sigma'_h(z)$. En las ramas basadas en una
formulación geotécnica,

$$
K_0^{(m)}(z)=f_m\!\left[\mathbf{x}_m(z)\right],
\qquad
\sigma_h'^{(m)}(z)=K_0^{(m)}(z)\,\sigma'_v(z),
$$

donde $m$ identifica la formulación y $\mathbf{x}_m$ contiene sólo sus
variables primitivas. $K_0$ se materializa como resultado derivado; no se
muestrea de manera independiente de $\phi'$, $\nu_g$, OCR o
$\mathrm{OCR}_{\max}$ cuando esas variables lo determinan.

Una medición directa puede constituir una rama observada. Un valor constante
adoptado se admite únicamente como escenario analítico explícito. El valor
$K_0=0.50$ de la aplicación vigente pertenece a esta última categoría: no es
una estimación del relleno existente y sus resultados se conservarán sin
cambios durante el desarrollo del nuevo módulo.

### 26.2 Formulaciones inicialmente habilitables

| Identificador conceptual | Expresión | Variables primitivas | Dominio y función |
|---|---|---|---|
| `elastic.confined` | $K_0=\nu_g/(1-\nu_g)$ | $\nu_g$ | referencia constitutiva elástica isótropa con deformación lateral impedida; no representa por sí sola historia tensional ni compactación |
| `jaky.nc` | $K_{0,NC}=1-\sin\phi'$ | $\phi'$ | carga primaria; suelos no cohesivos y suelos cohesivos normalmente consolidados |
| `mayne.kulhawy.unloading` | $K_{0,OC}=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'}$ | $\phi'$, OCR | descarga primaria desde la rama de compresión virgen; los ajustes estudiados fueron generalmente para $\mathrm{OCR}<15$ |
| `mayne.kulhawy.reload` | ecuación de descarga--recarga indicada abajo | $\phi'$, OCR, $\mathrm{OCR}_{\max}$ | recarga con historia máxima identificable; opción condicionada por la limitada evidencia de recarga |
| `measured` | valor medido y su incertidumbre | medición y metadatos | rama preferente cuando exista un ensayo o una medición representativa |
| `adopted.constant` | valor declarado | $K_0$ adoptado | comprobación o sensibilidad; no se presenta como correlación ni dato del proyecto |

La comparación académica conservará, sin convertirla en otra rama
probabilística, la forma de 1944 transcrita por Michalowski:

$$
K_{0,\mathrm{J\acute{a}ky\,1944}}
=(1-\sin\phi')
\frac{1+\frac{2}{3}\sin^2\phi'}{1+\sin\phi'}.
$$

La forma abreviada $1-\sin\phi'$ fue adoptada por Jáky en 1948. La revisión
de Michalowski muestra que la derivación original parte de un campo tensional
de un prisma de arena que no representa una trayectoria general de
deformación lateral nula. En la memoria, la forma abreviada se utiliza como
correlación respaldada por datos; la forma de 1944 y la crítica de su
derivación pertenecen al documento metodológico.

Mayne y Kulhawy definen

$$
\mathrm{OCR}=\frac{\sigma'_{v,\max}}{\sigma'_v},
\qquad
\mathrm{OCR}_{\max}
=\frac{\sigma'_{v,\max}}{\sigma'_{v,\min}},
$$

y para descarga seguida de recarga proponen

$$
K_0=(1-\sin\phi')\left[
\frac{\mathrm{OCR}}
{\mathrm{OCR}_{\max}^{\,1-\sin\phi'}}
+\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right)
\right].
$$

Cuando $\mathrm{OCR}=\mathrm{OCR}_{\max}$, esta expresión recupera la rama de
descarga primaria. Cuando
$\mathrm{OCR}=\mathrm{OCR}_{\max}=1$, recupera la relación normalmente
consolidada. La fuente primaria dispuso de una base considerablemente menor
para recarga que para carga primaria y descarga; la relación no se adoptará
por defecto sin una historia tensional que permita definir
$\mathrm{OCR}_{\max}$.

La rama de descarga se controla frente a la movilización pasiva:

$$
K_p=\frac{1+\sin\phi'}{1-\sin\phi'},
\qquad
\mathrm{OCR}_{\lim}
=\left[
\frac{1+\sin\phi'}{(1-\sin\phi')^2}
\right]^{1/\sin\phi'}.
$$

Al alcanzar este límite, la hipótesis de estado en reposo queda fuera de su
dominio. La implementación informará esa condición; no recortará $K_0$ de
manera silenciosa. El coeficiente pasivo de Rankine se utiliza aquí sólo como
control del dominio de la correlación original; no constituye una ley de
interfaz ni una capacidad general del relleno contra el revestimiento.

### 26.3 Discrepancia documental resuelta

FHWA NHI-05-037, ecuación 5.39, imprime el segundo término de la relación de
recarga como
$(3/4)\,\mathrm{OCR}/\mathrm{OCR}_{\max}$. La ecuación 18 del artículo
primario de Mayne y Kulhawy contiene
$(3/4)(1-\mathrm{OCR}/\mathrm{OCR}_{\max})$.

La expresión del manual no recupera la relación normalmente consolidada para
$\mathrm{OCR}=\mathrm{OCR}_{\max}=1$; produce
$1.75(1-\sin\phi')$. La fuente primaria sí satisface ese límite y gobierna el
procedimiento. La transcripción FHWA queda registrada como discrepancia y no
se implementará.

La fuente primaria fue preservada en
`TITO/kb/sources/mayne_kulhawy_1982_k0_ocr_relationships.pdf`; su SHA-256 es
`3e6cf544178882cb9acb2d48c53a4c9908c851dc8903d32e047334734a178e60`.
La clave bibliográfica es `MayneKulhawy1982`. El artículo de Michalowski fue
preservado en
`TITO/kb/sources/michalowski_2005_coefficient_earth_pressure_at_rest.pdf`, con
SHA-256
`ba20eb1b9a953068a55858f448431c925aa9a65162e371ba54ef732486716b2e` y clave
`Michalowski2005`.

### 26.4 Compactación e historia tensional

El coeficiente en reposo y la tensión horizontal residual de compactación no
son el mismo objeto. La relación operativa más general puede escribirse como

$$
\sigma'_h(z)=K_{0,b}(z)\,\sigma'_v(z)
+\Delta\sigma'_{h,c}(z),
$$

pero esta forma no autoriza sumar indiscriminadamente dos modelos. Se
mantendrán dos rutas excluyentes:

1. representar la historia mediante una formulación aplicable de $K_0$, sin
   agregar otra vez el efecto de carga--descarga; o
2. adoptar un estado base y un modelo independiente, documentado y aplicable,
   para $\Delta\sigma'_{h,c}(z)$.

La acción temporal de compactación de FHWA-RD-98-191 continúa siendo una carga
por etapa. No define un $K_0$ permanente ni una fracción universal retenida.
La distribución residual aplicable a un revestimiento circular flexible
permanece `UNKNOWN`; antes de cuantificarla deben recuperarse y evaluarse las
fuentes específicas de presión residual, la movilidad de la estructura y la
secuencia real de colocación.

### 26.5 Arquitectura editorial

La memoria incorporará una subsección compacta titulada «Estimación del
coeficiente de empuje en reposo» dentro de
`TITO/kb/calculation-memo/chapters/calculation.actions.review.es.md`, después
de la tensión vertical efectiva y antes de proyectar el estado tensional sobre
el contorno. Esa subsección contendrá:

1. la definición efectiva y la salida $\sigma'_h$;
2. una tabla de selección de ramas;
3. las fórmulas finales correspondientes a la rama adoptada;
4. el control de dominio; y
5. la separación respecto de la presión residual de compactación.

No se crea otro capítulo de la memoria ni otro apéndice mientras la extensión
operativa pueda mantenerse en esa subsección. La comparación detallada por
autores, la forma original de Jáky, las regresiones auxiliares, las
discrepancias documentales y los límites experimentales se redactarán, cuando
se inicie esa etapa, en el candidato académico independiente:

```text
TITO/kb/paper-candidate/chapters/methodology.k0.estimation.es.md
```

La Fase 1 congelada no se modifica. Un desarrollo sólo pasará al Apéndice A si
la memoria necesita una transformación matemática concreta para obtener una
de sus fórmulas operativas; el apéndice no repetirá el estado de la práctica.

### 26.6 Contrato de datos implementado

`calculation.json`, con `schemaVersion = 1.0.0`, es la fuente única de entradas
adoptadas de la corrida. Cada estado selecciona exactamente una rama de
$K_0$ y declara sólo sus variables primitivas. Los identificadores son:

| `modelId` | Variables declaradas | Estado |
|---|---|---|
| `adopted-constant` | `k0` | implementado para comprobación o sensibilidad |
| `elastic-confined` | `poissonRatio` | implementado |
| `jaky-nc` | `frictionAngleDeg` | implementado |
| `mayne-kulhawy-unloading` | `frictionAngleDeg`, `ocr` | implementado |
| `mayne-kulhawy-reload` | `frictionAngleDeg`, `ocr`, `ocrMaximum` | implementado |
| `measured` | medición y metadatos | diferido hasta definir su evidencia y esquema |

El validador aplica una exclusión equivalente a `oneOf`: rechaza campos de
otra rama, entradas ausentes, dominios inválidos y la rama `measured` todavía
no habilitada. La procedencia de cada formulación reside en el registro del
modelo en R; no es un texto editable del JSON.

El estado lateral materializado distingue tres magnitudes:

- `k0Input`: valor primitivo de una rama directa;
- `k0Derived`: resultado de una formulación; y
- `k0Applied`: valor que forma la tensión horizontal efectiva.

La salida primaria es `effectiveHorizontalKPa`. Las acciones perimetrales la
consumen una sola vez y no recalculan $K_0$. Para el estado biaxial uniforme
vigente, `stress.state.csv` contiene una fila; no repite el mismo estado en
cada ordenada angular. Las columnas no aplicables son nulas.

La presión residual de compactación no se sustituye por cero. El modo
`unknown-not-modeled` produce `horizontalIncrementKPa = NA` y conserva ese
estado explícito hasta disponer de una formulación sustentada. La diferencia
de presión de agua es una magnitud con signo y se incorpora una única vez en
la transformación de acciones.

La corrida genera de manera coherente los siguientes productos bajo
`data/calculation/`:

```text
calculation.config.json
calculation.inputs.csv
section.properties.csv
stress.state.csv
perimeter.loads.csv
section.resultants.csv
section.extrema.csv
numerical.controls.csv
display.scales.csv
```

`calculation.config.json` es la instantánea exacta de la entrada. El CSV de
entradas no contiene magnitudes derivadas. `section.properties.csv` conserva
las rigideces obtenidas de la tabla publicada en `data/reference/`;
`numerical.controls.csv` identifica controles matemáticos internos y no
benchmarks externos. Este último materializa `alpha` como magnitud numérica;
ningún consumidor la reconstruye a partir de `caseId`, que es un identificador
opaco.

La publicación se realiza por intercambio de directorios: el productor escribe
y comprueba el conjunto completo en staging, preserva temporalmente el conjunto
anterior, renombra el staging a la ruta canónica y restaura el anterior si el
intercambio falla. Una corrida inválida no mezcla productos nuevos y previos.

### 26.7 Secuencia de trabajo

1. **K0.1 — Evidencia básica.** Cerrada para Jaky, elasticidad confinada y
   Mayne--Kulhawy. La fuente primaria y la discrepancia FHWA están registradas.
2. **K0.2 — Alcance de modelos: cerrado.** La memoria habilita elasticidad
   confinada, Jáky para carga primaria y Mayne--Kulhawy para descarga y
   recarga. Brooker--Ireland, Mesri--Hayat y un modelo cuantitativo de presión
   residual permanecen fuera del módulo operativo.
3. **K0.3 — Redacción: cerrada.** La subsección operativa vive en
   `calculation.actions.review.es.md`; la revisión por autores y la
   discrepancia FHWA viven en el capítulo académico independiente. La Fase 1
   no fue editada.
4. **K0.4 — Prototipo R: cerrado.** `k0NormallyConsolidated()`,
   `k0ElasticConfined()`, `k0MayneKulhawyUnloading()`,
   `k0MayneKulhawyReload()` y `checkK0PassiveDomain()` implementan las ramas y
   el control adoptados. `resolveCalculationK0()` selecciona explícitamente la
   rama declarada; no se crearon clases ni una jerarquía de modelos.
5. **K0.5 — Controles numéricos: cerrado.** `testRingMethod.R` comprueba el
   límite NC, las identidades de borde, un estado intermedio de recarga,
   $K_0>1$, el límite pasivo y los dominios escalares. Los valores se
   clasifican como controles internos, no como resultados publicados.
6. **K0.6 — Auditoría: cerrada.** Se verificaron ecuaciones, unidades,
   dominios, citas, atribuciones y ausencia de doble contabilización de
   compactación sobre la implementación y el HTML regenerado. Los dictámenes
   técnico, editorial y de continuidad están en
   `/private/tmp/k0-implementation-technical-audit.md`,
   `/private/tmp/k0-implementation-editorial-audit.md` y
   `/private/tmp/k0-implementation-continuity-audit.md`.
7. **K0.7 — Parametrización: cerrada.** `calculation.json` gobierna la corrida,
   `stress.state.csv` materializa el estado lateral y la memoria consume los
   productos canónicos mediante un único bloque `_results`, tablas y figuras
   delgadas.

### 26.8 Puertas verificadas al cerrar K0.7

- cada ecuación activa tiene fuente primaria o institucional leída y
  localizador exacto;
- cada rama define suelo, trayectoria de carga, variables y dominio;
- la versión errónea de FHWA 5.39 no aparece en código ni prosa operativa;
- $K_0$ sólo es una entrada directa en las ramas `measured` y
  `adopted.constant`;
- no se muestrean simultáneamente $K_0$ y sus variables determinantes;
- no se suman una relación de historia tensional y una presión residual que
  representen el mismo fenómeno;
- $K_0>1$ no se rechaza por una restricción global; gobiernan los controles de
  dominio de la formulación;
- los resultados actuales del escenario $K_0=0.50$ se conservan como control;
- la salida primaria $\sigma'_h$ alimenta una sola vez la proyección de
  acciones; y
- la Fase 1 conserva sus hashes.

La prueba `scripts/R/testCalculationData.R` verifica además cambios
controlados de tensión vertical, $K_0$, espesor, $\alpha$ y presión de agua;
equivalencia entre una rama adoptada y Jáky para $\phi'=30^\circ$; rechazo de
ramas mezcladas, espesores fuera de la tabla, controles incumplidos y esquemas
incompatibles; y ausencia de bloques de Monte Carlo en el JSON. La perturbación
de $\alpha$ utiliza deliberadamente un `caseId` no numérico y atraviesa tablas
y figura. Una falla de control conserva íntegra la publicación anterior.

### 26.9 Estado de implementación

K0.3--K0.7 están cerrados para la corrida determinística. La aplicación
conserva el valor adoptado $K_0=0.50$; las ramas derivadas no sustituyen esa
hipótesis sin datos del relleno. El incremento residual de compactación
permanece físicamente no caracterizado y no se incluye en la respuesta.

`runCalculationMemo.R`, `testCalculationData.R`, `testRingMethod.R` y
`testCalculationFigures.R` concluyeron PASS. El render normal con `qrt` produjo
`html/calculation.review.es/index.html`, SHA-256
`d7bb53bb2ec5faa70b3db22d6c2f652e0e6bcfd1934a63a4d09035c48a03d563`.
Los hashes de master, index y HTML congelados de Fase 1 permanecen,
respectivamente, en
`ae3db1c42fe7626c8233ac3fb4c77da7743172bdfff3b51ef762c139cf27d1ef`,
`0eee73a9c7e7ed90104a7b3074e3e93bbd57254a568ba302861135a3568b4baa` y
`0d46a5f6e437056adf809ef57ec16975631af6b2bad0206bf5c572f8fce4cb54`.

Las auditorías finales concluyeron PASS: técnica en
`/private/tmp/k0-7-final-technical-audit.md`, editorial y de artefacto en
`/private/tmp/k0-7-final-editorial-artifact-audit-v2.md`, y de continuidad y
reproducibilidad en
`/private/tmp/k0-7-final-reproducibility-audit-v3.md`.

La siguiente etapa probabilística permanece detenida hasta aprobar variables,
distribuciones y dependencias. K0.7 no ejecutó Monte Carlo ni asignó
probabilidades de modelo.

## 27. Arquitectura funcional del cálculo y migración por paridad

Esta sección es la fuente de verdad para la reestructuración del código R
solicitada el 12 de agosto de 2026. En este contexto, una SoT es el registro
duradero que gobierna las fronteras funcionales, los datos que atraviesan cada
etapa, los observables que deben conservarse, las puertas de sustitución y las
decisiones todavía no resueltas. No es un diagrama aspiracional separado de la
implementación.

Esta etapa documenta el plan. No reemplaza todavía ninguna función del cálculo
vigente, no modifica sus resultados y no habilita una simulación Monte Carlo
del proyecto.

### 27.1 Decisiones rectoras

1. El cálculo determinístico auditado y sus productos vigentes constituyen el
   oráculo de comportamiento. Permanecerán ejecutables y sin cambios durante
   la coexistencia.
2. La migración seguirá un proceso de «barco de Teseo»: se extraerá una
   frontera por vez, se comparará el objeto candidato contra el oráculo con las
   mismas entradas y sólo entonces se redirigirá su consumidor.
3. $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$ se resolverán en
   una única función. Las tres resultantes pertenecen al mismo sistema de
   equilibrio y compatibilidad y comparten acciones, malla angular, constantes
   de cierre y diagnósticos. No se crearán tres procedimientos de solución
   independientes.
4. $K_0$, el estado tensional, las propiedades seccionales, las acciones
   perimetrales, las resultantes y sus extremos serán etapas independientes y
   componibles.
5. El camino invocado una vez por realización será determinístico y no tendrá
   lectura o escritura de archivos, formato editorial, figuras, generación
   aleatoria ni selección de distribuciones.
6. No se crearán clases nuevas, una jerarquía general de modelos de suelo, una
   teoría ortótropa general ni una infraestructura de ejecución genérica. Las
   listas, vectores y tablas simples son suficientes para las fronteras
   observadas.
7. Las clases ligeras existentes `ringLoad` y `ringDirectResponse` se
   conservarán durante la coexistencia porque tienen consumidores activos. Su
   eventual retiro requerirá inventario y paridad propios.
8. La recuperación de tensiones en la chapa y la respuesta de juntas y pernos
   son módulos posteriores que consumen las resultantes. Sus fronteras se
   reservan ahora, pero no se implementarán hasta aprobar los modelos
   mecánicos y los datos que hoy permanecen `UNKNOWN`.
9. El nombre de la futura librería R permanece `UNKNOWN`. Bautizarla antes de
   estabilizar las superficies de llamada produciría una migración adicional
   sin beneficio técnico.
10. Todo código R de esta migración se rige por el router canónico
    `/Users/averrik/github/agents/AGENTS.md` y, según el efecto inmediato, por
    `STYLE.md`, `PRACTICE.md`, `R.md`, `CONFIG.md`, `R-PIPELINES.md`,
    `COMPATIBILITY.md`, `GIT.md` para la publicación y `R-DATA-TABLE.md` antes
    de cualquier uso de `data.table`. Esta obligación se revalida después de
    una compactación antes de continuar una mutación de código; esta SoT
    registra la decisión, pero no sustituye la lectura de esos contratos.
11. Las funciones y parámetros usan `lowerCamelCase`; las variables locales
    con identidad estable usan `PascalCase`; los recipientes efímeros usan el
    vocabulario compacto `DT`, `AUX`, `LIST`, `OUT`, `DATA`, `COLS`, `FILES`,
    `FILE`, `DIR`, `OK`, `MASK` o `IDX`, y las primitivas efímeras usan una
    letra minúscula. No se codifican tipos ni estados transitorios en los
    nombres.
12. `data.table` no se introducirá sólo por brevedad. Si una etapa lo requiere,
    deberá declarar propiedad antes de mutar por referencia, preservar lado y
    cardinalidad de cada unión, y probar orden, tipos, ausencias, duplicados y
    atributos. Mientras el cálculo vigente use `data.frame`, la migración por
    paridad conservará esa representación salvo una puerta deliberada y
    comprobada.

### 27.2 Sistema vigente que se preserva como oráculo

La memoria ejecuta actualmente:

```text
calculation.json
  -> validateCalculationConfig()
  -> readCalculationSection()
  -> resolveCalculationK0()
  -> biaxialStressTangentialMultiplierLoad()
  -> solveRingDirect()
  -> N(theta), M(theta), Q(theta) y diagnósticos
  -> extremos, controles, productos CSV y memoria
```

Los hechos arquitectónicos relevantes son:

- `solveRingDirect()` ya resuelve conjuntamente las tres resultantes y es el
  núcleo mecánico de producción;
- `runRingMonteCarlo()` recibe realizaciones ya materializadas y no selecciona
  distribuciones, dependencias ni probabilidades;
- `buildCalculationData()` concentra validación, lectura de referencias,
  derivaciones, solución, controles, adaptación tabular y publicación;
- `scripts/setup/setup.R` combina la carga de funciones con la ejecución y la
  escritura de productos; y
- no existen funciones aprobadas para tensiones locales de la chapa, demanda
  de una junta o respuesta de pernos.

La principal deuda no está en el número de líneas de `solveRingDirect()`, sino
en la concentración de cálculo, adaptación editorial e I/O dentro de
`buildCalculationData()` y en el efecto de escritura implícito de `setup.R`.

#### 27.2.1 Identidad observada de la línea base

La línea base fue inspeccionada inicialmente en la rama `main`, con
`HEAD = d498910d6c98fab8723cc88585bc8dffe483f976`, R 4.6.0 y `jsonlite` 2.0.0.
El árbol contenía trabajo modificado y sin seguimiento; por ello ese `HEAD` no
permitía por sí solo recuperar el cálculo auditado. La puerta G0 resolvió esta
condición mediante el commit `4f0d9a8`, publicado en `origin/main`, que
incorpora al historial el alcance determinístico observado y constituye su
ancla recuperable.

| Objeto | SHA-256 observado |
|---|---|
| `calculation.json` | `70d628478812f42d8f0b8468ef1a01df237a3d1ec4263069200b4937ec86848b` |
| `data/reference/corrugation.section.properties.csv` | `ac7991f21dcaf805346ebb35bd3eb5a92ab9c1fd7caf3cd7f043ba72d7904539` |
| `scripts/R/ringDirect.R` | `dd2d0fec24bbaf9c4cafda0df3d4c35b7595d4fd0a9c5f7a01d65eaa70d8f26c` |
| `scripts/R/ringLoads.R` | `d73c5ea4b284b044b27aa622513d88a8fc45da1c0773b0c67230c6746516bce6` |
| `scripts/R/calculationData.R` | `4e0077f1daadbdc845a10cde806f4861e2e57940d611967b76fd637e3408cfea` |
| `scripts/R/ringMonteCarlo.R` | `ae6f48cd5643bba4488b46defbf668674280ce9f89ed063d72ce41780da246ce` |
| `scripts/R/calculationMonteCarloOutput.R` | `b057be7318058ab57c290ed4dcdd383fdd7175b1b6b2fbe57432e0ba782f8f12` |
| `scripts/setup/setup.R` | `d2ae892c477c486753b6d101869cc10190dc41041febd6507ae7eab4c8eeef61` |
| `scripts/setup/utils.R` | `061cd9a5a0144193606dee507c2de26128273992e02c7b3db6791ab566bd740f` |
| `scripts/setup/calculationResults.R` | `ed81d335cc579edc3c89bad7a4cc899b5a46da7816bf344e784fdf46e72c6345` |
| `scripts/R/testRingMethod.R` | `a45207e35fd41e8b0e15faf2a38b0632b9efc6da30f989eeb2c7ee5771169679` |
| `scripts/R/testCalculationData.R` | `c40a156599f348f614aa8837b49f4ba90667ca75828603bc20ea6af4587bbc1a` |
| `scripts/R/testCalculationMonteCarloOutput.R` | `b08c913300a4f62284cde6948cfee419ff6e91a83b9edb7daad6bb86a19f718b` |
| `scripts/R/testCalculationFigures.R` | `0d2b09555473951034bb87cb542c10aaf7420e3a3e3efc1c342237e049a6d994` |
| `html/calculation.review.es/index.html` | `d7bb53bb2ec5faa70b3db22d6c2f652e0e6bcfd1934a63a4d09035c48a03d563` |

Los nueve productos canónicos de `data/calculation/` también integraron la
instantánea de G0. Sus hashes observados son:

| Producto | Filas con cabecera | SHA-256 observado |
|---|---:|---|
| `calculation.config.json` | 52 | `70d628478812f42d8f0b8468ef1a01df237a3d1ec4263069200b4937ec86848b` |
| `calculation.inputs.csv` | 26 | `193a9456492ba34e19def68f9860ffb105b0f6ceb13ce3a46d9df7bdbd3b0910` |
| `section.properties.csv` | 2 | `4b36cf593a6bdf88d94c4a202d83845a5cca81646bba79d76e661c20712f7ae9` |
| `stress.state.csv` | 2 | `ecd272d7594d78f2f8f57911c74d12b8d059fed01a480769849df5ddf3af87fc` |
| `perimeter.loads.csv` | 2913 | `9d3c640574dc468a3d6be3c8282084f7c41a4e0c9ecee91a6c7ae711f226efda` |
| `section.resultants.csv` | 4369 | `b2e5fae2188205367f1fb757f7a4dac1eb4c8b2853c63bfb5441896bc5f09eed` |
| `section.extrema.csv` | 19 | `6881e17589fd53c65676c2826d5c96948580f3c37d2e8a270bf2e7e0eb40f014` |
| `numerical.controls.csv` | 7 | `be43a911b0b3b3af6334e61e3ca40909b1ef3858b4d01254ee0037f93791c5e3` |
| `display.scales.csv` | 4 | `08b3222ce5b947783293a37a8c888276c729ef83ce968505e8b80f2d6198cc6b` |

### 27.3 Capas objetivo

La arquitectura mínima tiene cuatro capas. Cada una conoce únicamente a la
inmediatamente anterior:

```text
funciones puras del dominio
  -> composición de una realización
     -> adaptadores de configuración y productos de AR-SAD40
        -> tablas, figuras y documento Quarto
```

1. **Núcleo de dominio.** Evalúa ecuaciones y controles con objetos en
   memoria. No conoce rutas, JSON, CSV, Quarto ni gráficos.
2. **Composición determinística.** Encadena las etapas para una realización y
   devuelve cada estado intermedio en una lista simple y auditable.
3. **Adaptadores del proyecto.** Ejecutan las operaciones explícitas de lectura
   y escritura solicitadas por el runner: validan `calculation.json`, cargan
   referencias, agregan IDs, unidades y trazabilidad, y publican los productos
   declarados.
4. **Documento.** Lee productos terminados y prepara tablas, figuras y texto;
   no vuelve a implementar ecuaciones.

El runner será el único orquestador de los efectos; los adaptadores ejecutarán
las lecturas y escrituras que aquél les solicite. La carga del núcleo no
regenerará datos. Durante la coexistencia, `scripts/setup/setup.R` conservará
su efecto histórico para consumidores todavía no inventariados y no se usará
como superficie nueva.

### 27.4 Contratos funcionales propuestos

Los nombres siguientes son la superficie candidata que se probará en
coexistencia. Respetan `lowerCamelCase`; una función interna conservará un
punto inicial. Ningún nombre se promoverá a un paquete antes de inventariar sus
consumidores.

| Función candidata | Responsabilidad | Entradas principales | Salida | Estado |
|---|---|---|---|---|
| `estimateK0()` | seleccionar una rama y evaluar $K_0$ | `modelId` y sólo las variables primitivas de esa rama | valor aplicado, estado de dominio y magnitudes de control | extraer de `resolveCalculationK0()`; las ecuaciones `k0*()` vigentes se preservan |
| `calculateEffectiveStressState()` | formar el estado efectivo aplicado | $\sigma'_v$, resultado de `estimateK0()`, diferencia de presión de agua y estado explícito del incremento horizontal | $\sigma'_{h,b}=K_0\sigma'_v$, componente horizontal aplicada y metadatos del incremento | nueva frontera sobre lógica hoy embebida |
| `interpolateCorrugatedSection()` | obtener $A_\theta$ e $I_\theta$ desde una referencia ya cargada | tabla, perfil y espesor de análisis | propiedades e información de interpolación | extraer de `readCalculationSection()` |
| `calculateRingSection()` | obtener rigideces circunferenciales | $E_\theta$, $A_\theta$, $I_\theta$ y $R$ | $EA_\theta$, $EI_\theta$ y $I_\theta/(A_\theta R^2)$ | función pura vigente; conserva la implementación y la firma |
| `calculatePerimeterActions()` | proyectar el estado tensional sobre el contorno | estado tensional, $\alpha$ y $\theta$ | $P_r(\theta)$, $P_t(\theta)$ y representación compatible con el motor | envolver la proyección biaxial vigente |
| `calculateSectionResultants()` | resolver equilibrio y compatibilidad | acciones, $R$, razón seccional, malla y parámetros numéricos | una única tabla con $N_\theta$, $M_\theta$, $Q_\theta$ y diagnósticos | envolver `solveRingDirect()`; no se divide por resultante |
| `summarizeSectionResultants()` | localizar extremos espaciales | respuesta conjunta de resultantes | mínimos, máximos y máximos absolutos, con signo y ángulo | consolidar tres implementaciones duplicadas |
| `calculateScenario()` | componer una realización | una fila de primitivas y un contexto invariante | etapas anteriores, resultantes, extremos y diagnósticos | nueva función delgada; no contiene ecuaciones propias |
| `calculateSheetNormalStress()` | recuperar tensión normal global por flexo-compresión | $N_\theta$, $M_\theta$, propiedades netas y coordenadas de fibra | campo de tensión por ángulo y fibra | futuro; modelo de recuperación pendiente |
| `calculateJointDemand()` | transformar las resultantes en acciones transmitidas por una junta | resultantes en la junta, ancho tributario y geometría | acciones de la unión | futuro; transferencia pendiente |
| `calculateBoltResponse()` | distribuir la acción de junta en el grupo de pernos | acción de junta, disposición, áreas y modelo de reparto | fuerza por perno y componentes nominales de tensión | futuro; modelo y datos pendientes |

`estimateK0()` será la fachada única solicitada para el cálculo. Las funciones
por formulación continuarán siendo unidades pequeñas y comprobables; durante
la migración conservarán sus nombres existentes para no romper consumidores.
La fachada aplicará una exclusión de tipo `oneOf`: no aceptará parámetros de
ramas que no correspondan al `modelId` seleccionado.

`calculateSectionResultants()` devolverá siempre las tres resultantes. Un
consumidor que necesite sólo una de ellas seleccionará su columna después de
resolver, sin volver a ejecutar el equilibrio.

La separación entre `calculateJointDemand()` y `calculateBoltResponse()` es
intencional. La resultante circunferencial no se transforma directamente en
una tensión de perno sin definir primero el ancho tributario, la geometría de
la junta, la excentricidad y el reparto entre pernos.

### 27.5 Hoja de cálculo ejecutable por etapas

La composición debe poder leerse y auditarse como una planilla o un notebook,
sin ocultar resultados intermedios:

```r
K0 <- estimateK0(...)
StressState <- calculateEffectiveStressState(...)
CorrugatedSection <- interpolateCorrugatedSection(...)
SectionRigidity <- calculateRingSection(...)
PerimeterActions <- calculatePerimeterActions(...)
SectionResultants <- calculateSectionResultants(...)
ResultantExtrema <- summarizeSectionResultants(SectionResultants)
```

Cuando sus metodologías estén aprobadas, se agregarán aguas abajo:

```r
SheetNormalStress <- calculateSheetNormalStress(...)
JointDemand <- calculateJointDemand(...)
BoltResponse <- calculateBoltResponse(...)
```

`calculateScenario()` ejecutará exactamente esas mismas funciones y devolverá
una lista nombrada con cada etapa. El ejemplo secuencial y el orquestador no
serán dos implementaciones: ambos llamarán al mismo núcleo.

### 27.6 Parámetros invariantes, primitivos y derivados

El contexto de una corrida se prepara una sola vez y contiene únicamente
invariantes: geometría conocida, malla angular, ángulos críticos, parámetros
numéricos, tabla de propiedades ya leída, modelos seleccionados, unidades y
convenciones de signo. Será una lista simple, no una clase.

Cada realización contiene sólo variables primitivas de las ramas activas. Los
parámetros derivados —los «hijos»— se calculan una vez en el orden indicado:

| Padres | Parámetro derivado | Consumidor | Estado actual |
|---|---|---|---|
| diámetro interior y regla geométrica | $R$ | sección y resultantes | implementado |
| tapada, estratigrafía, pesos unitarios efectivos, sobrecarga y agua | $\sigma'_v$ | estado tensional | las funciones básicas existen; la aplicación vigente ingresa $\sigma'_v$ directamente |
| `modelId` y $K_0$ adoptado, o $\phi'$, o $\nu_g$, o $\phi'$--OCR, o $\phi'$--OCR--$\mathrm{OCR}_{\max}$ | $K_0$ | $\sigma'_h$ | implementado por ramas |
| $K_0$ y $\sigma'_v$ | $\sigma'_{h,b}=K_0\sigma'_v$ | acciones perimetrales | implementado |
| modelo residual aprobado y sus primitivas | $\Delta\sigma'_{h,c}$ | estado tensional | `UNKNOWN`; no se sustituye por una constante inventada |
| $\sigma'_v$, $\sigma'_h$, diferencia de agua y $\alpha$ | $P_r(\theta)$ y $P_t(\theta)$ | resultantes | implementado para el estado biaxial uniforme prescrito |
| espesor original y un modelo o medición de pérdida por corrosión | espesor neto $t_{net}$ | propiedades netas | `UNKNOWN`; hoy se usa un espesor de análisis adoptado |
| perfil, referencia y espesor de análisis o neto | $A_\theta$, $I_\theta$ y futuras coordenadas de fibra | rigideces y tensiones | $A_\theta$ e $I_\theta$ implementados dentro del intervalo publicado; coordenadas de fibra `UNKNOWN` |
| $E_\theta$, $A_\theta$, $I_\theta$ y $R$ | $EA_\theta$, $EI_\theta$, $I_\theta/(A_\theta R^2)$ | resultantes | implementado |
| $P_r$, $P_t$, $R$, razón seccional y malla | $N_\theta$, $M_\theta$, $Q_\theta$ | extremos y módulos posteriores | implementado y auditado |
| $N_\theta$, $M_\theta$ y sección neta | tensión normal de chapa | evaluación posterior | `UNKNOWN` hasta aprobar recuperación global/local |
| resultantes en junta, geometría y ancho tributario | acción de junta | pernos | `UNKNOWN` |
| acción de junta y disposición de pernos | fuerza y tensión nominal por perno | evaluación posterior | `UNKNOWN` |

Regla de propagación: una realización no contendrá simultáneamente un hijo y
los padres que lo determinan. En particular, no se muestrearán juntos:

- $K_0$ y $\phi'$, $\nu_g$, OCR o $\mathrm{OCR}_{\max}$ dentro de una misma
  rama;
- $\sigma'_h$ y el par $K_0$--$\sigma'_v$;
- $A_\theta$, $I_\theta$ o la razón seccional y el espesor del cual se
  derivan;
- el espesor neto y una pérdida de corrosión que lo determine; ni
- tensiones de chapa, acciones de junta o respuestas de pernos, porque son
  salidas del cálculo.

### 27.7 Contrato para Monte Carlo

La especificación probabilística permanecerá separada del cálculo mecánico:

1. una etapa aprobada y auditable genera las realizaciones primitivas;
2. `calculateScenario(realization, context)` evalúa cada fila sin RNG ni I/O;
3. el agregador conserva matrices de $N$, $M$ y $Q$, además de extremos por
   realización;
4. los cuantiles puntuales por ángulo y los cuantiles de extremos espaciales se
   materializan como productos distintos; y
5. la publicación ocurre una vez terminada la corrida.

La malla, las referencias y los datos conocidos se prepararán una sola vez.
Dentro del bucle no se leerán JSON o CSV, no se construirán tablas o figuras y
no se escribirán artefactos. Este contrato permite miles de llamadas sin
convertir el runner documental en el camino crítico.

`runRingMonteCarlo()` ya recibe realizaciones materializadas y mantiene fuera
la selección de distribuciones; ese contrato se conservará inicialmente. La
función de respuesta pasará a adaptar `calculateScenario()` a
`ringDirectResponse` hasta que todos sus consumidores hayan migrado.

La integración directa con 8192 pasos puede dominar el tiempo de una corrida.
No se reemplazará silenciosamente por la solución cerrada ni se introducirá un
operador precalculado antes de medir el costo. Si se habilitan varios métodos,
el método será una entrada explícita con dominio declarado y paridad propia;
no habrá un selector automático oculto.

Continúan `UNKNOWN` la política ante realizaciones fuera de dominio, las
distribuciones, dependencias, probabilidades de modelo, semilla, tamaño de
muestra y criterio de convergencia. El comportamiento inicial por paridad será
detenerse ante el primer error; descartar realizaciones silenciosamente queda
prohibido.

### 27.8 Migración «barco de Teseo»

La compatibilidad del núcleo mecánico seguirá coexistencia acotada de nivel 2.
Los productos determinísticos seguirán paridad de nivel 1. Cada puerta se
implementará en un cambio recuperable separado y conservará el entry point
vigente hasta aprobar la candidata.

#### G0 — Congelar un oráculo recuperable — cerrada

Se clasificó el alcance, se preservó el trabajo ajeno, se registraron los
hashes de 27.2.1 y se creó la instantánea recuperable `4f0d9a8`. Antes de
afirmar paridad byte a byte en una futura ejecución deberán registrarse además
sistema operativo y arquitectura, locale, opciones R relevantes, ruta de
carga, versiones de dependencias y orden de ejecución que gobiernen esa
serialización.

**Puerta satisfecha:** el cálculo vigente puede restaurarse sin depender del
worktree que existía al iniciar el plan. La suite determinística y los hashes
de la Fase 1 fueron verificados antes del commit.

#### G1 — Caracterizar las superficies consumidas — cerrada

Inventariar los consumidores locales, registrar los consumidores externos
como `UNKNOWN` y fijar fixtures inmutables para:

- el escenario vigente con $\alpha=0$ y $\alpha=1$;
- $\alpha=0.5$, agua con signo, tensión vertical modificada y espesor de
  3.1 mm;
- las ramas de $K_0$ adoptada, elástica, Jáky, descarga y recarga;
- presión uniforme, un armónico, una carga con discontinuidad si se toca la
  integración y los controles directo--cerrado--Fourier aplicables; y
- los errores de esquema, dominio, balance e interpolación ya comprobados.

El legado y la candidata se cargarán en entornos separados para evitar
colisiones de nombres. No se creará una grilla masiva que no corresponda a un
consumidor o modo de falla real. La falta de un inventario externo exhaustivo
no bloquea G2--G9 mientras se preserven archivos, firmas y efectos históricos;
sí bloquea el retiro, renombre o promoción de esas superficies.

G1 quedó cerrada sobre el commit recuperable `4f0d9a8`, sin duplicar los CSV de
curvas. El fixture inmutable de entrada es
`scripts/R/fixtures/calculation.g0.json`; el manifiesto
`scripts/R/fixtures/calculation.g0.products.json` fija los SHA-256 de los nueve
productos y la huella del entorno que habilita una comparación byte a byte.
Fuera de esa huella, las pruebas mantienen la comparación semántica de
esquema, tipos, orden, valores y `NA`, sin afirmar identidad de serialización.

La huella registrada comprende R 4.6.0, plataforma
`aarch64-apple-darwin23`, Darwin 25.5.0 arm64, locale
`C.UTF-8/C.UTF-8/C.UTF-8/C/C.UTF-8/C.UTF-8`, opciones `digits = 7` y
`scipen = 0`, `jsonlite` 2.0.0, `openssl` 2.4.2 y la ruta de carga
`/Library/Frameworks/R.framework/Versions/4.6/Resources/library`.

Los consumidores locales observados son:

- la cadena productiva `_master/calculation.review.es.qmd` --
  `_index/calculation.review.ES.qmd` --
  `_results/calculation.results.es.qmd` -- `scripts/setup/setup.R` --
  `buildCalculationData()`;
- `runCalculationMemo.R` y el bloque `_results` como consumidores del efecto
  histórico de `setup.R`;
- `testCalculationData.R` como consumidor directo de
  `buildCalculationData()`, `validateCalculationConfig()` y
  `resolveCalculationK0()`;
- `calculationResults.R`, los builders de tablas y figuras y la prosa numérica
  como consumidores de los productos materializados;
- las pruebas, benchmarks, figuras y ejemplos que consumen
  `calculateRingSection()`, `solveRingDirect()`, `runRingMonteCarlo()`,
  `ringLoad` y `ringDirectResponse`.

Los consumidores externos permanecen `UNKNOWN`; por ello estas superficies no
se retiran ni renombran. `perimeter.loads.csv` tiene pruebas y una ruta expuesta
en `Calculation`, aunque no tenga hoy una inclusión visible en la memoria.

`testCalculationData.R` caracteriza las cinco ramas de $K_0$, el escenario
base, $alpha=0.5$, agua con signo, tensión vertical modificada, espesor de
3.1 mm, publicación por intercambio y los errores de esquema, dominio,
interpolación y control. `testRingMethod.R` conserva presión uniforme, armónico
$n=3$, discontinuidades, balance, comparaciones directa--cerrada--Fourier y
refinamiento. Se agregó paridad numérica por superposición para
$\alpha=0.5$ y valores exactos para la interpolación a 3.1 mm; no se creó una
grilla adicional.

#### G2 — Extraer `estimateK0()` y el estado tensional — cerrada

Separar la selección de rama de la adaptación documental y luego extraer
`calculateEffectiveStressState()`. El productor continuará entrando por
`buildCalculationData()`.

**Puerta:** mismos valores y estados para las cinco ramas, mismos errores de
esquema JSON y dominio, y productos idénticos. `stress.state.csv` y
`calculation.inputs.csv` permanecen idénticos.

La puerta se cerró mediante `scripts/R/k0Models.R` y
`scripts/R/stressState.R`. `estimateK0()` recibe `modelId` y exclusivamente las
variables primitivas de la rama, devuelve el valor aplicado y los controles de
dominio y no incorpora metadatos bibliográficos. `resolveCalculationK0()`
permanece como adaptador compatible de evidencia. El estado tensional efectivo
conserva `horizontalIncrementKPa = NA_real_` cuando el incremento residual es
`unknown-not-modeled`; no sustituye ese desconocimiento por cero. La diferencia
de presión de agua conserva su signo y sólo se transporta hacia las acciones
perimetrales.

Legado `4f0d9a8` y candidata se cargaron en entornos separados. Las cinco ramas
válidas, el error de límite pasivo y los nueve productos de cada rama resultaron
idénticos; bajo la huella G0 la comparación de productos fue byte a byte. Las
pruebas integradas reprodujeron también los nueve SHA-256 canónicos.

Existe una diferencia intencional limitada a llamadas directas malformadas de
la nueva fachada: `estimateK0()` informa modelo no admitido, primitiva faltante,
parámetro ajeno a la rama o valor adoptado fuera de dominio mediante errores
explícitos. El legado producía en esos casos errores incidentales de R. Esta
diferencia no modifica el esquema JSON —que continúa validándose en
`.normaliseK0Model()`—, los errores declarados de dominio, ningún consumidor
local observado ni los productos. Por ello no se presenta como paridad total
de errores fuera del contrato normalizado.

La auditoría funcional concluyó PASS en
`/private/tmp/ar-sad40-g2-functional-audit.md`; la auditoría de políticas R,
interfaces y paridad concluyó PASS en
`/private/tmp/ar-sad40-g2-r-style-audit.md`.

#### G3 — Extraer propiedades seccionales — cerrada

Separar la lectura de la tabla de la interpolación. Conservar
`calculateRingSection()` como única implementación pura de
$E_\theta,A_\theta,I_\theta,R \mapsto EA_\theta,EI_\theta,I_\theta/(A_\theta
R^2)$; no crear una fachada seccional equivalente.

**Puerta:** mismas propiedades, procedencia y errores para 3.0 y 3.1 mm; sin
cambio en `section.properties.csv` ni en las resultantes.

La puerta se cerró mediante
`interpolateCorrugatedSection(reference, profileId, baseThicknessMm)` en
`scripts/R/corrugatedSection.R`. La función recibe una tabla ya cargada,
selecciona el perfil, comprueba el intervalo y la procedencia e interpola
$A_\theta$ e $I_\theta$; no accede a archivos, configuración global, RNG ni
objetos documentales. `readCalculationSection()` conserva su firma, la lectura
CSV y la adaptación al producto. No se creó un segundo helper de lectura ni se
introdujo `data.table`.

`calculateRingSection()` no fue modificado. Legado `80240b9` y candidata se
cargaron en entornos separados: los objetos seccionales para 3.0 y 3.1 mm, los
errores de archivo o columna ausentes, perfil insuficiente, valores inválidos,
duplicados, espesor fuera del intervalo y procedencia discordante fueron
idénticos. Los nueve productos de ambos espesores fueron byte-idénticos; el
caso de 3.0 mm reprodujo además el manifiesto G0.

La prueba durable conserva los dos puntos interiores, los extremos publicados
de 2.65684 y 3.41630 mm con fracciones 0 y 1, los identificadores y la
procedencia, y los modos de falla trasladados. Los consumidores externos de
los archivos R continúan `UNKNOWN`; por ello `readCalculationSection()` se
preserva sin fallback duplicado.

La auditoría independiente de diseño y políticas R concluyó PASS en
`/private/tmp/ar-sad40-g3-section-design-audit.md`; la auditoría independiente
de paridad concluyó PASS en
`/private/tmp/ar-sad40-g3-parity-audit.md`.

La corrida productiva, las pruebas de datos, mecánica, figuras y adaptador
Monte Carlo, y la comparación aislada G2--G3 concluyeron PASS. El render de la
memoria produjo `html/calculation.review.es/index.html`, SHA-256
`c843e32d171093d630fe6d9e2397bc93ab60ff3bfdca0469ca71bb15b0ee6556`;
los nueve productos del manifiesto G0 y la línea base congelada de Fase 1 no
cambiaron.

#### G4 — Extraer malla y acciones perimetrales — cerrada

Separar la preparación invariante de $\theta$, la proyección biaxial y la
adaptación a `perimeter.loads.csv`. Conservar `ringLoad` durante la
coexistencia.

**Puerta:** misma malla, orden, signos, componentes, metadatos, breakpoints y
filas de acciones.

La puerta se cerró mediante dos funciones puras en
`scripts/R/perimeterActions.R`:

- `buildThetaMesh(pointCount, criticalAnglesDeg)` prepara una vez la malla de
  evaluación invariante y conserva exactamente la expresión, el orden y la
  precisión de G3;
- `calculatePerimeterActions(stressState, alpha, theta)` delega la proyección
  física a `biaxialStressTangentialMultiplierLoad()` y la evaluación a
  `evaluateRingLoad()`, y devuelve el mismo `ringLoad` junto con sus ordenadas.

El adaptador interno `.buildPerimeterLoadTable()` conserva en
`calculationData.R` la responsabilidad exclusiva de materializar las filas del
producto. No resuelve cargas ni escribe archivos. `solveRingDirect()`,
`ringLoads.R`, la clase ligera `ringLoad`, los breakpoints y el esquema JSON no
fueron modificados. No se introdujeron `data.table`, clases, un registro de
cargas, gradientes espaciales ni una segunda formulación.

La candidata se comparó contra `e7f807d` en entornos separados. Fueron
idénticos la malla de 728 ordenadas y una malla con ángulo crítico adicional;
la clase, campos, rótulo, procedencia, representación, metadatos, breakpoints y
valores de las acciones para `alpha = 0`, `0.5` y `1`; la respuesta completa
del integrador; y los errores históricos observados. Siete configuraciones
integradas —caso G0, tres valores de `alpha`, tensión vertical modificada,
`K0 = 0.6`, agua con signo, estado isotrópico y orden de casos invertido—
produjeron los mismos nueve archivos byte a byte. Los hashes del manifiesto G0
y la línea base congelada de Fase 1 permanecen inalterados.

Las auditorías independientes concluyeron PASS en
`/private/tmp/ar-sad40-g4-architecture-final-audit.md`,
`/private/tmp/ar-sad40-g4-r-policy-final-audit-v2.md` y
`/private/tmp/ar-sad40-g4-parity-final-audit.md`. Los consumidores externos
continúan `UNKNOWN`; por ello ninguna superficie histórica fue retirada ni
renombrada.

El render final de G4 produjo `html/calculation.review.es/index.html`,
SHA-256
`8b61f6917052400363c1f9d9c09ca49f12911c10210c8eae2ef1c2e33a3bc9ac`.

#### G5 — Exponer la respuesta conjunta de resultantes

Crear `calculateSectionResultants()` como wrapper exacto de
`solveRingDirect()`. No modificar el integrador en esta puerta.

**Puerta:** clase, campos, columnas, orden, valores y diagnósticos idénticos;
los controles analíticos, Fourier y Wolfram aplicables continúan pasando.

#### G6 — Consolidar extremos y controles

Hacer que la corrida determinística y Monte Carlo usen una única
`summarizeSectionResultants()`. Separar los controles cerrados y las escalas
gráficas del cálculo físico.

**Puerta:** mismos desempates —primer índice de la malla—, extremos, signos,
ángulos, unidades y seis controles vigentes.

#### G7 — Componer una realización pura

Crear la secuencia visible de 27.5 y `calculateScenario()` con una realización
y un contexto en memoria.

**Puerta:** cada estado intermedio y la respuesta final coinciden con la
corrida determinística individual; la función no accede al sistema de
archivos, al RNG ni a objetos globales.

#### G8 — Reducir el productor y migrar explícitamente la ejecución

Reducir `buildCalculationData()` a validación, adaptación, llamada al núcleo y
publicación. El entry point final será `runCalculationMemo.R`, que invocará
explícitamente el único productor. El render llamará ese mismo productor desde
su bloque `_results` y después cargará sus productos.

Retirar de `setup.R` su escritura implícita es un cambio de interfaz
intencional, no una paridad invisible. Antes de realizarlo se migrarán y
probarán sus dos consumidores locales observados —`runCalculationMemo.R` y
`_results/calculation.results.es.qmd`—. Mientras los consumidores externos
permanezcan `UNKNOWN`, el efecto histórico se conservará mediante una
superficie de compatibilidad explícita o el archivo no se retirará.

**Puerta:** runner y render alcanzan el mismo productor único; el cambio de
interfaz de `setup.R` tiene una prueba y una relación final declaradas; los
nueve productos son byte-idénticos en el entorno completo requerido por G0 y
registrado para esa comparación, la
publicación por intercambio conserva su rollback, `Calculation` mantiene su
estructura, y tablas, figuras y render contienen los mismos valores.

#### G9 — Conectar el agregador Monte Carlo

Conectar `calculateScenario()` mediante el callback `responseFunction` ya
aceptado por `runRingMonteCarlo()`, sin acoplar el agregador a AR-SAD40 ni
modificar su interfaz. Sólo se modificará el agregador si aparece un requisito
real que el callback no pueda expresar.

**Puerta:** los callbacks legado y candidato reciben los mismos draws y la
misma malla, y producen el mismo orden de muestras, curvas y extremos para un
lote pequeño de control. Ese lote sigue siendo una prueba de software, no un
resultado probabilístico del proyecto.

#### G10 — Incorporar módulos posteriores y promover a librería

Esta puerta se divide en tres aprobaciones independientes:

1. recuperación de tensión normal de chapa;
2. acción de junta y respuesta de pernos; y
3. promoción del núcleo estable a un paquete R bautizado por el usuario.

Ningún submódulo se incorporará para completar una estructura vacía. Cada uno
requiere ecuaciones, unidades, signos, datos, controles y casos de referencia
propios. El paquete sólo recibirá funciones puras y pruebas; JSON, referencias
del proyecto, CSV, Quarto, captions, tablas y figuras permanecerán en
AR-SAD40.

### 27.9 Observables y reglas de paridad

| Superficie | Observable | Regla de comparación |
|---|---|---|
| $K_0$ | rama, primitivas, valor, estado de dominio y errores | identidad de estructura y valores para iguales entradas |
| sección | perfil, filas de referencia, fracción, $A$, $I$, $EA$, $EI$ y razón seccional | identidad mientras se preserve el mismo cálculo y orden |
| acciones | malla, $P_r$, $P_t$, signos, metadatos y orden | identidad estructural y numérica |
| motor | clase, campos, malla, $N$, $M$, $Q$ y diagnósticos | identidad cuando la candidata llama al mismo motor con iguales argumentos |
| extremos | estadístico, signo, ángulo y regla de desempate | identidad |
| productos | nombres, esquemas, tipos, `NA`, filas, IDs, unidades y orden | byte a byte sólo en el entorno completo requerido por G0 y registrado para la ejecución comparada; si éste difiere, comparar tablas y declarar la diferencia de serialización |
| publicación | intercambio completo y restauración ante falla | misma prueba de falla inyectada |
| ejecución | entry point, efectos de `setup.R` y productores alcanzados | cambio intencional auditado en G8; no se presenta como paridad pura |
| memoria | valores, tablas, datos de figuras, citas y referencias cruzadas | pruebas integradas; el HTML no se convierte en contrato byte-exacto |
| Fase 1 | master, index, capítulos y HTML congelados | hashes exactos vigentes |

Las tolerancias actuales pertenecen a controles matemáticos concretos; no son
una tolerancia genérica de refactor. Mientras no cambien algoritmo, orden de
evaluación, precisión ni entorno se exigirá identidad. Si una etapa posterior
cambia el integrador o su orden numérico, la tolerancia de equivalencia será
`UNKNOWN` hasta que una solución cerrada, Fourier, Wolfram u otro oráculo
competente la establezca. Una diferencia funcional deliberada se aprobará y
probará separadamente; nunca se ocultará dentro de una tolerancia.

### 27.10 Puertas técnicas de los módulos futuros

#### 27.10.1 Tensión normal de la chapa

`calculateSheetNormalStress()` estará limitada a la recuperación por
flexo-compresión a partir de $N_\theta$ y $M_\theta$. No incorporará
silenciosamente el efecto de $Q_\theta$ ni una verificación de capacidad.
Antes de implementarla deben aprobarse:

- la convención de signos y las fibras de evaluación;
- las propiedades de la sección neta y su relación con la corrosión;
- la correspondencia entre la sección corrugada equivalente y la tensión
  local que se pretende verificar;
- las coordenadas o módulos resistentes necesarios; y
- un caso de referencia que compruebe la recuperación.

El tratamiento local de $Q_\theta$ permanece `UNKNOWN` y, si corresponde,
pertenecerá a una función separada de tensión cortante.

#### 27.10.2 Junta y pernos

No se calculará una «tensión del perno» dividiendo directamente
$N_\theta$ por un número de pernos. Antes deben definirse:

- orientación y tipo de junta;
- ancho tributario de la resultante;
- número, separación y disposición de pernos;
- excentricidad del solape;
- mecanismo de transferencia y reparto entre filas; y
- componentes de fuerza y áreas resistentes asociadas a la tensión nominal
  que se informará.

`calculateJointDemand()` resolverá la primera transformación y
`calculateBoltResponse()` la segunda. Ambas terminarán en demanda; la
verificación resistente y la capacidad permanecen fuera de esta arquitectura
hasta una etapa posterior.

### 27.11 Estructura de archivos candidata

La extracción podrá materializarse gradualmente con una responsabilidad por
archivo, sin renombrar primero los archivos consumidos:

```text
scripts/R/k0Models.R
scripts/R/stressState.R
scripts/R/corrugatedSection.R
scripts/R/perimeterActions.R
scripts/R/sectionResultants.R
scripts/R/calculationScenario.R
scripts/R/calculationProducts.R
scripts/R/sheetStress.R       # futuro, sólo después de aprobación
scripts/R/boltedJoint.R       # futuro, sólo después de aprobación
```

`ringDirect.R`, `ringLoads.R` y `ringMonteCarlo.R` continuarán como oráculos o
wrappers durante la coexistencia. `calculationProducts.R` y el runner son
adaptadores de AR-SAD40 y no forman parte del núcleo que se promoverá a la
futura librería.

### 27.12 Condiciones para promover el núcleo a un paquete R

La promoción comienza únicamente cuando:

1. las interfaces hayan permanecido estables dentro de AR-SAD40;
2. el usuario haya aprobado nombre, repositorio y superficie pública;
3. los consumidores locales y externos estén inventariados;
4. unidades, signos, dominios, errores y salidas estén documentados;
5. fixtures y controles conserven su clasificación de evidencia;
6. una instalación temporal, las pruebas y `R CMD check` concluyan
   correctamente;
7. AR-SAD40 reproduzca sus productos primero contra el paquete candidato y
   luego contra la superficie final; y
8. el código legado se retire sólo después de la aceptación explícita de la
   relación final paquete--consumidor.

La siguiente acción ejecutiva de este plan es G1. El motor no se editará hasta
que los consumidores locales y los fixtures de caracterización de esa puerta
queden registrados.
