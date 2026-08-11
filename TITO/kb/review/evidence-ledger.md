# Evidencia para la metodología de solicitaciones del revestimiento circular

## Tema, audiencia y producto

El tema es la determinación de las fuerzas internas por unidad de longitud axial
en la sección transversal de un revestimiento circular enterrado de chapa de
acero corrugada. La audiencia prevista está formada por ingenieros geotécnicos
y estructurales. El producto público candidato es un informe metodológico en
español, con ecuaciones, aplicación numérica, comprobaciones reproducibles y
bibliografía BibTeX.

El informe termina en las distribuciones y extremos de la fuerza normal
circunferencial $N_\theta$, el momento flector $M_\theta$ y la fuerza cortante
$Q_\theta$. Las tensiones locales de la chapa, la resistencia seccional, la
estabilidad y las uniones apernadas pertenecen a una etapa posterior.

## Distinciones técnicas obligatorias

- Las tensiones geostáticas del relleno no son idénticas a las presiones de
  contacto suelo--revestimiento.
- Una relación de diseño que produce una fuerza normal circunferencial escalar
  no determina por sí sola $M_\theta(\theta)$ ni $Q_\theta(\theta)$.
- Las ecuaciones de una viga curva circular sometida a cargas prescritas no
  constituyen un modelo de interacción suelo--estructura.
- La prescripción $P_t=0$ define una carga exclusivamente normal; no equivale
  por sí sola a una ley de contacto con deslizamiento.
- La versión de Núñez de 2000 y la formulación publicada en 2014 se conservan
  separadas porque sus expresiones de fuerza normal no son equivalentes.
- El cálculo estructural actual se limita a sistemas de cargas
  autoequilibrados. Un gradiente sobre el diámetro requiere incorporar las
  reacciones que completen el equilibrio global.
- La Ec. 5.1 de FHWA proporciona una presión lateral. La fuerza nodal se forma
  multiplicándola por la longitud tributaria; la representación continua por
  franjas es una idealización propia del cálculo.
- Una comparación con resultados publicados verifica la transcripción y la
  resolución numérica; no constituye validación física del modelo de carga.
- $N_\theta$, $M_\theta$ y $Q_\theta$ son resultantes seccionales. No son
  tensiones locales en crestas, valles, solapes o pernos.

## Fuentes y alcance de lectura

| Fuente | Clase y acceso | Afirmaciones admitidas | Afirmaciones excluidas |
|---|---|---|---|
| Baker (1968) | fuente externa; tesis completa, lectura dirigida de pp. impresas 15--27 y 49--51 | equilibrio, compatibilidad y series de Fourier para una viga curva circular delgada; valores de las tablas XIII--XIV | ley de presión de tierras; interacción con relleno; respuesta local de chapa corrugada |
| Schwartz y Einstein (1980) | fuente externa; informe completo escaneado, lectura dirigida de §2, apéndice A y ejemplo HP97 | razones de rigidez relativa; soluciones de interacción para medio elástico, secuencias de excavación y carga externa | compactación por tongadas; superficie libre somera; conducta no lineal del relleno |
| USACE (2020) | manual oficial completo; lectura dirigida del §4.12 y apéndice D4 | presión vertical en clave, fuerza normal circunferencial de diseño, factores del ejemplo publicado | distribución perimetral de $M_\theta$ y $Q_\theta$ |
| McGrath et al. (1999) | informe FHWA completo; lectura dirigida de capítulos 2, 4 y 5 | influencia de instalación; relación de carga de prisma/arqueo; presión nodal de compactación de la Ec. 5.1; tabla 5.5 | presión residual permanente universal; especificación normativa |
| Christopher et al. (2006) | manual FHWA completo; lectura dirigida del §5.4.9 | definición de $K_0$ y estimadores elástico y de Jaky | distribución probabilística universal de $K_0$ para un relleno compactado desconocido |
| Núñez (2000); Núñez, Sfriso y Laiún (2014) | fuentes externas completas; lectura dirigida de formulación y ejemplos | dos formulaciones semiempíricas para sostenimientos de túneles excavados, conservadas con sus respectivas ecuaciones y valores publicados | combinación de las dos versiones; aplicación directa a una tubería colocada y posteriormente rellenada |
| Katona et al. (1976); CANDE-2025 | informe y manuales completos; lectura dirigida de alcance, niveles y formulaciones | identidad de CANDE como sistema especializado de análisis de conductos enterrados; soluciones analíticas de Nivel 1 y niveles de elementos finitos | identidad como biblioteca R/Python; sustitución automática por una ecuación única |
| NCSPA (2018) | manual completo; lectura dirigida de tabla 2.6 | propiedades seccionales publicadas de corrugación de 3 x 1 pulgadas | geometría conforme a obra del revestimiento estudiado |
| Mai (2013) | tesis completa; lectura dirigida de propiedades equivalentes y resultados | ejemplo publicado de propiedades seccionales y sección equivalente | validación del caso actual |
| Aoki y Maysenhölder (2017) | artículo completo; lectura dirigida | alcance y limitaciones de una placa ortótropa equivalente para paneles corrugados planos | teoría directa de un cilindro corrugado |
| JCSS (2006) | documento completo; lectura dirigida | separación entre variabilidad espacial, incertidumbre estadística y del modelo | distribuciones específicas para el relleno actual |
| Efron (1979, 1987); Wilson (1927) | artículos completos; lectura dirigida | remuestreo *bootstrap* no paramétrico, intervalo percentil e intervalo de puntuación binomial empleados para controlar el error de simulación | distribuciones de las variables geotécnicas o estructurales del problema |

