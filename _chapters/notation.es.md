Las tablas siguientes resumen la notación matemática del reporte, por bloque temático y en orden de aparición.

### Símbolos generales

| Símbolo | Definición |
|---|---|
| $T_n$ | Período del oscilador correspondiente a la ordenada espectral $n$; por convención, $T_n=0$ representa el PGA (s). |
| $T_R$ | Período de retorno, $T_R=1/\lambda_I(i^*)$ (años). |
| $V_{S30}$ | Velocidad de onda de corte promediada según el tiempo de viaje en los 30 m superiores; identifica una condición de sitio, no una clase de sitio (m/s). |
| $V_{\mathrm{ref}}$ | Velocidad de la condición de roca de referencia usada como entrada; en la formulación aparecen 760 y 3000 m/s (m/s). |

### Amenaza sísmica

| Símbolo | Definición |
|---|---|
| $M_w$ | Magnitud de momento. |
| $I$ | Medida de intensidad del movimiento. |
| $i^*$ | Nivel de intensidad cuya excedencia se evalúa. |
| $\lambda_I(i^*)$ | Tasa anual de excedencia total; por fuente, $\lambda_I(i^*)^{(s)}$ (1/año). |
| $\nu_0^{(s)}$ | Tasa anual de ocurrencia de la fuente $s$ por encima de $M_{\min}$ (1/año). |
| $M_{\min}$, $M_{\max}^{(s)}$ | Magnitud mínima del dominio y límite superior de la fuente. |
| $P_{1\text{yr}}$, $P_T$ | Probabilidad de al menos una excedencia en 1 año / en $T$ años. |
| $\hat\eta_I$ | Mediana de la intensidad del GMM en unidades lineales. |
| $\sigma_{\ln I}$ | Desviación estándar logarítmica total del GMM. |
| $\tau$, $\phi$ | Desviaciones inter-evento e intraevento; $\sigma_{\ln I}^2=\tau^2+\phi^2$. |
| $\varepsilon$, $\varepsilon^*$ | Residuo normal estándar del GMM; número de desviaciones en que $i^*$ excede la mediana. |
| $R_{JB}$, $R_{rup}$, $R_x$, $R_{hypo}$, $R_{epi}$; $z_{1.0}$, $z_{2.5}$, $z_{tor}$, $W$, $h$ | Métricas de distancia y parámetros geométricos requeridos por los GMM (km). |
| $\theta_{k,j,\ell}$ | Probabilidad condicional de que la excedencia provenga del intervalo magnitud–distancia–residuo $(k,j,\ell)$; su máximo define el escenario modal. |

### DSHA

| Símbolo | Definición |
|---|---|
| $e$ | Escenario determinístico dentro del conjunto analizado $\mathcal E$. |
| $\mu_{rg}$, $\sigma_{rg}$ | Media y desviación de $\ln I$ para la realización de ruptura $r$ y la rama GMM $g$; con $k=(r,g)$, también se escriben $\mu_k$, $\sigma_k$. |
| $w_k=v_g/N_R$ | Peso de la componente $k$: peso de la rama sobre el número de variantes de ruptura; $\sum_k w_k=1$. |
| $S_a^{(84\%)}(T_n)$ | Envolvente del percentil 84 sobre el conjunto de escenarios (g). |

### Mezcla GMM

| Símbolo | Definición |
|---|---|
| $w_k$ | Peso de la rama GMM $k$ en el conjunto; $\sum_k w_k=1$. |
| $\bar\lambda_I$, $\lambda_I^{(k)}$ | Curva media de amenaza y curva de la rama $k$ (1/año). |
| $\varepsilon_{ij}=\eta_i+\delta_{ij}$ | Partición de efectos mixtos del residuo total del registro $j$ del evento $i$: término inter-evento $\eta_i$ y término intra-evento $\delta_{ij}$. |

### Respuesta de sitio

| Símbolo | Definición |
|---|---|
| $S_a^o(T_n)$ | Variable aleatoria de aceleración espectral obtenida con los GMM en el modelo de amenaza; el superíndice $o$ no significa «roca» (g). |
| $S_a^s(T_n,V_{S30})$ | Variable aleatoria de aceleración espectral obtenida al aplicar ST20 a $S_a^o(T_n)$ evaluada en la condición de referencia (g). |
| $S_a$ | Variable aleatoria resultante de la mezcla de $S_a^o$ y $S_a^s$ (g). |
| $\alpha$ | Coeficiente de mezcla asignado a la componente $S_a^o$; $1-\alpha$ se asigna a $S_a^s$. |
| $\mathrm{PGA}^o$ | Variable aleatoria de PGA obtenida con los GMM y usada como intensidad de entrada de ST20 (g). |
| $pga^*$ | Realización de $\mathrm{PGA}^o$ que condiciona el término no lineal de ST20 (g). |
| $F$ | Factor aleatorio de amplificación de ST20 que relaciona $S_a^s$ con $S_a^o$. |
| $F_{\mathrm{comp}}$ | Modelo compuesto de amplificación, $F_{\mathrm{comp}}=F_{760}F_VF_{nl}$; el factor aplicado desde 760 m/s es la razón entre $F_{\mathrm{comp}}$ en la condición objetivo y en la condición de referencia. |
| $F_{760}$ | Factor de ajuste entre la condición de 760 m/s y la referencia de roca dura de 3000 m/s. |
| $F_V$ | Factor lineal de amplificación; vale uno en la referencia de 760 m/s. |
| $F_{nl}$ | Factor no lineal de amplificación. |
| $\mu_{\ln F}$, $\sigma_{\ln F}$ | Media y desviación estándar total de $\ln F$, condicionadas a $T_n$, $V_{S30}$ y $pga^*$. |
| $\sigma_L$, $\sigma_I$, $\sigma_{NL}$ | Contribuciones lineal, de cambio de referencia y no lineal a $\sigma_{\ln F}$. |
| $\mathrm{AF}$ | Factor de amplificación publicado: media y cuantiles de la razón entre la demanda en la condición de sitio y la demanda en la roca de referencia; vale exactamente 1 en $V_{S30}=760$ m/s. |

