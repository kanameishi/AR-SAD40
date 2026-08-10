# Auditoría del aporte Python sobre cargas en revestimientos circulares

Fecha: 10 de agosto de 2026
Estado: revisión interna; no es un capítulo público.

## 1. Objeto y regla de aceptación

Se revisaron:

- `scripts/py/circular_tunnel_lining_loads.ipynb`;
- `scripts/py/structural_check_worksheet.md`;
- la formulación y las tablas del artículo de Núñez, Sfriso y Laiún (2014);
- las funciones canónicas de `scripts/R/ringLoads.R` y su suite de pruebas.

El notebook se trató como prosa y código no verificados. Un elemento se
rescata sólo cuando cumple simultáneamente estas condiciones:

1. puede localizarse en una fuente primaria disponible o derivarse de ella
   sin completar datos ausentes;
2. se reproduce de manera independiente con la implementación R;
3. conserva el dominio del método y no transforma un supuesto ilustrativo en
   dato, capacidad o distribución del proyecto.

La fuente primaria auditada fue
[`nunez_sfriso_laiun_2014_tunnel_support_loads.pdf`](sources/nunez_sfriso_laiun_2014_tunnel_support_loads.pdf),
en particular sus páginas PDF 5 a 7. El artículo corresponde a sostenimientos
de túneles excavados; no establece una metodología de diseño para una tubería
de chapa corrugada colocada y rellenada.

## 2. Elementos rescatados

### 2.1 Resultantes puntuales de Núñez 2014

Las Ecs. 22 a 25 del notebook coinciden con las ecuaciones publicadas para
$M_{max}$, $N_A$, $N_C$ y $N_I$, con compresión positiva y $H$ medido hasta el
eje del túnel. Esta rama ya existe en R como `nunez2014Resultants()`; el
notebook no agrega una formulación nueva.

Con las entradas declaradas por el notebook

$$
D=10\ \mathrm{m},\quad H=18\ \mathrm{m},\quad
\gamma=19\ \mathrm{kN/m^3},\quad q=20\ \mathrm{kPa},
$$

$$
K_0=0.60,\quad \eta=0.50,\quad a=0.00625,
$$

Python y R producen los mismos valores:

| Magnitud | R | Notebook | Unidad |
|---|---:|---:|---|
| $M_{max}$ | 2.810559 | 2.811 | kN m/m |
| $N_C$ | 687.834369 | 687.8 | kN/m |
| $N_A$ | 905.000000 | 905.0 | kN/m |
| $N_I$ | 1117.668737 | 1117.7 | kN/m |

Este cálculo se conserva como **control cruzado de una misma ecuación**. No es
un benchmark externo ni reproduce el caso 1 de la Tabla 3, porque el artículo
no publica todos los parámetros adoptados por el notebook.

### 2.2 Forma general del cociente de interacción

La expresión programada

$$
a=\frac{192EI}{\chi E_{s0}D^3}
$$

es algebraicamente compatible con

$$
a=\frac{16}{\chi}\frac{E_{r0}}{E_{s0}}
\left(\frac{e}{D}\right)^3
$$

cuando $EI=E_{r0}e^3/12$. La implementación R reproduce $a=0.00625$ para el
ejemplo. Se rescata la equivalencia algebraica; no se rescata la explicación
del notebook según la cual se habría eliminado una corrección de Poisson.
La página PDF 5 del artículo contiene una inconsistencia interna: define
módulos restringidos en la Ec. 14 y vuelve a introducir un cociente de
Poisson en la Ec. 20. La metodología conserva una única corrección y documenta
la diferencia entre versiones.

### 2.3 Datos publicados y formato de cálculo manual

La transcripción de las Tablas 2 y 3 coincide con el artículo. La copia
canónica ya está preservada en
[`nunez-2014-analytical-fem.csv`](benchmarks/nunez-2014-analytical-fem.csv),
donde se declara que los siete casos no son reproducibles de manera
independiente con las entradas publicadas.

La secuencia del worksheet —entradas, unidades, ecuación, sustitución y
resultado— es útil como formato pedagógico. Cuando se prepare el caso numérico
del informe, esa estructura se regenerará desde R y desde datos aprobados; no
se copiarán los números del worksheet como autoridad independiente.

