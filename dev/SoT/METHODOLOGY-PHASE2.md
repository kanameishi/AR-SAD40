# Fuente de verdad — memoria de cálculo ejecutiva, Fase 2

**Estado:** G0--G10.2 y G10.7 cerradas; recuperación condicionada de chapa publicada; metodología candidata de shotcrete redactada y auditada; verificaciones resistentes del caso bloqueadas por entradas
**Fecha de corte:** 2026-08-13
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
5. continuar desde la última sección declarada vigente —actualmente 30.5—,
   sin repetir trabajo aprobado.

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
11. sección metálica neta del revestimiento existente, incluidas coordenadas
    firmadas de fibras y regla de agregación de corrosión o picado; y
12. criterio respaldado que habilite la recuperación lineal de tensión frente
    a la curvatura de la sección corrugada.

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
- ninguna tensión del revestimiento existente sin sección neta y criterio de
  aplicabilidad declarados; ninguna capacidad de chapa, junta o perno en
  G10.2;
- ninguna dependencia de FORM/FOSM;
- ninguna promoción pública sin aprobación del usuario.

## 17. Próxima acción histórica

Esta sección registró la acción vigente al cerrar K0.7 y fue sustituida por la
sección 28. No gobierna el trabajo actual. La memoria determinística permanece
en `html/calculation.review.es/index.html`; la simulación probabilística del
caso continúa condicionada a una definición explícita de variables,
marginales y dependencias.

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
- **2026-08-10:** la memoria determinística cerrada en esa fecha termina en
  `N_theta`, `M_theta` y `Q_theta`. La decisión fue ampliada el 12 de agosto
  mediante G10.2 para admitir una recuperación condicional interna; el
  escenario público no produce tensiones mientras falten sus entradas.
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
TITO/kb/paper-candidate/chapters/methodology.tangential.participation.es.md
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

Las tensiones de la chapa y las demandas de pernos son salidas, no variables
aleatorias de entrada. G10.2 adoptó una recuperación normal condicional desde
`N_theta` y `M_theta`; antes de aplicarla al caso deben definirse la sección
neta y la base de curvatura. El tratamiento local de `Q_theta` y la
transferencia a juntas y pernos permanecen `UNKNOWN`.

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

### 21.7 Próxima acción histórica

Esta acción quedó sustituida primero por la sección 22 y finalmente por la
sección 28. Se conserva para documentar la frontera probabilística: no se
asignarán distribuciones antes de acordar las variables, marginales y
dependencias.

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

Como la corrida determinística actual es pequeña, el bloque
`_results/calculation.results.es.qmd` carga las funciones sin efectos y llama
explícitamente al productor al inicio de cada render. El entry point
`scripts/R/runCalculationMemo.R` ejecuta la misma llamada para pruebas y uso
fuera de Quarto. Esta decisión evita resultados obsoletos sin introducir una
caché o un sistema de dependencias prematuro. `scripts/setup/setup.R` conserva
el efecto histórico únicamente como superficie de compatibilidad para
consumidores externos todavía `UNKNOWN`.

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

`calculation.json`, con `schemaVersion = 2.0.0`, es la fuente única de entradas
adoptadas de la corrida. Cada estado selecciona exactamente una rama de
$K_0$ y declara sólo sus variables primitivas. Los identificadores son:

| `modelID` | Variables declaradas | Estado |
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
ningún consumidor la reconstruye a partir de `caseID`, que es un identificador
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
de $\alpha$ utiliza deliberadamente un `caseID` no numérico y atraviesa tablas
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
   son módulos posteriores que consumen las resultantes. G10.2 habilitó la
   recuperación normal como función condicional; su conexión al caso continúa
   bloqueada por las entradas `UNKNOWN`. Juntas y pernos permanecen sólo como
   fronteras reservadas.
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
    letra minúscula. Las siglas establecidas conservan su caja convencional:
    `modelID`, `ScenarioID`, `OpenSSLAvailable`; no se convierten
    mecánicamente en `Id` o `Ssl`. No se codifican tipos ni estados
    transitorios en los nombres.
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
- al cierre de G9 no existían funciones aprobadas para tensiones locales de la
  chapa, demanda de una junta o respuesta de pernos. G10.2 agregó después una
  recuperación normal circunferencial homogeneizada y condicional, sin
  modificar este oráculo.

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
| `estimateK0()` | seleccionar una rama y evaluar $K_0$ | `modelID` y sólo las variables primitivas de esa rama | valor aplicado, estado de dominio y magnitudes de control | extraer de `resolveCalculationK0()`; las ecuaciones `k0*()` vigentes se preservan |
| `calculateEffectiveStressState()` | formar el estado efectivo aplicado | $\sigma'_v$, resultado de `estimateK0()`, diferencia de presión de agua y estado explícito del incremento horizontal | $\sigma'_{h,b}=K_0\sigma'_v$, componente horizontal aplicada y metadatos del incremento | nueva frontera sobre lógica hoy embebida |
| `interpolateCorrugatedSection()` | obtener $A_\theta$ e $I_\theta$ desde una referencia ya cargada | tabla, perfil y espesor de análisis | propiedades e información de interpolación | extraer de `readCalculationSection()` |
| `calculateRingSection()` | obtener rigideces circunferenciales | $E_\theta$, $A_\theta$, $I_\theta$ y $R$ | $EA_\theta$, $EI_\theta$ y $I_\theta/(A_\theta R^2)$ | función pura vigente; conserva la implementación y la firma |
| `calculatePerimeterActions()` | proyectar el estado tensional sobre el contorno | estado tensional, $\alpha$ y $\theta$ | $P_r(\theta)$, $P_t(\theta)$ y representación compatible con el motor | envolver la proyección biaxial vigente |
| `calculateSectionResultants()` | resolver equilibrio y compatibilidad | acciones, $R$, razón seccional, malla y parámetros numéricos | una única tabla con $N_\theta$, $M_\theta$, $Q_\theta$ y diagnósticos | envolver `solveRingDirect()`; no se divide por resultante |
| `summarizeSectionResultants()` | localizar extremos espaciales | respuesta conjunta de resultantes | mínimos, máximos y máximos absolutos, con signo y ángulo | consolidar tres implementaciones duplicadas |
| `calculateScenario()` | componer una realización | una fila de primitivas y un contexto invariante | etapas anteriores, resultantes, extremos y diagnósticos | nueva función delgada; no contiene ecuaciones propias |
| `calculateSheetNormalStress()` | recuperar tensión normal circunferencial homogeneizada por flexocompresión | $N_\theta$, $M_\theta$, propiedades netas, coordenadas firmadas de fibra y base de aplicabilidad | campo de tensión por ángulo y fibra, o `NA` cuando la base no habilita el modelo | implementada condicionalmente en G10.2; no conectada al escenario actual |
| `calculateJointDemand()` | transformar las resultantes en acciones transmitidas por una junta | resultantes en la junta, ancho tributario y geometría | acciones de la unión | futuro; transferencia pendiente |
| `calculateBoltResponse()` | distribuir la acción de junta en el grupo de pernos | acción de junta, disposición, áreas y modelo de reparto | fuerza por perno y componentes nominales de tensión | futuro; modelo y datos pendientes |

`estimateK0()` será la fachada única solicitada para el cálculo. Las funciones
por formulación continuarán siendo unidades pequeñas y comprobables; durante
la migración conservarán sus nombres existentes para no romper consumidores.
La fachada aplicará una exclusión de tipo `oneOf`: no aceptará parámetros de
ramas que no correspondan al `modelID` seleccionado. El adaptador de
`calculation.json` usa `modelID`, de acuerdo con la política vigente de siglas,
y esa ortografía se conserva en el núcleo R.

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

Cuando las entradas y dominios de cada módulo estén aprobados, se agregarán
aguas abajo. La primera función existe ya como frontera condicional:

