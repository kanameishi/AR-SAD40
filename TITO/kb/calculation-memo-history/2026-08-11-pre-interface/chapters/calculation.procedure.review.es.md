# Procedimiento de cálculo {#sec-calculation-procedure}

La @tbl-calculation-procedure presenta la secuencia completa. Cada caso conserva
la identificación de la etapa constructiva y de la alternativa de modelación
hasta la formación de las envolventes; las alternativas excluyentes no se
suman.

| Paso | Entradas | Operación | Salidas | Control |
|---:|---|---|---|---|
| 0 | geometría, unidades y convenciones | definir casos, etapas y alternativas | registro de estados | separar datos confirmados, parámetros nominales e hipótesis |
| 1 | estratigrafía, pesos unitarios, agua y tapada | integrar tensiones verticales y presión intersticial | $\sigma'_v(\theta)$, $u(\theta)$ | clave, eje, solera y continuidad entre estratos |
| 2 | condición del relleno e historia tensional | seleccionar una relación de $K_0$ o una presión residual | $\sigma'_h(\theta)$ | no duplicar dependencias ni sumar ramas incompatibles |
| 3 | tensiones verticales, laterales y agua | transformar el estado biaxial en el contorno | $P_r(\theta)$ y $P_t(\theta)$ permanentes | equilibrio global y signos |
| 4 | equipo, tongadas y secuencia | definir acciones temporales y su eventual retención documentada | acciones por etapa | no presumir retención permanente |
| 5 | $R$, $E_\theta$, $A_p$, $I_p$ | calcular rigideces circunferenciales | $EA_\theta$, $EI_\theta$, $\eta_s$ | unidades y procedencia |
| 6 | acciones perimetrales y rigideces | integrar equilibrio y aplicar compatibilidad | $N_\theta$, $M_\theta$, $Q_\theta$ | periodicidad, equilibrio y casos cerrados |
| 7 | curvas por etapa y alternativa | localizar extremos en tramos continuos y discontinuidades | valores, signos, ángulos y etapa | comprobar extremos interiores y límites laterales |
| 8 | distribuciones y dependencias aprobadas | ejecutar realizaciones Monte Carlo por alternativa | curvas y extremos por realización | reproducibilidad y convergencia |
| 9 | resultados de todas las realizaciones | calcular cuantiles puntuales, cuantiles de extremos y envolvente exterior | bandas angulares e intervalos escalares | no equiparar estadísticos distintos |
| 10 | tablas y metadatos | representar los resultados con escalas comunes | memoria y productos reproducibles | igualdad entre figuras y tablas fuente |

: Secuencia de cálculo, productos y controles obligatorios. {#tbl-calculation-procedure}

## Cierre físico de los estados de carga

La tensión vertical puede variar entre clave y solera. Sin embargo, proyectar
ese gradiente sobre el contorno sin incluir en el mismo estado el peso del
revestimiento, la flotación y las reacciones de apoyo produce una resultante
global distinta de cero. El cálculo estructural sólo se ejecuta después de
cerrar ese equilibrio. Por esta razón, la aplicación de la
@sec-calculation-application utiliza un estado biaxial uniforme en el eje como
caso analítico; una distribución variable alrededor de la circunferencia se
incorporará cuando estén definidas las acciones y reacciones complementarias.

## Controles mínimos

Cada estado debe satisfacer: coherencia dimensional; continuidad por estratos;
equilibrio global de fuerzas y momentos; periodicidad de las tres resultantes;
convergencia respecto de la discretización angular; y reproducción de una
solución cerrada cuando la carga pertenezca a un caso disponible. Los extremos
de cargas discontinuas se determinan por intervalos y no mediante una única
búsqueda sobre una serie truncada.
