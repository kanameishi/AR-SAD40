# Bases y datos de entrada {#sec-calculation-basis}

## Alcance mecánico

Se considera una franja de revestimiento de longitud unitaria en la dirección
del eje. La respuesta se resuelve en la sección transversal, sin variación
longitudinal de las acciones. La formulación admite distribuciones generales de
acción radial $P_r(\theta)$ y tangencial $P_t(\theta)$ siempre que el estado de
carga incluya todas las fuerzas y reacciones necesarias para satisfacer el
equilibrio global.

El procedimiento entrega resultantes por unidad de longitud del eje. Estas
magnitudes constituyen la entrada para recuperar las tensiones locales de la
corrugación y evaluar las uniones mediante relaciones resistentes específicas.

## Coordenada angular, signos y unidades

El ángulo $\theta$ se mide desde la clave y aumenta en sentido horario. Por lo
tanto, $\theta=\pi/2$ y $3\pi/2$ corresponden a los hastiales y $\theta=\pi$ a
la solera. La dirección radial positiva apunta hacia el exterior y la dirección
tangencial positiva coincide con $\theta$ creciente.

Sea $\xi$ la coordenada local del perfil, positiva hacia la fibra exterior.
Las resultantes se definen sobre la cara positiva de la sección mediante

$$
N_\theta=\int_A\sigma_\theta\,dA,
\qquad
M_\theta=\int_A\sigma_\theta\xi\,dA.
$$ {#eq-calculation-resultant-signs}

Se adopta $N_\theta>0$ para tracción, $M_\theta>0$ cuando produce tracción en
la fibra exterior y $Q_\theta>0$ cuando actúa hacia el centro sobre la cara
positiva. Con $P_r$ y $P_t$ en kPa y $R$ en m, $N_\theta$ y $Q_\theta$ se
expresan en kN/m y $M_\theta$ en kN·m/m.

## Datos de cálculo

Los datos necesarios se agrupan en: geometría resistente; propiedades
seccionales del perfil corrugado; estratigrafía y propiedades del relleno;
agua exterior e interior; estado de tensiones laterales; sobrecargas; equipos y
tongadas de compactación; secuencia constructiva; y condición de contacto entre
el relleno y el revestimiento. Cada tabla indica si el valor procede de un dato
suministrado, de una hipótesis del escenario o de una operación de cálculo.
