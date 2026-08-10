# Solución del anillo circular bajo tracciones prescritas

## 1. Alcance mecánico

Una vez conocidas las tracciones perimetrales, el problema estructural se
resuelve sin elementos finitos. El anillo se idealiza como una viga curva,
cerrada, de radio centroidal $R$, en estado plano y por unidad de longitud
longitudinal. La solución entrega los resultantes circunferenciales

$$
N(\theta),\qquad M(\theta),\qquad Q(\theta).
$$

Esta operación no determina por sí sola el contacto suelo–estructura. Si la
presión cambia con la rigidez del liner, las tracciones deben proceder de una
solución acoplada o tratarse como escenarios de carga. La independencia de
$E$ e $I$ que aparece para los armónicos $n\geq2$ es una propiedad del
equilibrio de un anillo bajo **cargas prescritas**, no una afirmación sobre un
suelo real.

La formulación radial y sus verificaciones publicadas siguen a Baker (1968),
PDF pp. 19–31 y 53–55. La extensión a tracción tangencial se presenta a
continuación como **DERIVACIÓN** y se verifica sustituyéndola en las tres
ecuaciones diferenciales de equilibrio.

## 2. Equilibrio diferencial

Con los signos definidos en el capítulo de alcance, el equilibrio local es

$$
RQ-M'=0,
$$ {#eq-ring-moment}

$$
RP_r-N-Q'=0,
$$ {#eq-ring-radial}

$$
N'-Q+RP_t=0,
$$ {#eq-ring-tangential}

donde la prima indica derivada respecto de $\theta$. Eliminando $Q$:

$$
RN+M''=R^2P_r,
\qquad
N'-\frac{M'}{R}=-RP_t.
$$

Antes de resolver, el programa comprueba el equilibrio global:

$$
\int_0^{2\pi}R\left(P_r\mathbf e_n+P_t\mathbf e_t\right)d\theta=\mathbf0,
\qquad
\int_0^{2\pi}R^2P_t\,d\theta=0.
$$

Una carga que no satisfaga estas condiciones necesita peso propio, flotación,
apoyos o reacciones de contacto expresamente modeladas. El programa se detiene
en vez de absorber esa resultante en un modo ficticio.

## 3. Comparador modal de Fourier

Se escriben ambas fases de cada tracción:

$$
P_r(\theta)=A_0+
\sum_{n=1}^{n_{max}}\left[A_n\cos(n\theta)+\widetilde A_n\sin(n\theta)\right],
$$

$$
P_t(\theta)=C_0+
\sum_{n=1}^{n_{max}}\left[C_n\cos(n\theta)+B_n\sin(n\theta)\right].
$$

Para una curva tabulada sobre una grilla periódica, el código obtiene los
coeficientes mediante la transformada discreta equivalente a

$$
A_n=\frac1\pi\int_0^{2\pi}P_r(\theta)\cos(n\theta)\,d\theta,
\qquad
\widetilde A_n=\frac1\pi\int_0^{2\pi}P_r(\theta)\sin(n\theta)\,d\theta,
$$

y expresiones análogas para $B_n$ y $C_n$. No se incluye simultáneamente
$\theta=0$ y $2\pi$, porque representan el mismo punto.

### 3.1 Significado de los modos y del truncamiento

La serie de Fourier no introduce una hipótesis de carga adicional: descompone
la distribución prescrita en patrones angulares. El modo $n$ tiene una
longitud angular característica $2\pi/n$.

| Modo | Contenido mecánico en este problema |
|---:|---|
| $n=0$ | componente uniforme: presión media y compresión anular media |
| $n=1$ | fuerza global o movimiento rígido; exige equilibrio o una reacción explícita |
| $n=2$ | ovalización: diferencia entre las acciones vertical y horizontal |
| $n\geq3$ | variaciones progresivamente más localizadas de presión o contacto |

Por ejemplo, el tensor biaxial constante usado para representar un estado
$K_0$ contiene exactamente $n=0$ y $n=2$. No obtiene mayor precisión por
agregar modos cuyo coeficiente es nulo. En cambio, una banda de compactación,
una sobrecarga localizada o una reacción de contacto parcial requiere modos
$n\geq3$ para reproducir su variación perimetral.

$n_{max}$ no es un parámetro físico. Es el truncamiento de una representación
numérica y se selecciona aumentando su valor hasta que los extremos y ángulos
de $N$, $M$ y $Q$ permanezcan estables dentro de una tolerancia declarada. Las
cargas suaves convergen con menos modos que las cargas con bordes abruptos;
estas últimas pueden presentar oscilaciones de Gibbs cerca de la
discontinuidad.

### 3.2 Armónicos $n\geq2$

Para el par $A_n\cos n\theta$ y $B_n\sin n\theta$, la **DERIVACIÓN** da

$$
N_n=\frac{R(nB_n-A_n)}{n^2-1}\cos(n\theta),
$$ {#eq-ring-n-cos}

$$
M_n=\frac{R^2(B_n/n-A_n)}{n^2-1}\cos(n\theta),
$$ {#eq-ring-m-cos}

$$
Q_n=\frac{R(nA_n-B_n)}{n^2-1}\sin(n\theta).
$$ {#eq-ring-q-sin}

La fase ortogonal, $\widetilde A_n\sin n\theta$ y
$C_n\cos n\theta$, produce

$$
\widetilde N_n=-\frac{R(\widetilde A_n+nC_n)}{n^2-1}\sin(n\theta),
$$

$$
\widetilde M_n=-\frac{R^2(\widetilde A_n+C_n/n)}{n^2-1}\sin(n\theta),
$$

$$
\widetilde Q_n=-\frac{R(n\widetilde A_n+C_n)}{n^2-1}\cos(n\theta).
$$

La respuesta total es la suma de todos los armónicos. Cada modo calculado
satisface individualmente @eq-ring-moment–@eq-ring-tangential.

### 3.3 Modo $n=0$

Para $P_r=A_0$ y $P_t=0$,

$$
N_0=RA_0,\qquad Q_0=0.
$$

El momento constante es la única indeterminación estática. La aproximación
membranal adopta $M_0=0$. Para una sección simétrica de área $A_p$ y segundo
momento $I_p$, la compatibilidad elástica empleada en esta metodología da

$$
\eta=\frac{I_p}{A_pR^2},
\qquad
M_0=\frac{R^2\eta}{1+\eta}A_0.
$$

Para una sección rectangular isótropa de espesor $t$, el caso particular es

$$
\eta=\frac{t^2}{12R^2}.
$$

La sección corrugada se introduce mediante sus propiedades $A_p$ e $I_p$;
no se modifica el resultado después de resolver el anillo.

### 3.4 Modo $n=1$

El modo $n=1$ representa fuerza global. Para la fase
$P_r=A_1\cos\theta$, $P_t=B_1\sin\theta$, un anillo libre exige
$A_1=B_1$. La otra fase exige $C_1=-\widetilde A_1$. Cuando ambas
condiciones se cumplen, la compatibilidad da

$$
N_1=R\left(A_1\cos\theta+\widetilde A_1\sin\theta\right),
\qquad M_1=Q_1=0.
$$

Si no se cumplen, el código informa $F_x$, $F_z$ y el torque desequilibrados
y no devuelve resultantes.

## 4. Soluciones cerradas de control

Sea un estado constante al eje con compresiones efectivas
$\sigma'_v$ y $\sigma'_h$, presión de poros $u$, y

$$
p_0=u+\frac{\sigma'_v+\sigma'_h}{2},
\qquad
\Delta=\sigma'_v-\sigma'_h.
$$

### 4.1 Tracción completa del tensor

Al aplicar las componentes normal y tangencial del tensor:

$$
N(\theta)=-Rp_0+\frac{R\Delta}{2}\cos2\theta,
$$ {#eq-full-n}

$$
M(\theta)=M_0+\frac{R^2\Delta}{4}\cos2\theta,
$$ {#eq-full-m}

$$
Q(\theta)=-\frac{R\Delta}{2}\sin2\theta.
$$ {#eq-full-q}

Para $\Delta\geq0$, los valores de control son

| Ubicación | $N$ | $M-M_0$ | $Q$ |
|---|---:|---:|---:|
| clave y solera, $\theta=0,\pi$ | $-R(u+\sigma'_h)$ | $+R^2\Delta/4$ | $0$ |
| hastiales, $\theta=\pi/2,3\pi/2$ | $-R(u+\sigma'_v)$ | $-R^2\Delta/4$ | $0$ |
| diagonales, $\theta=\pi/4+k\pi/2$ | $-Rp_0$ | $0$ | $\lvert Q\rvert=R\Delta/2$ |

Por lo tanto,

$$
N_{min}=-Rp_0-\frac{R|\Delta|}{2},
\qquad
N_{max}=-Rp_0+\frac{R|\Delta|}{2},
$$

$$
M_{max,min}=M_0\pm\frac{R^2|\Delta|}{4},
\qquad
|Q|_{max}=\frac{R|\Delta|}{2}.
$$

### 4.2 Interfaz sólo normal

Si se conserva la misma ordenada normal pero se impone $P_t=0$:

$$
N(\theta)=-Rp_0+\frac{R\Delta}{6}\cos2\theta,
$$ {#eq-normal-n}

$$
M(\theta)=M_0+\frac{R^2\Delta}{6}\cos2\theta,
$$ {#eq-normal-m}

$$
Q(\theta)=-\frac{R\Delta}{3}\sin2\theta.
$$ {#eq-normal-q}

Para $\Delta\geq0$:

| Ubicación | $N$ | $M-M_0$ | $Q$ |
|---|---:|---:|---:|
| clave y solera | $-R[u+(\sigma'_v+2\sigma'_h)/3]$ | $+R^2\Delta/6$ | $0$ |
| hastiales | $-R[u+(2\sigma'_v+\sigma'_h)/3]$ | $-R^2\Delta/6$ | $0$ |
| diagonales | $-Rp_0$ | $0$ | $\lvert Q\rvert=R\Delta/3$ |

Las dos ramas comparten $p_n(\theta)$, pero no son equivalentes: la
transferencia tangencial modifica $N$, $M$ y $Q$. Ninguna de las dos se
denomina predicción del contacto real sin una justificación de interfaz.

{{< include /_fig/Ring.resultants.ES.qmd >}}

## 5. Influencia explícita de tapada y $K_0$

Para un relleno homogéneo, seco y evaluado al eje,

$$
\sigma'_v=q'+\gamma'(H+R),
\qquad
\sigma'_h=K_0\sigma'_v+\Delta\sigma'_{h,c}.
$$

Sin incremento residual, $\Delta=\sigma'_v(1-K_0)$. En la rama de tracción
completa:

$$
|M-M_0|_{max}=\frac{R^2}{4}\sigma'_v|1-K_0|,
\qquad
|Q|_{max}=\frac{R}{2}\sigma'_v|1-K_0|.
$$

En la rama sólo normal, los denominadores correspondientes son $6$ y $3$.
Mientras $\gamma'$ y $K_0$ permanezcan constantes, la respuesta crece
linealmente con $H$. Cuando $K_0\to1$, desaparecen el momento y el corte
ovalizantes; queda compresión membranal. Para $K_0<1$, disminuir $K_0$
aumenta $|M|$ y $|Q|$, aunque reduce la compresión de $N$ en clave en la rama
de tracción completa.

La presión de poros uniforme de referencia incrementa $p_0$ y, por tanto,
la compresión membranal, pero no $\Delta$. Un gradiente hidrostático real
genera además un modo $n=1$ de flotación; requiere incluir su reacción antes
de resolver el anillo.

## 6. Procedimiento numérico

Para cada escenario determinístico, la ruta principal es:

1. construir $P_r(\theta)$ y $P_t(\theta)$ con un adaptador autorizado;
2. verificar sus fuerzas y torque globales;
3. resolver directamente las ecuaciones de equilibrio y compatibilidad;
4. reconstruir $N(\theta)$, $M(\theta)$ y $Q(\theta)$;
5. localizar los extremos conservando valor, signo y ángulo;
6. refinar la integración y la grilla hasta estabilizar esos extremos.

La comparación modal se realiza por separado:

1. proyectar las mismas tracciones sobre una grilla periódica uniforme;
2. inspeccionar sus coeficientes e identificar los modos físicamente presentes;
3. comprobar que el modo $n=1$ satisface el equilibrio global;
4. aplicar las ecuaciones modales y reconstruir los tres resultantes;
5. incrementar $n_{max}$ hasta que la solución truncada coincida con la ruta
   directa dentro de la tolerancia declarada.

Una carga discontinua, como la banda de compactación FHWA, converge más
lentamente que un campo suave. El truncamiento $n_{max}$ y el número de puntos
angulares son parte del registro de cada corrida.

El solver principal está implementado en `scripts/R/ringDirect.R` y el
comparador modal en `scripts/R/ringFourier.R`. Las pruebas de equilibrio,
soluciones cerradas y reproducción de Baker están en
`scripts/R/testRingMethod.R`.
