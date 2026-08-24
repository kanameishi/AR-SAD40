# Protocolo de auditoría de código — motor R

Método reproducible para auditar el motor de cálculo contra los estándares de
`~/github/agents/`. No es un plan de corrección: define cómo se produce un
dictamen defendible. El plan vigente está en `checkpoint.md`.

Repuesto el 2026-08-18 tras una remedición que encontró cuatro cifras
incorrectas en la versión anterior. Las secciones 3, 4 y 5 existen por errores
concretos y las secciones 2 y 8 se endurecieron por los que se escaparon igual.

## 0. Principio rector

No inferir. Toda afirmación del dictamen se sostiene en una de tres cosas:

1. una línea de código citada con archivo y número;
2. un localizador exacto de norma efectivamente leído; o
3. una medición ejecutada y reproducible.

Lo que no se sostiene así se marca `UNKNOWN` y se pregunta. **Un hallazgo sin
evidencia ejecutada no es un hallazgo: es una sospecha**, y las sospechas no
entran al dictamen.

## 1. Encuadre, antes de abrir código

1. Resolver el routing. Para revisión de R sin modificarlo: `R.md`, más
   `STYLE.md` y `PRACTICE.md` porque son el estándar contra el que se juzga;
   `RESEARCH.md` si hay verificación normativa; `DATA.md` si se inspeccionan
   PDF o artefactos grandes; `QRT.md` y `PSHA.md` para infraestructura de
   render y contenido de scaffold.
2. Seleccionar el tier. Auditoría de sólo lectura es Tier 0; un traspaso
   explícito a otra sesión es Tier 1 y abre `HARNESS.md`.
3. **Fijar el estado medido**: rama, `git rev-parse HEAD` y
   `git status --porcelain`. Toda cifra queda atada a ese commit.
4. Declarar alcance y exclusiones por escrito antes de medir.
5. Establecer si hay escritores concurrentes. Si los hay, la sección 7 es
   obligatoria.

## 2. Inventario mecánico, con el instrumento correcto

Barrido acotado que produce números, no opiniones. **El instrumento importa
tanto como la medición**: una heurística de texto sobre código estructurado da
cifras que parecen medidas y no lo son.

| Dimensión | Instrumento obligatorio |
|---|---|
| Longitud de funciones | parser de R con `srcref`. **Nunca** contar líneas entre definiciones con `awk` o `grep`: infla con funciones anidadas y código de cola |
| Rendimiento | `Rprof` sobre la entrada real, informando `% total` y `% propio`. **Nunca** estimar por lectura |
| Complejidad algorítmica | contar las iteraciones reales y medir el escalado con al menos tres tamaños de entrada |
| Código muerto | referencias en **todo** `git ls-files`, no sólo en el árbol de código |
| Parámetros no usados | `formals()` contra el cuerpo deparseado |
| Nombres | recuento contra el vocabulario de `STYLE.md` |
| Duplicación | batería diferencial de entradas, no comparación de nombres |
| Suite | ejecución completa, no muestreo |

Excluir datos por construcción: partir de `git ls-files` con lista blanca de
extensiones de fuente.

## 3. Falsación obligatoria

Ningún candidato entra al dictamen sin un intento de refutación **ejecutado**.

| Candidato | Refutación exigida |
|---|---|
| Duplicación de validadores | batería diferencial sobre entradas límite; si coinciden, no es defecto |
| Colisión de nombres | ¿los consumidores aíslan el entorno? ¿el cruce fallaría ruidosamente? |
| Acoplamiento por texto | evaluar **todas** las rutas contra un objeto real |
| Código muerto | buscar en todo archivo versionado, incluidos README, `.qmd`, `.wl`, `.nb` |
| Rama muerta | leer la asignación previa y probar que el estado ya era ese |
| Afirmación de documentación | ejecutar lo que la documentación afirma |
| Fórmula normativa | reproducir un punto a mano y comparar |
| Cuello de rendimiento | perfilar antes de nombrar la función |
| Divergencia de estilo entre builders | comprobar que ambos usan la **misma API**; una función distinta puede no admitir el parámetro |

Si el candidato sobrevive, es defecto. Si no, se registra como **verificado y
descartado**, con su evidencia, en sección propia. Esa sección existe para que
nadie lo «corrija» después.

