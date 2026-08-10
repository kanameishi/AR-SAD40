# Resumen ejecutivo

Se dispone de un procedimiento no-FEM para transformar cargas perimetrales
declaradas en resultantes $N(\theta)$, $M(\theta)$ y $Q(\theta)$ de un anillo
circular. El solver canónico integra directamente las ecuaciones del anillo,
comprueba equilibrio global y calcula los extremos. Una solución modal de
Fourier se conserva como comparador independiente. El motor Monte Carlo recibe
realizaciones declaradas y no impone distribuciones de suelo.

La conclusión documental central es que las fuentes no entregan el mismo tipo
de dato:

- USACE 2020 proporciona para CMP un empuje escalar; su proyección uniforme
  sólo reproduce $N_0$;
- FHWA-RD-98-191 proporciona carga global y una amplitud de compactación por
  etapa; la función angular de la banda es una implementación derivada;
- Núñez 2000/2014 proporciona resultantes puntuales para túneles excavados;
  su aplicación a una tubería rellenada está fuera del dominio publicado;
- un campo $K_0$ puede proyectarse geométricamente sobre el círculo, pero esa
  tracción de campo libre no debe confundirse con el contacto final.

Para un estado efectivo constante al eje, con
$\Delta=\sigma'_v-\sigma'_h$, la rama de tracción completa da

$$
N=-Rp_0+\frac{R\Delta}{2}\cos2\theta,
\qquad
M=M_0+\frac{R^2\Delta}{4}\cos2\theta,
\qquad
Q=-\frac{R\Delta}{2}\sin2\theta.
$$

Estas expresiones muestran directamente cómo la tapada escala la demanda y
cómo $K_0\to1$ elimina la componente ovalizante. El documento desarrolla
también la rama sólo normal, las ecuaciones generales para cualquier carga
angular y las restricciones de los modos globales.

La implementación reproduce las tablas de Baker (1968), el ejemplo D4 de
USACE, la Tabla 5.5 de FHWA y dos ejemplos de Núñez (2000). Las copias fuente,
páginas y hashes están preservados. No se generó ningún PDF del informe.

La corrugación anular se incorpora antes de resolver mediante $A_p$, $I_p$,
$EA$, $EI$ y $\eta=I_p/(A_pR^2)$. El alcance termina antes de convertir los
resultantes en tensiones locales de la chapa o demandas de pernos.
