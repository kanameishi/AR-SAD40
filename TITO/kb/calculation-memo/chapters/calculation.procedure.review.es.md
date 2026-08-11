# Procedimiento de cálculo {#sec-calculation-procedure}

La @tbl-calculation-procedure presenta la secuencia determinística. Cada caso
conserva la identificación de la etapa constructiva y de la condición de
interfaz; las hipótesis incompatibles se evalúan por separado.

| Paso | Entradas | Operación | Salidas | Control |
|---:|---|---|---|---|
| 0 | geometría, unidades y convenciones | definir casos, etapas y alternativas | registro de estados | separar datos confirmados, parámetros nominales e hipótesis |
| 1 | estratigrafía, pesos unitarios, agua y tapada | integrar tensiones verticales y presión intersticial | $\sigma'_v(\theta)$, $u(\theta)$ | clave, eje, fondo y continuidad entre estratos |
| 2 | condición del relleno e historia tensional | seleccionar una relación de $K_0$ o una presión residual | $\sigma'_h(\theta)$ | no duplicar dependencias ni sumar ramas incompatibles |
| 3 | tensiones verticales, laterales, agua y multiplicador $\alpha$ | transformar el estado tensional y escalar la componente tangencial proyectada | $P_r(\theta)$ y $P_t(\theta)$ | $0\leq\alpha\leq1$, equilibrio global y signos |
| 4 | equipo, tongadas y secuencia | definir acciones temporales y su eventual retención documentada | acciones por etapa | no presumir retención permanente |
| 5 | $R$, $E_\theta$, $A_p$, $I_p$ | calcular rigideces circunferenciales | $EA_\theta$, $EI_\theta$, $\eta_s$ | unidades y procedencia |
| 6 | acciones perimetrales y rigideces | integrar equilibrio y aplicar compatibilidad | $N_\theta$, $M_\theta$, $Q_\theta$ | periodicidad, equilibrio y casos cerrados |
| 7 | curvas por etapa y condición | localizar extremos en tramos continuos y discontinuidades | valores, signos, ángulos y etapa | comprobar extremos interiores y límites laterales |

: Secuencia de cálculo, productos y controles obligatorios. {#tbl-calculation-procedure}

## Cierre físico de los estados de carga

Las tensiones verticales y laterales del relleno varían con la profundidad y se
evalúan en cada punto del contorno mediante $z(\theta)$. Su proyección sobre una
sección cerrada debe integrar, dentro del mismo estado, el peso del
revestimiento, la flotación y las reacciones de contacto necesarias para
satisfacer el equilibrio global. La aplicación de la
@sec-calculation-application emplea tensiones uniformes en la cota del eje
exclusivamente como escenario de comprobación de las ecuaciones. La evaluación
del revestimiento existente deberá incorporar el gradiente y las acciones de
equilibrio correspondientes.

La propagación probabilística constituye una etapa posterior a esta secuencia.
Su ejecución requiere las variables, distribuciones y dependencias definidas
en la @sec-calculation-uncertainty.

## Controles mínimos

Cada estado debe satisfacer: coherencia dimensional; continuidad por estratos;
equilibrio global de fuerzas y momentos; periodicidad de las tres resultantes;
convergencia respecto de la discretización angular; y reproducción de una
solución cerrada cuando la carga pertenezca a un caso disponible. Los extremos
de cargas discontinuas se determinan por intervalos y no mediante una única
búsqueda sobre una serie truncada.
