# Taller 4 - Haciendo Economía 📊

Este repositorio contiene el material y los resultados del **Taller 4: Experimentos**, desarrollado en el curso *Haciendo Economía*.  
El taller se centra en el análisis de juegos de bienes públicos, comparando la cooperación en entornos con y sin castigo, siguiendo el estudio de Herrmann et al. (2008).

---

## 📂 Estructura del repositorio

- **Rawdata/**  
  Contiene los datos originales del taller y los archivos base:
  - `juego20252_haciendo_econ.xlsx`: resultados del juego de bienes públicos realizado en clase.  
  - `Data_Figure2A_Herrmann.xlsx` y `Data_Figure3_Herrmann.xlsx`: datos de Herrmann et al. (2008) para reproducir las Figuras 2A y 3.  
  - `taller4_monedas.xlsx`: resultados del ejercicio de lanzamiento de moneda (P2.3.1).  

- **CreatedData/**  
  Archivos procesados en Stata listos para el análisis (promedios por período, datos fusionados, etc.).

- **Code/**  
  Scripts en Stata (`.do`) utilizados para limpiar datos, calcular estadísticas descriptivas, realizar pruebas de hipótesis (`ttest`) y generar figuras.

- **Outputs/**  
  - **Figures/**  
  Gráficos generados en Stata y usados en el informe en LaTeX:
  - Contribución promedio por período (con vs. sin castigo).  
  - Contribución promedio en la clase (P2.1.1).  
  - Gráficos de columnas y de dispersión para diferentes ejercicios del taller.  

- **Informe/**  
  Documento principal en **LaTeX (Overleaf)** con las respuestas al taller, gráficos y tablas.  

---

## 📑 Contenido del taller

1. **Sección 2.1 – Nuestro experimento en clase**  
   - Gráfico de la contribución promedio por ronda.  
   - Comparación con Herrmann et al. (2008).  
   - Discusión de similitudes y diferencias.

2. **Sección 2.2 – Datos de Herrmann et al. (2008)**  
   - Promedios por período con y sin castigo.  
   - Gráficos de líneas y columnas.  
   - Estadísticas descriptivas (media, varianza, desviación estándar, min, max, rango).  

3. **Sección 2.3 – Análisis causal**  
   - Ejercicio del lanzamiento de moneda (azar vs. causalidad).  
   - Pruebas t (`ttest`) en los períodos 1 y 10.  
   - Discusión sobre significancia estadística y causalidad.  
   - Limitaciones de los experimentos de laboratorio.  

---

## 📚 Referencias

- Herrmann, B., Thöni, C., & Gächter, S. (2008). *Antisocial punishment across societies*. Science, 319(5868), 1362–1367.  
- Levitt, S. D., & List, J. A. (2007). *What do laboratory experiments measuring social preferences reveal about the real world?* Journal of Economic Perspectives, 21(2), 153–174.  

---

✍️ Autor: **Samuel Blanco Castellanos, Joan Shick, Gabriel Salcedo, Juan Rusinque**  
📅 Fecha: 2025  
