****************************************************
* Proyecto: Taller 4 – Experimentos (Haciendo Economía)
* Título: Script maestro para el taller 4, análisis reproducible
* Autores de referencia: Herrmann, Thöni y Gächter (Science, 2008)
* Elaborado por: Samuel Blanco Castellanos 
* Objetivo general:
*   - Estandarizar flujo de trabajo del Taller 4 (importación, limpieza,
*     análisis, gráficos y tablas) en una sola rutina reproducible.
* Reproducibilidad:
*   - Este .do fija rutas, crea subcarpetas si faltan, abre log,
*     guarda datasets intermedios y exporta todas las salidas a /Outputs.
****************************************************
clear all

*----------------------*
* 0) RUTAS DEL TALLER
*----------------------*
global ROOT "C:\Users\Lenovo\Documents\Universidad\Material Clases\Haciendo Economía\Taller_4"
global RAW  "$ROOT\Rawdata"
global OUT  "$ROOT\Outputs"
global FIG  "$OUT\Figures"
global TAB  "$OUT\Tables"
global SLD  "$OUT\Slides"
global COD  "$ROOT\Code"
global CRE  "$ROOT\CreatedData"


*==================================================*
* SECCIÓN 1. (Reserva) – Contexto / datasets base  *
*==================================================*
****************************************************
* P2.1.1 - Contribución promedio por ronda (nuestro experimento)
****************************************************

* Cargar datos desde Excel
import excel using "$RAW\juego20252 haciendo econ.xlsx", sheet("Hoja1") firstrow clear

* Renombrar variables para mayor claridad
rename Team Jugador
rename Playerscontributions Contribucion
rename PayoffsinthisGame Retribucion

* Rellenar valores faltantes de Round
replace Round = Round[_n-1] if missing(Round)

* Calcular contribución promedio por ronda
collapse (mean) Contribucion, by(Round)

* Gráfico corregido con eje Y hasta 40
twoway (line Contribucion Round, lcolor(navy) lwidth(medthick) msymbol(circle)), ///
       title("Contribución promedio por ronda", size(medlarge)) ///
       subtitle("Juego de bienes públicos realizado en clase", size(medsmall)) ///
       xtitle("Ronda", size(medlarge)) ///
       ytitle("Contribución promedio", size(medlarge)) ///
       xlabel(1(1)10, labsize(small)) ///
       ylabel(0(5)40, labsize(small) angle(horizontal)) ///
       yscale(range(0 40)) ///
       legend(off) ///
       graphregion(color(white)) plotregion(color(white)) ///
       scheme(s1color)


* Exportar gráfico a Figures
graph export "$FIG\contribucion_promedio_rondas.png", as(png) replace




*==================================================*
* SECCIÓN 2.    
*==================================================*
* P2.2.1 – Herrmann et al. (2008)  

import excel using ///
"$RAW\Data_Figure2A_Herrmann.xlsx", ///
firstrow clear
* Convertir la tabla a formato largo
* Renombrar todas las ciudades con prefijo "c"
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
* Hacer reshape largo
reshape long c, i(Period) j(ciudad)
collapse (mean) c, by(Period)
rename c mean_contribucion
rename mean_contribucion mean_castigo
* Guardar en formato Stata (.dta)
save "$CRE\promedios_periodo_fig2A.dta", replace



*Importo el segundo excel
import excel using ///
"$RAW\Data_Figure3_Herrmann.xlsx", ///
firstrow clear
* Convertir la tabla a formato largo
* Renombrar todas las ciudades con prefijo "c"
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
* Hacer reshape largo
reshape long c, i(Period) j(ciudad)
collapse (mean) c, by(Period)
rename c mean_contribucion
rename mean_contribucion mean_NOcastigo
* Guardar en formato Stata (.dta)
save "$CRE\promedios_periodo_fig3.dta", replace


* Merge de promedios por periodo (Fig. 2A y Fig. 3)
* Cargar primer dataset (Figura 2A - con castigo)
use "$CRE/promedios_periodo_fig2A.dta", clear
* Hacer merge con el segundo dataset (Figura 3 - sin castigo)
merge 1:1 Period using "$CRE/promedios_periodo_fig3.dta"
drop _merge
* Guardar dataset combinado
save "$CRE/promedios_periodo_merge.dta", replace

