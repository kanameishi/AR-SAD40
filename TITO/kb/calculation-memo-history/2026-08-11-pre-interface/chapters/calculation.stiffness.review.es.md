# Rigidez circunferencial del perfil corrugado {#sec-calculation-stiffness}

## Ley seccional

En el problema plano, la corrugación se representa mediante las propiedades de
la sección por unidad de longitud proyectada sobre el eje. La ley constitutiva
es

$$
N_\theta=EA_\theta\varepsilon_\theta,
\qquad
M_\theta=EI_\theta\kappa_\theta,
$$

$$
EA_\theta=E_\theta A_p,
\qquad
EI_\theta=E_\theta I_p,
\qquad
\eta_s=\frac{EI_\theta}{EA_\theta R^2}
=\frac{I_p}{A_pR^2}.
$$ {#eq-calculation-section-stiffness}

$A_p$ e $I_p$ son, respectivamente, el área y el momento de inercia del perfil
corrugado por unidad de longitud proyectada; deben proceder de la geometría
real, de tablas aplicables o de una medición documentada. La tabla 2.6 del
manual NCSPA proporciona propiedades para perfiles normalizados y permite el
contraste de unidades [@NCSPA2018, tabla 2.6].

## Función de las rigideces

La integración de equilibrio determina la distribución no uniforme de las
resultantes. La razón $\eta_s$ interviene en la condición de compatibilidad del
modo uniforme mediante la @eq-calculation-compatibility-constants. Para el
perfil del escenario analítico, $\eta_s$ es del orden de $10^{-5}$; por ello,
la contribución uniforme $M_m$ es pequeña frente al momento asociado al
armónico de orden dos. Este resultado se comprueba numéricamente en la
@sec-calculation-application.

La reducción a $EA_\theta$ y $EI_\theta$ no es una modificación posterior de
una respuesta calculada con otra rigidez: las propiedades se incorporan en la
compatibilidad de la solución desde el inicio. Las rigideces longitudinales,
los acoplamientos de una lámina y las tensiones locales en crestas y valles no
intervienen en el estado plano adoptado.

## Equivalencia seccional auxiliar

Para comparar unidades y órdenes de magnitud puede definirse una sección lisa
que conserve simultáneamente $EA_\theta$ y $EI_\theta$:

$$
t_{eq}=\sqrt{\frac{12I_p}{A_p}},
\qquad
E_{eq}=\frac{E_\theta A_p}{t_{eq}}.
$$ {#eq-calculation-equivalent-section}

$t_{eq}$ no es el espesor físico de la chapa y $E_{eq}$ no sustituye el módulo
del acero para una comprobación resistente. Ambos son parámetros auxiliares de
una equivalencia seccional.