```r
SheetNormalStress <- calculateSheetNormalStress(...)
JointDemand <- calculateJointDemand(...)
BoltResponse <- calculateBoltResponse(...)
```

`calculateScenario()` ejecuta actualmente hasta `ResultantExtrema`. Cuando se
aprueben las entradas netas, incorporará `calculateSheetNormalStress()` como
etapa aguas abajo; no duplicará su ecuación. Mientras tanto, la función queda
disponible para controles sintéticos y no altera las siete salidas vigentes de
una realización.

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
| `modelID` y $K_0$ adoptado, o $\phi'$, o $\nu_g$, o $\phi'$--OCR, o $\phi'$--OCR--$\mathrm{OCR}_{\max}$ | $K_0$ | $\sigma'_h$ | implementado por ramas; el esquema vigente usa `modelID` |
| $K_0$ y $\sigma'_v$ | $\sigma'_{h,b}=K_0\sigma'_v$ | acciones perimetrales | implementado |
| modelo residual aprobado y sus primitivas | $\Delta\sigma'_{h,c}$ | estado tensional | `UNKNOWN`; no se sustituye por una constante inventada |
| $\sigma'_v$, $\sigma'_h$, diferencia de agua y $\alpha$ | $P_r(\theta)$ y $P_t(\theta)$ | resultantes | implementado para el estado biaxial uniforme prescrito |
| espesor original y un modelo o medición de pérdida por corrosión | espesor neto $t_{net}$ | propiedades netas | `UNKNOWN`; hoy se usa un espesor de análisis adoptado |
| perfil, referencia y espesor de análisis o neto | $A_\theta$, $I_\theta$ y futuras coordenadas de fibra | rigideces y tensiones | $A_\theta$ e $I_\theta$ implementados dentro del intervalo publicado; coordenadas de fibra `UNKNOWN` |
| $E_\theta$, $A_\theta$, $I_\theta$ y $R$ | $EA_\theta$, $EI_\theta$, $I_\theta/(A_\theta R^2)$ | resultantes | implementado |
| $P_r$, $P_t$, $R$, razón seccional y malla | $N_\theta$, $M_\theta$, $Q_\theta$ | extremos y módulos posteriores | implementado y auditado |
| $N_\theta$, $M_\theta$, sección neta, fibras y base de aplicabilidad | tensión normal circunferencial homogeneizada de chapa | evaluación posterior | función condicional implementada; resultado del revestimiento actual `UNKNOWN` |
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
`scripts/R/stressState.R`. `estimateK0()` recibe `modelID` y exclusivamente las
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
`interpolateCorrugatedSection(reference, profileID, baseThicknessMm)` en
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

#### G5 — Exponer la respuesta conjunta de resultantes — cerrada

Crear `calculateSectionResultants()` como wrapper exacto de
`solveRingDirect()`. No modificar el integrador en esta puerta.

**Puerta:** clase, campos, columnas, orden, valores y diagnósticos idénticos;
los controles analíticos, Fourier y Wolfram aplicables continúan pasando.

La puerta se cerró mediante `calculateSectionResultants()` en
`scripts/R/sectionResultants.R`. La función conserva exactamente los siete
parámetros, su orden y sus expresiones por defecto, y devuelve directamente el
objeto producido por `solveRingDirect()`. No reconstruye campos, no intercepta
errores, no agrega validaciones y no modifica el integrador ni la clase
`ringDirectResponse`.

El único consumidor productivo migrado es `buildCalculationData()`; los
controles analíticos, comparaciones y adaptadores que aún llaman directamente
a `solveRingDirect()` se conservan como oráculos durante la coexistencia. Los
consumidores externos permanecen `UNKNOWN`, por lo que ninguna superficie
histórica fue retirada o renombrada.

La candidata se comparó contra `db24bad` en entornos separados. Fueron
idénticos los objetos completos para presión uniforme, tres valores de
`alpha`, una carga armónica, una banda discontinua con breakpoint y una carga
desbalanceada admitida; también coincidieron exactamente doce errores
históricos. Siete variantes integradas conservaron la configuración y los
nueve productos byte a byte, incluidos el orden de casos, los controles y las
escalas. `ringDirect.R` y `ringLoads.R` permanecieron byte-idénticos.

Las auditorías independientes concluyeron PASS en
`/private/tmp/ar-sad40-g5-architecture-final-audit.md`,
`/private/tmp/ar-sad40-g5-r-policy-final-audit.md` y
`/private/tmp/ar-sad40-g5-parity-final-audit.md`. No se introdujeron
`data.table`, clases, registros de motores, fallbacks ni controles nuevos.

El render final de G5 produjo `html/calculation.review.es/index.html`,
SHA-256
`752efef360a6fdc585815c97d9eb5a46fd23998a1253144befb28a988da93f33`.
Los nueve productos del manifiesto G0 y los trece archivos de la línea base
congelada de Fase 1 permanecen idénticos.

#### G6 — Consolidar extremos y controles — cerrada

Hacer que la corrida determinística y Monte Carlo usen una única
`summarizeSectionResultants()`. Separar los controles cerrados y las escalas
gráficas del cálculo físico.

**Puerta:** mismos desempates —primer índice de la malla—, extremos, signos,
ángulos, unidades y seis controles vigentes.

La puerta se cerró mediante `summarizeSectionResultants(response)`, ubicada
junto a `ringDirectResponse` en `scripts/R/ringDirect.R`. La función localiza
en una respuesta conjunta los mínimos, máximos y máximos absolutos de `N`, `M`
y `Q`; conserva el signo y el ángulo de la ordenada elegida y mantiene como
desempate el primer índice de la malla. No conoce unidades, casos, muestras,
tolerancias, archivos ni opciones gráficas. `summarizeRingGrid()` conserva su
nombre y firma histórica y delega en esta única implementación.

La corrida determinística adapta el resumen mediante
`.buildSectionExtremaTable()`. Monte Carlo usa la misma función para cada
realización y agrega después `sampleID`; no cambia la generación de cuantiles
ni incorpora distribuciones. Los contrastes contra la solución cerrada y las
escalas de representación permanecen fuera del resumen físico, aislados en
`.buildResultantControlTable()` y `.buildDisplayScaleTable()`.

La candidata se comparó contra `7ca14f2` en entornos separados. Un fixture con
empates verificó exactamente el primer índice, el signo y los ángulos; tres
respuestas físicas verificaron `alpha = 0`, `0.5` y `1`. La corrida Monte Carlo
de control, sus tres tablas, seis variantes determinísticas y los nueve
productos resultaron idénticos. Una tolerancia cerrada de `1e-16` conservó el
mismo error y no dejó un directorio parcial. Los tres productos propios de la
puerta mantuvieron sus hashes G0:

- `section.extrema.csv`:
  `6881e17589fd53c65676c2826d5c96948580f3c37d2e8a270bf2e7e0eb40f014`;
- `numerical.controls.csv`:
  `be43a911b0b3b3af6334e61e3ca40909b1ef3858b4d01254ee0037f93791c5e3`;
- `display.scales.csv`:
  `08b3222ce5b947783293a37a8c888276c729ef83ce968505e8b80f2d6198cc6b`.

Las auditorías independientes concluyeron PASS en
`/private/tmp/ar-sad40-g6-architecture-final-audit.md`,
`/private/tmp/ar-sad40-g6-r-policy-final-audit-v2.md` y
`/private/tmp/ar-sad40-g6-parity-final-audit.md`. No se introdujeron
`data.table`, clases, registros, políticas probabilísticas ni cambios al
integrador, Fourier o las formulaciones de carga.

El render final de G6 produjo `html/calculation.review.es/index.html`,
SHA-256
`81951d0f0d50b9a0bff09ae5faee869fe1eeecc97b1694f21cc1176c8033805e`.
Los nueve productos G0 y los trece archivos de la línea base congelada de
Fase 1 permanecen idénticos.

