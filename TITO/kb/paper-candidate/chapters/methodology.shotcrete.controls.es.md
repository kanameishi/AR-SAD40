# Apéndice B. Controles y datos requeridos {#sec-methodology-shotcrete-controls .unnumbered}

## B.1 Controles del núcleo seccional {.unnumbered}

Los siguientes controles son independientes de los coeficientes resistentes
de una norma:

- equilibrio de fuerzas y momentos para cada estado de deformación;
- simetría del dominio respecto de $M=0$ cuando la geometría, los materiales y
  las armaduras son simétricos;
- inversión coherente del signo de $M$ al intercambiar las caras interior y
  exterior;
- convergencia respecto de la discretización del contorno de hormigón;
- correspondencia de unidades entre kN/m, kN·m/m y N--mm; y
- reproducción de estados elementales de fuerza normal pura y flexión pura
  cuando el adaptador normativo los habilite.

Estos controles verifican la implementación de compatibilidad y equilibrio;
no demuestran conformidad con ACI.

## B.2 Control de unidades y signos {.unnumbered}

Para una franja de $b=1.000$ m, el estado

$$
N_\theta=-100\ \mathrm{kN/m},
\qquad
M_\theta=25\ \mathrm{kN\,m/m}
$$

se transforma mediante las
@eq-shotcrete-strip-resultants--@eq-shotcrete-unit-conversion en

$$
P_u=100\,000\ \mathrm N,
\qquad
M_u=25\,000\,000\ \mathrm{N\,mm}.
$$

La compresión circunferencial produce $P_u>0$ y el momento positivo comprime
la cara exterior. Este control no asigna propiedades de material ni calcula
capacidad.

## B.3 Puerta normativa ACI {.unnumbered}

Antes de habilitar el cálculo resistente debe existir una tabla auditable con,
como mínimo:

| Componente | Evidencia requerida |
|---|---|
| clasificación estructural | definición y artículo de ACI CODE-318.2-25 o ACI CODE-318-25 que gobierna el revestimiento |
| leyes constitutivas | edición, artículo, sistema de unidades y límites de deformación |
| dominio axial--flexional | factores de reducción, límites axiales y reglas aplicables a cada estado |
| armadura mínima | artículos de ACI CODE-318.2-25 y ACI CODE-318-25, incluidos requisitos por dirección y excepciones |
| estructura existente | artículos aplicables de ACI CODE-562-25 para geometría, propiedades y factores de evaluación |
| shotcrete | alcance de ACI SPEC-506.2-13(18) para materiales, ejecución, ensayos y aceptación |

El acceso oficial disponible confirma el alcance y el índice de esos
documentos, pero no proporciona el articulado completo necesario para poblar
la tabla. Los coeficientes de la formulación CIRSOC anterior no se trasladan a
ACI por analogía.

## B.4 Datos necesarios para la aplicación {.unnumbered}

| Grupo | Datos requeridos |
|---|---|
| base normativa | autoridad, adopción, ACI CODE-318.2-25, ACI CODE-318-25 y ACI CODE-562-25 aplicables, sistema SI y fecha de comprobación de errata |
| sistema resistente | revestimiento autónomo o acción conjunta; secuencia y transferencia de cargas |
| demanda | sección, combinación, etapa, ancho de franja, $N_\theta$ y $M_\theta$ factorizados, signos y unidades |
| geometría | espesor resistente, contorno efectivo, caras, defectos, juntas y clasificación como cáscara u otro elemento |
| hormigón | resistencia de diseño aprobada, ensayos, población, localización y procedimiento de evaluación conforme a ACI 562 |
| armaduras | capas, coordenadas, áreas netas, recubrimientos, diámetros, separaciones, $f_y$, $E_s$, corrosión, mínimos y detallado |
| fibras | tipo, dosificación, orientación, ensayo, resistencias residuales y disposición normativa, si se pretende considerar su contribución |
| verificaciones separadas | estabilidad, corte, servicio, estanqueidad, durabilidad, juntas, anclajes y ejecución conforme a ACI 506.2 |

Mientras falten la clasificación, el articulado vigente o los datos
resistentes, la salida admisible es `sin evaluar`. No se publican capacidad,
utilización ni reserva con valores nominales supuestos.
