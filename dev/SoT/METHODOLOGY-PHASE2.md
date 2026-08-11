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
- Apéndice A con síntesis suficiente de los desarrollos y remisión al documento
  metodológico; Apéndice B con contrastes completos y trazables;
- resultados numéricos reproducibles desde datos declarados;
- diagramas consistentes con las tablas fuente;
- cuantiles puntuales y de extremos tratados como objetos distintos;
- lenguaje profesional para audiencia experta;
- ningún cálculo de tensiones, capacidad o pernos en esta fase;
- ninguna dependencia de FORM/FOSM;
- ninguna promoción pública sin aprobación del usuario.

## 17. Próxima acción

Ejecutar F2.7: entregar y revisar la memoria actualizada en
`html/calculation.review.es/index.html` y conservar
`html/calculation.resultants.review.es/index.html` como antecedente de la
selección gráfica. Aplicar únicamente las observaciones del usuario y no
promover el candidato a las rutas públicas antes de una aprobación explícita.
Los cambios de NGR permanecen sin `stage`, `commit` ni `push` hasta recibir una
instrucción específica para esas operaciones.

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

### 22.2 Diagnóstico de reproducibilidad vigente

La memoria todavía no satisface el requisito de actualización automática al
cambiar las entradas:

- `scripts/R/runCalculationMemo.R` contiene valores numéricos del escenario;
- el resumen, la aplicación y las conclusiones repiten parte de esos valores;
- tablas y figuras leen CSV, pero desde
  `TITO/kb/calculation-memo/results/`; y
- el antiguo Apéndice B contiene tablas de comparación escritas directamente
  en Markdown.

Por consiguiente, los builders actuales demuestran la presentación, pero no
constituyen aún un contrato único de datos para la memoria.

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

`calculation.json` será la única fuente de los datos adoptados para la corrida.
Los valores tabulados de una publicación no son datos del proyecto y se
conservarán separadamente en `data/reference/`, con clave bibliográfica y
localización en la fuente. `data/calculation/` contendrá únicamente productos
generados. `data/benchmarks/` pertenecerá a la línea académica y no será
consumido por la memoria ejecutiva.

Los nombres definitivos deben conservar la política PSHA: namespace semántico
en inglés y tokens separados por puntos. No se migrará ningún archivo hasta
aprobar el contrato de columnas de cada producto.

### 22.4 Contrato mínimo de `calculation.json`

La primera versión incluirá solamente:

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

El cálculo se concentrará en una función de producción, por ejemplo
`buildCalculationData(config, outputDirectory)`, alojada en `scripts/R/`. Esa
función:

1. leerá y validará `calculation.json`;
2. leerá las propiedades tabuladas necesarias desde `data/reference/`;
3. resolverá en memoria las acciones y resultantes;
4. ejecutará los controles matemáticos;
5. escribirá los CSV sólo después de completar correctamente el cálculo; y
6. fallará antes del render si falta una entrada o un control no se satisface.

Como la corrida determinística actual es pequeña, `scripts/setup/setup.R` la
regenerará al inicio de cada render. Esta decisión evita resultados obsoletos
sin introducir una caché o un sistema de dependencias prematuro. El productor
también conservará una interfaz ejecutable mediante `Rscript` para pruebas y
uso fuera de Quarto.

`scripts/setup/utils.R` poseerá únicamente lectura con esquema, formateo y
resolución de rutas. No contendrá ecuaciones mecánicas. Los builders de tablas
y figuras leerán los CSV con columnas explícitas; no calcularán resultantes ni
repetirán valores del JSON.

### 22.6 Composición documental mínima

Se adopta el principio de `_results/` del scaffold PSHA sin reproducir toda su
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