#### G7 — Componer una realización pura — cerrada

Crear la secuencia visible de 27.5 y `calculateScenario()` con una realización
y un contexto en memoria.

**Puerta:** cada estado intermedio y la respuesta final coinciden con la
corrida determinística individual; la función no accede al sistema de
archivos, al RNG ni a objetos globales.

La puerta se cerró mediante `calculateScenario(realization, context)` en
`scripts/R/calculateScenario.R`. La realización contiene las primitivas que
pueden variar entre evaluaciones y el contexto contiene la geometría, la malla,
la referencia seccional ya cargada y los parámetros numéricos invariantes. La
función compone, en este orden, `estimateK0()`,
`calculateEffectiveStressState()`, `interpolateCorrugatedSection()`,
`calculateRingSection()`, `calculatePerimeterActions()`,
`calculateSectionResultants()` y `summarizeSectionResultants()`. Su retorno
expone los siete estados con los nombres `k0State`, `stressState`,
`corrugatedSection`, `sectionRigidity`, `perimeterActions`,
`sectionResultants` y `resultantExtrema`.

La implementación no lee ni escribe archivos, no genera números aleatorios,
no consulta opciones o rutas de sesión y no modifica sus argumentos. Las
validaciones nuevas se limitan a la frontera de las dos listas nombradas; las
restricciones físicas y los mensajes de error continúan bajo responsabilidad
de las funciones que ya los resolvían. No se introdujeron clases, registros,
despacho, `data.table` ni ecuaciones alternativas.

La candidata se comparó contra `8d68814` en entornos R separados. Tres
realizaciones cubrieron la rama constante, Jaky normalmente consolidado y la
recarga de Mayne--Kulhawy, con variaciones de agua, espesor y `alpha`. Cada
estado intermedio, las cargas evaluadas, los diagnósticos, las resultantes y
los extremos fueron idénticos. También se preservaron los errores de dominio
pasivo, espesor fuera de la tabla y `alpha > 1`, los argumentos recibidos, el
estado del RNG y la ausencia de archivos temporales.

Como control de la futura conexión, `calculateScenario()` se usó desde el
callback vigente de Monte Carlo con y sin conservación de curvas; objetos,
orden de muestras y productos fueron idénticos a la secuencia anterior. Esta
prueba no conecta todavía el agregador ni define una simulación del proyecto.
Asimismo, seis variantes integradas conservaron byte a byte los nueve
productos G0. `buildCalculationData()` y `runRingMonteCarlo()` permanecen sin
cambios; sus migraciones continúan reservadas para G8 y G9.

Las auditorías independientes concluyeron PASS en
`/private/tmp/ar-sad40-g7-architecture-final-audit.md`,
`/private/tmp/ar-sad40-g7-r-policy-final-audit-v2.md` y
`/private/tmp/ar-sad40-g7-parity-final-audit.md`. La auditoría de política R
detectó inicialmente dos calificadores temporales en la prueba; fueron
reclasificados como expectativas y la reauditoría quedó sin hallazgos.

El render final de G7 produjo `html/calculation.review.es/index.html`,
SHA-256
`cabccb0cbdc05cceaf76d061fd4be285cd1e48acec358ea233d5a007dc7bc1d6`.
Los nueve productos G0 y los trece archivos de la línea base congelada de
Fase 1 permanecen idénticos.

#### G8 — Reducir el productor y migrar explícitamente la ejecución — cerrada

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

G8 se ejecuta mediante tres puntos recuperables. G8.1 quedó cerrada al separar
la carga en `scripts/setup/calculationFunctions.R`. Este archivo conserva el
orden de las diez fuentes vigentes y no lee configuración, no ejecuta el
productor y no crea `CalculationRun` ni `Calculation`. `setup.R` delega esa
carga con `local = TRUE` y conserva después su default de `projectRoot`, la
llamada histórica a `buildCalculationData()` y la asignación de
`CalculationRun`. El uso `source(setup.R, local = E)` permanece compatible;
los consumidores externos continúan `UNKNOWN`, por lo que el wrapper no se
retira ni se vuelve inerte.

`scripts/R/testCalculationLoading.R` comprueba separadamente la carga sin
efectos y el wrapper compatible, tanto en el ambiente global como en uno
explícito. La carga no modificó los nueve productos ni el estado del RNG; el
wrapper produjo el mismo retorno y los nueve hashes G0. Las auditorías finales
concluyeron PASS en
`/private/tmp/ar-sad40-g8-1-r-final-audit.md` y
`/private/tmp/ar-sad40-g8-1-compat-final-audit-v2.md`. La primera auditoría de
compatibilidad había detectado la pérdida del ambiente explícito; el uso de
`local = TRUE` y el nuevo caso de prueba resolvieron ese hallazgo antes del
cierre.

G8.2 quedó cerrada al sustituir exclusivamente el interior del productor para
consumir `calculateScenario()` una vez por caso y adaptar sus siete estados.
No modificó el runner ni el bloque `_results`, conservó la firma y el retorno
de `buildCalculationData()`, la publicación por intercambio, los errores
contractuales seleccionados y los nueve productos G0 byte a byte. Las
reauditorías de naming, arquitectura y paridad concluyeron PASS en
`/private/tmp/ar-sad40-g8-2-naming-scoped-reaudit.md`,
`/private/tmp/ar-sad40-g8-2-architecture-reaudit.md` y
`/private/tmp/ar-sad40-g8-2-parity-reaudit.md`.

G8.3 quedó cerrada al migrar los dos consumidores locales a una llamada
explícita del productor. `runCalculationMemo.R` y
`_results/calculation.results.es.qmd` cargan `calculationFunctions.R` sin
efectos y llaman una vez a `buildCalculationData()`; el bloque documental
carga después `calculationResults.R` para formar `Calculation`. `setup.R`
permanece byte-idéntico y conserva `CalculationRun` como compatibilidad para
consumidores externos todavía `UNKNOWN`.

La corrección de nombres de G8.3 se limitó a los parámetros y locales internos
de `calculationResults.R`; las columnas históricas `...Id` y el objeto
`Calculation` permanecieron idénticos en esa puerta. Las seis pruebas pertinentes, el render,
los nueve productos G0 y la línea base congelada de Fase 1 concluyeron sin
cambios. La auditoría independiente final concluyó PASS en
`/private/tmp/ar-sad40-g8-3-final-audit.md`. Las superficies Monte Carlo y la
interfaz gráfica de NGR conservan puertas propias.

Durante G8.2 se detectó una aplicación incorrecta de la política de siglas en
las superficies puras creadas por G2, G3 y G7. La corrección pertenece a esta
misma puerta: el núcleo y sus listas en memoria usan `modelID`, `profileID`,
`k0ModelID`, `ScenarioID`, `sectionID` y `stressStateID`; durante G8.2 los
adaptadores conservaron las claves y columnas históricas `...Id` de
`calculation.json`, la referencia seccional y los nueve productos G0. Esa fue
una restricción acotada de G8.2, no una excepción permanente a la política de
nombres.

#### G9 — Conectar el agregador Monte Carlo — cerrada

Conectar `calculateScenario()` mediante el callback `responseFunction` ya
aceptado por `runRingMonteCarlo()`, sin acoplar el agregador a AR-SAD40 ni
modificar su interfaz. Sólo se modificará el agregador si aparece un requisito
real que el callback no pueda expresar.

**Puerta:** los callbacks legado y candidato reciben los mismos draws y la
misma malla, y producen el mismo orden de muestras, curvas y extremos para un
lote pequeño de control. Ese lote sigue siendo una prueba de software, no un
resultado probabilístico del proyecto.

