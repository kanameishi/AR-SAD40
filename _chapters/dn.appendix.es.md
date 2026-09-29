Este apéndice compila la forma publicada de cada formulación de desplazamientos permanentes de Newmark aplicada en el capítulo de coeficientes sísmicos: tres modelos de bloque rígido, dos de bloque flexible y la regla que define la configuración activa.

## Modelos de bloque rígido {#sec-newmark-rigid}

La formulación `AM88` de Ambraseys y Menu [-@AmbraseysMenu1988] utiliza la razón entre aceleración de fluencia y PGA, limitada para mantener el dominio logarítmico, $r^\star=\min (k_y/\mathrm{PGA},0.9999)$^[El soporte numérico de $k_y$ corresponde al intervalo definido en la sección de demanda; cuando una realización AM88 completa alcanza el límite $r^\star=0.9999$, su inversión conserva la PGA muestreada y recupera la rama física según @eq-kmax-am88-limit.]:

$$
\begin{aligned} \mu_{\ln D} &=\ln (10)\left[0.90+\log_{10}\!\left((1-r^\star)^{2.53} (r^\star)^{-1.09}\right)\right],\\ \sigma_{\ln D}&=0.30\ln (10). \end{aligned}
$${#eq-newmark-am88}

La excepción es el límite de AM88. Si la PGA muestreada de una realización, $\mathrm{PGA}_s$, es menor que el extremo inferior de la grilla, todos los puntos almacenados pueden satisfacer $k_y/\mathrm{PGA}_s\geq r_{\max}=0.9999$ y formar una meseta $D_{0,s}$. En ese caso no se extrapola la meseta ni se asigna $k_{\max}=0$. Para $D_a>D_{0,s}$ se resuelve la rama física $0<r<r_{\max}$ de @eq-newmark-am88:

$$
\mu_{\ln D}(r)
=\ln D_a-\ln D_{0,s}+\mu_{\ln D}(r_{\max}),
\qquad
k_{\max,s}=\mathrm{PGA}_s r .
$${#eq-kmax-am88-limit}

El residuo aleatorio se cancela entre $D_a$ y $D_{0,s}$. Además, $\mathrm{d}\mu_{\ln D}/\mathrm{d}r=-2.53/(1-r)-1.09/r<0$, por lo que la raíz es única. Una meseta AM88 sólo se acepta cuando la curva original es exactamente constante y la propia $\mathrm{PGA}_s$ demuestra que toda la grilla alcanzó ese límite; una curva plana de otro modelo, o un objetivo $D_a\leq D_{0,s}$, se rechaza como soporte no identificable.

La intensidad de Arias utilizada por JB07 y SR08 se estima para cada realización a partir de la PGA [@Verri2023a]:

$$
I_A=\exp(2.6109)\,\mathrm{PGA}^{1.9228}.
$${#eq-newmark-arias}

donde $I_A$ se expresa en m/s y PGA en unidades de $g$. La evaluación aplica esta relación de forma determinística: cada realización de PGA determina un único valor de $I_A$, y la muestra de desplazamientos propaga la variabilidad de PGA.

La formulación `JB07` de Jibson [-@Jibson2007] incorpora la intensidad de Arias y la razón $k_y/\mathrm{PGA}$:

$$
\begin{aligned} \mu_{\ln D} &=\ln (10)\left[0.561\log_{10}I_A -3.833\log_{10}\!\left(\frac{k_y}{\mathrm{PGA}}\right)-1.474\right],\\ \sigma_{\ln D}&=0.616\ln (10). \end{aligned}
$${#eq-newmark-jb07}

La formulación `SR08` de Saygili y Rathje [-@SaygiliRathje2008] define $r=k_y/\mathrm{PGA}$ y combina PGA e intensidad de Arias:

$$
\begin{aligned} \mu_{\ln D} ={}&2.39-5.24r-18.78r^2+42.01r^3-29.15r^4\\ &-1.56\ln\mathrm{PGA}+1.38\ln I_A,\\ \sigma_{\ln D}={}&0.46+0.56r. \end{aligned}
$${#eq-newmark-sr08}

La formulación BT07 de Bray y Travasarou [-@BrayTravasarou2007] emplea $S_a=S_a (1.5T_s)$ y $M_w$:

$$
\begin{aligned} \mu_{\ln D}={}&a_0-2.83\ln k_y-0.333 (\ln k_y)^2 +0.566\ln k_y\ln S_a\\ &+3.04\ln S_a-0.244 (\ln S_a)^2 +1.50T_s+0.278 (M_w-7),\\ a_0={}& \begin{cases} -0.22, & T_s<0.05\ \mathrm{s},\\ -1.10, & T_s\geq0.05\ \mathrm{s}, \end{cases}\\ \sigma_{\ln D}={}&0.66. \end{aligned}
$${#eq-newmark-bt07}

La formulación `BM17` de Bray, Macedo y Travasarou [-@BrayEtAl2018] representa movimientos de interfaz de subducción con $S_a=S_a (1.5T_s)$:

$$
\begin{aligned} \mu_{\ln D}&=a_0+a_1\ln S_a-0.225 (\ln S_a)^2,\\ a_1&=3.060+0.538\ln k_y,\\ a_{0,<}={}&-5.864+0.550M_w-9.421T_s\\ &-3.353\ln k_y-0.390 (\ln k_y)^2,\\ a_{0,\geq}={}&-6.896+0.550M_w+3.081T_s-0.803T_s^2\\ &-3.353\ln k_y-0.390 (\ln k_y)^2,\\ a_0&= \begin{cases} a_{0,<}, & T_s<0.1\ \mathrm{s},\\ a_{0,\geq}, & T_s\geq0.1\ \mathrm{s}, \end{cases}\\ \sigma_{\ln D}&=0.73. \end{aligned}
$${#eq-newmark-bm17}

La formulación `BM19` de Bray y Macedo [-@BrayMacedo2019] representa movimientos corticales someros ordinarios con $S_a=S_a (1.3T_s)$:

$$
\begin{aligned} \mu_{\ln D}&=a_0+\left(2.649+0.344\ln k_y\right)\ln S_a -0.090 (\ln S_a)^2,\\ a_{0,<}={}&-4.684+0.603M_w-9.471T_s\\ &-2.482\ln k_y-0.244 (\ln k_y)^2,\\ a_{0,\geq}={}&-5.981+0.603M_w+3.223T_s-0.945T_s^2\\ &-2.482\ln k_y-0.244 (\ln k_y)^2,\\ a_0&= \begin{cases} a_{0,<}, & T_s<0.1\ \mathrm{s},\\ a_{0,\geq}, & T_s\geq0.1\ \mathrm{s}, \end{cases}\\ \sigma_{\ln D}&=0.72. \end{aligned}
$${#eq-newmark-bm19}

## Modelos de bloque flexible {#sec-newmark-flexible}

## Ensamble {#sec-newmark-ensemble}

La configuración activa aplica cinco formulaciones: `AM88`, `JB07`, `SR08`, `BT07` y una rama BM — `BM17` cuando el proyecto declara control de subducción, `BM19` cuando declara control cortical; cada evaluación aplica por lo tanto cinco formulaciones, nunca ambas ramas BM a la vez. Los predictores y las dispersiones se aplican con la forma publicada de cada modelo.