### Selección de registros sísmicos

| Símbolo | Definición |
|---|---|
| $\mathrm{CAV}$ | Velocidad absoluta acumulada del registro. |
| $\mathrm{CAV}_5$ | Velocidad absoluta acumulada restringida a los intervalos en que la aceleración supera 5 cm/s². |
| $\overline S_a(T_j)$, $S_a^t(T_j)$ | Media espectral del conjunto escalado y espectro objetivo (g). |

### MCER

| Símbolo | Definición |
|---|---|
| $C_x$ | Capacidad espectral de colapso de la fragilidad genérica anclada en la ordenada $x$: lognormal con $P[C_x\leq x]=0.10$ y $\sigma_{\ln C}=0.60$ (g). |
| $\lambda_C(x)$ | Tasa anual de colapso; $\lambda_C^{-1}$ es su inversa funcional (1/año). |
| $\underline S_a(T_n)$ | Límite inferior determinístico de la Tabla 21.2-1 (g). |
| $S_{aM}(T_n)$ | Ordenada MCER específica del sitio (ASCE/SEI 7-22, Sección 21.2.3) (g). |
| $S_a(T_n)$ | Ordenada del espectro de diseño, $\tfrac23 S_{aM}(T_n)$ (símbolo normativo, Ec. 21.3-1) (g). |
| $S_{DS}$, $S_{D1}$, $T^*$ | Parámetros de aceleración de diseño de la Sección 21.4 (g) y límite de período (s). |
| $S_{MS}=1.5S_{DS}$, $S_{M1}=1.5S_{D1}$ | Parámetros MCER (g). |
| $T_0$, $T_S$, $T_L$ | Períodos de esquina del espectro de forma normativa de la Sección 11.4.5: $T_0=0.2\,S_{D1}/S_{DS}$, $T_S=S_{D1}/S_{DS}$; $T_L$ es la transición de período largo (s). |

### Dinámica de taludes

| Símbolo | Definición |
|---|---|
| $H_s$, $s$, $\lambda_o=b/b_{\max}$ | Altura del talud (m), relación del talud y razón de truncamiento, con $b$ y $b_{\max}$ los anchos de berma y de base. |
| $G_o$, $m_o$ | Módulo de corte basal ajustado a pequeñas deformaciones (MPa) y factor de inhomogeneidad que gobierna el perfil de rigidez. |
| $V_S^o$ | Velocidad basal de onda de corte asociada a $G_o$ (m/s). |
| $T_s$ | Período fundamental del talud (Dakoulas–Gazetas) (s). |

### Desplazamientos y coeficientes sísmicos

| Símbolo | Definición |
|---|---|
| $D_n$ | Desplazamiento permanente de Newmark (cm). |
| $\mu_{\ln D}$, $\sigma_{\ln D}$ | Media y desviación estándar de $\ln D_n$ definidas por cada modelo de desplazamiento. |
| $I_A$ | Intensidad de Arias, derivada de la PGA mediante la relación adoptada en el reporte (m/s). |
| $D_a$ | Desplazamiento permanente admisible (cm). |
| $D_a/H$ | Desplazamiento residual relativo (%). |
| $a_y$, $k_y=a_y/g$ | Aceleración de fluencia (m/s²) y su forma adimensional. |
| $r$, $r^\star$ | Razón $k_y/\mathrm{PGA}$ y su versión limitada $\min(k_y/\mathrm{PGA},0.9999)$ (AM88). |
| $k_{\max}(p_e\mid D_a)$ | Menor $k_y$ cuya probabilidad de exceder $D_a$ no supera $p_e$ (g). |
| $p_e$ | Probabilidad objetivo de excedencia del coeficiente; el fractil empírico asociado es $q=1-p_e$. |
| $k_h=100\,k_{\max}/\mathrm{PGA}(V_{S30})$ | Coeficiente sísmico normalizado con la PGA en condición de sitio (%). |