El 12 de agosto de 2026 el usuario rechazó expresamente la excepción histórica
`...Id`. La puerta G9 incorpora por ello una migración declarada del esquema:
`schemaVersion = 2.0.0`, claves de configuración, columnas, referencia
seccional, parámetros R y productos Monte Carlo usan el sufijo `ID`. Los
fixtures `calculation.g0.*` preservan el oráculo histórico de la versión 1.0.0;
`calculation.schema.*` fija la versión vigente. La comparación contra
`953e0c7` normaliza exclusivamente `Id` a `ID` y la versión de esquema; exige
identidad de estructura restante, tipos, valores, filas, orden, signos,
ángulos, diagnósticos y cuantiles. No existe una capa de compatibilidad que
acepte ambas grafías.

G9 quedó cerrada al adaptar `calculateScenario()` al argumento
`responseFunction` de `runRingMonteCarlo()`. El lote fijo de tres realizaciones
se evaluó mediante el callback histórico por etapas y mediante el callback
candidato; ambos produjeron objetos completos idénticos, incluidas las
realizaciones recibidas, diagnósticos, curvas conservadas, cuantiles puntuales,
extremos y cuantiles de extremos. El agregador no conoce AR-SAD40, archivos,
configuración documental, distribuciones ni generación aleatoria. Este lote es
un control determinístico de software y no una simulación probabilística del
proyecto.

La migración nominal también alcanzó los atributos activos de representación:
`ringCaseIDs` en el prototipo de AR-SAD40 y `sectionCaseIDs` en
`NGR::buildSectionResultantsPlot()`. No se mantuvo un alias con la grafía
anterior. La fuente de NGR corregida fue comprobada mediante su prueba enfocada
y el instalador oficial, y el consumidor de AR-SAD40 se ejecutó contra esa
instalación. La publicación Git de NGR permanece como efecto independiente;
esta puerta no la ejecuta ni la presenta como terminada.

Las comparaciones de paridad concluyeron PASS en
`/private/tmp/ar-sad40-g9-parity-reaudit.md` y la auditoría integrada de
arquitectura, esquema y nombres concluyó PASS en
`/private/tmp/ar-sad40-g9-r-architecture-final-audit.md`. El render vigente de
la memoria tiene SHA-256
`1b297dc09b81f99fc4f0a4341f37b6ba862a556fd8bace15807bec00c36df0f2`.
La ejecución Wolfram permanece `UNKNOWN` porque no existe un kernel configurado;
los cambios nominales en `.wl` y `.nb` no se presentan como una comprobación
ejecutada.

#### G10 — Alcance histórico, ampliado por la sección 28

Esta definición registró el alcance antes de abrir las investigaciones
geotécnica y de hormigón proyectado. La sección 28 la sustituye y divide G10
en siete puertas. Las tres aprobaciones originales eran:

1. recuperación de tensión normal de chapa;
2. acción de junta y respuesta de pernos; y
3. promoción del núcleo estable a un paquete R bautizado por el usuario.

Ningún submódulo se incorporará para completar una estructura vacía. Cada uno
requiere ecuaciones, unidades, signos, datos, controles y casos de referencia
propios. El paquete sólo recibirá funciones puras y pruebas; JSON, referencias
del proyecto, CSV, Quarto, captions, tablas y figuras permanecerán en
AR-SAD40.

El 12 de agosto de 2026 se autorizaron tres investigaciones independientes,
sin implementación: verificación normativa de la chapa corrugada con espesor
neto; ampliación de la caracterización de $K_0$, compactación y cementación; y
verificación de una sección de shotcrete/hormigón por metro con armadura que
puede ser nula. Sus resultados son evidencia candidata. No habilitan funciones,
resultados ni texto público hasta completar los ledgers, resolver los datos
`UNKNOWN` y obtener la aceptación técnica del usuario.

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

`calculateSheetNormalStress()` está limitada a la recuperación por
flexo-compresión a partir de $N_\theta$ y $M_\theta$. No incorpora
silenciosamente el efecto de $Q_\theta$ ni una verificación de capacidad. La
función fue habilitada como cálculo condicional: recibe explícitamente las
propiedades netas, las coordenadas de las fibras y una base de aplicabilidad.
La convención de signos, las dos fibras y el control sintético de
flexo-compresión están definidos. Para conectarla al escenario deben aprobarse:

- las propiedades de la sección neta y su relación con la corrosión;
- las coordenadas reales de las fibras netas;
- la correspondencia entre la tensión normal circunferencial homogeneizada y la magnitud
  que se pretende verificar; y