twoway (line mean_castigo Period, lcolor(navy) lwidth(medthick)) ///
       (line mean_NOcastigo Period, lcolor(maroon) lpattern(dash) lwidth(medthick)), ///
       title("Contribución promedio por período", size(medlarge)) ///
       subtitle("Juego de bienes públicos: Con vs Sin castigo", size(medsmall)) ///
       xtitle("Período", size(medlarge)) ///
       ytitle("Contribución promedio", size(medlarge)) ///
       xlabel(1(1)10, labsize(medsmall)) ///
       ylabel(0(2)16, labsize(medsmall) nogrid) ///
       yscale(range(0 16)) ///
       legend(order(1 "Con castigo" 2 "Sin castigo") pos(6) row(1) region(lstyle(none)) size(small)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       scheme(s1color)
* Exportar como PNG
graph export "$FIG\grafico_contribuciones.png", as(png) replace



* P2.2.2 - Gráfico de columnas: Período 1 vs Período 10
use "$CRE\promedios_periodo_merge.dta", clear
* Mantener solo periodos 1 y 10
keep if Period == 1 | Period == 10
reshape long mean_, i(Period) j(condicion, string)
* Renombrar
rename mean_ contribucion
* Convertir 'condicion' de string a numérica con etiquetas
encode condicion, gen(cond_id)
label define cond 1 "Con castigo" 2 "Sin castigo"
label values cond_id cond
* Gráfico de columnas agrupadas
graph bar contribucion, over(cond_id) over(Period) ///
    blabel(bar, format(%4.1f)) ///
    bar(1, color(navy)) bar(2, color(maroon)) ///
    title("Contribución promedio en los períodos 1 y 10") ///
    subtitle("Con y sin castigo") ///
    ytitle("Contribución promedio") ///
    legend(order(1 "Con castigo" 2 "Sin castigo")) ///
    graphregion(color(white)) plotregion(color(white)) ///
    scheme(s1color)
* Guardar gráfico
graph export "$FIG\grafico_columnas_p2_2_2.png", as(png) replace

****************************************************
* P2.2.3 - Desviación estándar Períodos 1 y 10
****************************************************

****************************************************
* P2.2.3, P2.2.4 y P2.2.5 - Desviación estándar, maximos, minimos, Rango (Períodos 1 y 10)
* Usando Rawdata con datos de cada país
****************************************************

* --- Experimento con castigo (Figura 2A) ---
import excel "$RAW\Data_Figure2A_Herrmann.xlsx", firstrow clear

* Reestructurar a formato largo: columnas = países → filas = observaciones
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
* Hacer reshape largo
reshape long c, i(Period) j(ciudad)

rename c contribucion
label var contribucion "Contribución individual"
* Filtrar solo periodos 1 y 10
keep if Period == 1 | Period == 10

* Calcular estadísticas por período
bysort Period: summarize contribucion, detail
* Guardar tabla resumida
collapse (mean) media=contribucion (sd) sd=contribucion ///
         (min) minimo=contribucion (max) maximo=contribucion, by(Period)
gen condicion = "Con castigo"
save "$CRE\stats_fig2A.dta", replace


* --- Experimento sin castigo (Figura 3) ---
import excel "$RAW\Data_Figure3_Herrmann.xlsx", firstrow clear
* Reestructurar a formato largo: columnas = países → filas = observaciones
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
* Hacer reshape largo
reshape long c, i(Period) j(ciudad)

rename c contribucion
label var contribucion "Contribución individual"
keep if Period == 1 | Period == 10

bysort Period: summarize contribucion, detail

collapse (mean) media=contribucion (sd) sd=contribucion ///
         (min) minimo=contribucion (max) maximo=contribucion, by(Period)
gen condicion = "Sin castigo"
save "$CRE\stats_fig3.dta", replace


* --- Unir ambos ---
use "$CRE\stats_fig2A.dta", clear
append using "$CRE\stats_fig3.dta"

* Tabla final
list, clean



*==================================================*
* SECCIÓN 3
*==================================================*

****************************************************
* P2.3.2 - Prueba t en Período 1 (Con vs Sin castigo)
****************************************************

* --- Dataset con castigo ---
import excel "$RAW\Data_Figure2A_Herrmann.xlsx", firstrow clear
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
* Hacer reshape largo
reshape long c, i(Period) j(ciudad)

rename c contribucion
gen condicion = "Con castigo"
save "$CRE\temp_castigo.dta", replace

* --- Dataset sin castigo ---
import excel "$RAW\Data_Figure3_Herrmann.xlsx", firstrow clear
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
* Hacer reshape largo
reshape long c, i(Period) j(ciudad)

rename c contribucion
gen condicion = "Sin castigo"
save "$CRE\temp_sin_castigo.dta", replace

* --- Unir datasets ---
use "$CRE\temp_castigo.dta", clear
append using "$CRE\temp_sin_castigo.dta"

* Mantener solo Período 1
keep if Period == 1

* t-test de medias entre con y sin castigo
ttest contribucion, by(condicion)

****************************************************
* P2.3.3 - Prueba t en Período 10 (Con vs Sin castigo)
****************************************************

* --- Dataset con castigo ---
import excel "$RAW\Data_Figure2A_Herrmann.xlsx", firstrow clear
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
reshape long c, i(Period) j(ciudad)

rename c contribucion
gen condicion = "Con castigo"
save "$CRE\temp_castigo.dta", replace

* --- Dataset sin castigo ---
import excel "$RAW\Data_Figure3_Herrmann.xlsx", firstrow clear
rename Copenhagen   c1
rename Dnipropet    c2
rename Minsk        c3
rename StGallen     c4
rename Muscat       c5
rename Samara       c6
rename Zurich       c7
rename Boston       c8
rename Bonn         c9
rename Chengdu      c10
rename Seoul        c11
rename Riyadh       c12
rename Nottingham   c13
rename Athens       c14
rename Istanbul     c15
rename Melbourne    c16
reshape long c, i(Period) j(ciudad)

rename c contribucion
gen condicion = "Sin castigo"
save "$CRE\temp_sin_castigo.dta", replace

* --- Unir datasets ---
use "$CRE\temp_castigo.dta", clear
append using "$CRE\temp_sin_castigo.dta"

* Mantener solo Período 10
keep if Period == 10

* t-test de medias entre con y sin castigo
ttest contribucion, by(condicion)

