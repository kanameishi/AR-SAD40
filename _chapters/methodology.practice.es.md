# Metodología preliminar de cálculo no-FEM

## Resultado de esta etapa

Se implementó un procedimiento para analizar un anillo circular lineal bajo
tracciones perimetrales prescritas. Para una corrugación anular, la sección se
representa mediante $A_p$ e $I_p$ antes de resolver. El procedimiento no
requiere un modelo de elementos finitos y produce

$$
p_n(\theta),\ p_t(\theta)
\quad\longrightarrow\quad
N(\theta),\ M(\theta),\ Q(\theta),
$$

sus extremos y sus envolventes probabilísticas. La metodología mantiene la
geometría y las propiedades como entradas; la aplicación numérica identifica
separadamente los datos preliminares y los controles que no son demanda del
proyecto.

El resultado importante no es una única fórmula de “presión de suelo”. Es una arquitectura en dos operaciones:

1. una fuente de cargas produce una magnitud escalar, una carga global, unas tracciones angulares o resultantes puntuales, según lo que efectivamente publique;
2. sólo las fuentes que definen $p_n(\theta),p_t(\theta)$ pasan por el operador común del anillo.

```text
USACE ─────► empuje escalar ──────────────► N0 equivalente únicamente
Núñez ─────► resultantes puntuales ───────► comparación directa, sin solver

campo K0 ──► tensor de campo libre ───────► pn(θ), pt(θ) ─┐
FHWA etapa ► presión de compactación ─────► pn(θ), pt(θ) ─┼► solver directo ► N,M,Q
Núñez 2014 ► proyección simétrica derivada ► pn(θ), pt(θ) ─┘
                                                         └► Fourier: comparación modal
```

La tabla resume qué admite cada rama.

| Rama | Salida documentada por la fuente | Paso por el solver angular | Uso admisible |
|---|---|---:|---|
| USACE EM 1110-2-2902 (2020), CMP | presión vertical en clave y empuje anular escalar | sólo una equivalencia $n=0$ | $N_0$; no valida $M,Q$ |
| FHWA-RD-98-191, prisma/VAF | carga global y empuje en springline | no, sin forma angular adicional | comparación de carga global |
| FHWA-RD-98-191, compactación | amplitud de presión nodal horizontal por etapa | sí, con banda de etapa explícita | envolvente durante construcción |
| Campo geostático $K_0$ | tensor efectivo supuesto a una profundidad de referencia | sí | escenario de tracción prescrita |
| Núñez (2000/2014) | $M$ y $N$ en puntos particulares | no, en el adaptador directo | comparador de túnel excavado |
| Proyección simétrica de Núñez 2014 | derivación $n=0+n=2$, no curva publicada | sí | comparación controlada, fuera de dominio |

## Qué no está resuelto por una fórmula de fuente

- La presión de contacto real de un liner rellenado depende de la interacción suelo–estructura y de la secuencia constructiva.
- USACE y FHWA no publican, en los documentos auditados, una función final universal $p_n(\theta),p_t(\theta)$ para chapa metálica corrugada.
- La Ec. 5.1 de FHWA representa la acción de compactación durante una etapa. La fracción residual que permanece al terminar el relleno es `UNKNOWN`.
- Núñez estudia túneles excavados con shotcrete. Su aplicación a un conducto instalado y rellenado está fuera del dominio publicado.
- Las distribuciones probabilísticas del suelo y los pesos entre modelos son `UNKNOWN` hasta que sean declarados con datos o juicio experto trazable.

Por estas razones, el producto informa envolventes por rama. No promedia métodos incompatibles ni completa datos ausentes.

## Qué aporta cada familia de métodos

USACE y las ecuaciones globales de FHWA son reglas de carga/diseño: producen
presión en clave, carga de prisma o empuje escalar, pero no una solución
angular completa. La Ec. 5.1 de FHWA sí aporta la amplitud de una acción de
compactación por etapa; su traducción al anillo se rotula como derivada.

El solver directo integra el equilibrio y la compatibilidad del anillo para
una tracción angular prescrita. Fourier descompone esa misma carga y verifica
la respuesta por superposición modal. Ninguno de los dos calcula por sí solo
cómo el liner altera el campo de tensiones del suelo.

Schwartz–Einstein (1980) pertenece a otra familia: suelo elástico infinito,
anillo elástico y contacto acoplado mediante las rigideces relativas

$$
C^*=\frac{ER(1-\nu_s^2)}{E_sA_s(1-\nu^2)},
\qquad
F^*=\frac{ER^3(1-\nu_s^2)}{E_sI_s(1-\nu^2)}.
$$

El informe distingue descarga por excavación y carga exterior posterior; esta
última es la rama conceptualmente comparable con un conducto rellenado. Sus
soluciones `full slip` y `no slip` obtienen contacto y resultantes
simultáneamente, pero suponen tensiones remotas uniformes, medio homogéneo e
influencia despreciable de la superficie; el propio informe indica, en
general, profundidades mayores que dos diámetros. No sustituye una formulación
de relleno somero o compactación por etapas.

Núñez incorpora relajación e interacción mediante un cociente de rigidez y
publica resultantes puntuales para túneles excavados. No es una ley de empuje
para tuberías colocadas en zanja.

CANDE es un programa especializado de elementos finitos bidimensionales para
conductos enterrados, con modelos de suelo, interfaz y construcción
incremental. No es una biblioteca R/Python ni una ecuación cerrada. En esta
metodología queda como contraste externo; no se necesita para ejecutar el
motor no-FEM.

## Convención única

La sección transversal usa $x$ positivo a la derecha y $z$ positivo hacia abajo. El ángulo comienza en clave y aumenta en sentido horario:

$$
\mathbf r(\theta)=R
\begin{bmatrix}
\sin\theta\\-\cos\theta
\end{bmatrix},
\qquad
\mathbf e_n=
\begin{bmatrix}
\sin\theta\\-\cos\theta
\end{bmatrix},
\qquad
\mathbf e_t=
\begin{bmatrix}
\cos\theta\\\sin\theta
\end{bmatrix}.
$$

Las variables del operador son:

- $P_r>0$: carga radial hacia afuera;
- $P_t>0$: carga tangencial según $+\theta$;
- una presión exterior $p_n>0$ se introduce como $P_r=-p_n$;
- $N>0$: tracción circunferencial; la compresión es negativa;
- $Q$ y $M$: signos definidos por las ecuaciones de equilibrio del capítulo siguiente.

Para una presión en unidades $F/L^2$ y un radio en $L$, los resultados por unidad de longitud longitudinal son $N,Q\,[F/L]$ y $M\,[F]$, equivalente a momento por unidad de longitud.

## Estado de verificación

El código supera controles independientes de:

- presión radial uniforme;
- las tres ecuaciones diferenciales de equilibrio para ambas fases de Fourier;
- modos especiales $n=0$ y $n=1$;
- transformación de un campo biaxial constante;
- Tablas XII–XIV de Baker (1968);
- ejemplo D4 de USACE (2020);
- Tabla 5.5 de FHWA-RD-98-191;
- ejemplos de Núñez (2000);
- muestreo reproducible y cuantiles de las envolventes Monte Carlo.

La rigidez plana de la chapa corrugada ya se incorpora mediante $A_p$ e $I_p$.
La recuperación de tensiones locales, las capacidades y los pernos se
mantienen fuera de esta fase.