- el criterio respaldado de aplicabilidad frente a la curvatura.

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
scripts/R/calculateScenario.R
scripts/R/calculationData.R       # adaptador y productor de AR-SAD40
scripts/R/sheetStress.R       # recuperación condicional de G10.2
scripts/R/boltedJoint.R       # futuro, sólo después de aprobación
```

`ringDirect.R`, `ringLoads.R` y `ringMonteCarlo.R` continuarán como oráculos o
wrappers durante la coexistencia. `calculationData.R` y el runner son
adaptadores de AR-SAD40 y no forman parte del núcleo que se promoverá a la
futura librería. No se creará `calculationProducts.R` sin una responsabilidad
real que no pueda permanecer en el productor vigente.

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

G0--G9 están cerradas. Esta declaración abrió G10.1; la sección 28.5 registra
su cierre y la acción vigente. Ningún módulo resistente se implementará antes
de que su evidencia, dominio, variables, unidades, signos y controles alcancen
la puerta indicada allí.

## 28. Estado vigente y ejecución de G10

Esta sección sustituye las frases de «próxima acción» anteriores y gobierna la
continuación solicitada el 12 de agosto de 2026. El commit `cdb6a93`, publicado
en `origin/main`, cierra G9: el esquema activo es 2.0.0, los identificadores
propios usan `ID`, el productor determinístico y el agregador por realizaciones
consumen `calculateScenario()` y no se han definido distribuciones ni ejecutado
una simulación probabilística del caso. El commit `4eb4b11`, también publicado
en `origin/main`, cierra G10.1 y preserva mediante Git LFS las cuatro fuentes
CIRSOC autorizadas. El commit `f45aecd`, publicado en `origin/main`, cierra
G10.2. La función permanece desconectada del escenario hasta resolver sus
entradas obligatorias.

### 28.1 Alcance de G10

G10 incorpora únicamente módulos cuya formulación y evidencia hayan sido
aprobadas. Se divide en siete puertas independientes:

1. **G10.1 — evidencia:** cerrar por auditoría cruzada las ramas de chapa,
   $K_0$/compactación/cementación y shotcrete;
2. **G10.2 — chapa:** recuperar tensiones globales desde las resultantes y,
   en una puerta separada, efectuar las verificaciones resistentes admitidas;
3. **G10.3 — estado horizontal del relleno:** ampliar las funciones existentes
   sólo cuando una formulación de compactación o cementación tenga dominio,
   entradas y consumidor definidos;
4. **G10.4 — shotcrete/hormigón:** verificar una franja por flexocompresión y
   corte únicamente después de resolver la aplicabilidad normativa y la
   clasificación de la sección;
5. **G10.5 — juntas y pernos:** transformar las resultantes en acciones de
   junta y luego en demanda por perno después de definir geometría y mecanismo
   de transferencia; y
6. **G10.6 — librería:** promover sólo el núcleo estable después de aprobar su
   nombre, superficie pública y relación final con AR-SAD40; y
7. **G10.7 — documentación y control Wolfram:** después de implementar las
   ramas aceptadas, comprobar su incorporación a la metodología interna y
   recuperar un notebook legible para contrastar un escenario fijo contra R.

Las puertas 2--5 no forman una entrega indivisible. Cada una conserva sus
propios datos `UNKNOWN`, controles y decisión de aceptación. No se crearán
clases generales, despachadores multirreglamento, ramas vacías ni funciones sin
un consumidor real.

### 28.2 G10.1 — cierre de evidencia

Las tres investigaciones preliminares son candidatos internos; no constituyen
texto público ni especificaciones de implementación.

| Rama | Estado de cierre | Resultado y límites vigentes |
|---|---|---|
| chapa corrugada | `PASS` de auditoría cruzada | candidata preservada; producto, articulado normativo, criterio de curvatura, condición longitudinal, modelo de corte y datos resistentes permanecen `UNKNOWN` |
| $K_0$, compactación y cementación | `PASS` de auditoría cruzada | funciones vigentes confirmadas; persistencia FHWA, presión residual aplicable y rama cuantitativa de cementación permanecen `UNKNOWN` |
| shotcrete/hormigón | `PASS` de auditoría cruzada | candidata preservada; aplicabilidad reglamentaria, jurisdicción, clasificación de la sección y datos resistentes del caso permanecen `UNKNOWN` |

Una rama alcanza G10.1 sólo con un documento candidato corregido, una auditoría
independiente `PASS`, un registro de ecuaciones y una lista explícita de datos
que siguen `UNKNOWN`. El `PASS` autoriza presentar la formulación al usuario;
no equivale por sí mismo a adoptarla para el caso ni a publicarla en la memoria.

El registro compacto de ecuaciones, entradas, unidades, dominio y controles de
las tres ramas está en `TITO/kb/research/g10.equations.register.es.md`.

#### 28.2.1 Chapa corrugada — evidencia cerrada

La investigación corregida y su auditoría independiente se preservan en:

- `TITO/kb/research/g10.corrugated.steel.verification.es.md`; y
- `TITO/kb/research/g10.corrugated.steel.verification.audit.es.md`.

La auditoría concluyó `PASS`: la recuperación lineal desde $N_\theta$ y
$M_\theta$ queda condicionada por un control respaldado de curvatura; no se
inventó un umbral; $Q_\theta$ permanece como resultante sin una distribución
de corte aprobada; y la tensión equivalente queda bloqueada hasta cerrar la
condición longitudinal. El ejemplo USACE 1997 sólo se admite como reproducción
histórica de su corriente SI y conserva sus discrepancias imperiales.

Permanecen `UNKNOWN` la familia exacta del producto, la base normativa y su
articulado vigente, la geometría y orientación de la corrugación, el criterio
de viga curva, el mapa de espesor neto, el grado de acero, el modelo local de
corte, la condición longitudinal y los estados límite obligatorios. Por ello,
el usuario habilitó G10.2 únicamente para implementar la recuperación mecánica
condicional; esos datos continúan bloqueando su aplicación al revestimiento y
toda comprobación resistente.

#### 28.2.2 Estado horizontal y compactación — evidencia cerrada

La investigación corregida y su auditoría independiente se preservan en:

- `TITO/kb/research/g10.k0.compaction.es.md`; y
- `TITO/kb/research/g10.k0.compaction.audit.es.md`.

La auditoría concluyó `PASS`: $K_0$, la acción equivalente FHWA, una eventual
tensión residual y la interacción suelo--conducto permanecen como objetos
distintos. La regla de persistencia o transición entre incrementos FHWA es
`UNKNOWN`; ocho filas de la tabla 5.5 se reproducen y la novena discrepancia se
conserva sin corrección silenciosa. No se proponen distribuciones de Monte
Carlo ni una corrección genérica por cementación.

Esta rama no exige una nueva implementación. `estimateK0()`,
`calculateEffectiveStressState()`, `fhwaCompactionPressure()` y
`fhwaCompactionBandLoad()` ya materializan las responsabilidades admisibles.
No se creará un helper duplicado ni se ampliará la API sin un consumidor real
y una formulación aplicable. La presión residual, la secuencia constructiva
acumulativa y la cementación cuantitativa permanecen diferidas.

#### 28.2.3 Hormigón proyectado — evidencia cerrada

La investigación corregida y su auditoría independiente se preservan en:

- `TITO/kb/research/g10.shotcrete.section.verification.es.md`; y
- `TITO/kb/research/g10.shotcrete.section.verification.audit.es.md`.

La auditoría concluyó `PASS` para la trazabilidad reglamentaria, la
clasificación explícita de la sección, la separación entre resistencia
efectiva de producción y resistencia especificada equivalente de una
estructura existente, la distinción de vía húmeda y vía seca, el sistema
N--mm--MPa y los controles numéricos B1--B2. Las cuatro fuentes oficiales se
preservaron y registraron en `TITO/kb/MANIFEST.md`.

Este cierre no selecciona una norma para el proyecto. Permanecen `UNKNOWN`:

- la jurisdicción, adhesión y base contractual aplicables;
- la aplicación de CIRSOC 201-25 al revestimiento frente a su exclusión de
  cáscaras delgadas y la función específica de CIRSOC 804-4;
- la clasificación reglamentaria de la sección y sus mínimos;
- el proceso de colocación, la función estructural y la condición compuesta o
  independiente respecto de la chapa;
- el espesor resistente, las armaduras y su detallado;
- la resistencia especificada equivalente y su evidencia estadística; y
- las acciones de cálculo y servicio que alimentarán las verificaciones.

Por estas condiciones, G10.4 está documentada pero bloqueada para
implementación y resultados del caso hasta la aceptación técnica del dominio
y la resolución de sus entradas obligatorias.

### 28.3 G10.2 — secuencia mínima para la chapa

La recuperación de demanda y la comprobación resistente son operaciones
distintas:

1. definir la sección neta y la geometría radial efectiva;
2. recuperar la tensión circunferencial debida a $N_\theta$ y $M_\theta$ con
   el modelo de sección aprobado;
3. mantener $Q_\theta$ como resultante mientras no exista una distribución de
   flujo cortante aplicable;
4. cerrar la condición constitutiva longitudinal antes de calcular una tensión
   equivalente; y
5. evaluar estados límite sólo con la norma, edición, clase de producto,
   factores y propiedades resistentes aprobados.

La primera función no mezcla demanda y capacidad.
`calculateSheetNormalStress()` implementa

$$
\sigma_\theta=\frac{N_\theta}{\bar A_n}
-1000\frac{M_\theta y}{\bar I_n},
$$

para $N_\theta$ en kN/m, $M_\theta$ en kN·m/m, $\bar A_n$ en
mm²/mm, $\bar I_n$ en mm⁴/mm y $y$ en mm; la tensión se obtiene en MPa.
La convención adoptada es $N_\theta>0$ a tracción, $y>0$ radialmente hacia
afuera y $M_\theta>0$ comprimiendo la fibra positiva. La función devuelve
`NA` cuando la aplicabilidad del modelo lineal es `unknown` o
`not-satisfied`; no infiere una formulación de viga curva.

Una comprobación resistente posterior podrá consumir este resultado sólo
después de cerrar la sección neta y la base normativa. No se informará un
factor de seguridad global cuando falte un estado límite obligatorio.

### 28.4 G10.3 y G10.4 — extensiones independientes

La ampliación geotécnica conservará una sola familia de funciones para la
acción FHWA existente. La acción equivalente de construcción, una presión
residual y una rama de $K_0$ continúan siendo objetos diferentes; no se sumarán
ni transformarán entre sí sin una relación sustentada. No se asignarán
distribuciones de Monte Carlo durante esta puerta.

El módulo de shotcrete será una rama estructural alternativa o adicional sólo
después de decidir si actúa como sección autónoma o compuesta con la chapa. La
acción compuesta requiere otra formulación y no se inferirá. Una sección con
armadura nula no se clasificará automáticamente como hormigón simple: la clase
reglamentaria, los mínimos y el detallado gobiernan la selección.

### 28.5 Orden de ejecución y aceptación

1. corregir y reauditar las tres investigaciones de G10.1;
2. registrar en esta SoT únicamente los hallazgos que alcancen `PASS`;
3. presentar al usuario las formulaciones candidatas, sus límites y los datos
   `UNKNOWN` que modifican el resultado;
4. implementar una sola rama aprobada por vez mediante funciones puras,
   fixtures y paridad contra controles independientes;
5. conectar su producto a la memoria mediante el productor explícito sólo si
   existen todas las entradas obligatorias; de lo contrario registrar el
   bloqueo sin cálculo embebido en Markdown;
6. ejecutar pruebas y auditorías, y efectuar render únicamente si cambia el
   producto documental; controlar en todos los casos la Fase 1; y
7. publicar un punto recuperable antes de iniciar la rama siguiente.

G10.1 está cerrada: las tres candidatas y sus auditorías independientes
alcanzaron `PASS`, y el registro de ecuaciones fue materializado. El usuario
aceptó G10.2 para la chapa el 12 de agosto de 2026. Esa aceptación habilita la
función mecánica condicional, no adopta una norma ni completa los datos del
caso. G10.4 continúa bloqueada; G10.3 no requiere código nuevo con la evidencia
actual.

### 28.6 G10.7 — metodología y control independiente Wolfram

G10.7 comienza únicamente después de cerrar las implementaciones de G10 que el
usuario haya aceptado. Tiene dos productos acotados:

1. una auditoría de correspondencia entre cada función implementada y la
   metodología interna: ecuaciones, variables, unidades, signos, dominio,
   datos `UNKNOWN`, controles y fuentes; y
2. un único notebook Wolfram de lectura secuencial que evalúe un escenario
   fijo y compare resultados declarados con R.

El primer producto concluyó `PASS` después de corregir la derivación, las
conversiones dimensionales, el esquema real de salida y el tratamiento de la
función desconectada. Su auditoría se conserva en
`TITO/kb/research/g10.sheet.stress.correspondence.audit.es.md`. El segundo
producto fue construido como candidato, ejecutado con Wolfram 15.0.1 y obtuvo
`PASS` en sus dos auditorías independientes; G10.7 permanece abierta hasta la
revisión del usuario y la consolidación de los artefactos Wolfram vigentes.

La auditoría puede proponer texto candidato en `TITO/kb/paper-candidate/` o en
la investigación interna de G10. No editará la Fase 1 congelada ni promoverá
prosa a la memoria sin aprobación explícita. El notebook no será una segunda
implementación de producción: reutilizará sólo el material Wolfram vigente que
supere el inventario, fijará todas sus entradas, no muestreará distribuciones y
comparará magnitudes físicamente equivalentes mediante una tolerancia definida
por cada control. R continúa siendo la fuente ejecutable de producción.

Antes de editar el notebook se registró un inventario `KEEP`, `REUSE`,
`DELETE` o `UNKNOWN` de los artefactos Wolfram existentes, junto con las
entradas, salidas y oráculos del escenario fijo. El plan de esta puerta se
conserva en
`TITO/kb/research/g10.wolfram.methodology.followup.plan.es.md`. Su inventario
propone reutilizar selectivamente `soT.nb`; retirar el conjunto monolítico sólo
después de aceptar el reemplazo y migrar sus consumidores; y resolver como
`UNKNOWN` el destino de `testRingNotebook.wl`. El cuaderno candidato se
materializó en `scripts/wolfram/calculationScenario.nb`. Ningún archivo
vigente fue sustituido o retirado.

El escenario candidato es la fixture determinística
`verification-biaxial-uniform`; no alcanza por sí sola para completar chapa,
shotcrete o pernos. El notebook importará una única fixture R que ya contenga
todas las entradas aprobadas, calculará independientemente y sólo al final
importará los resultados R para compararlos. La superficie Wolfram autorizada
por el usuario es exclusivamente un notebook `.nb` nativo, organizado como
una hoja de cálculo secuencial con texto, definiciones, celdas y resultados.
No se empleará `wolframscript` ni se creará un archivo `.wl` como superficie
de uso. El kernel nativo observado es
`/Applications/Wolfram.app/Contents/MacOS/WolframKernel`, versión 15.0.1.

### 28.7 Candidato `calculationScenario.nb`

El notebook importa `calculation.json` y la tabla seccional referenciada,
reconstruye independientemente el estado de tensiones efectivas, las
propiedades circunferenciales, las acciones perimetrales y las curvas completas
de $N_\theta$, $M_\theta$ y $Q_\theta$ para `alpha-1` y `alpha-0`. Los CSV de R
se leen sólo después de terminar el cálculo Wolfram.

La solución cerrada es la serie comparada con R. La integración mediante
`NDSolveValue` y la descomposición de Fourier en los modos $n=0$ y $n=2$ son
controles independientes. La malla contiene 728 ángulos y conserva los puntos
críticos del escenario. Los extremos repetidos por simetría se informan como
conjuntos de posiciones equivalentes; no se fuerza la elección angular
producida por ruido numérico de otro motor.

La ejecución completa de las trece celdas obtuvo:

- diferencia máxima entre acciones Wolfram y R:
  $9.95\times10^{-14}$ kPa;
- diferencia máxima entre resultantes cerradas Wolfram y R:
  $2.41\times10^{-12}$ en las unidades de cada resultante, frente al límite
  $10^{-7}$;
- diferencia máxima de la integración directa respecto de la solución
  cerrada: $1.48\times10^{-6}$, frente a su límite independiente $10^{-4}$;
- métrica máxima de equilibrio de la integración directa:
  $1.32\times10^{-13}$, frente al límite $10^{-9}$;
- residuo máximo del control independiente de presión uniforme en el límite
  puramente membranal $\eta=0$: $5.39\times10^{-8}$, frente al límite
  independiente $10^{-4}$;
- diferencias máximas de $1.34\times10^{-12}$ para los valores y los valores
  firmados de los 18 extremos contrastados con R, frente al límite $10^{-7}$;
  y
- `overallPass = True` con Wolfram 15.0.1.

El notebook adopta como representante de un extremo repetido el primer índice
entre las posiciones equivalentes dentro de la tolerancia. El ángulo informado
por R puede ser otro miembro del mismo conjunto debido al ruido numérico; en
ese caso se comprueban tanto la pertenencia al conjunto como el valor firmado
de la solución Wolfram en el ángulo R. También se exige igualdad de unidades,
identificadores de escenario y caso, rama y dominio de $K_0$, y estados
`UNKNOWN` o no aplicables.

La recuperación de tensión normal circunferencial se presenta, pero permanece
sin evaluar para este escenario: faltan la sección neta, las coordenadas
firmadas de las fibras interior y exterior y el criterio aprobado de
aplicabilidad frente a la curvatura. No se utiliza $Q_\theta$ para inferir una
tensión y no se calculan resistencia, utilización, tensión longitudinal, von
Mises, juntas o pernos.

No se modificaron `calculation.json`, `data/calculation/`, la memoria pública,
la Fase 1 ni el plan Mai.1--Mai.10. Las auditorías matemática y de usabilidad
concluyeron `PASS` en
`/private/tmp/ar-sad40-g10-7-notebook-math-audit.md` y
`/private/tmp/ar-sad40-g10-7-notebook-usability-audit.md` para el SHA-256
`3631fe64b25ffd4bbb6a114e519a6e4336a5577511b1ff2e2d9b778a77e01659`.
La revisión del notebook por el usuario gobierna su aceptación; hasta entonces
no se retira ningún artefacto Wolfram anterior.

## 29. Plan posterior — Mai (2013) y deterioro de conductos corrugados

Esta sección se incorpora después del cierre de G10.2 y de la auditoría
metodológica de G10.7. No reemplaza esas puertas ni habilita por sí sola
resultados resistentes. La fuente, su extracción completa y el análisis se
preservan en:

- `TITO/kb/sources/mai_2013_deteriorated_corrugated_steel_culverts_thesis.pdf`;
- `TITO/kb/research/g10.mai.2013.thesis.extraction.en.md`;
- `TITO/kb/research/g10.mai.2013.deterioration.analysis.es.md`; y
- `TITO/kb/research/g10.mai.2013.deterioration.audit.es.md`.

La extracción contiene 233 bloques consecutivos, uno por página física del
PDF. El archivo fuente tiene SHA-256
`4af68ba05cd52a4281937401c998348cad1119327edb5f697d686bca4a3bbc25`.
La auditoría independiente concluyó `PASS` después de corregir la dirección de
una comparación porcentual, reservar $z$ para profundidad y distinguir la
Ecuación (4-1) impresa de una transformación algebraica derivada.

### 29.1 Dictamen de aplicabilidad

Mai aporta condicionalmente a la transición entre inspección y modelo
mecánico:

1. documenta calibración y estados de lectura de mediciones ultrasónicas;
2. conserva por separado $EA$ y $EI$ al representar una corrugación mediante
   propiedades circunferenciales equivalentes;
3. recupera $N$ y $M$ desde deformaciones de valle y cresta dentro del rango
   elástico; y
4. muestra perforación, plastificación localizada y pandeo de ligamentos como
   mecanismos que una tensión global homogeneizada no verifica.

La tesis no cierra el criterio de aplicabilidad por curvatura, la distribución
local asociada a $Q_\theta$, la condición longitudinal, una norma vigente, un
modelo general de perforación o una distribución probabilística del espesor.
Sus casos CANDE y de carga superficial son antecedentes académicos; no forman
parte del procedimiento de producción ni del reporte ejecutivo.

### 29.2 Secuencia Mai.1--Mai.10

1. **Mai.1 — datos de deterioro:** separar espesor nominal, observación
   $t_{\rm measured}(\theta,x_L)$, estado de lectura, fracción perforada,
   espesor de cálculo y pérdida futura. No descontar dos veces la corrosión
   histórica ya medida.
2. **Mai.2 — calidad de medición:** distinguir medido, perforado, no medible
   por degradación superficial y no accesible. La falta de acceso permanece
   `UNKNOWN`; no se convierte automáticamente en espesor nulo.
3. **Mai.3 — reducción espacial:** mantener $x_L$ como coordenada de
   inspección. El modelo mecánico sigue siendo plano y sin variación
   longitudinal de cargas; hasta aprobar una regla de redistribución se
   evalúan estaciones independientes o una envolvente, no un promedio
   longitudinal implícito.
4. **Mai.4 — contrastes seccionales:** materializar por separado los controles
   M1 de la Tabla 2.1 y M2 de la Tabla E.1. Los valores tabulados son datos de
   referencia; los ajustes y extrapolaciones se clasifican como derivados.
5. **Mai.5 — correspondencia con G10.2:** incorporar las Ecuaciones (4-2) a
   (4-5) como antecedente experimental de recuperación elástica. No modificar
   la puerta vigente de curvatura ni introducir $Q_\theta$, tensión
   longitudinal, von Mises o resistencia local.
6. **Mai.6 — perforación y continuidad:** si existen perforaciones o ligamentos
   aislados, la tensión global puede informarse sólo como diagnóstico; la
   verificación resistente permanece incompleta hasta evaluar estabilidad
   local y continuidad del camino de carga.
7. **Mai.7 — mecanismos y límites:** reservar la evidencia de CSP1 sobre
   plastificación, pandeo local y causalidad no resuelta para la metodología
   académica o el futuro paper.
8. **Mai.8 — contrastes:** conservar M1--M6 en el apéndice metodológico con su
   clase de evidencia. No presentar CANDE como método empleado por AR-SAD40.
9. **Mai.9 — incertidumbre:** agregar al inventario de Monte Carlo espesor
   observado, error de medición, fracción perforada, estado de lectura y regla
   de agregación. Sus distribuciones y dependencias permanecen `UNKNOWN`; antes
   de aprobarlas se ejecutan sensibilidades determinísticas.
10. **Mai.10 — auditoría:** comprobar símbolos, unidades, signos, reproducción
    de M1--M2, tratamiento de las discrepancias de la fuente, ausencia de
    promedios longitudinales implícitos y trazabilidad a `[@Mai2013]`.

### 29.3 Puertas de ejecución

La ejecución de Mai.1--Mai.10 requiere, en este orden:

1. aprobar el esquema de datos de inspección y la nomenclatura de estados;
2. recibir o definir la forma de los datos del proyecto sin inventar valores;
3. aprobar la regla que transforma el campo medido en propiedades por sección
   plana;
4. implementar primero productores determinísticos y los contrastes M1--M2;
5. conectar G10.2 sólo si la sección neta, las fibras y el criterio de
   curvatura están completos; y
6. incorporar texto a la memoria o al futuro paper únicamente después de la
   revisión técnica y editorial del usuario.

No se modifica `calculation.json`, no se ejecuta Monte Carlo, no se generan
tensiones del revestimiento existente y no se altera la Fase 1 durante esta
etapa de planificación.

## 30. Ampliación metodológica y secuencia chapa--shotcrete

La instrucción del 12 de agosto de 2026 establece una secuencia de dos
productos: primero se incorporan los hallazgos posteriores a la Fase 1 en una
metodología candidata autónoma; después se trasladan a la memoria profesional
solamente las fórmulas operativas y el estado de aplicación que puedan
sostenerse. La alternativa de shotcrete comienza después de cerrar la etapa de
chapa y no se mezcla con esta ampliación.

### 30.1 Producto metodológico candidato

La Fase 1 permanece congelada. La ampliación independiente se ensambla mediante

```text
_master/methodology.extension.review.es.qmd
_index/methodology.extension.review.ES.qmd
```

y reúne cinco bloques bajo `TITO/kb/paper-candidate/chapters/`:

1. alcance y cadena de cálculo;
2. estimación de $K_0$ desde variables primitivas e historia tensional;
3. participación prescrita de la componente tangencial mediante
   $P_t=\alpha p_t^*$, sin atribuir a $\alpha$ una ley de fricción;
4. deterioro, sección neta y recuperación elástica condicionada de la tensión
   normal circunferencial; y
5. controles matemáticos y datos de referencia en un apéndice separado.

El producto no incorpora resultados CANDE, cargas superficiales de Mai ni
ensayos últimos como contrastes del cálculo geostático. Tampoco adopta una
norma resistente sin acceso a su articulado aplicable.

### 30.2 Estado de la chapa

La recuperación mecánica condicional está formulada e implementada:

$$
\sigma_\theta(\theta,y)
=\frac{N_\theta(\theta)}{\bar A_n}
-1000\frac{M_\theta(\theta)y}{\bar I_n}.
$$

Con la coordenada $\xi=-y$ de la memoria, positiva hacia el interior, la misma
relación se expresa como

$$
\sigma_\theta(\theta,\xi)
=\frac{N_\theta(\theta)}{\bar A_n}
+1000\frac{M_\theta(\theta)\xi}{\bar I_n}.
$$

La metodología de recuperación puede incorporarse a la memoria. Su evaluación
para el revestimiento existente continúa bloqueada por la sección neta
corroída $\bar A_n,\bar I_n$, las coordenadas reales de las fibras y un criterio
aprobado de aplicabilidad frente a la curvatura. Las propiedades nominales del
escenario de comprobación no sustituyen esos datos. La verificación resistente
permanece además bloqueada por la identificación del producto, la norma y
edición aplicables, el acero, las combinaciones y los estados límite
obligatorios. No se informarán tensiones, utilizaciones ni factores de
seguridad del caso hasta resolver esas entradas.

### 30.3 Puerta documental y próxima rama

El diseño independiente del candidato concluyó inicialmente `PASS` en
`/private/tmp/ar-sad40-methodology-candidate-design.md`. La auditoría de cierre
posterior detectó tres defectos documentales: dominio no negativo del espesor,
comparaciones dimensionales agregadas y omisión de los datos seccionales
publicados por Mai. Después de corregirlos, una primera reauditoría exigió
además declarar que el incremento horizontal residual de compactación no está
determinado ni incluido en el escenario; no corresponde reemplazarlo por cero.

El cierre definitivo obtuvo `PASS` en
`/private/tmp/ar-sad40-methodology-extension-closure-final.md`. El HTML vigente
es `html/methodology.extension.review.es/index.html`, SHA-256
`589ce206fa1ca3d679d62f36df28d94da72a3dd7103918105b5e074ffacd0876`.
Las formulaciones de $K_0$, participación tangencial, G10.2, Mai y G10.7
conservan sus auditorías independientes; las citas y referencias cruzadas
resuelven y los trece hashes protegidos de Fase 1 permanecen exactos. La
aceptación editorial final del candidato corresponde al usuario.

La memoria puede incorporar la fórmula final, sus signos, unidades, dominio y
el estado no evaluado del escenario; no copiará derivaciones ni controles
académicos. La rama de shotcrete permanece como próxima etapa y conserva las
condiciones registradas en 28.2.3 y 28.4.

### 30.4 Cierre de la memoria y transición a shotcrete

La memoria incorporó la recuperación normal circunferencial como una operación
condicionada y autónoma. El cuerpo presenta la fórmula final, las convenciones,
las unidades y las entradas; el Apéndice A.6 desarrolla la relación y declara
su dominio sin remitir a otro producto. La aplicación conserva las propiedades
nominales como escenario de comprobación y no calcula tensiones del
revestimiento existente.

La misma sección neta y el mismo eje centroidal deben producir
$EA_\theta$, $EI_\theta$ y la recuperación de tensión. Para propiedades netas
uniformes se recalculan las resultantes con esas rigideces. Si
$\bar A_n(\theta)$ o $\bar I_n(\theta)$ varían de forma relevante, la solución
actual de rigidez uniforme no se usa como base de una posoperación local: debe
resolverse nuevamente el equilibrio y la compatibilidad con rigideces
variables, o justificarse una sección equivalente aplicable.

Controles de cierre:

- `Rscript scripts/R/testSheetStress.R`: PASS;
- `Rscript scripts/R/runCalculationMemo.R`: PASS;
- `Rscript scripts/R/testCalculationData.R`: PASS;
- `Rscript scripts/R/testRingMethod.R`: PASS;
- `Rscript scripts/R/testCalculationFigures.R`: PASS;
- auditoría técnica: PASS en
  `/private/tmp/ar-sad40-sheet-memo-technical-audit.md`;
- reauditoría editorial: PASS en
  `/private/tmp/ar-sad40-sheet-memo-editorial-reaudit.md`; y
- HTML: `html/calculation.review.es/index.html`, SHA-256
  `10a249fc6604da90e1b4f6b9b2c69600c1d77ae0b5c9f5d919f1a531ee651f29`.

Este cierre corresponde al procedimiento de recuperación, no a una
verificación resistente del caso. Permanecen obligatorios y no resueltos la
sección neta, las coordenadas firmadas de fibras, la representación espacial de
la corrosión, la continuidad resistente, el criterio de curvatura, el producto,
la norma y edición, el acero, las combinaciones y los estados límite. No se
informan tensiones, utilización ni factor de seguridad del revestimiento
existente.

La alternativa de shotcrete es la rama siguiente, separada de la chapa. Su
investigación G10.1 permanece en
`TITO/kb/research/g10.shotcrete.section.verification.es.md` y su auditoría en
`TITO/kb/research/g10.shotcrete.section.verification.audit.es.md`. Antes de
implementar o trasladar fórmulas a la memoria deben resolverse la aplicabilidad
reglamentaria, la clasificación de la sección, la condición autónoma o
compuesta, el espesor resistente, la armadura, la resistencia efectiva y las
acciones de cálculo y servicio. No se inferirá una sección compuesta con la
chapa ni se tratará automáticamente una cuantía nula como hormigón simple.

### 30.5 Metodología candidata para la alternativa de shotcrete

La investigación G10.1 se convirtió en una ampliación candidata del mismo
producto metodológico independiente, sin crear otro master. El ensamblado
`methodology.extension.review.*` incorpora ahora tres capítulos nuevos:

1. alcance, base reglamentaria condicionada y decisiones del sistema;
2. transformación de las resultantes circunferenciales y comprobación de una
   franja de hormigón simple o armado; y
3. controles analíticos y numéricos autónomos en el Apéndice B.

La rama modelada es un revestimiento de shotcrete autónomo. Sus resultantes
$N_\theta$, $M_\theta$ y $Q_\theta$ deben recalcularse con las rigideces de esa
alternativa; no se transfieren las resultantes obtenidas para la chapa. La
acción compuesta queda excluida mientras no existan un modelo de interfaz,
adherencia, secuencia constructiva y transferencia de acciones aceptados.

La base reglamentaria argentina se presenta como una ruta condicionada, no
como una adopción automática: Resolución SOP 11/2026, CIRSOC 200-24 para
tecnología y aceptación, y CIRSOC 201-25 para evaluación estructural, sujeto a
la jurisdicción, al contrato y a la exclusión reglamentaria de cáscaras
delgadas. La función que pudiera corresponder a CIRSOC 804-4 permanece
`UNKNOWN`.

Para una franja longitudinal de ancho $b$, el cambio de convención entre el
modelo global y la comprobación de hormigón queda fijado por

$$
P_u=-N_\theta b,\qquad M_u=M_\theta b,\qquad V_u=Q_\theta b,
$$

donde $P_u>0$ representa compresión y $M_u>0$ comprime la cara exterior. El
capítulo distingue hormigón simple, armado y reforzado con fibras mediante la
clasificación normativa y el detallado, no por la sola condición $A_s=0$.
Incluye las expresiones de hormigón simple, la compatibilidad y el equilibrio
de la sección armada, el bloque rectangular equivalente, $\beta_1$, los
factores $\phi$ punto a punto y las ramas de corte unidireccional. En una
estructura existente se usa una resistencia especificada equivalente
$f'_{c,\mathrm{eq}}$ aprobada; no se reemplaza por la resistencia efectiva de
producción.

La primera auditoría técnica detectó cuatro defectos materiales: signo de la
deformación de tracción, omisión del límite global de corte, omisión del límite
de $\sqrt{f'_c}$ y definición demasiado amplia de la armadura longitudinal en
$\rho_w$. Los cuatro fueron corregidos. La reauditoría técnica concluyó `PASS`
en `/private/tmp/ar-sad40-shotcrete-candidate-technical-reaudit.md`; la
reauditoría editorial concluyó `PASS` en
`/private/tmp/ar-sad40-shotcrete-candidate-editorial-reaudit.md`. Los controles
B.1--B.4 reproducen casos de hormigón simple, factores $\phi$ y el límite
global de corte mediante cálculos independientes.

El render integrado concluyó correctamente y produjo
`html/methodology.extension.review.es/index.html`, SHA-256
`3858ea25a3ff863f9be9d95f9c93382c9f141bd3b8cdcc63207f30b6063dfe43`.
Las citas y referencias cruzadas resuelven, los cuatro masters vigentes se
conservan y los trece hashes protegidos de Fase 1 permanecen exactos.

Esta ampliación no se traslada todavía a la memoria profesional. Antes deben
resolverse, como mínimo, la jurisdicción y la base contractual; la condición
autónoma o compuesta; el proceso húmedo o seco; las combinaciones últimas y de
servicio; el espesor resistente y sus defectos; $f'_{c,\mathrm{eq}}$ y la
estadística de testigos; la clasificación seccional; las armaduras o
propiedades residuales de fibras; y los requisitos de exposición, fisuración y
estanqueidad. Sin esas decisiones no se informan capacidad, utilización ni
factor de seguridad del caso.