## 3. Elementos no aceptados

| Elemento del aporte | Evidencia observada | Decisión |
|---|---|---|
| `u_h()` con denominador 6 | La Ec. 15 imprime 6, mientras la Ec. 18 usa 12 para la compatibilidad radial | no integrar el helper; conservar la discrepancia documental |
| automatización de $\eta(d)$ | La Ec. 8 pertenece al avance del frente NATM y su convención de distancia no es necesaria para la tubería rellenada | no usar en el flujo principal |
| $M_I=0$ en la verificación de capacidad | Las Ecs. 22 a 25 no publican ese valor; el notebook lo introduce sin derivación | descartar |
| propiedades sinusoidales $A,I,W$ de la chapa | No se cita una fuente ni se representan rigideces ortótropas, orientación de corruga o juntas | diferir hasta `methodology.orthotropy.es.md` y usar propiedades verificadas |
| adopción de $\chi=2$ para chapa corrugada | El artículo recomienda ese valor para revestimiento permanente/contacto rugoso en su dominio NATM | no trasladar a una tubería rellenada |
| tensiones y utilización de la chapa | Dependen de la sección aproximada y de $F_y=230$ MPa ilustrativo | no publicar |
| capacidad de costura de 1750 kN/m | El propio notebook la declara placeholder y no aporta geometría, ensayo ni norma aplicable | no publicar |
| diagrama $N$-$M$ romboidal | Sus cuatro vértices son ilustrativos | diferir hasta contar con una capacidad trazable |
| distribuciones probabilísticas | Son elecciones ilustrativas; además se aleatorizan dimensiones declaradas conocidas y se supone independencia | no incorporar a Monte Carlo |
| resultados FORM, $\beta$, $P_f$ e importancias | Dependen de distribuciones y capacidades ficticias y linealizan una función de falla, operación ajena al método adoptado | descartar; FORM/FOSM no forman parte de la metodología ni del backlog |
| correlaciones y ranking Spearman | Son diagnósticos de sensibilidad, no envolventes de esfuerzo, y dependen de los priors inventados | no integrar en el alcance actual |
| promedio de importancia FORM y Spearman | Combina métricas distintas mediante una normalización ad hoc sin fundamento citado | descartar |
| inferencia de $\gamma=13.78\ \mathrm{kN/m^3}$ | Es un cálculo inverso bajo la Ec. 23, no un valor publicado para el caso | conservar, como máximo, como diagnóstico interno; no como dato de fuente |
| afirmación de diferencia de “dos órdenes” de $EI$ | Los valores impresos dan una razón aproximada de 16.4 | corregir si el ejemplo se reutiliza |

La hoja `structural_check_worksheet.md` declara que sus valores fueron copiados
del notebook; por definición no constituye una segunda verificación. Además,
el notebook guardado está ejecutado con `LINING_TYPE = "concrete"`; los
resultados probabilísticos de acero citados en el worksheet no quedan
reproducibles desde el estado de salida preservado.

## 4. Integración autorizada

- R permanece como única implementación científica canónica.
- El notebook y el worksheet se preservan sin borrarlos, como aporte bruto en
  evaluación; no se incorporan al grafo de render ni a la API de producción.
- El caso determinístico puede convertirse después en un fixture de regresión
  cruzada, rotulado como control interno y no como benchmark independiente.
- El futuro ejemplo público seguirá el formato de cálculo manual, pero será
  producido por R y separará claramente datos publicados, valores derivados y
  supuestos del analista.
- La propagación de incertidumbre se realizará exclusivamente mediante Monte
  Carlo para obtener cuantiles angulares, cuantiles de extremos y envolventes
  entre escenarios. FORM, FOSM y la aproximación lineal de funciones de falla
  quedan descartados. Los rankings de sensibilidad tampoco forman parte del
  alcance actual.

## 5. Consecuencia para el primer render

El aporte Python no bloquea ni habilita el primer render. No aporta una rama
nueva de cargas para el liner rellenado. El render metodológico inicial debe
mostrar la solución isotrópica canónica en R, los comparadores de fuente y un
caso determinístico reproducible. Las extensiones de chapa, capacidad, pernos
permanecen fuera de esa primera revisión; FORM/FOSM permanecen fuera de toda
la metodología.
