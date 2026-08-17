## Estado tensional y acciones adoptadas {#sec-calculation-actions}

El estado de cálculo se define mediante las tensiones efectivas del terreno en
ausencia del revestimiento, evaluadas en el centro geométrico de la sección
transversal. Ese estado biaxial se proyecta sobre el contorno y se resuelve por
integración directa. La presión vertical debida al peso del relleno se
desarrolla en el [Apéndice B](#sec-calculation-appendix-actions). El caso
provisional adopta presión hidráulica neta nula y no incorpora una tensión
horizontal residual de compactación, porque ambos efectos requieren datos que
aún no han sido suministrados.

### Tensión vertical efectiva de referencia

Sea $H_0$ la altura de relleno medida desde la superficie del terreno hasta la
clave y $R$ la distancia desde la clave hasta el centro geométrico de la
sección circular. Para la profundidad de referencia adoptada,

$$
z_{ref}=H_0+R.
$$ {#eq-calculation-reference-depth}

El escenario ejecutado representa un relleno homogéneo. La tensión vertical
efectiva en la profundidad de referencia se calcula mediante

$$
\sigma'_v(z_{ref})=q'+\gamma' z_{ref},
$$ {#eq-calculation-vertical-effective-stress}

donde $q'$ es la sobrecarga asignada al cálculo de tensiones efectivas y
$\gamma'$ es el peso unitario asignado directamente a ese cálculo. Esta
entrada no se reclasifica como peso unitario total o sumergido. Las
profundidades se expresan en m, el peso unitario en kN/m³ y las tensiones en
kPa. La entrada de presión hidráulica neta permite recalcular el caso cuando
se disponga de la condición de agua.

### Tensión horizontal efectiva y coeficiente $K_0$ {#sec-calculation-k0-estimation}

El coeficiente de empuje en reposo se define en tensiones efectivas:

$$
K_0(z_{ref})=\frac{\sigma'_h(z_{ref})}{\sigma'_v(z_{ref})},
\qquad
\sigma'_h(z_{ref})=K_0(z_{ref})\,\sigma'_v(z_{ref}).
$$ {#eq-calculation-k0}

La aplicación calcula $K_0$ a partir de sus variables primitivas. En el caso
provisional, la rama de descarga de Mayne--Kulhawy con $\phi'=30^\circ$ y
$\mathrm{OCR}=1$ se reduce a [@MayneKulhawy1982]

$$
K_0=(1-\sin\phi')\,\mathrm{OCR}^{\sin\phi'}=0{,}5.
$$ {#eq-calculation-k0-unloading}

Las formulaciones alternativas y sus dominios se reúnen en el
[Apéndice B.3](#sec-calculation-appendix-k0-alternatives). Cada estado emplea
una sola rama.

### Proyección del estado biaxial {#sec-calculation-external-interaction}

En la cota del centro de la sección se prescribe un estado uniforme con
componentes principales $\sigma'_{v,A}$ y $\sigma'_{h,A}$. Su proyección sobre
el contorno es

$$
\begin{aligned}
p'_n(\theta)&=\sigma'_{v,A}\cos^2\theta
  +\sigma'_{h,A}\sin^2\theta,\\
p_t^*(\theta)&=(\sigma'_{v,A}-\sigma'_{h,A})
  \sin\theta\cos\theta,\\
p_n(\theta)&=p'_n(\theta)+\Delta u_A.
\end{aligned}
$$ {#eq-calculation-stress-projection}

Con la convención estructural adoptada,

$$
P_r(\theta)=-p_n(\theta),
\qquad
P_t(\theta)=\alpha p_t^*(\theta),
\qquad 0\leq\alpha\leq1.
$$ {#eq-calculation-tangential-multiplier}

$\alpha=1$ incorpora la proyección tangencial completa y $\alpha=0$ conserva
únicamente la acción normal. $\alpha$ no es un coeficiente de fricción ni una
ley constitutiva de contacto.

Definiendo

$$
p_m=\Delta u_A+\frac{\sigma'_{v,A}+\sigma'_{h,A}}{2},
\qquad
\Delta\sigma=\sigma'_{v,A}-\sigma'_{h,A},
$$

las acciones se reducen a

$$
P_r(\theta)=-p_m-\frac{\Delta\sigma}{2}\cos2\theta,
\qquad
P_t(\theta)=\alpha\frac{\Delta\sigma}{2}\sin2\theta.
$$ {#eq-calculation-biaxial-load}

Las resultantes se obtienen por integración directa del equilibrio,
periodicidad y compatibilidad del anillo. La solución cerrada del mismo estado
biaxial y su representación de Fourier controlan el cálculo numérico. La rama
de Schwartz--Einstein se materializa en tablas separadas de comparación y no
alimenta las verificaciones resistentes.
