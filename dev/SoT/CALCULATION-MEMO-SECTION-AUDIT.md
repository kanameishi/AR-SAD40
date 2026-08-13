# Auditoría de pertenencia — memoria de cálculo

## Estado

Matriz interna en preparación. No constituye prosa pública ni autoriza una
reescritura o un render. La aceptación técnica y editorial corresponde al
usuario.

El usuario detuvo además toda reescritura y render hasta disponer de un plan
integral que articule metodología, memoria, helpers R y notebook Wolfram. Esta
matriz es sólo un insumo de ese plan.

Se auditan por separado el contenido vigente del árbol de trabajo y la versión
publicada en `HEAD`. Ningún bloque se conserva por antigüedad ni por un
dictamen anterior: debe superar nuevamente el filtro de producto.

## Filtro de pertenencia

Una sección pertenece al cuerpo de la memoria sólo si todas las respuestas
siguientes son afirmativas:

1. ¿Es necesaria para reproducir o interpretar un cálculo efectivamente
   ejecutado en esta emisión?
2. ¿Declara una entrada o hipótesis adoptada, una ecuación operativa consumida,
   un control ejecutado o un resultado obtenido?
3. ¿Sus símbolos, unidades, signos, dominio, procedencia y condición de
   adopción están definidos?
4. ¿Evita presentar alternativas no seleccionadas, investigaciones,
   comparaciones bibliográficas, planes futuros o datos `UNKNOWN` como parte
   del cálculo?
5. ¿Evita metadata de implementación, auditoría, gestión y trazabilidad?
6. ¿Tiene una única función documental y no duplica una definición existente?

Las tablas se someten además a una regla propia: los encabezados de resultados
contienen símbolos o códigos compactos, no descripciones, unidades ni metadata.
Las posiciones y unidades se definen en el caption o en una nota de tabla. Por
ejemplo, las posiciones principales se identifican como $A$ y $B$, y las
columnas como $N_A$, $N_B$, $M_A$ y $M_B$.

Destinos posibles:

- **CUERPO:** información aplicada y necesaria para ejecutar o interpretar el
  cálculo;
- **APÉNDICE A:** desarrollo matemático indispensable de una ecuación usada en
  el cuerpo;
- **APÉNDICE B:** caso analítico de contraste, reproducción, diferencia y
  control numérico;
- **METODOLOGÍA:** revisión de alternativas, fundamento amplio, formulaciones
  no adoptadas, limitaciones generales y estado de la práctica;
- **SoT:** inventarios, decisiones, entradas pendientes, puertas de aceptación
  y planes futuros; y
- **ELIMINAR:** duplicación o narrativa sin función técnica propia, una vez
  preservada la información útil en su destino correcto.

## Identidad del producto vigente

La única aplicación numérica ejecutada corresponde al escenario
`verification-biaxial-uniform`, con tensión vertical efectiva uniforme
prescrita, valor constante adoptado de $K_0$ y dos valores de $\alpha$. No se
ha calculado la distribución de contacto del relleno existente, el empuje
reglamentario, la tensión de la chapa ni una simulación de Monte Carlo.

Por ello, el producto vigente sólo puede informar un **caso analítico
determinístico preliminar** y sus resultantes. No puede presentarse como
evaluación de la demanda del revestimiento existente. La reescritura deberá
resolver esta identidad en el título, el alcance, el resumen y las
conclusiones.

## Matriz de secciones del cuerpo

