---
lang: es
title: "Memoria de cálculo del revestimiento circular"
subtitle: "Escenario determinístico definido por la altura de relleno sobre la clave"
pilotStatus: candidate
---

# Modelo de cálculo {#sec-calculation-model}

## Objeto y alcance {#sec-calculation-scope}

Esta memoria documenta el cálculo de las resultantes seccionales de un
revestimiento circular, expresadas por unidad de ancho axial proyectado, para
un escenario determinístico definido por la altura de relleno sobre la clave,
el estado tensional efectivo del terreno en ausencia del revestimiento y las
propiedades elásticas del relleno. La respuesta de la sección transversal se
obtiene mediante la secuencia de carga externa de Schwartz--Einstein para dos
idealizaciones cinemáticas de la interfaz: deslizamiento libre y ausencia de
deslizamiento [@SchwartzEinstein1980]. Estas idealizaciones no se presentan
como límites demostrados de la respuesta de toda interfaz real.

El cálculo determina la fuerza normal circunferencial $N_\theta(\theta)$, el
momento flector circunferencial $M_\theta(\theta)$ y la fuerza de corte
circunferencial $Q_\theta(\theta)$, junto con sus valores extremos y posiciones
angulares. Las entradas son hipótesis de la aplicación numérica; no se
presentan como resultados de una caracterización del relleno existente.

El modelo se aplica por separado al revestimiento existente de chapas de acero
corrugadas y a dos alternativas autónomas de hormigón proyectado: simple y
armado. Cada alternativa emplea su propio radio hasta el baricentro de la
pared, sus propiedades seccionales y sus rigideces. La interacción y las
resultantes se recalculan para cada revestimiento y no se transfieren entre
alternativas. El hormigón simple se comprueba mediante las disposiciones
aplicables del Capítulo 14 de ACI 318-25 [@ACI31825]. La alternativa armada se
evalúa mediante un dominio de interacción $P$--$M$ de ACI 318-25 y el área
mínima de armadura para cáscaras adoptada de ACI 318.2-14
[@ACI31825; @ACI318214].

En forma separada, el conducto de acero corrugado se comprueba mediante una
reproducción identificada de un procedimiento AASHTO anterior, publicada en
CIRSOC 804-4 [@CIRSOC8044]. La comprobación determina el empuje mayorado por
unidad de longitud de pared y evalúa la resistencia de pared, la resistencia
de las costuras, la flexibilidad y el recubrimiento mínimo de suelo sobre el
conducto. Esta aplicación no demuestra conformidad con la edición AASHTO
vigente. El empuje escalar de pared y las resultantes angulares provienen de
formulaciones de carga distintas y no se combinan entre sí.

## Datos comunes y convenciones {#sec-calculation-basis}

### Datos del caso {#sec-calculation-scenario-data}

La @tbl-calculation-inputs reúne exclusivamente las magnitudes comunes del
escenario. La altura de relleno sobre la clave, el peso unitario adoptado para
el cálculo en tensiones efectivas, la sobrecarga, $K_0$, $E_g$ y $\nu_g$
determinan el estado tensional del terreno en ausencia del revestimiento y la
interacción adoptada. Las propiedades de cada alternativa de revestimiento se
presentan en sus tablas seccionales correspondientes; las del perfil corrugado
se identifican en la @tbl-calculation-section-reference.

| $x_i$ | $v_i$ | $u_i$ |
|---|---:|---|
| $H_0$ | 8 | m |
| $R$ | 1.315 | m |
| $\gamma'$ | 19 | kN/m³ |
| $q'$ | 0 | kPa |
| $K_0$ | 0.5 | adimensional |
| $E_g$ | 30 | MPa |
| $\nu_g$ | 0.3 | adimensional |

