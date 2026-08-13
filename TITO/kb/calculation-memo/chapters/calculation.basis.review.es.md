# Objeto y alcance {#sec-calculation-scope}

Esta memoria documenta el cálculo de las resultantes seccionales de un
revestimiento circular, expresadas por unidad de ancho axial proyectado, bajo
las acciones perimetrales obtenidas al proyectar sobre el contorno un estado
tensional biaxial uniforme prescrito. El estado tensional prescrito es
uniforme; las componentes radial $P_r(\theta)$ y tangencial $P_t(\theta)$ de
la acción sobre el contorno varían con la coordenada angular.

El cálculo determina la fuerza normal circunferencial $N_\theta(\theta)$, el
momento flector circunferencial $M_\theta(\theta)$ y la fuerza cortante
circunferencial $Q_\theta(\theta)$, junto con sus extremos, para los valores
adoptados de $\alpha$, que multiplica la componente tangencial prescrita. El
caso constituye la evaluación determinística de referencia para comprobar la
resolución numérica. Sus resultados corresponden al estado de acciones adoptado y
no representan por sí solos la demanda del revestimiento existente.

# Datos adoptados y convenciones {#sec-calculation-basis}

## Datos del caso

La @tbl-calculation-inputs reúne las magnitudes empleadas en la evaluación
determinística. El diámetro define la línea circular de referencia. Las
propiedades seccionales corresponden a la fila exacta de 2,8 mm del perfil
CSPI 76×25: el espesor especificado es $t_s=2{,}80$ mm y el espesor base de
diseño es $t_d=2{,}64$ mm. El área y el momento de inercia se toman
directamente de esa fila.
El módulo $E_\theta$, el estado tensional efectivo y los valores adoptados de
$\alpha$ completan las entradas del caso.

{{< include /_tbl/Calculation.inputs.ES.qmd >}}

La tabla identifica la formulación empleada para obtener $K_0$, sus variables
primitivas y el valor aplicado. Una rama de valor adoptado constituye una
hipótesis del caso; las demás ramas calculan $K_0$ mediante las relaciones y
los dominios establecidos en la @sec-calculation-k0-estimation. El parámetro
$\alpha$ es un multiplicador de la componente tangencial prescrita y no un
coeficiente de fricción ni una ley constitutiva de la interfaz.

## Coordenada angular y convenciones de signo

La coordenada angular se define con $\theta=0$ en la clave y sentido positivo
horario. El versor radial $\mathbf e_r$ es positivo hacia el exterior del
revestimiento y el versor tangencial $\mathbf e_t$ sigue el sentido creciente
de $\theta$. En consecuencia, $P_r>0$ actúa hacia el exterior y $P_t>0$ actúa
en la dirección de $\mathbf e_t$.

La fuerza normal circunferencial es positiva a tracción. La coordenada
seccional $\xi$ es positiva hacia la fibra interior; por lo tanto,
$M_\theta>0$ produce tracción en esa fibra. En la cara positiva del elemento
diferencial, cuya normal sigue $\mathbf e_t$, $Q_\theta>0$ actúa hacia el
centro de la sección circular. Las componentes de acción perimetral $P_r$ y
$P_t$ se expresan en kPa; $N_\theta$ y $Q_\theta$, en kN/m; y $M_\theta$, en
kN·m/m.

## Definición de las resultantes seccionales

Para una posición angular $\theta$ fija, sea $A_b$ el dominio material de la
sección resistente idealizada comprendido en una franja de ancho axial
proyectado $b$, en un corte normal a la dirección circunferencial. Sean $x_L$
la coordenada axial y $\xi$ la coordenada radial local medida desde el eje
centroidal de esa sección; $dA$ denota un elemento diferencial de $A_b$.
La tensión tangencial $\tau_{\theta\xi}$ es positiva en la dirección de
$\xi>0$. Las resultantes por unidad de ancho se definen mediante

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
la exterior. Las tres expresiones son integrales bidimensionales sobre $A_b$ con
$\theta$ constante; no integran alrededor de la circunferencia.
