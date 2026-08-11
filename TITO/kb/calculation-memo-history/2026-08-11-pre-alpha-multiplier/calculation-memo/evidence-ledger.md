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
- FHWA-RD-03-048 (2003): resistencia de interfaz de Coulomb expresada mediante
  adhesión y fuerza normal efectiva por $\tan\delta$
  (`VulovaLeshchinsky2003`).
- CANDE-2025: contacto, deslizamiento, separación y límite de fricción de
  Coulomb en interfaces suelo--conducto (`CANDE2025Formulations`).
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

## Afirmaciones admitidas

- Las tensiones vertical y lateral efectivas se proyectan sobre el contorno
  para obtener una presión normal efectiva y una tracción tangencial
  disponible.
- La transferencia tangencial se limita por
  $\tau_{lim}=c_a+\tan\delta\,\max(p_n',0)$, de acuerdo con la forma de
  Coulomb documentada por FHWA y CANDE.
- $\alpha_\delta=\tan\delta$ es un coeficiente de fricción y no un multiplicador
  arbitrario de las resultantes. $\alpha_\delta=0$ y $1$ son extremos de
  sensibilidad del escenario de comprobación.
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
verticales; ramas excluyentes de $K_0$; proyección del estado tensional; límite
de fricción de interfaz; comparación uniforme USACE; acción temporal FHWA;
equilibrio global; sistema diferencial de primer orden; constantes de
compatibilidad; soluciones cerradas de los extremos de interfaz; rigideces
circunferenciales; resultantes y extremos espaciales. El Apéndice A resume los
desarrollos necesarios para comprobarlas.

## Hechos requeridos no resueltos

- radio centroidal y estado geométrico medido;
- categoría de espesor y propiedades seccionales confirmadas;
- estratigrafía, clasificación, pesos unitarios, humedad y compactación;
- estado tensional, historia de carga y evidencia para $K_0$;
- $\delta$, eventual $c_a$ y sus dependencias con el estado del relleno;
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
resistentes indicadas.