| Bloque vigente | Consumo o resultado real | Dictamen preliminar | Destino y corrección requerida |
|---|---|---|---|
| Resumen ejecutivo | resume el caso, pero mezcla AASHTO, interacción, tensiones y Monte Carlo no evaluados | FAIL | reescribir al final; informar únicamente objeto, hipótesis del caso, resultantes obtenidas y límite de representatividad |
| Bases — alcance mecánico | fija el problema plano y las salidas | PASS condicionado | CUERPO, reducido al alcance realmente ejecutado |
| Bases — coordenadas, signos y unidades | gobierna cálculo, tablas y figuras | PASS algebra / FAIL exposición | CUERPO; aclarar que $\int_{A_b}(\cdot)dA$ es una integral de área a $\theta$ fijo, definir $\xi$, $dA$, el eje centroidal y $1/b$ |
| Bases — datos de cálculo | enumera familias de información y tablas futuras | FAIL | reemplazar por la tabla de entradas efectivamente adoptadas; inventario completo a SoT |
| Procedimiento — Tabla 1 | matriz interna de pasos, controles y puertas no ejecutadas | FAIL | ELIMINAR; conservar sólo una secuencia profesional breve en prosa |
| Procedimiento — «Cierre físico de los estados de carga» | repite advertencias, interacción y tareas pendientes | FAIL | retirar encabezado; conservar equilibrio únicamente junto a su ecuación |
| Procedimiento — «Controles mínimos» | checklist genérico | FAIL | retirar; informar cada control donde se ejecuta y con su resultado |
| Acciones — clasificación del producto AASHTO | no interviene en el caso calculado | FAIL para el cuerpo actual | METODOLOGÍA; una limitación concreta puede quedar en alcance si se discute resistencia |
| Acciones — tensión vertical efectiva y agua por profundidad | el caso vigente prescribe $\sigma'_{v,A}=100$ kPa y $\Delta u_A=0$; no usa $H_0$, estratos ni integración | FAIL para la aplicación vigente | METODOLOGÍA; volver al cuerpo sólo cuando existan estratigrafía, tapada y niveles realmente calculados |
| Acciones — empuje circunferencial de referencia $T_L$ | no se evalúa ni alimenta $N_\theta$, $M_\theta$ o $Q_\theta$ | FAIL | METODOLOGÍA/antecedente normativo; retirar del cuerpo, resumen, conclusiones, tabla de entradas y productos del reporte |
| Acciones — estimación de $K_0$ | la aplicación usa sólo $K_0=0.5$ adoptado; no ejecuta las ramas comparadas | FAIL como sección general | METODOLOGÍA; en la aplicación conservar sólo el valor adoptado y $\sigma'_h=K_0\sigma'_v$ |
| Acciones — compactación dentro de $K_0$ | no se adopta incremento residual ni historia de compactación | FAIL | METODOLOGÍA/SoT |
| Acciones — estado biaxial analítico prescrito | genera las acciones realmente usadas | PASS con reubicación | trasladar a APLICACIÓN como caso de carga adoptado; definir sin ambigüedad la elevación del centro de la sección y no presentarlo como modelo del relleno real |
| Acciones — interacción suelo–conducto | declara una formulación aún no seleccionada | FAIL | METODOLOGÍA/SoT; en la memoria basta una limitación concreta de representatividad |
| Acciones — acción temporal FHWA | no se usa equipo, tongada ni acción FHWA en la aplicación; la distribución continua es derivada | FAIL | METODOLOGÍA; retirar también su desarrollo del apéndice de esta memoria |
| Resultantes — equilibrio global | condición necesaria para el sistema de acciones usado | PASS condicionado | CUERPO si se informa el control ejecutado; desarrollo en APÉNDICE A |
| Resultantes — integración directa y compatibilidad | ecuaciones consumidas por el cálculo R | PASS | CUERPO con fórmulas finales; desarrollo en APÉNDICE A |
| Resultantes — soluciones del estado biaxial uniforme | caso analítico usado para comprobar la integración | FAIL como metodología del cuerpo | APÉNDICE B; el cuerpo sólo informa el contraste y su resultado |
| Rigidez circunferencial — ley seccional | $EA_\theta$, $EI_\theta$ y $\eta_s$ se calculan y usan | PASS | CUERPO con fórmula final y valores adoptados; desarrollo geométrico en APÉNDICE A |
| Rigidez — sección neta futura y variación con $\theta$ | no se usa en el caso | FAIL para el cuerpo actual | METODOLOGÍA/SoT |
| Recuperación de tensión normal | fórmula implementada pero no evaluada por falta de sección neta y fibras | FAIL para la memoria vigente | METODOLOGÍA hasta que exista una evaluación reproducible; eliminar «Estado de la recuperación de tensiones» y toda promesa futura del reporte |
| Plan de análisis probabilístico — capítulo completo | no existen marginales, dependencias, tamaño de muestra, convergencia ni resultados aprobados | FAIL | retirar del master; preservar el plan en METODOLOGÍA/SoT; el alcance sólo declara que la emisión es determinística |
| Aplicación — definición del escenario | identifica el cálculo efectivamente ejecutado | PASS condicionado | CUERPO; renombrar como caso analítico determinístico y definir cada hipótesis |
| Aplicación — tabla de entradas | mezcla entradas, salidas derivadas, identificadores normativos pendientes y magnitudes no modeladas | FAIL en su forma actual | reconstruir con entradas adoptadas, valor, unidad, procedencia y condición; separar propiedades derivadas |
| Aplicación — estado de comprobación reglamentaria | informa una rama no ejecutada | FAIL | retirar; conservar la investigación en METODOLOGÍA |
| Aplicación — interpolación y rigideces | cálculo ejecutado y consumido | PASS | CUERPO; separar datos adoptados de propiedades derivadas |
| Aplicación — estado biaxial | cálculo ejecutado | PASS condicionado | CUERPO; explicar que es un caso de carga prescrito, no la presión real del relleno |
| Aplicación — resultantes, extremos y figuras | resultados ejecutados | PASS condicionado | CUERPO; conservar tabla y tres figuras, con unidades y signos; reemplazar encabezados descriptivos por códigos/símbolos y definir las posiciones en el caption |
| Aplicación — estado de recuperación de tensiones | describe una operación no ejecutada | FAIL | retirar; una limitación breve basta si afecta el alcance declarado |
| Aplicación — comprobación numérica | comparación cerrada ejecutada | PASS con reubicación parcial | cuerpo: resultado resumido; APÉNDICE B: ecuaciones, métricas, tolerancias y tabla completa |
| Resultados/conclusiones — resultados del caso | resultados ejecutados, pero mezclados con control y normativa pendiente | PASS condicionado | CUERPO, reescrito con valores y alcance del caso |
| Resultados/conclusiones — «Datos del revestimiento existente» | inventario de trabajo pendiente | FAIL | SoT; mencionar sólo el dato ausente que impida una conclusión concreta |

