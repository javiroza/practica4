# formato y nombre de la imagen
set term png
set output "P4-1920-b-fig2.png"

# muestra los ejes
set xzeroaxis
set yzeroaxis

# define el título
set title "Error en el càlcul de l'àrea A_m"

# define el rango de valores de los ejes que se muestra en pantalla
#set xrange[-0.01:0.4]
#set yrange[-0.1:1]

# define los títulos de los ejes
set xlabel "h (x10^6 km)"
set ylabel "Error (x10^1^2 km^2)"

set ytics("1x10^-^1^0" 1.00e-10,"1x10^-^5" 1.00e-05,"1x10^0" 1.00e+00,"1x10^5" 1.00e+05,"1x10^1^0" 1.00e+10, "1x10^1^5" 1.00e+15)
set xtics("1x10^-^3" 1.00e-03,"1x10^-^3" 1.00e-02,"1x10^-^1" 1.00e-01,"1x10^0" 1.00e+00,"1x10^1" 1.00e+01)

# format dels nombres de l'eix y: 2 decimals
set format y '%.2e'
set format x '%.2e'

trapezism(x) = 0.5*508.633*x**4
set logscale y
set logscale x
set key top left

# plot 
plot "P4-1920-b-res.dat" index 1 using 1:3 with points t "Error A_m", \
trapezism(x) t "Tendència esperada", \
"auxb.dat" using 1:3 with points t "Error Simpson"
#pause -1
