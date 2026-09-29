
La condición sísmica del sitio se caracteriza inicialmente mediante $V_{S30}$, la velocidad de onda de corte equivalente en los 30 m superiores del perfil. El perfil de $V_S$ se obtiene mediante investigaciones geofísicas apropiadas para las condiciones del proyecto, entre ellas registros de pozo, ensayos de penetración con cono sísmico y métodos de ondas superficiales. La definición de $V_{S30}$ conserva el tiempo de viaje de la onda de corte a través del perfil estratificado:

$$
V_{S30}=\frac{30}{\displaystyle\sum_{i=1}^{N}\frac{H_i}{V_{S,i}}},
$${#eq-class-vs30}

donde $H_i$ y $V_{S,i}$ son, respectivamente, el espesor en metros y la velocidad de onda de corte de la capa $i$ comprendida dentro de los primeros 30 m, y $N$ es el número de capas del perfil en ese espesor. La expresión corresponde a un promedio según el tiempo de viaje y proporciona la velocidad uniforme que reproduce el tiempo de propagación del perfil real.

$V_{S30}$ constituye el predictor de condición de sitio empleado por los modelos de predicción de movimiento sísmico y por las relaciones de amplificación de esta evaluación [@Borcherdt2012]. También identifica la condición de referencia desde la que se interpretan los espectros de amenaza y las transformaciones roca--sitio. En los análisis específicos, el cálculo utiliza además las propiedades que correspondan al modelo de respuesta; la clasificación inicial no reemplaza esa caracterización.

El parámetro resume la rigidez media somera, pero no describe por sí solo los contrastes estratigráficos, la profundidad al basamento, los efectos de cuenca ni los períodos de resonancia. Estas limitaciones se consideran al definir el alcance de una evaluación específica del sitio y al interpretar la demanda espectral resultante.


Las disposiciones NEHRP clasifican los sitios en las clases A a E y reservan la Clase F para condiciones que requieren una evaluación específica [@BSSC2015]. Los intervalos de referencia basados en $V_{S30}$ son los siguientes:

* **Clase A:** roca dura, con $V_{S30}>1500$ m/s.
* **Clase B:** roca, con $V_{S30}$ entre 760 y 1500 m/s.
* **Clase C:** suelo muy denso o roca blanda, con $V_{S30}$ entre 360 y 760 m/s.
* **Clase D:** suelo rígido, con $V_{S30}$ entre 180 y 360 m/s.
* **Clase E:** suelo blando, con $V_{S30}<180$ m/s.
* **Clase F:** perfiles que requieren evaluación específica, entre ellos suelos susceptibles a licuación o colapso, turbas, arcillas orgánicas, arcillas de alta plasticidad de gran espesor y arcillas muy blandas.

Cuando se dispone de mediciones de velocidad, $V_{S30}$ constituye el criterio principal. Las disposiciones también contemplan criterios basados en resistencia a la penetración y resistencia al corte no drenada cuando la información geofísica no es suficiente. La Clase F no se asigna mediante un intervalo único de $V_{S30}$ y conduce a un análisis de respuesta de sitio en lugar de la aplicación directa de factores genéricos.


ASCE/SEI 7-22 actualiza la discretización de las condiciones de sitio y distingue las clases A, B, BC, C, CD, D, DE y E mediante intervalos de velocidad, desde roca competente hasta suelos blandos [@ASCE722]. La Clase F identifica condiciones que requieren procedimientos específicos de respuesta de sitio y no se asigna exclusivamente mediante un intervalo de $V_{S30}$.

Los intervalos y descripciones de la clasificación adoptada se presentan a continuación. Los valores de $V_{S30}$ evaluados representan las condiciones de sitio para las que se determina la demanda. La clase de una ubicación particular se asigna a partir del perfil geotécnico aplicable y de las condiciones adicionales definidas por la norma.

Las condiciones de sitio evaluadas descienden hasta $V_{S30}=180$ m/s, comprendida en la clase DE; la evaluación no alcanza la clase E. Las condiciones más blandas quedan reservadas a procedimientos específicos de respuesta de sitio: la Clase F los requiere conforme a ASCE/SEI 7-22 [@ASCE722, secs. 11.4.7, 21.1], y la Clase E puede asignarse además por el criterio de arcilla blanda de la Sección 20.2.2, independientemente de $V_{S30}$. El modelo ergódico de amplificación declara su aplicabilidad para $V_{S30}$ entre 200 y 3000 m/s, y sus autores recomiendan un análisis específico de respuesta de sitio para condiciones con $V_{S30}$ menor que 200 m/s [@Stewart2020; @Hashash2020]. Para perfiles más blandos que los evaluados, los espectros y los parámetros de este reporte no son aplicables sin una evaluación específica de respuesta de sitio.

```{r}
#| include: false
CAP <- "Clasificación sísmica del sitio. Fuente: ASCE/SEI 7-22 [@ASCE722]."
```

{{< include /_tbl/ASCE722.ES.qmd >}}