En la auditoría de origen cayeron tres candidatos en este paso y dos
afirmaciones sobrevivieron indebidamente por no aplicarlo a rendimiento ni a
identidad de API.

## 4. Autoverificación del arnés

Antes de atribuir un defecto al código, descartar que sea del instrumento:

- ¿la extracción capturó basura? Inspeccionar las cadenas extraídas antes de
  evaluarlas. Una asignación capturada por error puede anular el objeto bajo
  prueba y hacer fallar todo lo que sigue.
- ¿la copia de trabajo está completa? Un snapshot parcial hace fallar tests
  que dependen de directorios ausentes; eso no es un defecto del código.
- reproducir el hallazgo por una segunda vía independiente antes de publicarlo.

**Un resultado sorprendente se contrasta antes de reportarse**, no después.

## 5. Clasificación y severidad

Tres categorías; sólo la primera genera trabajo:

- **Defecto** — produce o puede producir un resultado incorrecto, o afirma
  algo que la implementación no establece.
- **Riesgo** — hoy correcto, sin guarda que lo mantenga así.
- **Preferencia** — conforme al estándar, distinto del gusto del auditor. No
  se toca, y se dice explícitamente que no se toca.

La severidad se asigna por consecuencia observable, nunca por tamaño del
cambio.

## 6. Verificación contra normas externas

1. Lectura acotada por rango de páginas a un archivo de trabajo.
2. Registrar el localizador exacto y el **nivel de acceso real**: texto
   completo, lectura dirigida, índice, o vista previa.
3. Registrar el SHA-256 de la fuente preservada.
4. Prohibido citar articulado no leído.
5. Cuando demanda y resistencia provengan de cuerpos normativos distintos,
   verificar la coherencia de calibración entre factores.

## 7. Contra-medición antes de publicar

1. Releer `git rev-parse HEAD` y `git status --porcelain`.
2. Si el árbol cambió respecto de la sección 1, **remedir todo lo que dependa
   del árbol** antes de publicar cualquier cifra.
3. Publicar cada cifra junto al commit sobre el que se midió.
4. Si una cifra ya comunicada quedó obsoleta, corregirla explícitamente.

En la auditoría de origen el árbol cambió tres veces y varias cifras
publicadas quedaron obsoletas.

## 8. Durabilidad del dictamen

Un dictamen que vive sólo en el chat se pierde. Las conclusiones y sus cifras
se escriben en el documento **en el momento en que se obtienen**, no al final.

Esto incluye lo que se declara fuera de alcance: si la auditoría detecta
rendimiento, duplicación o deuda que no se va a corregir, esa lista va al
documento igual, con su medición. Una observación mencionada al pasar y no
registrada equivale a no haberla hecho.

## 9. Producto

**Dictamen** — qué está mal: veredicto; estado medido con commit; tabla de
evidencia primaria con localizadores, nivel de acceso y hash; hallazgos
numerados con severidad, evidencia y consecuencia; sección de verificado y
descartado; riesgos sin corrección propuesta; `UNKNOWN` bloqueantes.

**Plan** — qué hacer: fases ordenadas por severidad con condición observable
de terminado; qué es borrable y con qué método se comprobó; qué requiere
ruling; y qué **no** hay que corregir.

## 10. Gates de aceptación

No se entrega si alguno falla:

1. toda cifra tiene comando reproducible y commit asociado;
2. toda cifra usó el instrumento que exige la sección 2;
3. todo hallazgo pasó por la sección 3;
4. toda cita normativa tiene localizador leído y nivel de acceso declarado;
5. la sección de verificado y descartado no está vacía si hubo candidatos
   caídos;
6. los `UNKNOWN` están enumerados y ninguno fue rellenado por inferencia;
7. el dictamen distingue defecto, riesgo y preferencia;
8. lo declarado fuera de alcance quedó registrado con su medición;
9. no se modificó código, configuración ni producto durante la auditoría.

## 11. Promoción

Si este protocolo se adopta más allá de este repositorio, su lugar es
`~/github/agents/` como contrato canónico, y esa promoción se rige por
`PROMOTION.md` y `GIT.md`.
