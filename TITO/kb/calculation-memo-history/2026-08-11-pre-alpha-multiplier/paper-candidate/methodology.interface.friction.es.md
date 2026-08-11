# Candidato académico: transferencia tangencial en la interfaz

## Función dentro de la metodología

La Fase 1 distinguió la proyección completa del estado biaxial y la carga
exclusivamente normal como dos estados de carga prescrita. También identificó
que una transferencia parcial requiere una relación constitutiva adicional.
Este candidato desarrolla esa relación sin modificar los archivos congelados
de Fase 1.

La formulación adopta un límite de Coulomb para la interfaz suelo--revestimiento.
FHWA expresa la resistencia tangencial disponible como la suma de una
contribución adhesiva y la fuerza normal efectiva multiplicada por
$\tan\delta$ [@VulovaLeshchinsky2003, sec. 3.2.3, ec. 3.3]. CANDE representa
el deslizamiento, la separación y la recuperación del contacto mediante
elementos de interfaz y limita la fuerza tangencial con la misma forma de
Coulomb [@CANDE2025Formulations, secs. 4.3.3--4.4].

## Proyección del estado tensional

Para tensiones principales efectivas vertical y horizontal,
$\sigma_v'$ y $\sigma_h'$, la presión normal efectiva y la tracción
tangencial disponible sobre una circunferencia son

$$
p_n'(\theta)=\sigma_v'\cos^2\theta+\sigma_h'\sin^2\theta,
$$

$$
p_t^*(\theta)=(\sigma_v'-\sigma_h')\sin\theta\cos\theta.
$$

La diferencia de presión intersticial se incorpora en la acción normal total,
pero no en la resistencia friccional efectiva. Se define

$$
\alpha_\delta=\tan\delta,
\qquad
\tau_{lim}(\theta)=c_a+\alpha_\delta\max[p_n'(\theta),0],
$$

$$
P_r(\theta)=-[p_n'(\theta)+\Delta u(\theta)],
$$

$$
P_t(\theta)=\operatorname{sgn}[p_t^*(\theta)]
\min\{|p_t^*(\theta)|,\tau_{lim}(\theta)\}.
$$

$\delta$ es el ángulo de fricción de interfaz, $\alpha_\delta$ es el
coeficiente correspondiente y $c_a$ es la adhesión. En esta formulación,
$\alpha_\delta$ no es un multiplicador arbitrario aplicado a
$p_t^*$: determina la capacidad tangencial. La tracción proyectada se
transfiere íntegramente mientras permanezca por debajo de esa capacidad y se
trunca cuando la alcanza.

## Estados límite y umbral del estado biaxial

Con $c_a=0$, $\alpha_\delta=0$ anula la transferencia tangencial. El estado
con proyección tangencial completa se recupera cuando

$$
\alpha_\delta\geq
\max_\theta\frac{|p_t^*(\theta)|}{p_n'(\theta)}.
$$

Para un estado biaxial uniforme con $\sigma_v'>0$ y $\sigma_h'>0$, el umbral
es

$$
\alpha_{\delta,req}
=\frac{|\sigma_v'-\sigma_h'|}{2\sqrt{\sigma_v'\sigma_h'}}.
$$

En el escenario $\sigma_v'=100$ kPa y $\sigma_h'=50$ kPa,
$\alpha_{\delta,req}=0.3536$. Por consiguiente, el extremo
$\alpha_\delta=1$ recupera la tracción tangencial completa, mientras que los
valores inferiores a 0.3536 producen sectores con deslizamiento limitado por
fricción.

## Incorporación en el análisis probabilístico

La variable primitiva es $\delta$ o, de manera equivalente,
$\alpha_\delta=\tan\delta$; ambas no se muestrean simultáneamente. Su
distribución y sus dependencias con el tipo, humedad, densidad y estado del
relleno requieren datos de caracterización. En ausencia de una probabilidad
sustentada, los intervalos de $\alpha_\delta$ se mantienen como escenarios y
no reciben pesos probabilísticos implícitos.

## Límites del candidato

La ley representa una capacidad tangencial local y no incorpora por sí sola
rigidez tangencial previa al deslizamiento, apertura de la interfaz,
recontacto, degradación cíclica ni variación espacial de $\delta$ o $c_a$.
Tampoco establece valores de proyecto para esos parámetros. La adopción de una
ley más completa requiere datos que permitan identificar sus parámetros y un
contraste independiente adecuado.
