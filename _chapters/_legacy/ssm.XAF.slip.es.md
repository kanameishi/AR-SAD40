
Las tasas de actividad para fuentes de falla con datos de tasa de deslizamiento disponibles pueden derivarse del balance de momento sísmico:

$$\dot{M}_0 = \mu\, A\, S$$

donde $\mu$ es el módulo de corte, $A$ es el área de falla y $S$ es la tasa de deslizamiento a largo plazo. Esta relación conecta estimaciones geodésicas o geológicas de tasa de deslizamiento con la tasa de liberación de momento sísmico usada en la construcción de MFD.

Las estimaciones de tasa de deslizamiento de la GEM North Africa Active Fault Database (NAAFD) [@Styron2018] están documentadas para 15 de las 115 fuentes de falla. Los valores documentados abarcan tasas de deslizamiento neto, tasas paralelas al rumbo, tasas verticales y tasas de acortamiento, con magnitudes típicamente en el rango 0.01 a 2.5 mm/año. Sin embargo, estos datos de tasa de deslizamiento no están codificados en los archivos XML del modelo de fuentes de OpenQuake; los registros de auditoría del modelo de fuentes indican que ninguna fuente de falla tiene datos de tasa de deslizamiento en la representación XML. Por lo tanto, las tasas MFD incrementales para fuentes de falla se especificaron independientemente de las restricciones de tasa de deslizamiento de NAAFD en la etapa de implementación de OpenQuake [@Poggi2020].