## Matriz del apéndice vigente

| Bloque | Relación con el cálculo ejecutado | Dictamen preliminar | Destino |
|---|---|---|---|
| A.0 Alcance del empuje de referencia | rama no evaluada | FAIL | METODOLOGÍA |
| A.1 Equilibrio del elemento diferencial | deriva el sistema usado | PASS condicionado | APÉNDICE A, después de auditar signos y definiciones |
| A.2 Cierre por compatibilidad | deriva las constantes usadas | PASS condicionado | APÉNDICE A, después de auditar hipótesis y normalización |
| A.3 Geometría de franjas de compactación | rama no usada en el caso | FAIL | METODOLOGÍA |
| A.4 Propiedades del perfil corrugado | deriva las rigideces usadas | PASS con aclaración | APÉNDICE A; explicitar integral de área, $dA$, $\theta$ fijo y trabajo por unidad de ancho |
| A.5 Solución cerrada biaxial | controla el caso numérico | PASS con reubicación | APÉNDICE B, como control interno derivado y no como evidencia externa |
| A.6 Recuperación de tensión normal | operación no evaluada | FAIL para esta memoria | METODOLOGÍA hasta disponer de sección neta y resultados |

## Auditoría de tablas públicas

| Tabla vigente | Función | Dictamen | Corrección |
|---|---|---|---|
| Secuencia de cálculo | matriz interna de organización | ELIMINAR | conservar la secuencia en prosa y la matriz completa en SoT |
| Ramas de $K_0$ | comparación de formulaciones | METODOLOGÍA | no forma parte de la aplicación con $K_0=0.5$ adoptado |
| Variables probabilísticas | inventario de información pendiente | SoT/METODOLOGÍA | retirar de la memoria hasta ejecutar Monte Carlo |
| Entradas del escenario | mezcla entradas, propiedades derivadas, magnitudes no modeladas y códigos internos | RECONSTRUIR | una fila por entrada realmente adoptada; símbolos/códigos en encabezados; valores, unidades y procedencia definidas en caption/notas |
| Extremos de resultantes | resultados ejecutados | CONSERVAR CON CORRECCIÓN | usar $\alpha$, $N_A$, $N_B$, $M_A$, $M_B$ y $\lvert Q\rvert_{\max}$; definir $A=(0,\pi)$ y $B=(\pi/2,3\pi/2)$ y las unidades fuera de los encabezados |
| Controles numéricos | contraste ejecutado con solución cerrada | APÉNDICE B | reemplazar frases por símbolos/códigos; definir métrica, malla, integración, tolerancia y unidades en caption/notas |

