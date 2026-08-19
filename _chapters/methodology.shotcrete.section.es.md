# Comprobación resistente de la sección de hormigón proyectado

## Acciones sobre una franja longitudinal

Para cada condición de interfaz, combinación y posición angular se reciben las
resultantes concurrentes $N_\theta$, $M_\theta$ y $Q_\theta$, expresadas por
unidad de longitud del eje. Se adopta $N_\theta>0$ a tracción y
$M_\theta>0$ cuando tracciona la cara interior. Para una franja de ancho $b$,
las acciones resistentes son

$$
P_u=-N_\theta b,
\qquad
M_u=\lvert M_\theta\rvert b,
\qquad
V_u=\lvert Q_\theta\rvert b,
$$ {#eq-shotcrete-strip-resultants}

donde $P_u>0$ corresponde a compresión. Si $N_\theta$ se expresa en kN/m,
$M_\theta$ en kN·m/m y $b$ en m:

$$
P_u[\mathrm N]=-10^3N_\theta b,
\qquad
M_u[\mathrm{N\,mm}]=10^6\lvert M_\theta\rvert b,
\qquad
V_u[\mathrm N]=10^3\lvert Q_\theta\rvert b.
$$ {#eq-shotcrete-unit-conversion}

El cálculo resistente no aplica factores adicionales. La combinación, la
etapa, la condición factorizada, la interfaz y el ángulo forman parte de cada
registro de demanda.

En las combinaciones resistentes de esta aplicación, la acción vertical
permanente comprende el relleno y la sobrecarga de lodo; la acción horizontal
es el empuje lateral asociado al mismo estado del relleno. La envolvente
EV--EH adopta los pares de factores
$(\Gamma_{EV},\Gamma_{EH})=(1.30,1.35)$,
$(1.30,0.90)$, $(0.90,1.35)$ y $(0.90,0.90)$ de la base
AASHTO/CIRSOC utilizada para estructuras enterradas rígidas. Los factores se
aplican a las componentes vertical y horizontal del estado libre antes de
recalcular la interacción, no a $N_\theta$, $M_\theta$ o $Q_\theta$ ya
calculados.

## Hormigón simple: propiedades de la franja

Sea $h$ el espesor especificado. En esta aplicación, el shotcrete se coloca
sobre la cara interior del liner existente y se utiliza el espesor completo:

$$
h_d=h.
$$ {#eq-shotcrete-design-thickness}

No se descuenta espesor por contacto con el terreno.

Para una franja rectangular:

$$
A_g=b h_d,
\qquad
S_m=\frac{b h_d^2}{6}.
$$ {#eq-shotcrete-plain-properties}

Las expresiones siguientes usan $f'_c$ en MPa, $b$ y $h_d$ en mm, $P_u$ y
$V_u$ en N y $M_u$ en N·mm. Para el Capítulo 14, el factor de reducción es
$\phi=0.60$.

## Tracción en la cara extrema

La tensión de tracción producida por flexocompresión se evalúa como

$$
f_t=\max\left(0,\frac{M_u}{S_m}-\frac{P_u}{A_g}\right).
$$ {#eq-shotcrete-plain-tension-demand}

La resistencia de cálculo y la utilización son

$$
f_{t,d}=\phi\,0.42\lambda\sqrt{f'_c},
\qquad
U_t=\frac{f_t}{f_{t,d}}\le1,
$$ {#eq-shotcrete-plain-tension-check}

conforme a ACI CODE-318-25, Tabla 14.5.4.1(a) [@ACI31825]. Esta comprobación
se aplica a estados con compresión axial; los estados con tracción axial
requieren una disposición resistente diferente.

## Compresión combinada con flexión

La resistencia nominal a flexión para la cara comprimida es

$$
M_{n,c}=0.85 f'_c S_m.
$$ {#eq-shotcrete-plain-compression-moment}

Cuando se conoce la longitud de compresión $\ell_c$, la resistencia axial
nominal se calcula mediante

$$
P_n=0.60 f'_c A_g
\left[1-\left(\frac{\ell_c}{32h_d}\right)^2\right],
$$ {#eq-shotcrete-plain-axial-capacity}

y se exige

$$
U_c=
\frac{M_u}{\phi M_{n,c}}+
\frac{P_u}{\phi P_n}
\le1.
$$ {#eq-shotcrete-plain-compression-check}

Estas expresiones corresponden a ACI CODE-318-25, Ecuación 14.5.3.1 y Tabla
14.5.4.1(b) [@ACI31825]. Si $\ell_c$ no está documentada, la comprobación de
la cara comprimida queda indeterminada; no se adopta $\ell_c=0$.

## Corte unidireccional

La resistencia nominal y la utilización a corte son

$$
V_n=0.11\lambda\sqrt{f'_c}\,b h_d,
\qquad
U_v=\frac{V_u}{\phi V_n}\le1,
$$ {#eq-shotcrete-plain-shear-check}

conforme a ACI CODE-318-25, Tabla 14.5.5.1(a) [@ACI31825]. El signo de
$Q_\theta$ se conserva en los resultados para identificar el sentido de la
acción, aunque la comprobación utiliza su valor absoluto.

## Concurrencia de acciones y comprobaciones complementarias

Para cada proyección y combinación, el estado resistente está gobernado por el
mayor valor calculado entre $U_t$, $U_c$ y $U_v$. La conclusión se obtiene de
filas concurrentes; no se combinan el máximo de $N_\theta$, el máximo de
$M_\theta$ y el máximo de $Q_\theta$ ubicados en posiciones diferentes.

El cumplimiento integral requiere además confirmar que la tipología admite la
rama de hormigón simple, que la categoría sísmica es compatible y que las
juntas y aberturas satisfacen las disposiciones aplicables. La estabilidad
global, la durabilidad y el servicio se informan como comprobaciones distintas.
Una utilización superior a la unidad gobierna la comprobación seccional. Las
condiciones de tipología, estabilidad, durabilidad y servicio conservan sus
propios criterios de aceptación.

## Hormigón armado

Para una sección armada se adopta una distribución plana de deformaciones

$$
\varepsilon(y)=\varepsilon_0+\kappa(y-y_0),
$$ {#eq-shotcrete-strain-field}

y las resultantes nominales se obtienen por compatibilidad y equilibrio:

$$
P_n=
\int_{A_c}\sigma_c[\varepsilon(y)]\,\mathrm dA
+\sum_jA_{s,j}\sigma_s[\varepsilon(y_j)],
$$

$$
M_n=
\int_{A_c}\sigma_c[\varepsilon(y)](y-y_0)\,\mathrm dA
+\sum_jA_{s,j}\sigma_s[\varepsilon(y_j)](y_j-y_0).
$$ {#eq-shotcrete-reinforced-equilibrium}

Estas ecuaciones definen el núcleo mecánico; los límites de deformación, los
factores de reducción y el equilibrio local se toman de ACI CODE-318-25,
Tabla 21.2.2 y artículos 21.2.2.3, 22.2.1 y 22.2.2 [@ACI31825]. La
comprobación de hormigón armado no reutiliza las ecuaciones del Capítulo 14
para hormigón simple.

Para acero Grade 60, la cuantía mínima total de una cáscara en cada dirección
se expresa, conforme a ACI 318.2-14, 6.1.3, como

$$
A_{s,\min}=0.0018\,b\,h.
$$ {#eq-shotcrete-reinforced-minimum}

ACI 318.2-14, 6.1.9, exige considerar ambas superficies cuando el análisis
demanda armadura sólo en una cara [@ACI318214]. Una distribución igual entre
caras puede adoptarse para construir un primer dominio simétrico, pero no
reemplaza la definición del detalle, del recubrimiento ni de la separación.
La comprobación de cuantía mínima se informa separadamente del dominio
$P$--$M$ y no determina qué curva satisface la demanda.

Cuando se especifica una misma malla en ambas caras y direcciones, el área de
acero por cara y por dirección se obtiene directamente de su diámetro
$\phi_b$ y separación $s_b$:

$$
A_{s,f}=\frac{\pi\phi_b^2}{4}\frac{1000}{s_b}.
$$ {#eq-shotcrete-reinforced-mesh-area}

Si $r_c$ es la relación entre el recubrimiento libre y el espesor de la
sección, la distancia desde el plano medio hasta el centroide de cada capa es

$$
z_s=\frac{h}{2}-r_c h-\frac{\phi_b}{2}.
$$ {#eq-shotcrete-reinforced-layer-coordinate}

Las capas circunferenciales, ubicadas en $z=\pm z_s$, intervienen en el
equilibrio local $P$--$M$. La malla ortogonal se materializa con la misma área
para comprobar la cuantía mínima por dirección, pero no se incorpora como una
resistencia longitudinal ficticia en el problema plano. Esta parametrización
no constituye una comprobación de fisuración, desarrollo, empalmes ni
separación reglamentaria.

## Sección compuesta con la chapa existente

La sección compuesta incorpora el hormigón, una malla circunferencial interior
y la chapa corrugada existente como capa exterior de acero. Se adopta
compatibilidad total de deformaciones entre los componentes. El centroide
elástico, la rigidez extensional y la rigidez flexional se calculan con las
áreas, módulos y posiciones de las tres partes; las acciones se obtienen
nuevamente con esas rigideces.

El dominio resistente emplea las mismas ecuaciones de compatibilidad y
equilibrio, incluyendo la contribución de la chapa en $P_n$ y $M_n$. La malla
interior y la chapa exterior forman una sección asimétrica y, por lo tanto, el
dominio no es simétrico respecto de $M=0$. La condición corresponde a acción
compuesta total durante el estado de carga analizado y requiere continuidad de
la transferencia de corte entre chapa y hormigón.

El dominio de diseño se obtiene multiplicando cada estado nominal por su
factor $\phi$. Para una demanda concurrente $(P_u,M_u)$, sea $\lambda_*>0$ el
multiplicador para el cual la semirrecta que parte del origen y pasa por la
demanda intersecta el dominio resistente:

$$
\left(\phi P_n,\phi M_n\right)
=\lambda_*\left(P_u,M_u\right),
\qquad
U_{NM}=\frac{1}{\lambda_*}\le1.
$$ {#eq-shotcrete-reinforced-radial-utilization}

La sección satisface la comprobación local cuando $U_{NM}\le1$ para todas las
filas concurrentes de posición, combinación y proyección. Los signos positivo y
negativo de $M_u$ se conservan para comprobar, respectivamente, las dos caras.
El corte, la acción longitudinal, la estabilidad y el detallado permanecen
comprobaciones independientes de este dominio local.
