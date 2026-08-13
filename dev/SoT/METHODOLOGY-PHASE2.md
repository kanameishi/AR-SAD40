# Fuente de verdad — memoria de cálculo ejecutiva, Fase 2

**Estado:** G0--G10.2 y G10.7 cerradas; bloque determinístico de la memoria reconstruido con la fila métrica CSPI 2,8/2,64; MC-R y verificaciones resistentes permanecen como etapas separadas
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
5. continuar desde la última sección declarada vigente —actualmente 35—,
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

- empuje circunferencial reglamentario `T_L`, cuando se confirmen el producto,
  la presión vertical mayorada en clave y la luz;
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
| 4 | Acciones del relleno | clasificación del producto, presión vertical en clave, empuje circunferencial reglamentario, agua, compactación, estado inicial `K_0`, interacción suelo--conducto y escenario biaxial analítico |
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
| 0 | producto estructural, geometría confirmada, unidades, convención angular y signos | definir artículos reglamentarios, casos, etapas y alternativas de modelación | registro de casos y etapas | no mezclar datos confirmados con escenarios nominales |
| 1 | estratigrafía, pesos unitarios, sobrecargas, nivel de agua y tapada | calcular tensiones verticales, presión intersticial y presión vertical mayorada en clave | `sigma_v'(theta)`, `u(theta)`, `P_F` | clave, eje y fondo; continuidad entre estratos; combinación y factores |
| 2 | `P_F` y luz `S` confirmadas | calcular `T_L=P_F S/2` | empuje seccional por combinación | seleccionar y registrar las secciones resistentes que se comprobarán |
| 3 | agua exterior e interior | calcular la acción hidrostática neta | `Delta u(theta)` | no aplicar `K_0` a la presión intersticial |
| 4 | equipos, tongadas y secuencia constructiva | construir acciones temporales y sólo con evidencia componentes residuales | acciones por etapa/modelo | no presumir retención ni duplicar historia tensional |
| 5 | condición del relleno, historia tensional, rigideces, interfaz y secuencia | si se requieren acciones angulares, resolver una formulación de interacción suelo--conducto | `P_r(theta,s)`, `P_t(theta,s)` | `K_0` es estado inicial, no presión de contacto |
| 6 | estado biaxial y `alpha` prescritos | ejecutar el escenario analítico de comprobación | acciones angulares del control | mantenerlo separado de la rama reglamentaria y del caso real |
| 7 | perfil corrugado, módulo, `A_p` e `I_p` | calcular rigideces circunferenciales | `EA_theta`, `EI_theta`, `eta_s` | unidades y procedencia de propiedades; espesor condicional identificado |
| 8 | acciones perimetrales cerradas y rigideces | integrar equilibrio y compatibilidad; aplicar soluciones cerradas cuando correspondan | `N_theta(theta)`, `M_theta(theta)`, `Q_theta(theta)` | equilibrio global, periodicidad y comparación con casos cerrados |
| 9 | curvas por etapa y modelo | localizar mínimos, máximos y máximos absolutos por tramos | valor, signo, ángulo y etapa gobernante por realización | incluir extremos interiores, discontinuidades y límites de tramo |
| 10 | distribuciones y dependencias aprobadas | ejecutar Monte Carlo para cada alternativa de modelación | curvas y extremos por realización | convergencia, conteo de cola y reproducibilidad de la corrida |
| 11 | resultados de todas las realizaciones | calcular cuantiles puntuales, cuantiles de extremos y envolvente exterior de modelos | bandas angulares, intervalos escalares y casos gobernantes | no equiparar cuantiles puntuales con cuantiles de extremos |
| 12 | tablas finales y metadatos | producir figuras, tablas y síntesis ejecutiva | memoria auditable y productos reproducibles | igualdad entre valores representados y tablas fuente |

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

$K_0$ caracteriza el estado efectivo inicial del relleno. En las ramas basadas
en una formulación geotécnica,

$$
K_0^{(m)}(z)=f_m\!\left[\mathbf{x}_m(z)\right],
\qquad
\sigma_h'^{(m)}(z)=K_0^{(m)}(z)\,\sigma'_v(z),
$$

donde $m$ identifica la formulación y $\mathbf{x}_m$ contiene sólo sus
variables primitivas. $K_0$ se materializa como resultado derivado; no se
muestrea de manera independiente de $\phi'$, $\nu_g$, OCR o
$\mathrm{OCR}_{\max}$ cuando esas variables lo determinan. La transferencia de
este estado a presiones de contacto requiere una formulación de interacción
suelo--conducto. No se identifica directamente
$\sigma'_h=K_0\sigma'_v$ con la presión horizontal sobre la pared.

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
\frac{1+\frac{2}{3}\sin\phi'}{1+\sin\phi'}.
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

## 31. Corrección de la jerarquía de acciones para el conducto enterrado

La revisión técnica del 13 de agosto de 2026 sustituyó la secuencia que
presentaba la proyección basada en $K_0$ como generador principal de las
acciones. Esa secuencia era válida únicamente como estado biaxial analítico
prescrito y no como metodología general de carga para un conducto flexible
instalado y rellenado.

### 31.1 Referencia reglamentaria

CIRSOC 804-4 distingue dos clases que no deben confundirse:

1. el artículo 12.7 comprende tubos metálicos corrugados y tubos construidos
   con chapas estructurales; su ecuación 12.7.2.2-1 establece
   $T_L=P_FS/2$; y
2. el artículo 12.13 comprende chapas de acero utilizadas como revestimiento
   de túneles; su ecuación 12.13.2-1 permite determinar la carga de suelo en
   clave mediante $W_E=C_{dt}\gamma_sS$, considera sobrecargas y presión de
   inyección, y remite después a los controles de pared, pandeo y costura del
   artículo 12.7.

USACE EM 1110-2-2902, sección 4.12.3.1.1 y ecuación 4-20, reproduce el empuje
de AASHTO para conductos metálicos corrugados. $T_L$ es la solicitación por
unidad de longitud de pared utilizada para comprobar una sección resistente.
Las secciones de pared, pandeo y costura que se evalúan son seleccionadas por
el análisis y por la configuración del revestimiento.

### 31.2 Estado de las entradas del caso

Permanecen `UNKNOWN`:

- la clasificación exacta del producto estructural;
- la presión vertical mayorada en clave $P_F$;
- la luz $S$ que corresponde a la ecuación reglamentaria; y
- la formulación de interacción suelo--conducto aplicable para obtener una
  distribución angular de presión.

La tensión vertical efectiva de 100 kPa en el eje y el diámetro interior de
2.63 m pertenecen al escenario analítico existente. No se sustituyen por
$P_F$ y $S$, respectivamente. La memoria no materializa 131.5 kN/m como
resultado del revestimiento existente.

### 31.3 Función de $K_0$, agua, cohesión y compactación

$K_0=\sigma'_h/\sigma'_v$ caracteriza el estado efectivo inicial. Puede
intervenir en una formulación de interacción o en el estado biaxial analítico,
pero no determina por sí solo la presión de contacto sobre un conducto
flexible. El agua se incorpora como presión intersticial separada. Las
expresiones con $\pm2c'\sqrt K$ corresponden a estados activo o pasivo y no se
agregan a las correlaciones de $K_0$. Un análisis no drenado en tensiones
totales requiere otra rama constitutiva. La compactación se separa entre acción
temporal, historia tensional y eventual tensión residual; ninguna fracción de
retención se presume sin evidencia.

La forma original de Jáky transcrita por Michalowski (2005), ecuación 8, fue
verificada visualmente y se conserva sin modificación:

$$
K_{0,\mathrm{J\acute{a}ky\,1944}}
=(1-\sin\phi')
\frac{1+\frac{2}{3}\sin\phi'}{1+\sin\phi'}.
$$

La inspección visual de la ecuación 8 confirma que $\sin\phi'$ no está
elevado al cuadrado. Cualquier nota previa que indicara $\sin^2\phi'$ queda
sustituida por esta verificación directa. La corrección no modifica la forma
abreviada $K_{0,NC}=1-\sin\phi'$ implementada en R.

### 31.4 Separación de productos de cálculo

`calculation.json` emplea el esquema 2.1.0. La rama reglamentaria se materializa
en `data/calculation/circumferential.thrust.csv`, separada de
`section.resultants.csv`. Mientras falten las entradas, el producto conserva
`structuralProductID=UNKNOWN`, `evaluationStatus=not-evaluated` y valores
numéricos vacíos. La configuración exige que $P_F$ y $S$ se suministren juntos
y sólo admite evaluar el empuje cuando se declara la clasificación aplicable.

`cirsocCorrugatedPipeThrust()` implementa exclusivamente la ecuación de empuje
por unidad de longitud de pared. El producto no selecciona la sección
resistente ni ejecuta sus comprobaciones. El
estado angular vigente conserva la identificación
`prescribed-biaxial-stress-projection`; `calculateScenario()` y sus valores de
referencia se mantienen como oráculo analítico, sin acoplarse a la rama
reglamentaria.

### 31.5 Productos documentales corregidos

La corrección afecta sólo los candidatos de Fase 2:

- `_master/methodology.extension.review.es.qmd` y sus capítulos bajo
  `TITO/kb/paper-candidate/`;
- `_master/calculation.review.es.qmd` y sus capítulos y registros bajo
  `TITO/kb/calculation-memo/`; y
- la implementación y los productos determinísticos gobernados por
  `calculation.json`.

La Fase 1 congelada no se edita ni se renderiza. Los dictámenes de cierre
anteriores de la ampliación y de la memoria quedan sustituidos para esta
materia hasta completar las nuevas auditorías técnica, editorial, numérica y
de artefactos.

### 31.6 Puertas de cierre

Antes de declarar cerrada esta corrección deben completarse:

1. pruebas R de la relación CIRSOC, del contrato de datos y de la paridad de la
   rama biaxial;
2. render independiente de los dos masters candidatos;
3. auditoría técnica de ecuaciones, dominios, unidades y separación de ramas;
4. auditoría editorial de lenguaje profesional y ausencia de narrativa
   interna; y
5. auditoría de artefactos, referencias cruzadas, citas y preservación de la
   Fase 1.

## 32. Jerarquía normativa internacional y frontera resistente

La decisión del usuario del 13 de agosto de 2026 sustituye, para las
verificaciones resistentes, la adopción argentina desarrollada en las
secciones 30 y 31. La autoridad principal de la chapa es AASHTO; la alternativa
de hormigón se organiza conforme a ACI. CIRSOC se conserva como antecedente de
correspondencia y control métrico, pero no gobierna ninguno de los dos
procedimientos.

### 32.1 Principio de independencia respecto del modelo de cargas

La comprobación resistente recibe efectos seccionales ya calculados y no
depende de que éstos provengan del escenario biaxial, de una formulación de
interacción suelo--conducto o de otro análisis admisible. La interfaz debe
conservar sección, combinación, etapa, signos, unidades, base longitudinal y
estado de mayoración. Esta independencia termina en la frontera de demanda:
la resistencia sí depende de la tipología estructural y de la rama normativa
correspondiente.

Las normas verifican la sección seleccionada por el análisis. No corresponde
buscar en ellas una distribución angular de presiones o resultantes. Tampoco
corresponde atribuir a una norma el campo angular construido por la metodología
del proyecto.

### 32.2 Chapa corrugada — autoridad AASHTO

La autoridad de diseño será *AASHTO LRFD Bridge Design Specifications*, 10.ª
edición de 2024, con la errata aplicable. El índice oficial disponible confirma
tres familias relevantes y un subcaso específico:

1. artículo 12.7: tubos, arcos y estructuras de arco metálicos, con empuje,
   resistencia de pared, pandeo y costura;
2. artículo 12.8: estructuras de gran luz de chapas estructurales, con empuje,
   área de pared y costura;
3. subartículo 12.8.9 dentro de 12.8: corrugación profunda, con análisis
   estructural, empuje y momento combinados, pandeo global y conexiones; y
4. artículo 12.13: chapas de acero para revestimiento de túneles (*steel
   tunnel liner plate*), con cargas, área de pared, pandeo, costura y rigidez
   de construcción.

La interacción de empuje y momento del artículo 12.8.9.5 no se transfiere a
los artículos 12.7 o 12.13. La geometría circular y el uso coloquial de la
palabra *liner* no clasifican el producto. La clasificación exige geometría de
corrugación, especificación de producto, forma de montaje, solapes, uniones y
documentación del fabricante.

El corpus contiene el índice oficial, no el articulado de la décima edición.
Permanecen `UNKNOWN` las ecuaciones, los factores de resistencia, las
propiedades efectivas y los dominios vigentes. USACE EM 1110-2-2902 conserva
la relación pública de empuje que atribuía a AASHTO en 2020. CIRSOC 804-4
contiene una correspondencia basada en la edición AASHTO 2012. Ninguna de esas
fuentes sustituye la lectura del articulado vigente.

La memoria ejecutiva adopta AASHTO como única referencia normativa de diseño
para la chapa y no necesita presentar CIRSOC en su cuerpo. La correspondencia
con la edición 2012 se conserva sólo en la trazabilidad interna y en la
investigación metodológica histórica.

*AASHTO LRFD Bridge Construction Specifications*, 4.ª edición, con las
revisiones interinas y erratas vigentes, es una autoridad separada de
ejecución. No suministra por sustitución las ecuaciones de resistencia de las
especificaciones de diseño.

### 32.3 Recuperación elástica de tensión en la chapa

La recuperación lineal continúa siendo un helper de demanda, no de
resistencia. Su interfaz se corrigió para coincidir con la memoria:

- coordenada de fibra positiva hacia el interior;
- `outerFiberCoordinateMm<0` e `innerFiberCoordinateMm>0`;
- momento positivo que tracciona la fibra interior;
- nombres de resultantes con unidades explícitas;
- conservación de `sectionID`, `combinationID` y `stageID`;
- base `per-projected-metre`; y
- transporte de $Q_\theta$ con estado de tensión cortante `not-evaluated`.

La ecuación operativa es

$$
\sigma_\theta
=\frac{N_\theta}{\bar A_n}
+1000\frac{M_\theta\xi}{\bar I_n},
$$

con $\xi>0$ hacia el interior. El helper no calcula capacidad AASHTO,
pandeo, costuras, conexiones ni pernos.

### 32.4 Hormigón proyectado — autoridad ACI

La jerarquía internacional de la alternativa de hormigón será:

- ACI CODE-318.2-25 para una cáscara delgada de hormigón;
- ACI CODE-318-25 como complemento y para las disposiciones generales de
  hormigón estructural;
- ACI CODE-562-25 para la evaluación de una estructura existente; y
- ACI SPEC-506.2-13(18) para materiales, ejecución, ensayos y aceptación del
  shotcrete.

La vista oficial de ACI CODE-318.2-25 confirma capítulos específicos de
estabilidad, resistencia frente a fuerzas de membrana, momento y corte, y
armadura mínima. El texto completo de esos artículos y de las disposiciones
correspondientes de ACI CODE-318-25/562-25 no está disponible en el corpus.
Por ello se conserva el núcleo agnóstico de compatibilidad y equilibrio,

$$
\varepsilon(y)=\varepsilon_0+\kappa(y-y_0),
$$

$$
P_n=\int_{A_c}\sigma_c\,dA+\sum_jA_{s,j}\sigma_{s,j},
\qquad
M_n=\int_{A_c}\sigma_c(y-y_0)\,dA
+\sum_jA_{s,j}\sigma_{s,j}(y_j-y_0),
$$

pero no se asignan leyes, deformaciones límite, factores $\phi$, cuantías
mínimas ni capacidades hasta leer el articulado vigente. Los coeficientes
CIRSOC previamente documentados no se renombran como ACI.

Una cuantía $A_s=0$ no habilita automáticamente hormigón simple. Debe
resolverse antes la clasificación como cáscara y la armadura mínima exigida.
El corte, la estabilidad, el servicio, la durabilidad y la ejecución permanecen
como comprobaciones separadas.

### 32.5 Estado de implementación y puertas

`calculation.json` identifica la rama normativa pendiente como
`aashto-lrfd-10e-2024-section-12-pending`. No materializa un empuje AASHTO
numérico. La única evaluación escalar habilitada en R es la relación pública de
USACE, con `modelID=usace-em-1110-2-2902-4.20`; su salida se identifica como
USACE y conserva la advertencia de que la correspondencia con AASHTO vigente
debe comprobarse.

Antes de implementar resistencia de chapa deben resolverse:

1. producto y rama AASHTO;
2. articulado vigente y errata;
3. propiedades netas y efectivas admitidas;
4. combinaciones y efectos mayorados;
5. pared o interacción, pandeo, costura y conexiones como controles separados;
   y
6. procedimiento aplicable a una estructura existente.

Antes de implementar resistencia de hormigón deben resolverse:

1. clasificación frente a ACI CODE-318.2-25;
2. articulado vigente en SI de ACI 318.2/318/562;
3. admisibilidad y disposición de armadura;
4. geometría y propiedades existentes; y
5. tabla ecuación--artículo--unidad y controles numéricos de la misma edición.

Los dictámenes independientes vigentes son `FAIL` como implementaciones
normativas completas, debido a esos bloqueos, y `PASS` para la arquitectura
conceptual y la identificación de las ramas. No se presentará cumplimiento
AASHTO o ACI hasta cerrar las puertas anteriores.

### 32.6 Cierre de la corrección AASHTO/ACI

La auditoría independiente de jerarquía normativa identificó una atribución
imprecisa de la relación $T_L=P_FS/2$ en el Apéndice A.2. El texto corregido la
identifica como relación reproducida por USACE, cita la ecuación 4-20 y declara
pendiente su correspondencia con AASHTO 10.ª edición. La reauditoría concluyó
`PASS` en `/private/tmp/ar-sad40-aashto-aci-final-reaudit-v2.md`.

La auditoría de artefactos detectó que un escenario USACE podía heredar el
`referenceID` de la rama AASHTO pendiente. La validación R exige ahora las
parejas cerradas
`aashto-section-12-product-pending` /
`aashto-lrfd-10e-2024-section-12-pending` y
`usace-em-1110-2-2902` / `usace-em-1110-2-2902-4.20`. La prueba incluye el
caso negativo de identidad cruzada. La reauditoría concluyó `PASS` en
`/private/tmp/ar-sad40-final-artifact-reaudit-v2.md`.

Los siete controles R vigentes concluyeron `PASS`:
`runCalculationMemo.R`, `testCalculationData.R`,
`testCalculationLoading.R`, `testRingMethod.R`,
`testCalculationFigures.R`, `testCalculationMonteCarloOutput.R` y
`testSheetStress.R`. Los dos renders con `qrt` concluyeron correctamente:

- `html/calculation.review.es/index.html`, SHA-256
  `7e4b6dc282458fd1d7f9640a96136ee22ac48a323676b434b3ca25752351d213`;
- `html/methodology.extension.review.es/index.html`, SHA-256
  `15c12b65b9cc37d84d80d72e39e3633983ba2bb91a503f37c2b52876cf84d30e`.

La memoria no contiene CIRSOC como referencia normativa. La metodología lo
conserva sólo como antecedente histórico de correspondencia con AASHTO 2012.
Los trece hashes de la Fase 1 congelada permanecen idénticos. Este cierre no
habilita una verificación resistente AASHTO o ACI: la clasificación del
producto, el articulado vigente y los datos resistentes continúan `UNKNOWN`.

## 33. Reinicio de la memoria por auditoría de pertenencia

La revisión directa del usuario del 13 de agosto de 2026 rechaza la memoria
vigente como producto profesional aplicado. La causa no es una corrección
editorial aislada: el cuerpo mezcla el cálculo ejecutado con metodología
general, alternativas no adoptadas, casos de control, datos pendientes y
planes futuros. Los dictámenes de cierre anteriores quedan sustituidos para
la memoria completa. La Fase 1 congelada y la metodología candidata conservan
sus alcances propios.

### 33.1 Puerta de producto

La reescritura y el render de `_master/calculation.review.es.qmd` permanecen
congelados hasta terminar una auditoría desde cero, sección por sección. Un
bloque sólo pertenece al cuerpo si es necesario para reproducir o interpretar
el cálculo ejecutado y contiene una entrada o hipótesis adoptada, una ecuación
operativa consumida, un control ejecutado o un resultado obtenido. Debe tener
símbolos, unidades, signos, dominio y procedencia definidos y no puede mezclar
alternativas, investigación, planes, inventarios de `UNKNOWN` ni metadata de
implementación o auditoría.

Los destinos permitidos son cuerpo aplicado, apéndice de desarrollo, apéndice
de control numérico, metodología/paper, SoT interna o eliminación de una
duplicación. La matriz de trabajo y sus evidencias se conservan en
`dev/SoT/CALCULATION-MEMO-SECTION-AUDIT.md`; este documento continúa siendo la
única fuente de verdad de Fase 2.

### 33.2 Identidad de la ejecución vigente

La inspección de `calculation.json`, la composición funcional y los productos
materializados demuestra que sólo se ejecutó el escenario
`verification-biaxial-uniform`:

- tensión vertical efectiva uniforme prescrita de 100 kPa en la elevación del
  centro de la sección;
- $K_0=0.5$ como valor constante adoptado y
  $\sigma'_h=50$ kPa;
- $\Delta u=0$;
- $\alpha=0$ y $\alpha=1$; y
- perfil nominal 76×25 mm con espesor base 3.0 mm y radio 1.315 m.

No se consumen tapada, estratigrafía, nivel freático variable, $P_F$, $S$,
equipo o tongadas FHWA, una formulación de interacción suelo--conducto,
propiedades netas de la sección deteriorada ni variables aleatorias. Las
resultantes vigentes constituyen un caso analítico determinístico de control;
no son la demanda del revestimiento existente.

### 33.3 Bloques rechazados

Quedan rechazados en el cuerpo de la memoria:

- la Tabla 1 del procedimiento;
- los encabezados «Cierre físico de los estados de carga» y «Controles
  mínimos»;
- la clasificación AASHTO no aplicada y el empuje escalar $T_L$ no evaluado;
- el catálogo de formulaciones de $K_0$ cuando la aplicación sólo adopta un
  valor constante;
- la interacción suelo--conducto como sección que declara una formulación
  pendiente;
- la acción FHWA de compactación no ejecutada;
- todo el capítulo «Plan de análisis probabilístico», incluidas «Datos
  conocidos y magnitudes por caracterizar», «Cierre del modelo determinístico»
  y la especificación futura de Monte Carlo;
- «Estado de la recuperación de tensiones» y cualquier promesa «se completará
  cuando...» sobre una operación no calculada; y
- la lista «Datos del revestimiento existente» usada como backlog público.

La relación $T_L=P_FS/2$ no fue inventada: está sustentada por USACE EM
1110-2-2902, ecuación 4-20. Su presencia en el cuerpo era impropia porque no
alimenta el modelo angular ni se evalúa en el escenario vigente. Las funciones
y fuentes de investigación pueden conservarse fuera de la memoria.

### 33.4 Tablas

Los encabezados públicos contienen símbolos o códigos compactos, no
descripciones, unidades o metadata. Las posiciones y unidades se definen en
el caption o en una nota de tabla. La tabla de extremos deberá usar, por
ejemplo, $\alpha$, $N_A$, $N_B$, $M_A$, $M_B$ y
$\max|Q_\theta|$, con $A$ y $B$ definidos fuera del encabezado. La tabla de
entradas se reconstruirá con los valores realmente consumidos; no incluirá
productos `UNKNOWN`, incrementos «no modelados», controles gráficos ni
identificadores internos.

### 33.5 Dictámenes vigentes y siguiente puerta

La ecuación de definición de $N_\theta$ y $M_\theta$ obtuvo PASS algebraico y
dimensional, pero FAIL documental: $\int_{A_b}(\cdot)dA$ es una integral de
área bidimensional a $\theta$ fijo; deben definirse $dA$, el eje centroidal,
$\xi$ como brazo firmado y la normalización $1/b$. El signo y la
implementación R son coherentes. El informe es
`/private/tmp/ar-sad40-eq1-integrals-audit.md`.

La primera mitad y el capítulo probabilístico obtuvieron FAIL en
`/private/tmp/ar-sad40-memo-front-sections-audit.md`. El procedimiento obtuvo
FAIL público en `/private/tmp/ar-sad40-memo-internal-sections-audit.md`. Falta
cerrar la auditoría de resultantes, rigidez, aplicación, conclusiones y
apéndices. Después se presentará al usuario una arquitectura reducida y la
lista exacta de cálculos o entradas que falten. No se editará ni renderizará el
candidato antes de esa aprobación.

### 33.6 Detención y nuevo plan de arquitectura documental y de cálculo

El usuario detuvo la corrección del HTML y exigió preparar un plan antes de
cualquier nueva implementación. La metodología auditada debe actuar como
fuente técnica de las fórmulas y decisiones; la memoria debe contener
exclusivamente el cálculo realizado. Las notas, metadata, dudas, poemas,
alternativas, planes y datos pendientes se conservan en la metodología o la
SoT según su función. Si falta una entrada necesaria, se solicita al usuario
fuera del reporte; no se crea una sección pública para explicar que no se
calculó.

El plan debe hacer visibles dos soportes de cálculo:

1. **R de producción:** inventario de cada función por etapa, con firma,
   entradas primitivas, contexto invariante, salidas, controles y consumidores;
   una composición de escenario debe poder leerse como una hoja de cálculo y
   la memoria debe consumir productos materializados, no reimplementar
   ecuaciones; y
2. **Wolfram de comprobación:** un único notebook `.nb` nativo, secuencial y
   autosuficiente para un escenario fijo, con texto, valores de entrada,
   sustituciones, resultados intermedios, resultantes, extremos y gráficos
   visibles. La comparación con R es el último control, no la razón de ser del
   cuaderno. No se usa `wolframscript` ni se crea un `.wl` como interfaz.

La auditoría de la segunda mitad ya cerró con FAIL editorial y PASS del núcleo
determinístico ejecutado en
`/private/tmp/ar-sad40-memo-back-sections-audit.md`. Confirmó los resultados de
$N_\theta$, $M_\theta$ y $Q_\theta$ y los seis controles cerrados para
$\alpha=0,1$, y confirmó que no se ejecutaron Monte Carlo, recuperación de
tensión ni AASHTO. No se editará la memoria, el código ni el notebook mientras
se prepara y revisa el nuevo plan.

## 34. Plan candidato de reconstrucción documental y soporte de cálculo

**Estado:** aprobado por el usuario el 2026-08-13. P34.1 y P34.2 se ejecutan
sobre soportes internos; P34.3 prepara un notebook candidato; P34.4 permanece
en la puerta de revisión del usuario. Esta aprobación no autoriza todavía la
reescritura del master de la memoria ni un nuevo render.

El objetivo observable es disponer de dos soportes de cálculo legibles y de
una memoria profesional que documente únicamente una ejecución reproducible.
La metodología conserva las bases, las derivaciones, las alternativas y los
contrastes; la SoT conserva decisiones, auditorías, datos pendientes y planes.
La existencia de una función o de una investigación no habilita su aparición
en la memoria.

### 34.1 Productos y fronteras

| Producto | Ruta gobernante | Contenido propio | Contenido excluido |
|---|---|---|---|
| metodología de referencia | `_master/methodology.review.es.qmd`, congelada | formulación general aprobada, derivaciones y fuentes del núcleo mecánico | cambios de Fase 2 |
| ampliación metodológica candidata | `_master/methodology.extension.review.es.qmd` | formulaciones posteriores que superen una auditoría por ecuación y por fuente | resultados del caso, promesas y texto de gestión |
| memoria de cálculo | `_master/calculation.review.es.qmd` | entradas adoptadas, ecuaciones efectivamente utilizadas, sustituciones, resultados y controles ejecutados | alternativas no adoptadas, investigación, `UNKNOWN`, planes, metadata, benchmarks generales y cálculos no realizados |
| implementación de producción | `scripts/R/` y `calculation.json` | funciones de cálculo, composición del escenario y productos reproducibles | prosa pública y decisiones editoriales |
| comprobación independiente | `scripts/wolfram/calculationScenario.nb` | un escenario fijo calculado de principio a fin, con resultados visibles | interfaz de producción, `wolframscript`, archivos `.wl` y planes futuros |
| gobierno interno | `dev/SoT/METHODOLOGY-PHASE2.md` y la matriz de auditoría | decisiones, destinos, gates, pendientes y evidencia de paridad | prosa del cliente |

La «hidratación» de la memoria no se hará mediante copia libre de párrafos ni
mediante ecuaciones reescritas dentro de fragmentos Quarto. Cada relación usada
seguirá esta correspondencia:

1. definición y dominio en la metodología auditada;
2. entrada en el registro interno de ecuaciones y convenciones;
3. helper R que la evalúa;
4. producto materializado bajo `data/calculation/`; y
5. fórmula final, sustitución y resultado en la memoria.

La ampliación metodológica vigente todavía es candidata. No se la declarará
fuente técnica auditada hasta revisar, como mínimo, las secciones consumidas
por el escenario: estado biaxial prescrito, participación tangencial, rigidez
circunferencial, ecuaciones de equilibrio y soluciones de comprobación. Las
ramas AASHTO, shotcrete, Monte Carlo, compactación e interacción quedan fuera
de esta primera reconstrucción porque no fueron ejecutadas.

### 34.2 Identidad de la memoria

El escenario materializado no representa todavía la demanda del revestimiento
existente. Por ello existen dos emisiones que no deben confundirse:

1. **caso analítico de referencia:** puede emitirse ahora con los datos y
   resultados ya calculados; y
2. **revestimiento existente:** sólo puede emitirse después de seleccionar y
   ejecutar el modelo de acciones del relleno real con sus entradas aprobadas.

Hasta cerrar esa segunda etapa, el título y las conclusiones deben identificar
el producto como memoria del caso analítico determinístico de referencia. No
se compensará la ausencia del caso real mediante listas de información
faltante dentro del reporte.

### 34.3 Arquitectura funcional R existente

No se propone una clase general nueva ni una segunda implementación. La cadena
de producción ya está separada en las siguientes funciones:

| Etapa | Helper | Entradas | Salida usada |
|---:|---|---|---|
| 0 | `buildThetaMesh(pointCount, criticalAnglesDeg)` | cantidad base y ángulos críticos, en grados | vector `theta` en radianes, creciente en $[0,2\pi)$ |
| 1 | `estimateK0(modelID, k0, frictionAngleDeg, poissonRatio, ocr, ocrMaximum)` | identificador de una única rama y sólo sus primitivas | `k0Applied` y trazabilidad de la rama; $K_0$ adimensional |
| 2 | `calculateEffectiveStressState(effectiveVerticalKPa, k0State, waterPressureDifferenceKPa, horizontalIncrementKPa, horizontalIncrementStatus)` | tensiones en kPa y estado de $K_0$ | $\sigma'_v$, $\sigma'_h$ y diferencia de presión de agua, en kPa |
| 3 | `interpolateCorrugatedSection(reference, profileID, baseThicknessMm)` | tabla publicada, perfil y espesor base | $A_\theta$ en mm²/mm, $I_\theta$ en mm⁴/mm y procedencia de la interpolación |
| 4 | `calculateRingSection(youngModulus, area, inertia, radius)` | sistema coherente; en el escenario: kPa, m²/m, m⁴/m y m | $EA_\theta$, $EI_\theta$, $I_\theta/(A_\theta R^2)$ y magnitudes equivalentes |
| 5 | `calculatePerimeterActions(stressState, alpha, theta)` | estado tensional, multiplicador $\alpha$ y malla | objeto de carga y ordenadas $P_r(\theta)$, $P_t(\theta)$ en kPa |
| 6 | `calculateSectionResultants(load, radius, theta, sectionRatio, integrationSteps, balanceTolerance, allowUnbalanced)` | carga, geometría, rigidez relativa y controles numéricos | respuesta `ringDirectResponse` con $N_\theta$, $M_\theta$, $Q_\theta$ y diagnósticos |
| 7 | `summarizeSectionResultants(response)` | respuesta de la etapa 6 | mínimos, máximos, máximos absolutos, signos y posiciones angulares |
| 8 | `calculateScenario(realization, context)` | primitivas variables de una realización y contexto invariante | lista ordenada con los estados de las etapas 1 a 7 |
| 9 | `buildCalculationData(configPath, outputDirectory, projectRoot)` | configuración, directorio de productos y raíz verificada | CSV consumidos por la memoria y copia exacta de la configuración |

En la llamada vigente, `calculateScenario()` separa:

- `realization`: `effectiveVerticalKPa`,
  `waterPressureDifferenceKPa`, `baseThicknessMm`, `alpha` y las primitivas de
  la rama de $K_0$ seleccionada; y
- `context`: `k0ModelID`, estado del incremento horizontal, tabla y perfil de
  la sección, módulo, radio, malla y tolerancias.

La forma legible del cálculo será una única secuencia, sin repetir ecuaciones:

```r
Theta <- buildThetaMesh(...)
K0State <- estimateK0(...)
StressState <- calculateEffectiveStressState(...)
CorrugatedSection <- interpolateCorrugatedSection(...)
SectionRigidity <- calculateRingSection(...)
PerimeterActions <- calculatePerimeterActions(...)
SectionResultants <- calculateSectionResultants(...)
ResultantExtrema <- summarizeSectionResultants(SectionResultants)
```

`calculateScenario()` continuará siendo la composición compacta de esa misma
secuencia. La documentación R mostrará ambas superficies: primero el cálculo
por etapas para auditoría y luego la fachada para repetir realizaciones. No se
agregará un helper que sólo renombre otro helper ni una clase destinada a un
único escenario.

`runRingMonteCarlo()` y `calculateSheetNormalStress()` permanecen fuera de la
memoria actual. La primera recibe realizaciones ya generadas y no define
distribuciones; la segunda requiere una sección neta y condiciones de
aplicabilidad que no fueron suministradas para esta ejecución.

### 34.4 Productos numéricos y oráculo de paridad

Antes de cualquier refactor se conservarán como oráculo los productos
determinísticos vigentes y sus tolerancias. Para el escenario adoptado:

- $A_\theta=3.7304717949$ mm²/mm;
- $I_\theta=287.9021537231$ mm⁴/mm;
- $EA_\theta=746094.35897$ kN/m;
- $EI_\theta=57.580430745$ kN·m²/m; y
- $I_\theta/(A_\theta R^2)=4.4630283681\times10^{-5}$.

Para $\alpha=1$, los extremos calculados son
$N_\theta\in[-131.5000,-65.7500]$ kN/m,
$M_\theta\in[-21.6211004,21.6095246]$ kN·m/m y
$\max|Q_\theta|=32.8750$ kN/m. Para $\alpha=0$, son
$N_\theta\in[-109.5833333,-87.6666667]$ kN/m,
$M_\theta\in[-14.4159963,14.4044204]$ kN·m/m y
$\max|Q_\theta|=21.9166667$ kN/m.

Los seis contrastes contra la solución cerrada presentan diferencias máximas
del orden de $10^{-12}$ frente a una tolerancia de $10^{-7}$. La migración
debe reproducir las curvas completas y estos productos; una prueba que sólo
compare extremos no basta. Los extremos simétricos se contrastarán por
posiciones analíticamente equivalentes y no por el primer ángulo seleccionado
por un desempate numérico.

### 34.5 Reconstrucción del notebook Wolfram

El notebook vigente no satisface su función pública de soporte de cálculo:
no conserva celdas `Output`, exige `schemaVersion == "2.0.0"` mientras la
configuración vigente declara `2.1.0`, y aborta antes de mostrar resultados.
Además dedica demasiado código a guards, lectura manual de CSV, estado de
operaciones no ejecutadas y un `overallPass` global.

Se reemplazará por un único `.nb` nativo, evaluado y guardado con la siguiente
secuencia:

1. objeto, convenciones y ecuaciones utilizadas;
2. valores primitivos del escenario fijo, asignados explícitamente y mostrados
   en una tabla;
3. cálculo visible de $K_0$, $\sigma'_h$ y estado de presiones;
4. lectura mediante funciones nativas de las filas de referencia, interpolación
   de $A_\theta$ e $I_\theta$ y cálculo de $EA_\theta$, $EI_\theta$ y la razón
   seccional;
5. definición y evaluación de $P_r(\theta)$ y $P_t(\theta)$ para cada $\alpha$;
6. resolución numérica principal de $N_\theta(\theta)$,
   $M_\theta(\theta)$ y $Q_\theta(\theta)$;
7. tabla de extremos y tres gráficos;
8. solución cerrada y Fourier como controles separados; y
9. comparación final con los productos R.

La comparación con R no condicionará la ejecución de las etapas 1 a 7. Se
eliminarán el guard de fixture, el parser CSV artesanal, la variable de entorno
como interfaz ordinaria, el bloque de tensión de chapa no evaluada y la
narrativa de estados pendientes. Al abrir el archivo deben verse los últimos
resultados guardados; `Evaluation > Evaluate Notebook` debe reproducirlos sin
internet, sin R, sin `wolframscript` y sin archivos `.wl`.

### 34.6 Estructura reducida de la memoria

El cuerpo candidato tendrá sólo estas funciones documentales:

1. **Objeto y alcance:** identidad exacta del caso calculado y magnitudes de
   salida;
2. **Datos adoptados y convenciones:** valores consumidos, unidades, signos y
   posiciones de referencia;
3. **Procedimiento de cálculo:** fórmulas finales de las acciones aplicadas,
   propiedades seccionales, rigideces y resultantes;
4. **Aplicación numérica:** sustituciones, estados intermedios, tabla de
   resultantes y tres figuras;
5. **Comprobaciones:** controles realmente ejecutados y sus errores; y
6. **Resultados y conclusiones:** valores obtenidos y alcance estricto de la
   ejecución.

El resumen ejecutivo se redactará al final, después de aprobar esas secciones.
El Apéndice A contendrá únicamente los desarrollos de equilibrio,
compatibilidad y rigidez usados. El Apéndice B contendrá la solución cerrada y
la comparación numérica del caso. No incluirá benchmarks bibliográficos no
aplicados.

Cada tabla pública usará símbolos o códigos breves en sus encabezados. Las
unidades, posiciones y definiciones se consignarán en el caption o en notas.
El documento no contendrá secciones denominadas «estado de», «pendientes»,
«controles mínimos», «cierre físico», «datos requeridos» ni formulaciones en
tiempo futuro.

### 34.7 Secuencia de ejecución y revisión del usuario

La implementación sólo comenzará después de aceptar este plan y seguirá estas
puertas, una por vez:

1. **P34.1 — registro técnico:** auditar las ecuaciones consumidas y depurar el
   registro de correspondencia; no incorporar ramas no ejecutadas.
2. **P34.2 — soporte R:** documentar la cadena por etapas, ejecutar sus pruebas
   vigentes y demostrar identidad de curvas y productos contra el oráculo.
3. **P34.3 — soporte Wolfram:** reconstruir, evaluar y guardar el notebook;
   contrastar primero sus resultados propios y luego la paridad con R.
4. **P34.4 — primera revisión pública:** presentar al usuario sólo el título,
   «Objeto y alcance» y «Datos adoptados y convenciones». No avanzar a la
   siguiente sección sin su dictamen.
5. **P34.5 — procedimiento:** presentar acciones adoptadas, rigidez y fórmulas
   finales de resultantes.
6. **P34.6 — aplicación:** presentar sustituciones, tablas y figuras generadas
   desde `data/calculation/`.
7. **P34.7 — apéndices:** presentar por separado los desarrollos y los
   controles numéricos.
8. **P34.8 — cierre:** redactar resultados, conclusiones y resumen; renderizar
   una candidata sólo después de la revisión sección por sección.

El primer paquete que requiere decisión del usuario será P34.4. En esa revisión
se resolverá además si el producto mantiene el título de caso analítico de
referencia o si debe quedar sin emisión pública hasta incorporar las acciones
del revestimiento existente.

### 34.9 Estado de ejecución al 2026-08-13

- **P34.1 — cerrado técnicamente:** el registro
  `dev/SoT/CALCULATION-EQUATION-REGISTER.md` contiene sólo CAL-E01--CAL-E10,
  explicita el puente de signo del momento con la Fase 1 y materializa los
  residuos normalizados de equilibrio global $F_x$, $F_z$ y $M_c$. Las ramas
  no consumidas permanecen excluidas.
- **P34.2 — cerrado:** `scripts/R/calculationScenarioExample.R` expone las
  etapas del cálculo y comprueba su identidad con `calculateScenario()`. Las
  pruebas `testRingMethod.R` y `testCalculationData.R` concluyen `PASS`. Las
  propiedades, cargas, curvas, extremos y escalas son idénticos byte por byte
  al oráculo previo; `numerical.controls.csv` agrega exclusivamente seis filas
  de equilibrio global a los seis contrastes cerrados.
- **P34.3 — en ejecución:** el notebook vigente se conserva intacto mientras
  se evalúa un candidato nativo, secuencial y con resultados visibles.
- **P34.4 — candidato no promovido:** el ledger
  `TITO/kb/calculation-memo/ledgers/calculation-P01-scope-conventions-2026-08-13.md`
  gobierna el primer paquete. El texto candidato permanece fuera de las rutas
  públicas hasta completar dos auditorías independientes y recibir el
  dictamen del usuario.

### 34.8 Salvaguardas de implementación

- La Fase 1 congelada no se edita ni se renderiza.
- No se inspecciona `_ref`.
- No se eliminan fuentes recuperadas.
- No se crea otra biblioteca ni una clase ortótropa general.
- No se asignan distribuciones Monte Carlo ni se informan resultados
  probabilísticos antes de aprobar sus entradas.
- No se calcula tensión de chapa, capacidad, pernos ni shotcrete dentro de esta
  reconstrucción determinística.
- No se cambia simultáneamente una ecuación y su oráculo. Toda modificación
  funcional se compara primero con los productos auditados.
- La memoria consume productos R materializados; los fragmentos Quarto no
  reimplementan el cálculo.

### 34.10 Repriorización y autorización de cierre documental

El usuario dispuso el 13 de agosto de 2026 terminar primero la memoria técnica
auditada y actualizada y postergar la reconstrucción de Wolfram. Esta decisión
autoriza reescribir y renderizar el candidato
`_master/calculation.review.es.qmd` conforme a la estructura reducida de la
Sección 34.6. No autoriza modificar la Fase 1 congelada ni incorporar a la
memoria cálculos resistentes, Monte Carlo, AASHTO, compactación o interacción
suelo--conducto que no fueron ejecutados en el escenario materializado.

El candidato Wolfram conservado fuera del repositorio queda descartado como
producto: mezclaba el cálculo con controles de paridad y metadata de auditoría
y no desarrollaba una hoja de cálculo autónoma hasta una comprobación
resistente. Cuando se retome esa rama se construirá después de la memoria y se
evitará la notación `X'[theta]` para magnitudes geotécnicas con prima, pues en
Wolfram esa sintaxis representa una derivada.

El cierre documental sigue esta secuencia vigente:

1. cuerpo con objeto, entradas, procedimiento, aplicación, comprobaciones y
   resultados del caso biaxial determinístico;
2. Apéndice A autónomo con los desarrollos efectivamente consumidos;
3. Apéndice B autónomo con la solución cerrada y la comparación numérica
   ejecutada;
4. auditorías técnica, editorial y de artefacto; y
5. render HTML para la aceptación del usuario.

### 34.11 Corrección de alcance — Monte Carlo permanece vigente

El usuario aclaró el 13 de agosto de 2026 que no había solicitado excluir
Monte Carlo. Su observación rechazaba una simulación presentada sin identificar
los parámetros variados, sus distribuciones y sus dependencias. En
consecuencia, la secuencia determinística de la Sección 34 sigue siendo el
nuevo núcleo auditable por realización, pero no constituye por sí sola el
cierre de la memoria completa.

Antes de ejecutar o redactar resultados probabilísticos deben quedar aprobados
como mínimo:

1. variables primitivas aleatorias y magnitudes determinísticas;
2. distribuciones marginales, parámetros y reglas de truncamiento;
3. dependencias físicas y estadísticas entre variables;
4. tratamiento de ramas discretas de modelo;
5. cantidad de realizaciones, semilla y criterio de convergencia; y
6. estadísticos de salida, distinguiendo cuantiles puntuales de
   $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$ de los
   cuantiles de extremos espaciales.

No se asignarán valores ni distribuciones por inferencia. El cuerpo
determinístico y los Apéndices A y B pueden cerrarse como base de cálculo; el
resumen, las conclusiones globales y la emisión final de la memoria permanecen
abiertos hasta integrar la propagación aprobada o recibir una decisión expresa
del usuario que defina una emisión determinística separada.

### 34.12 Contrato probabilístico observado

La auditoría del código existente concluye que `runRingMonteCarlo()` es un
agregador válido, no un generador de realizaciones. Recibe una tabla ya
muestreada, evalúa una respuesta determinística por fila y produce:

- cuantiles puntuales de $N_\theta(\theta)$, $M_\theta(\theta)$ y
  $Q_\theta(\theta)$;
- mínimos, máximos y máximos absolutos por realización; y
- cuantiles escalares de esos extremos, sin asignarles un ángulo ficticio.

La función de escenario vigente puede variar por realización
`effectiveVerticalKPa`, `waterPressureDifferenceKPa`, `baseThicknessMm`,
`alpha` y las primitivas de una única rama de $K_0$. En cambio, no deriva aún
la tensión vertical desde tapada, pesos unitarios, estratigrafía y sobrecarga;
no incorpora presión horizontal residual de compactación; no admite una rama
de $K_0$ variable dentro de un mismo lote; y no conecta corrosión, sección
neta, tensión, capacidad o factor de seguridad.

No existe todavía en el repositorio:

- especificación de marginales, parámetros y truncamientos;
- generador conjunto de realizaciones, semilla o dependencia estadística;
- probabilidades de ramas discretas;
- protocolo de tamaño de muestra y convergencia;
- persistencia de entradas y diagnósticos de cada corrida; ni
- una función de salida resistente conectada a la simulación.

Por ello se distinguen dos puertas:

1. **MC-R:** propagación hasta resultantes seccionales, una vez que se aprueben
   las primitivas geotécnicas, sus marginales, dependencias y el tratamiento
   de compactación y de $\alpha$; y
2. **MC-S:** propagación hasta tensiones y factor de seguridad, sólo después de
   definir la sección neta deteriorada, la recuperación local de tensiones y
   la verificación resistente aplicable.

$N_\theta$, $M_\theta$, $Q_\theta$, las tensiones y el factor de seguridad son
salidas; no se muestrean como entradas. Tampoco se muestreará $K_0$ junto con
las primitivas que lo determinan, ni $\sigma'_v$ junto con las variables de
las cuales se derive, ni una presión residual de compactación junto con una
historia tensional que represente el mismo efecto.

Los informes completos de solo lectura están en
`/private/tmp/ar-sad40-monte-carlo-contract-audit.md`,
`/private/tmp/ar-sad40-monte-carlo-inputs-evidence.md` y
`/private/tmp/ar-sad40-monte-carlo-document-boundary.md`.

### 34.13 Cierre de la base por realización y evidencia probabilística

La base determinística reestructurada concluyó las auditorías técnica y
editorial con `PASS`. La memoria define $N_\theta$, $M_\theta$ y $Q_\theta$,
declara correctamente la malla base de integración, expone el perfil NCSPA que
gobierna la interpolación y presenta sólo entradas, sustituciones, resultados y
comprobaciones ejecutadas. El HTML vigente se encuentra en
`html/calculation.review.es/index.html`. Este cierre acredita el cálculo de una
realización; no cierra la memoria completa ni reemplaza Monte Carlo.

La matriz de evidencia para parametrizar MC-R se conserva en
`TITO/kb/research/monte.carlo.parameterization.es.md`. Sus reglas vigentes son:

1. las familias y dispersiones de JCSS y JRC son antecedentes condicionados
   por clase de suelo y calidad de determinación, no *priors* del proyecto;
2. $K_0$ es derivado de $\phi'$ y OCR cuando se adopta esa rama y no recibe
   simultáneamente una marginal independiente;
3. la compactación residual permanece separada del estado geostático hasta
   seleccionar un modelo y datos de caracterización;
4. $\alpha$ participa en Monte Carlo, pero su distribución no se presume
   uniforme ni se identifica con $\tan\delta$;
5. las ramas granular, cohesiva o cementada permanecen separadas sin pesos de
   modelo sustentados; y
6. los cuantiles puntuales de las curvas y los cuantiles de extremos
   espaciales son productos distintos.

La auditoría de fuentes descartó de la promoción una atribución no cerrada al
procedimiento MLE/Kolmogorov--Smirnov de Caleyo et al. (2009). No se usará esa
frase ni sus familias de picadura para MC-R. La rama de deterioro queda
diferida a MC-S y se apoyará prioritariamente en el perfil ultrasónico del
conducto, conforme a Mai (2013).

Se recuperaron y verificaron las dos fuentes oficiales nuevas
`jrc_2024_reliability_geotechnical_structures.pdf` y
`mndot_2018_cpt_design_guide.pdf`; su procedencia, páginas y SHA-256 están en
`TITO/kb/MANIFEST.md`.

## 35. Recuperación selectiva de la memoria técnica

La revisión directa del usuario del 13 de agosto de 2026 establece que la
reducción de `_index/calculation.review.ES.qmd` eliminó contenido técnico que
debía corregirse y conservarse. Esta decisión sustituye cualquier
interpretación de la Sección 34 que autorice resolver defectos editoriales
mediante la supresión completa de capítulos. El HTML vigente se conserva como
evidencia del núcleo determinístico, pero queda rechazado como memoria técnica
completa.

La recuperación no se ejecuta mediante `git checkout`, reversión global ni
reinserción literal del ensamblado anterior. Cada bloque se recupera desde su
fuente existente, se audita contra la evidencia y se reescribe para su función
documental antes de incorporarlo. El núcleo de cálculo por realización,
incluidas las definiciones de $N_\theta$, $M_\theta$ y $Q_\theta$, la
integración directa, la solución cerrada y los productos materializados, se
conserva.

### 35.1 Contenido que debe recuperarse

1. La cadena de acciones: tensión vertical efectiva, agua, estimación de
   $K_0$, compactación, acción FHWA y transformación en acciones perimetrales.
   Las formulaciones alternativas se identifican como ramas y la aplicación
   declara cuál se evalúa en cada escenario.
2. La formulación conjunta de $N_\theta$, $M_\theta$ y $Q_\theta$, las
   condiciones de equilibrio y compatibilidad y las rigideces
   circunferenciales del perfil.
3. Los contrastes sustentados de USACE, FHWA y Núñez. Los resultados
   bibliográficos o reproducidos se ubican en un apéndice de referencia; no se
   confunden con resultados del revestimiento analizado. CANDE y el trabajo de
   Núñez--Sfriso--Laiún (2014) no se incorporan como benchmarks de la memoria.
4. La recuperación de tensión normal de la chapa y la alternativa de
   shotcrete se conservan en la metodología hasta que existan entradas y una
   ejecución aplicable; no se publican capítulos de estado o promesas de
   cálculo.
5. Monte Carlo permanece dentro del producto final. El capítulo público se
   incorpora sólo después de aprobar el contrato de variables, ejecutar la
   simulación y materializar sus resultados.

### 35.2 Propiedades del perfil corrugado

La entrada vigente documenta paso nominal de 76 mm, profundidad nominal de
25 mm y espesor informado de 3,0 mm. La tabla NCSPA 3×1 in utilizada hasta
ahora es una fuente imperial y no demuestra por sí sola las propiedades del
perfil métrico real. La interpolación de esa tabla queda excluida de la
reconstrucción pública hasta identificar una tabla métrica del producto o
definir la geometría completa de la onda y calcular sus propiedades.

El área, la inercia, las rigideces y cualquier tensión derivada que dependa de
ellas se marcarán internamente como condicionadas. No se sustituirá el dato
faltante con otro perfil ni se conservarán decimales producidos por una
interpolación cuya aplicabilidad no esté demostrada. El informe de regresión
es `/private/tmp/ar-sad40-section-properties-regression.md`.

### 35.3 Secuencia vigente

1. **Cerrado:** mapa de recuperación contra Git y las fuentes conservadas.
2. **Cerrado:** acciones, $K_0$, resultantes y rigidez corregidos y
   reincorporados.
3. **Cerrado:** contrastes reorganizados en apéndices autónomos.
4. **Cerrado:** propiedades métricas resueltas mediante la fila CSPI exacta.
5. **Pendiente:** aprobar y ejecutar MC-R hasta envolventes de resultantes.
6. **Cerrado para la realización determinística:** auditoría de las secciones
   públicas y render del HTML candidato; debe repetirse después de integrar
   MC-R.
7. **Posterior:** MC-S, tensiones, resistencia, juntas, pernos y shotcrete.

Los informes que originan esta recuperación son
`/private/tmp/ar-sad40-memo-content-regression.md`,
`/private/tmp/ar-sad40-section-properties-regression.md` y
`/private/tmp/ar-sad40-plot-style-regression.md`.

### 35.4 Selección seccional adoptada

El usuario resolvió el 13 de agosto de 2026 la puerta descrita en 35.2: para
el cálculo se adopta la fila menor publicada por CSPI para chapa CSP de perfil
76×25. La fila se identifica mediante espesor especificado
$t_s=2{,}80$ mm y emplea espesor base de diseño $t_d=2{,}64$ mm. Sus
propiedades por unidad de ancho proyectado son $A_p=3{,}281$ mm²/mm,
$I_p=249{,}73$ mm⁴/mm y $S_p=17{,}81$ mm³/mm; la geometría publicada es
76,2/25,4/R14,29. La evidencia y sus localizadores se conservan en
`dev/chapa/HANDOFF-chapa-76x25-espesor-2026-08-13.md`.

El productor debe seleccionar la fila `cspi-76x25-2.8` de forma exacta y
materializar por separado $t_s$ y $t_d$. Quedan prohibidas en la rama activa
la interpolación a 3,0 mm, la tabla NCSPA 3×1 y la sustitución por la fila
CSPI de 3,5 mm. La función histórica de interpolación se conserva únicamente
para reproducir los fixtures que acreditan la línea base previa; no gobierna
el escenario del reporte.

### 35.5 Cierre de la reconstrucción determinística

La recuperación selectiva terminó el 13 de agosto de 2026. El ensamblado
vigente contiene, en este orden, objeto y alcance, procedimiento de cálculo,
acciones del relleno y estimación de $K_0$, rigideces circunferenciales,
resultantes $N_\theta$, $M_\theta$ y $Q_\theta$, aplicación numérica,
comprobaciones ejecutadas y resultados determinísticos. Los apéndices reúnen
por separado el desarrollo matemático, los controles numéricos y las
reproducciones documentales de USACE, FHWA y Núñez (2000).

La configuración activa selecciona exactamente `cspi-76x25-2.8` desde
`data/reference/cspi.corrugation.section.properties.csv`. Las propiedades
publicadas se distinguen de las rigideces derivadas. La cita pública localiza
la geometría en la figura 2.1 y las propiedades seccionales en la tabla 2.4
del manual CSPI; las unidades figuran en el caption de la tabla de aplicación.

Las siguientes comprobaciones concluyeron `PASS`:

- generación reproducible de `data/calculation/` desde `calculation.json`;
- contrato de datos, cargas, mecánica, figuras, adaptador de salida Monte
  Carlo y recuperación condicional de tensión normal;
- igualdad entre el cálculo por etapas y `calculateScenario()`;
- auditoría técnica de las acciones;
- auditoría editorial del ensamblado; y
- auditoría independiente de la integración seccional métrica.

El HTML candidato es `html/calculation.review.es/index.html`, SHA-256
`3ed1fc08e3463ad76e04fe8b6aa56048cd913422b2096a4afa0cf34cea0d1205`.
Este producto representa una realización determinística de referencia. No
informa aún envolventes Monte Carlo ni resistencia de chapa, juntas, pernos o
shotcrete. La etapa siguiente es acordar el contrato MC-R sin asignar
distribuciones o dependencias por inferencia.

## 36. Auditoría y comparación paramétrica de $K_0$

### 36.1 Corrección documental verificada

La ecuación 8 de Michalowski (2005) transcribe la forma de Jáky de 1944 como

$$
K_{0,\mathrm{J\acute{a}ky\,1944}}
=(1-\sin\phi')
\frac{1+\frac{2}{3}\sin\phi'}{1+\sin\phi'}.
$$

La versión con $\sin^2\phi'$ era una transcripción errónea. La inspección del
PDF vectorial localizó el carácter `2` sobre el carácter `3`, ambos antes de
la palabra `sin`; ese carácter pertenece a la fracción $2/3$ y no es un
exponente. La corrección afecta la SoT, el ledger de evidencia y el candidato
metodológico. No modifica la forma abreviada
$K_{0,NC}=1-\sin\phi'$ implementada en R.

### 36.2 Formulaciones que pueden compararse

Las ramas actualmente respaldadas e implementadas son:

| Rama | Variables primitivas | Condición representada |
|---|---|---|
| valor adoptado | $K_0$ declarado | hipótesis de comprobación o sensibilidad; no es una estimación del relleno |
| elasticidad confinada | $\nu_g$ | continuo elástico lineal e isótropo con deformación lateral impedida |
| Jáky | $\phi'$ | carga primaria o estado normalmente consolidado |
| Mayne--Kulhawy, descarga | $\phi'$, OCR | descarga primaria desde compresión virgen |
| Mayne--Kulhawy, recarga | $\phi'$, OCR, $\mathrm{OCR}_{\max}$ | descarga seguida de recarga con historia máxima identificable |

Las ramas no son estimadores intercambiables que puedan evaluarse con un único
vector de parámetros. Una medición representativa, Brooker--Ireland,
Mesri--Hayat, una corrección por cementación y una presión residual de
compactación para el conducto no están habilitadas como ramas operativas.
Permanecen fuera de una comparación numérica hasta preservar y verificar la
fuente primaria y, cuando corresponda, implementar su dominio.

FHWA y USACE reproducen relaciones ya catalogadas dentro de sus respectivos
contextos; no constituyen nuevas formulaciones de $K_0$. Núñez (2000) recibe
$K_0$ como parámetro de su formulación de cargas e interacción y no aporta, en
las páginas verificadas, una correlación independiente para estimarlo. Las
comparaciones de cargas de esas fuentes permanecen separadas de la comparación
geotécnica de $K_0$.

Con $s=\sin\phi'$, las comparaciones algebraicas auditables son

$$
\frac{K_{0,OC}}{K_{0,NC}}=\mathrm{OCR}^{s},
$$

$$
\frac{K_{0,R}}{K_{0,NC}}
=\frac{\mathrm{OCR}}
{\mathrm{OCR}_{\max}^{\,1-s}}
+\frac{3}{4}\left(
1-\frac{\mathrm{OCR}}{\mathrm{OCR}_{\max}}
\right),
$$

y la igualdad puramente algebraica entre Jáky y la idealización elástica se
produce para

$$
\nu_g=\frac{1-\sin\phi'}{2-\sin\phi'}.
$$

Esta última identidad no define una correlación entre $\nu_g$ y $\phi'$.

### 36.3 Incidencia en el caso biaxial prescrito

Manteniendo iguales $\sigma'_v$ y $\Delta u$ para aislar la influencia de
$K_0$,

$$
\sigma'_h=K_0\sigma'_v,
\qquad
p_m=\Delta u+\frac{1+K_0}{2}\sigma'_v,
\qquad
\Delta\sigma=(1-K_0)\sigma'_v.
$$

Por lo tanto, la componente media aumenta con pendiente $\sigma'_v/2$ y la
amplitud desviadora disminuye con pendiente $-\sigma'_v$. Para $K_0=1$ la
proyección biaxial no contiene una componente armónica; para $K_0>1$ ésta
cambia de signo. Estas relaciones pertenecen al caso prescrito y no convierten
$K_0\sigma'_v$ en una ley general de contacto para un conducto flexible.

### 36.4 Frontera documental y de datos

La tabla de entradas y la aplicación numérica de la memoria presentan sólo la
rama aplicada, sus primitivas, $K_0$ calculado, $\sigma'_v$, $\sigma'_h$ y el
estado de control. Esos valores se leen de
`data/calculation/stress.state.csv`; no se transcriben en prosa o tablas. El
capítulo de acciones conserva las fórmulas finales de las ramas seleccionables
como parte del procedimiento, pero no les atribuye resultados alternativos no
ejecutados. El valor $K_0=0.50$ vigente es una entrada explícita de
`calculation.json` para el escenario de comprobación, no una estimación del
relleno existente.

La comparación completa pertenece al candidato metodológico o a un apéndice
de sensibilidad expresamente aprobado. Su arquitectura mínima será:

1. conservar `stressState.k0Model` como la única rama aplicada;
2. admitir una colección opcional de casos de estudio, cada uno con un
   identificador único, una formulación y sólo sus variables primitivas;
3. evaluar cada caso mediante `estimateK0()` y
   `calculateEffectiveStressState()`, sin duplicar ecuaciones;
4. materializar una tabla `data/calculation/k0.cases.csv` con entradas,
   resultado, dominio y fuente;
5. construir tablas y figuras exclusivamente desde ese producto; y
6. propagar cada caso a `calculateScenario()` sólo después de aprobar la
   comparación estructural y sus entradas.

No se asignarán probabilidades, pesos ni promedios entre formulaciones. En
Monte Carlo se muestrean las variables primitivas de una rama aprobada; $K_0$
es una salida derivada. Si la selección de rama permanece incierta y no hay
pesos sustentados, cada rama contribuye como escenario discreto a una
envolvente exterior.

El campo `domainStatus` vigente en las ramas Mayne--Kulhawy controla sólo si
se alcanzó el límite pasivo. No demuestra que el estado se encuentre dentro
del intervalo empírico: para descarga debe distinguirse $\mathrm{OCR}<15$ de
una extrapolación anterior al límite pasivo, y la recarga debe conservar la
advertencia de evidencia limitada. Ese estado adicional es obligatorio antes
de habilitar estas ramas en Monte Carlo; no se impondrá mediante truncamiento.

### 36.5 Datos pendientes para la comparación numérica

Antes de materializar casos deben definirse, sin inferencia:

- clase y condición de drenaje del relleno;
- intervalo y base de $\phi'$;
- intervalo de $\nu_g$ si se mantiene el escenario elástico;
- OCR y $\mathrm{OCR}_{\max}$ o las tensiones históricas que los determinan;
- tratamiento de la compactación: historia representada por $K_0$ o incremento
  residual separado, sin doble conteo; y
- si la comparación mantiene fijo el estado vertical y el agua para aislar
  $K_0$, o si cada escenario reconstruye también su historia vertical.

Hasta recibir estas decisiones, sólo se publican las comparaciones analíticas
anteriores y la rama determinística aplicada. Los números utilizados en
pruebas R continúan siendo controles internos y no resultados de la memoria.

### 36.6 Estado de ejecución

La reauditoría de fuentes se conserva en
`TITO/kb/research/g10.k0.formulations.reaudit.es.md`; el informe independiente
completo está en
`/private/tmp/ar-sad40-k0-source-reaudit-2026-08-13.md`. La auditoría de
parametrización está en
`/private/tmp/ar-sad40-k0-parameterization-audit-2026-08-13.md`.

`Rscript scripts/R/testCalculationData.R` concluyó `PASS` después de probar la
actualización documental para una rama adoptada, Jáky y Mayne--Kulhawy en
descarga. `git diff --check` concluyó `PASS`. Los renders concluyeron:

- metodología ampliada: SHA-256
  `a7b870a96c22a1ddb3f4c7ec3da74095f18240f0f42cc1928acbc55bc28fa3fb`; y
- memoria de cálculo: SHA-256
  `b182fec755dc90bbfa13f38a1a461922e78a93ff70f08e0f2c8b4cc6b5e4a80d`.

La comparación numérica no está ejecutada. Su ausencia es deliberada: aún no
se han aprobado las primitivas ni las trayectorias que deben definir los
casos. No debe interpretarse el valor constante vigente como estimación del
relleno ni como distribución para Monte Carlo.

## 37. Transición aprobada a la evaluación estructural

### 37.1 Base documental preservada

El usuario aprobó el 13 de agosto de 2026 la memoria determinística vigente y
la presentación de las formulaciones de $K_0$. Esta versión se conserva como
base de la ampliación siguiente. La incorporación de nuevas comprobaciones no
autoriza a retirar acciones, formulaciones de $K_0$, rigideces, resultantes,
controles ni resultados ya aceptados.

La sustitución aritmética visible de valores en la sección de aplicación está
parametrizada mediante R y no constituye un valor escrito manualmente. Su
simplificación editorial puede realizarse sin alterar el productor de datos:
las entradas permanecen en `calculation.json`, los resultados en
`data/calculation/` y la prosa consume exclusivamente esos productos.

### 37.2 Benchmarks

Los contrastes reproducibles de Einstein--Schwartz, Núñez, FHWA, USACE u otras
fuentes se ubicarán después de los resultados del caso determinístico, en un
apéndice independiente. Cada contraste deberá distinguir datos publicados,
resultados publicados reproducidos, resultados derivados y controles internos.
No se incorporará una comparación sin fuente primaria, localizador, unidades,
convenciones y ejecución reproducible. Los benchmarks no modificarán las
acciones adoptadas ni se presentarán como calibración del caso.

### 37.3 Secuencia estructural

La ampliación se ejecutará mediante puertas separadas:

1. **chapa:** recuperar la demanda normal circunferencial desde
   $N_\theta$ y $M_\theta$ con propiedades seccionales declaradas; incorporar
   una comprobación resistente sólo cuando la clasificación del producto, la
   rama normativa, el acero, la sección neta por corrosión y los efectos de
   cálculo estén definidos;
2. **juntas y pernos:** abrir la transformación de resultantes a demandas de
   junta únicamente después de recibir geometría, cantidad, disposición,
   material y mecanismo resistente de los pernos; y
3. **shotcrete u hormigón simple:** evaluar como sección estructural autónoma o
   compuesta sólo después de definir su función, geometría, materiales,
   armadura y transferencia de acciones.

La falta de datos de las puertas segunda y tercera no se representa mediante
valores supuestos ni mediante capítulos públicos de trabajo pendiente.

### 37.4 Parametrización obligatoria

La evaluación de chapa seguirá la arquitectura ya aplicada al caso
determinístico: entradas declaradas, funciones R puras, productos tabulares en
`data/calculation/` y consumidores Quarto sin resultados escritos manualmente.
La recuperación de tensiones, la resistencia de pared, el pandeo, las costuras
y las conexiones son productos diferentes y conservarán estados de evaluación
separados. Una razón respecto de la primera fluencia no se denominará factor de
seguridad AASHTO ni verificación global.

El notebook Wolfram se desarrollará en paralelo como hoja de cálculo de apoyo
para un escenario fijo. La implementación R y la memoria profesional gobiernan
el producto; el notebook no introduce fórmulas, propiedades ni resultados que
no existan previamente en la cadena auditada.

## 38. Hito auditado de demanda elástica y casos de referencia

### 38.1 Demanda de la sección publicada

La primera puerta de chapa queda cerrada únicamente para la recuperación
elástica de tensión normal circunferencial de la sección CSPI publicada. Las
propiedades adoptadas corresponden a la fila exacta CSP 76×25 de espesor
especificado 2,80 mm y espesor base de diseño 2,64 mm:

$$
A_p=3{,}281\ \mathrm{mm^2/mm},\qquad
I_p=249{,}73\ \mathrm{mm^4/mm},\qquad
S_p=17{,}81\ \mathrm{mm^3/mm}.
$$

Con tracción positiva y momento positivo cuando tracciona la fibra interior,
las expresiones operativas son

$$
\sigma_{\theta,e}=\frac{N_\theta}{A_p}
-1000\frac{M_\theta}{S_p},\qquad
\sigma_{\theta,i}=\frac{N_\theta}{A_p}
+1000\frac{M_\theta}{S_p}.
$$

El productor materializa `sheet.normal.stress.csv` y
`sheet.normal.stress.extrema.csv`; la tabla y la prosa de la memoria consumen
esos productos. La evaluación se identifica como adopción del modelo lineal
homogeneizado para la sección publicada. No se presenta como verificación de
la sección neta corroída, capacidad resistente o cumplimiento AASHTO. La
fuerza cortante $Q_\theta$ se conserva sin transformarla en tensión local.

### 38.2 Casos de referencia reproducibles

El Apéndice C contiene cuatro familias separadas de la aplicación:

1. USACE EM 1110-2-2902, ejemplo D4;
2. FHWA-RD-98-191, ecuación 5.1 y su tabla de compactación;
3. Schwartz--Einstein, ejemplo HP97; y
4. Núñez (2000), ejemplos circulares.

Los datos publicados y sus localizadores residen en `data/reference/`. El
productor `buildReferenceCaseData()` vuelve a evaluar las relaciones y
materializa los productos en `data/benchmarks/` durante cada ejecución de la
memoria. Las tablas no consumen fotografías numéricas ni valores escritos en
la prosa. Cada fila distingue dato publicado, resultado publicado reproducido,
resultado derivado o discrepancia de fuente. Los valores de $a_N$ de Núñez son
entradas publicadas no redondeadas; $A_N$, $M_{\max}$, $N_C$ y $N_A$ se
recalculan. Estos casos comprueban transcripción, unidades y evaluación
aritmética dentro de sus dominios; no calibran las acciones del caso.

### 38.3 Comprobaciones del hito

Concluyeron `PASS` el productor de la memoria y las pruebas de contrato,
tensión de chapa, casos de referencia, carga de productos, mecánica,
figuras y adaptador Monte Carlo. El render
`qrt render _master/calculation.review.es.qmd --profile html` concluyó
correctamente y produjo `html/calculation.review.es/index.html`, SHA-256
`c4450fc801df3a33539df10301257c599b88c8cbeff85acffbee10d21e4d0a3e`.

La reauditoría editorial final concluyó `PASS` en
`/private/tmp/ar-sad40-report-final-editorial-reaudit-2026-08-13.md`; la
reauditoría de política y arquitectura R concluyó `PASS` en
`/private/tmp/ar-sad40-report-final-r-policy-reaudit-2026-08-13.md`.
La Fase 1 congelada no fue regenerada ni modificada.

### 38.4 Secuencia posterior

La publicación de este hito precede al soporte Wolfram. El notebook anterior
no se extiende: se reconstruirá una candidata `.nb` autocontenida para una
realización fija, con entradas, resultados intermedios, resultantes, extremos,
gráficos y demanda elástica visibles. No importará productos R ni mostrará
metadatos de paridad como resultados de ingeniería. La resistencia de la
chapa, juntas y pernos, shotcrete y la simulación de Monte Carlo continúan como
puertas independientes y no se infieren desde este cierre.
