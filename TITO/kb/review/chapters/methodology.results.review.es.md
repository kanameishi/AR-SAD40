# Ejemplo analítico para un estado biaxial uniforme

## Geometría y propiedades seccionales

La aplicación considera los parámetros nominales suministrados como base del
estudio: diámetro interior de $2.63\ \mathrm{m}$, corrugación de
$76\times25\ \mathrm{mm}$ y espesor de $3.0\ \mathrm{mm}$. La categoría de
este último dato —espesor especificado o espesor base sin recubrimiento— debe
confirmarse. El ejemplo adopta condicionalmente $t_b=3.0\ \mathrm{mm}$ como
espesor base. En el cálculo definitivo, el radio se refiere al eje centroidal
de la chapa y las propiedades seccionales corresponden al perfil y al espesor
confirmados.

| Magnitud | Valor adoptado | Procedencia o cálculo |
|---|---:|---|
| diámetro interior $D_i$ | $2.63\ \mathrm{m}$ | parámetro nominal suministrado |
| radio $R$ | $1.315\ \mathrm{m}$ | aproximación $D_i/2$ para esta aplicación |
| perfil de corrugación | $76\times25\ \mathrm{mm}$ | parámetro nominal suministrado |
| espesor informado $t_0$ | $3.0\ \mathrm{mm}$ | parámetro nominal suministrado; categoría pendiente de confirmación |
| espesor base del escenario $t_b$ | $3.0\ \mathrm{mm}$ | hipótesis condicional del ejemplo |
| área por unidad de ancho $A_p$ | $3.73\ \mathrm{mm^2/mm}$ | escenario $t_0=t_b$; interpolación de la tabla 2.6 de NCSPA mediante la @eq-section-interpolation |
| segundo momento de área por unidad de ancho $I_p$ | $288\ \mathrm{mm^4/mm}$ | escenario $t_0=t_b$; interpolación de la tabla 2.6 de NCSPA mediante la @eq-section-interpolation |
| módulo circunferencial $E_\theta$ | $200\ \mathrm{GPa}$ | hipótesis del ejemplo: $E_\theta=E_s$ |
| relación seccional $\eta_s$ | $4.46\times10^{-5}$ | @eq-corrugated-ratio |

: Parámetros geométricos y seccionales de la aplicación numérica. {#tbl-example-section}

## Estado de tensiones y cargas sobre el contorno

Se adopta, a la cota del eje, el siguiente estado efectivo uniforme:

$$
\sigma'_{v,A}=100\ \mathrm{kPa},
\qquad
K_0=0.50,
\qquad
\Delta u_A=0.
$$

La tensión horizontal efectiva, la presión media y la diferencia entre las
tensiones efectivas vertical y horizontal resultan

$$
\sigma'_{h,A}=50\ \mathrm{kPa},
\qquad
p_m=75\ \mathrm{kPa},
\qquad
\Delta\sigma=50\ \mathrm{kPa}.
$$ {#eq-example-stress}

La proyección completa del tensor de tensiones sobre el contorno da

$$
p_n(\theta)=75+25\cos2\theta\ \mathrm{kPa},
\qquad
p_t(\theta)=25\sin2\theta\ \mathrm{kPa},
$$

y, con la convención estructural adoptada,

$$
P_r(\theta)=-75-25\cos2\theta\ \mathrm{kPa},
\qquad
P_t(\theta)=25\sin2\theta\ \mathrm{kPa}.
$$ {#eq-example-load}

También se evalúa una segunda prescripción, definida por la misma presión
normal y $P_t(\theta)=0$. Ambas distribuciones son autoequilibradas y contienen
sólo los términos de orden cero y dos.

## Resultantes seccionales

Para la sección corrugada del escenario condicional, la @eq-mean-moment da

$$
M_m=-0.0058\ \mathrm{kN\,m/m}.
$$

Las resultantes obtenidas con las @eq-k0-full-response y
@eq-k0-normal-response se resumen en la @tbl-example-results. La fuerza normal
negativa corresponde a compresión.

| Prescripción de carga | $N_\theta$ en clave y solera (kN/m) | $N_\theta$ en hastiales (kN/m) | $M_\theta$ en clave y solera (kN·m/m) | $M_\theta$ en hastiales (kN·m/m) | $\lvert Q_\theta\rvert_{\max}$ (kN/m) |
|---|---:|---:|---:|---:|---:|
| proyección completa | $-65.8$ | $-131.5$ | $21.61$ | $-21.62$ | $32.88$ |
| carga exclusivamente normal | $-87.7$ | $-109.6$ | $14.40$ | $-14.42$ | $21.92$ |

: Resultantes por unidad de longitud axial para el estado biaxial adoptado. {#tbl-example-results}

En las dos prescripciones, la máxima compresión circunferencial se localiza en
los hastiales. El momento flector cambia de signo entre la clave o la solera y
los hastiales; la fuerza cortante alcanza su valor absoluto máximo en las
secciones situadas a $45^\circ$ de los ejes vertical y horizontal,
$\theta=45^\circ$, $135^\circ$, $225^\circ$ y
$315^\circ$.

La componente tangencial de la proyección completa incrementa la amplitud del
armónico de orden dos: respecto de la carga exclusivamente normal, la amplitud
de $N_\theta$ se triplica, mientras que la amplitud de $M_\theta$ y el valor
máximo de $Q_\theta$ aumentan un $50\,\%$. Estos resultados corresponden a dos
estados de carga prescrita. La respuesta de la interfaz suelo--chapa requiere
una relación constitutiva independiente.

En este ejemplo,
$\lvert M_m\rvert/\max_\theta\lvert M_\theta\rvert=2.7\times10^{-4}$
($0.027\,\%$). Para las cargas prescritas, $EA_\theta$ y $EI_\theta$
intervienen en la compatibilidad del modo uniforme; las amplitudes de orden dos
quedan determinadas por el equilibrio de la viga curva.
