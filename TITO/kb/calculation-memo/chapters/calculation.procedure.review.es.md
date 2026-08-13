# Procedimiento de cálculo {#sec-calculation-procedure}

El análisis transversal se desarrolla por estados de carga. Para cada estado,
la secuencia de cálculo es la siguiente:

1. determinar $z(\theta)$ y las tensiones verticales efectivas a partir de la
   tapada, la estratigrafía, los pesos unitarios y la sobrecarga;
2. calcular por separado la presión de agua exterior e interior;
3. seleccionar una única formulación de $K_0$ compatible con la trayectoria
   tensional y obtener $\sigma'_h(\theta)$; cuando se represente una tensión
   residual de compactación, evitar su superposición con una historia
   tensional equivalente;
4. definir las componentes perimetrales $P_r(\theta)$ y $P_t(\theta)$ con el
   modelo de contacto adoptado; para el caso analítico de referencia, proyectar
   el estado biaxial uniforme, y para la compactación conservar cada etapa
   constructiva como un estado independiente;
5. obtener $A_\theta$ e $I_\theta$ del perfil aplicable y calcular las
   rigideces $EA_\theta$ y $EI_\theta$ con la misma sección empleada en la
   evaluación posterior;
6. comprobar el equilibrio global del conjunto completo de acciones y
   reacciones prescrito para el estado considerado;
7. resolver conjuntamente $N_\theta(\theta)$, $M_\theta(\theta)$ y
   $Q_\theta(\theta)$ mediante equilibrio, periodicidad y compatibilidad;
8. determinar los extremos sobre cada intervalo continuo y comprobar la
   solución mediante equilibrio global, soluciones cerradas o casos de
   referencia aplicables.

La @sec-calculation-actions define las acciones del relleno y de la
compactación. La @sec-calculation-stiffness establece las propiedades y
rigideces circunferenciales. La @sec-calculation-response presenta la solución
de las resultantes seccionales. Las ecuaciones se aplican por unidad de ancho
axial proyectado y con las convenciones de signo de la
@sec-calculation-basis.