Las descripciones «clave/fondo» y «puntos laterales» son información de
localización y no encabezados. El builder vigente
`scripts/tbl/Calculation.extrema.R` incumple esta regla y deberá corregirse
después de aprobar la matriz.

## Consecuencias para datos y código documental

La auditoría del producto no elimina implementaciones de investigación. Sí
exige que el productor del reporte deje de materializar o cargar objetos que no
alimentan la memoria vigente:

- `circumferential.thrust.csv` y la rama pendiente correspondiente no deben
  presentarse como producto de esta aplicación mientras $T_L$ no se evalúe;
- la tabla pública de entradas no debe incluir producto `UNKNOWN`, incremento
  residual «no modelado», controles gráficos ni metadata de implementación;
- las funciones USACE, FHWA, $K_0$ y recuperación de tensiones pueden
  conservarse en la biblioteca de investigación con pruebas propias, pero no
  determinan por su sola existencia el contenido del reporte; y
- el HTML vigente no se usa como fuente y no se regenerará hasta aprobar esta
  matriz y la arquitectura resultante.

## Puerta previa a la reescritura

Antes de editar el master deben cerrarse:

1. auditoría técnica y editorial independiente de ambas mitades;
2. dictamen de la ecuación de definición de resultantes y su correspondencia
   con la metodología ampliada;
3. decisión del usuario sobre la identidad pública del producto como memoria
   preliminar del caso analítico determinístico; y
4. aprobación de la estructura reducida y de los destinos de cada bloque.

## Dictámenes independientes recibidos

- La definición integral de $N_\theta$ y $M_\theta$ obtuvo **PASS algebraico y
  dimensional / FAIL documental** en
  `/private/tmp/ar-sad40-eq1-integrals-audit.md`. Es una integral de área
  bidimensional escrita en forma compacta, no una integración adicional en
  $\theta$; $\xi$ es el brazo firmado de cada elemento $dA$. Deben explicitarse
  $\theta$ fijo, el eje centroidal, $dA$ y la normalización $1/b$. El signo y
  la implementación R son coherentes. La Fase 1 congelada usa la coordenada y
  el signo opuestos y una normalización por ancho implícita; esa
  correspondencia se registra sin editarla.
- La auditoría del capítulo de procedimiento concluyó **FAIL público** en
  `/private/tmp/ar-sad40-memo-internal-sections-audit.md`. Confirmó la
  eliminación de la tabla de pasos, de «Cierre físico...» y de «Controles
  mínimos», y exigió ubicar cada control junto a su ecuación o resultado.
- La auditoría independiente de la primera mitad y del capítulo probabilístico
  concluyó **FAIL** en
  `/private/tmp/ar-sad40-memo-front-sections-audit.md`. Verificó en la entrada,
  el productor y los CSV que la única corrida es el estado biaxial uniforme
  prescrito con $\sigma'_v=100$ kPa, $K_0=0.5$, $\Delta u=0$ y
  $\alpha\in\{0,1\}$. No se consumen tapada, estratigrafía, $P_F$, $S$,
  compactación FHWA, interacción ni variables aleatorias. Confirmó que
  $T_L=P_FS/2$ está respaldada por USACE, pero es una inserción impropia y una
  salida vacía sin consumidor en las resultantes.
- La auditoría independiente de la segunda mitad concluyó **FAIL editorial,
  con núcleo determinístico ejecutado**, en
  `/private/tmp/ar-sad40-memo-back-sections-audit.md`. Confirmó que se
  calcularon propiedades nominales, acciones biaxiales, $N/M/Q$, extremos y
  seis controles cerrados; no se ejecutaron Monte Carlo, recuperación de
  tensión ni comprobación AASHTO. Exigió retirar `sheet`, `uncertainty`, los
  bloques «Estado de...», los pedidos de datos y A.0/A.3/A.6; conservar y
  compactar resultantes, rigidez, aplicación y A.1/A.2/A.4/A.5.