: Datos comunes del escenario: $H_0$ es la altura de relleno sobre la clave; $R$ es la distancia desde la clave hasta el centro geométrico del revestimiento circular; $\gamma'$ es el peso unitario adoptado para el cálculo en tensiones efectivas; $q'$ es la sobrecarga incluida en ese cálculo; $K_0$ es el coeficiente de presión de tierras en reposo adoptado; y $E_g$ y $\nu_g$ son los parámetros elásticos del relleno. {#tbl-calculation-inputs}

En esta aplicación, $K_0$ se adopta como hipótesis del caso. Las formulaciones
complementarias y sus dominios se reúnen en el
[Apéndice B.3](#sec-calculation-appendix-k0-alternatives). La interfaz con
deslizamiento libre y la interfaz sin deslizamiento son dos idealizaciones
cinemáticas discretas; no se interpolan mediante un multiplicador ni se afirma
que acoten la respuesta de cualquier interfaz real.

### Coordenada angular y convenciones de signo {#sec-calculation-sign-conventions}

La coordenada angular se define con $\theta=0$ en la clave y sentido positivo
horario. El vector unitario radial $\mathbf e_r$ es positivo hacia el exterior
del revestimiento y el vector unitario tangencial $\mathbf e_t$ sigue el
sentido creciente de $\theta$. En consecuencia, $P_r>0$ actúa hacia el
exterior y $P_t>0$ actúa en la dirección de $\mathbf e_t$.

La fuerza normal circunferencial es positiva a tracción. La coordenada
seccional $\xi$ es positiva hacia la fibra interior; por lo tanto,
$M_\theta>0$ produce tracción en esa fibra. En la cara positiva del elemento
diferencial, cuya normal sigue $\mathbf e_t$, $Q_\theta>0$ actúa hacia el
centro de la sección circular. Las componentes radial y tangencial de la
acción distribuida sobre el perímetro, $P_r$ y $P_t$, se expresan en kPa;
$N_\theta$ y $Q_\theta$, en kN/m; y $M_\theta$, en kN·m/m.

### Definición de las resultantes seccionales {#sec-calculation-resultants-definition}

Para una posición angular $\theta$ fija, sea $A_b$ la región ocupada por
material en la sección resistente idealizada comprendida en una franja de
ancho axial proyectado $b$, en un corte normal a la dirección
circunferencial. Sean $x_L$ la coordenada axial y $\xi$ la coordenada radial
local medida desde el eje baricéntrico de esa sección; $dA$ denota un elemento
diferencial de $A_b$. La tensión de corte $\tau_{\theta\xi}$ es positiva en la
dirección de $\xi>0$. Las resultantes por unidad de ancho se definen mediante

$$
\begin{aligned}
N_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\sigma_\theta(\theta,x_L,\xi)\,dA,\\
M_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\sigma_\theta(\theta,x_L,\xi)\,\xi\,dA,\\
Q_\theta(\theta)
&=\frac{1}{b}\iint_{A_b}
\tau_{\theta\xi}(\theta,x_L,\xi)\,dA.
\end{aligned}
$$ {#eq-calculation-resultant-definitions}

En una descripción cartesiana local, $dA=dx_L\,d\xi$. Para la sección de
material homogéneo considerada, el origen de $\xi$ satisface
$\iint_{A_b}\xi\,dA=0$; $\xi>0$ corresponde a la fibra interior y $\xi<0$ a
la exterior. Las tres expresiones son integrales bidimensionales sobre $A_b$
con $\theta$ constante; no integran alrededor de la circunferencia.

## Estado tensional y acciones adoptadas {#sec-calculation-actions}

El estado de cálculo se define mediante las tensiones efectivas del terreno en
ausencia del revestimiento, evaluadas a la profundidad del centro geométrico
del revestimiento circular, y la secuencia de carga externa de
Schwartz--Einstein [@SchwartzEinstein1980]. La presión vertical debida al peso
del relleno se desarrolla en el
[Apéndice B](#sec-calculation-appendix-actions). El escenario vigente no
incorpora una acción hidráulica; su consideración requiere caracterizar el
nivel freático y la presión de poros. La aplicación determinística corresponde
a la condición final del relleno colocado. La acción temporal debida al equipo de
compactación pertenece a otra etapa constructiva y no se superpone con esta
condición permanente. Tampoco se incorpora una tensión residual de
compactación, porque no está caracterizada para el caso.

### Tensión vertical efectiva de referencia {#sec-calculation-reference-stress}

Sea $H_0$ la altura de relleno medida desde la superficie del terreno hasta la
clave y $R=1.315\ \mathrm{m}$ la distancia desde la clave hasta el centro
geométrico del revestimiento circular. La profundidad de referencia adoptada
en esta aplicación es

$$
z_{ref}=H_0+R.
$$ {#eq-calculation-reference-depth}

El caso ejecutado representa un relleno homogéneo, con
$\gamma'=19\ \mathrm{kN/m^3}$ y $q'=0\ \mathrm{kPa}$. La tensión vertical
efectiva a la profundidad de referencia se determina mediante

$$
\sigma'_v(z_{ref})=q'+\gamma' z_{ref},
$$ {#eq-calculation-vertical-effective-stress}

donde $q'$ es la sobrecarga y $\gamma'$ el peso unitario asignados directamente
al cálculo de tensiones efectivas. Las profundidades se expresan en m, los
pesos unitarios en kN/m³ y las tensiones en kPa. El valor de $\gamma'$ no se
reclasifica aquí como peso total o flotante. Una condición con agua o
estratigrafía requiere entradas y una discretización propias y no forma parte
de este escenario.

### Tensión horizontal efectiva y coeficiente $K_0$ {#sec-calculation-k0-estimation}

El coeficiente de presión de tierras en reposo se define en tensiones
efectivas:

$$
K_0(z_{ref})=\frac{\sigma'_h(z_{ref})}{\sigma'_v(z_{ref})},
\qquad
\sigma'_h(z_{ref})=K_0(z_{ref})\,\sigma'_v(z_{ref}).
$$ {#eq-calculation-k0}

La aplicación adopta un valor declarado de $K_0$ para la profundidad y la
etapa analizadas. Las relaciones que permiten estimarlo a partir de $\nu_g$,
$\phi'$ y la historia tensional se reúnen en el
[Apéndice B.3](#sec-calculation-appendix-k0-alternatives); no se combinan entre
sí ni con el valor adoptado.
