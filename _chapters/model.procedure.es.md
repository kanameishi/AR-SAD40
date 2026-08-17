## Procedimiento de cálculo {#sec-calculation-procedure}

La aplicación determinística resuelve por integración directa la proyección
de un estado biaxial uniforme prescrito. Para cada revestimiento se aplica la
siguiente secuencia:

1. determinar la profundidad de referencia a partir de la altura de relleno
   sobre la clave y de la distancia hasta el centro geométrico de la sección;
2. calcular la tensión vertical efectiva del terreno en ausencia del
   revestimiento y seleccionar una
   única formulación de $K_0$ compatible con el estado tensional adoptado para
   obtener la tensión horizontal efectiva en la misma cota;
3. definir el radio hasta el baricentro de la pared, el módulo, el coeficiente
   de Poisson, el área y el momento de inercia propios del revestimiento;
4. proyectar $\sigma'_v$, $\sigma'_h$ y la presión hidráulica neta sobre el
   contorno para formar $P_r(\theta)$ y $P_t(\theta)$;
5. evaluar por separado $\alpha=1$ y $\alpha=0$;
6. comprobar el equilibrio global de las acciones prescritas;
7. obtener simultáneamente $N_\theta(\theta)$, $M_\theta(\theta)$ y
   $Q_\theta(\theta)$ por integración directa, periodicidad y compatibilidad;
8. contrastar la respuesta contra la solución cerrada, determinar los extremos
   y conservar Schwartz--Einstein sólo como comparación separada.

Las combinaciones resistentes que modifican las componentes vertical,
horizontal o hidráulica se resuelven nuevamente desde el paso 4. No
se mayoran extremos espaciales ni se combinan valores de posiciones angulares
distintas.

La chapa corrugada y las alternativas de hormigón comparten únicamente el
estado geotécnico del escenario. Cada aplicación conserva sus propias
rigideces, resultantes, extremos y comprobaciones
resistentes. Las ecuaciones se aplican por unidad de ancho axial proyectado y
con las convenciones de la @sec-calculation-basis.
