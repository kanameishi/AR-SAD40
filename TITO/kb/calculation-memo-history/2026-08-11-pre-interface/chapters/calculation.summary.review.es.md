# Resumen ejecutivo {.unnumbered}

Esta memoria establece el procedimiento para determinar las acciones del
relleno sobre un revestimiento circular y calcular, en su sección transversal,
la fuerza normal circunferencial $N_\theta(\theta)$, el momento flector
circunferencial $M_\theta(\theta)$ y la fuerza cortante circunferencial
$Q_\theta(\theta)$. El cálculo se formula para una sección uniforme, elástica
lineal, sometida a acciones perimetrales normales y tangenciales prescritas. El
perfil corrugado se incorpora mediante sus rigideces extensional y flexional en
la dirección circunferencial.

La secuencia comprende: determinación de tensiones verticales efectivas y
presiones de agua; definición de alternativas para el empuje lateral y la
compactación; transformación del estado tensional en acciones perimetrales;
control de equilibrio global; integración de las ecuaciones de equilibrio y
compatibilidad; localización de extremos; y propagación de incertidumbres por
simulación de Monte Carlo. Las formulaciones de USACE y FHWA se emplean para
contrastar, respectivamente, la componente uniforme de fuerza normal y una
acción temporal de compactación [@USACE2020; @McGrathEtAl1999].

La aplicación numérica utiliza un diámetro interior nominal de $2.63$ m y un
perfil corrugado nominal de $76\times25\times3$ mm. Como la categoría del
espesor, el radio centroidal y las propiedades del relleno no están
confirmados, se adopta un escenario analítico: $R=1.315$ m,
$\sigma'_{v,A}=100$ kPa, $K_0=0.50$ y $\Delta u_A=0$. Para la proyección
completa del estado biaxial se obtiene

$$
-131.5\le N_\theta\le-65.8\ \mathrm{kN/m},\qquad
-21.62\le M_\theta\le21.61\ \mathrm{kN\,m/m},
$$

con $|Q_\theta|_{\max}=32.88$ kN/m. Para la carga exclusivamente normal se
obtiene

$$
-109.6\le N_\theta\le-87.7\ \mathrm{kN/m},\qquad
-14.42\le M_\theta\le14.40\ \mathrm{kN\,m/m},
$$

con $|Q_\theta|_{\max}=21.92$ kN/m. Estos resultados son derivados para dos
prescripciones de carga y cuantifican la sensibilidad a la transferencia
tangencial; no caracterizan por sí solos la interfaz entre el relleno y la
chapa ni representan la demanda final del revestimiento existente.

La evaluación de proyecto requiere confirmar geometría resistente, propiedades
seccionales, estratigrafía, pesos unitarios, agua, historia tensional,
compactación, equipos y secuencia constructiva. También deben especificarse las
distribuciones conjuntas, dependencias, cuantiles de interés y tolerancias antes
de calcular envolventes probabilísticas. El alcance de esta memoria termina en
las tres resultantes seccionales, sus extremos y sus envolventes; la evaluación
de tensiones, resistencia de la chapa, juntas y pernos corresponde a una etapa
posterior.