Los metadatos bibliográficos de las fuentes citadas fueron comprobados
contra sus portadas, páginas de título o fichas técnicas. Los campos que no
aparecen allí no se incorporaron a `bib/references.bib`.

## Ecuaciones admitidas

- Integración de tensiones efectivas por estratos y presión intersticial
  hidrostática.
- Relación $\sigma'_h=K_0\sigma'_v$ y relación de Jaky dentro de su dominio.
- Proyección de un estado biaxial uniforme sobre el contorno circular, declarada
  como derivación tensorial.
- Ecuaciones diferenciales de equilibrio del revestimiento circular y cierre
  mediante periodicidad y compatibilidad.
- Coeficientes de Fourier y solución de los modos $n\geq2$.
- Soluciones cerradas para el estado biaxial uniforme, bajo dos prescripciones
  de carga: proyección completa y carga exclusivamente normal.
- Representación continua por franjas de la acción lateral FHWA, identificada
  como idealización del estudio a partir de la presión nodal y de la dirección
  de fuerzas publicadas.
- Relaciones USACE, FHWA, Schwartz--Einstein y Núñez únicamente con su dominio,
  convención y cita.
- Rigideces circunferenciales $EA_\theta$ y $EI_\theta$ de la sección
  corrugada.
- Muestreo Monte Carlo directo y definición separada de cuantiles puntuales y
  cuantiles de extremos espaciales, con localización de extremos por tramos e
  intervalos de remuestreo para controlar el error Monte Carlo.

## Ecuaciones excluidas

- Tensiones locales de la chapa o de los pernos.
- Fórmulas de capacidad, pandeo o resistencia de costuras.
- Relaciones de $K_0$ por sobreconsolidación cuya fuente primaria no haya sido
  leída.
- Una supuesta retención permanente de la presión nodal de compactación FHWA.
- La ecuación de agua de Núñez (2000), ilegible en el escaneo disponible.
- Cualquier distribución de probabilidad o correlación que no esté sustentada
  por caracterización del relleno o por una decisión posterior del proyecto.

## Terminología pública admitida

Revestimiento circular; conducto enterrado; chapa de acero corrugada; viga
curva circular cerrada; tensiones efectivas; presión intersticial; presión de
contacto; componentes normal y tangencial; fuerza normal circunferencial;
momento flector; fuerza cortante; rigidez extensional circunferencial; rigidez
flexional circunferencial; integración directa; series de Fourier; interacción
suelo--estructura; tongada; simulación Monte Carlo; realización; cuantil;
envolvente; caso de referencia; comprobación numérica.

## Terminología rechazada en el producto público

`no-FEM`; `solver`; `solver canónico`; `motor`; `adaptador`; `pipeline`;
`workflow`; `API`; `runner`; `producer`; `benchmark`; `source of truth`;
`UNKNOWN`; `fullTraction`; `normalOnly`; `surrogate`; `conclusión documental`;
`estado de auditoría`; rutas de archivos; nombres de funciones; instrucciones
de ejecución; lenguaje promocional o defensivo.

La palabra *anillo* se reserva para una cita o para describir de manera puntual
la idealización clásica de viga curva. El objeto de estudio se denomina
revestimiento circular.

## Vacíos de información del caso de obra

- clasificación, estratigrafía, peso unitario y estado hídrico del relleno;
- densidad o grado de compactación y equipo empleado por tongada;
- historia tensional representada por $K_0$;
- transferencia tangencial en la interfaz;
- perfil, orientación, categoría del espesor informado, espesor base y
  propiedades conforme a obra de la chapa;
- radio centroidal de la sección corrugada;
- sobrecargas y condiciones hidráulicas de servicio.

Estos vacíos no impiden formular el procedimiento. Impiden asignar una demanda
de proyecto y distribuciones probabilísticas definitivas.

Para la futura aplicación al caso de obra, la categoría del espesor nominal de
3,0 mm permanece `UNKNOWN`: todavía no se ha determinado si corresponde al
espesor especificado o al espesor base sin recubrimiento. Esta marca pertenece
al registro interno de evidencia y no debe trasladarse al informe público.

## Validación prevista

La versión candidata debe satisfacer simultáneamente: claves bibliográficas
resueltas; ausencia del vocabulario rechazado en los capítulos candidatos;
ecuaciones dimensionalmente consistentes; reproducción de los ejemplos Baker,
USACE, FHWA, Schwartz--Einstein y Núñez; render HTML sin errores; inspección
visual del documento completo. La aprobación técnica y editorial corresponde
al usuario antes de trasladar el texto a `_chapters/`.
