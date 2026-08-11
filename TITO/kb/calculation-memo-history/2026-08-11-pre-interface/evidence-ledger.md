# Registro de evidencia — memoria de cálculo

## Alcance

Este registro gobierna la redacción de la memoria de cálculo independiente. La
fuente técnica extensa permanece en el documento metodológico aprobado. La
memoria selecciona únicamente hallazgos comprobados y conserva trazabilidad
hacia las fuentes primarias mediante `bib/references.bib`.

## Fuentes leídas

- Baker (1968): equilibrio y compatibilidad de un aro circular, solución modal
  radial y valores tabulados de contraste (`Baker1968`).
- Schwartz y Einstein (1980): formulación de interacción suelo--revestimiento y
  caso HP97 (`SchwartzEinstein1980`).
- USACE EM 1110-2-2902 (2020): fuerza normal de conductos metálicos corrugados y
  ejemplo D4 (`USACE2020`).
- FHWA-RD-98-191 (1999): acción equivalente de compactación y antecedentes de
  interacción (`McGrathEtAl1999`).
- FHWA NHI-05-037 (2006): relaciones de referencia para el coeficiente de
  empuje en reposo (`ChristopherEtAl2006`).
- Núñez (2000) y Núñez, Sfriso y Laiún (2014): formulaciones analíticas y casos
  publicados para túneles excavados (`Nunez2000`,
  `NunezSfrisoLaiun2014`).
- NCSPA (2018): propiedades seccionales de perfiles corrugados de acero
  (`NCSPA2018`).
- JCSS (2006), Efron (1979, 1987) y Wilson (1927): tratamiento de variables,
  remuestreo y control de precisión (`JCSS2006`, `Efron1979Bootstrap`,
  `Efron1987BetterBootstrap`, `Wilson1927`).
- Documento metodológico aprobado: capítulos congelados en
  `TITO/kb/review/chapters/` y su registro de evidencia.

## Clases de evidencia

| Código | Clase | Regla de uso |
|---|---|---|
| PN | parámetro nominal suministrado | se declara como nominal; no se convierte en dato confirmado |
| HA | hipótesis adoptada | se limita al escenario analítico definido |
| DP | dato publicado transcrito | conserva fuente, ubicación, unidad y convención |
| RP | resultado publicado reproducido | informa el valor publicado, el recalculado y la discrepancia |
| DE | resultado derivado en este estudio | no se atribuye a una referencia |
| CI | control matemático interno | declara caso, malla, métrica, tolerancia y resultado |

## Afirmaciones admitidas

- Para acciones perimetrales prescritas y autoequilibradas, el equilibrio y la
  compatibilidad de la sección transversal determinan
  $N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$.
- El estado biaxial uniforme y la carga exclusivamente normal son dos
  prescripciones de carga separadas; no constituyen leyes de interfaz.
- En el problema plano, el perfil corrugado interviene mediante
  $EA_\theta$ y $EI_\theta$.
- La incertidumbre se propaga por simulación de Monte Carlo directa. Los
  cuantiles puntuales y los cuantiles de extremos espaciales son productos
  distintos.
- El escenario numérico disponible es ilustrativo y condicionado; no es la
  demanda del revestimiento existente.

## Afirmaciones excluidas

- No se informan tensiones de la chapa, capacidad resistente, juntas ni pernos.
- No se atribuye retención permanente a la acción FHWA sin evidencia de obra.
- No se presentan cuantiles del caso existente sin distribuciones conjuntas,
  dependencias, etapas y criterios de precisión aprobados.
- No se denomina validación o calibración a una reproducción o a un contraste.
- CANDE no se presenta como biblioteca R/Python ni como contraste cuantitativo
  cerrado.

## Ecuaciones admitidas

Las ecuaciones operativas autorizadas son: profundidad y tensiones verticales;
ramas excluyentes de $K_0$; proyección del estado biaxial; comparación uniforme
USACE; acción temporal FHWA; equilibrio global; sistema diferencial de primer
orden; constantes de compatibilidad; soluciones cerradas de orden cero y dos;
rigideces circunferenciales; extremos espaciales; cuantiles y envolvente exterior
de alternativas. Los desarrollos se resumen en el Apéndice A.

## Hechos requeridos no resueltos

- radio centroidal y estado geométrico medido;
- categoría de espesor y propiedades seccionales confirmadas;
- estratigrafía, clasificación, pesos unitarios, humedad y compactación;
- estado tensional, historia de tensiones y evidencia para $K_0$;
- niveles de agua y presión interior;
- equipos, tongadas, secuencia y mediciones durante la construcción;
- distribuciones conjuntas, dependencias, cuantiles de interés y tolerancias de
  la simulación.

Estos faltantes impiden calcular la demanda de proyecto, pero no impiden
documentar el procedimiento ni comprobarlo con un escenario analítico.

## Estado

APTO CON LÍMITES DE EVIDENCIA EXPLÍCITOS. La aplicación determinística y los
contrastes definidos pueden publicarse como escenario, resultados derivados y
controles; la evaluación probabilística del revestimiento existente queda
condicionada a la caracterización indicada.
