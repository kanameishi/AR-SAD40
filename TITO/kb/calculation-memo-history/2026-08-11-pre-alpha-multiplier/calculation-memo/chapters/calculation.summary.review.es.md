# Resumen ejecutivo {.unnumbered}

Esta memoria presenta el procedimiento para determinar las acciones del
relleno sobre un revestimiento circular y calcular, en su sección transversal,
la fuerza normal circunferencial $N_\theta(\theta)$, el momento flector
circunferencial $M_\theta(\theta)$ y la fuerza cortante circunferencial
$Q_\theta(\theta)$. El perfil corrugado se incorpora mediante las rigideces
extensional y flexional de la sección en la dirección circunferencial.

El cálculo comprende la determinación de las tensiones verticales efectivas y
de la presión intersticial, la estimación del empuje lateral y de las acciones
de compactación, la transformación de esas tensiones en acciones perimetrales
y la integración de las ecuaciones de equilibrio y compatibilidad. La
transferencia tangencial en la interfaz se limita mediante el coeficiente
$\alpha_\delta=\tan\delta$, donde $\delta$ es el ángulo de fricción entre el
relleno y el revestimiento. CANDE adopta una condición de contacto con
deslizamiento limitado por fricción de Coulomb para la interfaz suelo--conducto
[@CANDE2025Formulations, sec. 4.3.3]; la relación entre resistencia normal y
tangencial se expresa mediante adhesión y $\tan\delta$
[@VulovaLeshchinsky2003, sec. 3.2.3, ec. 3.3].

La aplicación numérica corresponde a un escenario de comprobación con
$D_i=2.63$ m, perfil corrugado nominal de $76\times25\times3$ mm,
$R=1.315$ m, $\sigma'_{v,A}=100$ kPa, $K_0=0.50$ y $\Delta u_A=0$. Se adopta
adhesión nula y se calculan los límites $\alpha_\delta=0$ y
$\alpha_\delta=1$. Para el límite superior se obtiene

$$
-131.5\le N_\theta\le-65.8\ \mathrm{kN/m},\qquad
-21.62\le M_\theta\le21.61\ \mathrm{kN\,m/m},
$$

con $|Q_\theta|_{\max}=32.88$ kN/m. Para $\alpha_\delta=0$ se obtiene

$$
-109.6\le N_\theta\le-87.7\ \mathrm{kN/m},\qquad
-14.42\le M_\theta\le14.40\ \mathrm{kN\,m/m},
$$

con $|Q_\theta|_{\max}=21.92$ kN/m. En este escenario, la proyección
tangencial completa requiere $\alpha_{\delta,req}=0.354$; por encima de ese
valor la capacidad de fricción no limita la tracción tangencial proyectada.
Estos resultados corresponden al escenario declarado y no constituyen la
demanda del revestimiento existente.

La evaluación probabilística del proyecto no fue ejecutada. La tapada, la
geometría del revestimiento, el acero y el espesor original se tratarán como
datos conocidos una vez incorporados sus registros definitivos. Permanecen por
caracterizar las propiedades del relleno, la compactación, la condición de
interfaz y el espesor neto actual afectado por corrosión. Antes de asignar
distribuciones también deben definirse las dependencias entre variables y las
relaciones para recuperar tensiones en la chapa y demandas en las uniones. El
alcance mecánico de esta emisión termina en $N_\theta$, $M_\theta$ y
$Q_\theta$ y sus extremos.
