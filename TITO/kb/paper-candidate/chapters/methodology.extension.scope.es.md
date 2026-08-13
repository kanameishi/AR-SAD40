# Objeto y alcance de la ampliación metodológica

## Finalidad

Esta ampliación desarrolla el estado lateral efectivo del relleno, la
participación de la componente tangencial proyectada y dos alternativas
estructurales diferenciadas:

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

1. obtener $K_0$ desde las variables primitivas y la trayectoria tensional que
   correspondan al relleno;
2. calcular $\sigma'_h=K_0\sigma'_v$ y mantener separada cualquier tensión
   horizontal residual atribuida a la construcción;
3. proyectar el estado tensional sobre el contorno y definir la participación
   de la componente tangencial mediante el multiplicador $\alpha$;
4. determinar $N_\theta$, $M_\theta$ y $Q_\theta$ con las rigideces de la
   alternativa estructural analizada;
5. para la chapa, transformar las mediciones de espesor en propiedades netas
   mediante una regla espacial explícita y recuperar la tensión normal
   circunferencial cuando la geometría y la curvatura permitan emplear una
   distribución lineal de deformaciones; y
6. para el hormigón proyectado, definir la sección resistente existente,
   clasificarla reglamentariamente y comprobar flexocompresión y corte con las
   combinaciones de acciones que correspondan.

Cada operación conserva sus variables, hipótesis y controles. $K_0$ no se
muestrea de manera independiente de las propiedades que lo determinan; una
tensión residual de compactación no se incorpora dos veces; $\alpha$ no se
interpreta como coeficiente de fricción; el espesor medido de la chapa no
recibe una segunda deducción por la corrosión histórica ya observada; y la
resistencia del hormigón existente no se sustituye por una resistencia mínima
de producción.

## Productos y límites

Para la chapa, la metodología permite obtener acciones perimetrales,
resultantes circunferenciales, propiedades netas y una demanda elástica normal.
No define, por sí sola, la distribución local de tensión cortante en la
corrugación, la tensión longitudinal, la resistencia de costuras o pernos, el
pandeo de ligamentos remanentes ni la capacidad de una chapa perforada.

Para el hormigón proyectado, la metodología proporciona una formulación
seccional de flexocompresión y corte. No resuelve la estabilidad global, los
efectos de segundo orden, la fisuración y estanqueidad en servicio, la
durabilidad, las juntas, los anclajes ni la transferencia de acciones con la
chapa. Esas comprobaciones requieren estados y datos propios.

La incertidumbre se propagará mediante simulación de Monte Carlo una vez
aprobadas las variables primitivas, sus distribuciones marginales y sus
dependencias. Mientras esos elementos permanezcan sin caracterizar, las
formulaciones geotécnicas, los estados de interacción, las alternativas de
reducción del espesor y las propiedades del hormigón se tratan mediante
escenarios determinísticos separados.
