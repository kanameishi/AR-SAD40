# Objeto y alcance de la ampliación metodológica

## Finalidad

Esta ampliación organiza dos niveles de análisis de las acciones del relleno.
El primero corresponde a la evaluación reglamentaria de una estructura
enterrada de acero corrugado conforme a la rama que resulte aplicable de
AASHTO LRFD Bridge Design Specifications, sección 12. El segundo corresponde a
distribuciones perimetrales prescritas o
resultantes de un modelo de interacción suelo--conducto. Dentro de este segundo
nivel se conserva un estado biaxial uniforme como caso analítico de control; no
se lo identifica con la presión de contacto de una instalación real.

La clasificación del producto precede a toda comprobación resistente. El
índice oficial de la décima edición distingue los tubos, arcos y estructuras
de arco metálicos del artículo 12.7, las estructuras de gran luz de chapas
estructurales del artículo 12.8, la subrama de corrugación profunda del
artículo 12.8.9 y las chapas de acero para revestimiento de túneles del
artículo 12.13 [@AASHTO2024TOC]. Sólo la rama de
corrugación profunda identifica expresamente una comprobación combinada de
empuje y momento. Las ecuaciones, los factores y los límites de aplicación de
la edición vigente deben verificarse en el articulado adoptado antes de
calcular una utilización normativa. Las especificaciones AASHTO de
construcción constituyen una publicación separada y se aplican a la ejecución,
no como ecuaciones de resistencia [@AASHTOConstruction2017].

El procedimiento comprende además dos alternativas estructurales
diferenciadas:

- la evaluación elástica de la chapa corrugada existente, incluida la
  representación de su deterioro; y
- la comprobación seccional de un revestimiento autónomo de hormigón
  proyectado.

En ambas alternativas, las magnitudes estructurales fundamentales son
$N_\theta(\theta)$, $M_\theta(\theta)$ y $Q_\theta(\theta)$, definidas por
unidad de longitud del eje. Sus valores dependen de las rigideces del sistema
analizado. Por ello, las resultantes obtenidas para la chapa no se transfieren
al revestimiento de hormigón proyectado: para esta segunda alternativa debe
resolverse nuevamente la respuesta de la sección transversal con sus propias
propiedades.

La formulación de la chapa termina en la recuperación condicionada de la
tensión normal circunferencial. La formulación del hormigón proyectado termina
en las comprobaciones de flexocompresión y corte de una franja longitudinal,
siempre que se hayan establecido la base reglamentaria, la clasificación y las
propiedades resistentes. No se supone acción compuesta entre ambos materiales.

## Cadena de cálculo

El procedimiento común y sus dos alternativas se organizan mediante las
siguientes operaciones:

1. clasificar el producto estructural y establecer los artículos
   aplicables de AASHTO LRFD: 12.7, 12.8 o 12.13, y el subartículo 12.8.9
   cuando el producto corresponda a una estructura de corrugación profunda;
2. determinar las acciones y la solicitación seccional exigidas por la rama
   seleccionada, con las combinaciones y factores de la edición adoptada;
3. evaluar por separado la diferencia de presión de agua y las acciones
   temporales de colocación y compactación;
4. cuando se requieran distribuciones angulares de acción, definir un modelo
   de interacción suelo--conducto que represente rigidez, arqueo, contacto y
   secuencia constructiva; $K_0$ caracteriza el estado efectivo inicial del
   relleno, pero no sustituye ese modelo;
5. emplear la proyección biaxial con multiplicador $\alpha$ sólo como estado de
   carga analítico prescrito y como control de las ecuaciones;
6. determinar $N_\theta$, $M_\theta$ y $Q_\theta$ una vez cerradas las acciones
   perimetrales y con las rigideces de la alternativa estructural analizada;
7. para la chapa, transformar las mediciones de espesor en propiedades netas
   mediante una regla espacial explícita y recuperar la tensión normal
   circunferencial cuando la geometría y la curvatura permitan emplear una
   distribución lineal de deformaciones; y
8. para el hormigón proyectado, definir la sección resistente existente,
   clasificarla reglamentariamente y comprobar flexocompresión y corte con las
   combinaciones de acciones que correspondan.

Cada operación conserva sus variables, hipótesis y controles. En las ramas que
emplean un empuje circunferencial escalar, esa magnitud no proporciona por sí
misma $M_\theta$ ni $Q_\theta$; en la corrugación profunda, el momento forma
parte de la comprobación específica del producto. $K_0$ no se
muestrea de manera independiente de las propiedades que lo determinan; una
tensión residual de compactación no se incorpora dos veces; $\alpha$ no se
interpreta como coeficiente de fricción; el espesor medido de la chapa no
recibe una segunda deducción por la corrosión histórica ya observada; y la
resistencia del hormigón existente no se sustituye por una resistencia mínima
de producción.

## Productos y límites

Para la chapa, la metodología permite identificar la demanda reglamentaria que
corresponde al producto y, cuando se dispone de una distribución perimetral
cerrada, obtener resultantes circunferenciales, propiedades netas y una demanda
elástica normal.
No define, por sí sola, la distribución local de tensión cortante en la
corrugación, la tensión longitudinal, la resistencia de costuras o pernos, el
pandeo de ligamentos remanentes ni la capacidad de una chapa perforada.

Para el hormigón proyectado, la metodología proporciona una formulación
seccional de flexocompresión y corte. No resuelve la estabilidad global, los
efectos de segundo orden, la fisuración y estanqueidad en servicio, la
durabilidad, las juntas, los anclajes ni la transferencia de acciones con la
chapa. Esas comprobaciones requieren estados y datos propios.

La redistribución de presiones por interacción suelo--conducto permanece sin
resolver mientras no se seleccione y verifique una formulación aplicable a la
instalación. La incertidumbre se propagará mediante simulación de Monte Carlo una vez
aprobadas las variables primitivas, sus distribuciones marginales y sus
dependencias. Mientras esos elementos permanezcan sin caracterizar, las
formulaciones geotécnicas, los estados de interacción, las alternativas de
reducción del espesor y las propiedades del hormigón se tratan mediante
escenarios determinísticos separados.
