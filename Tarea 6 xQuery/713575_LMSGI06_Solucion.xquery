(: Ejercicio 1 :)
(: Obtener el nombre y precio de los productos que cuesten entre 20 y 55 (ambos incluidos). 
Resultado: 
<producto>
   <nombre>Pack mascarillas FFP2</nombre>
   <precio moneda="EUR">32</precio>
</producto>
<producto>
   <nombre>EPI</nombre>
   <precio moneda="EUR">40</precio>
</producto>
<producto>
   <nombre>Kit Protección</nombre>
   <precio moneda="EUR">55</precio>
</producto>
:)

for $p in doc("LMSGI06.xml")//producto
where $p/precio <= 55 and $p/precio >= 20
return
<producto>{$p/nombre, $p/precio}</producto>

,

(: Ejercicio 2 :)
(: Obtener el nombre, teléfono, localidad y provincia de los centros sanitarios que han comprado, más de dos "EPI" (No sabemos su código, sólo el nombre del producto) y algún producto con código "PAND10".
Resultado: 
<centro>
   <nombre>Complejo hospitalario</nombre>
   <telefono>666588045</telefono>
   <localidad>Jaén</localidad>
   <provincia>Jaén</provincia>
</centro>
:)

for     $p1 in //producto,
        $p2 in //producto,
        $c in //centro,
        $t in //cantidad
where   $p1/nombre = "EPI" and
        $p2/@cod = "PAND10" and 
        $c/@cod=$t/@cliente and 
        $t/@producto=$p1/@cod and
        $t>2
        
return
<centro> {$c/nombre, $c/telefono, $c/localidad, $c/provincia} </centro>

,

(: Ejercicio 3 :)
(: Obtener los nombres de todos los centros sanitarios, ordenados alfabeticamente y luego por orden descendente de código.
Resultado:
<nombre>Complejo hospitalario</nombre>
<nombre>Hospital Poniente</nombre>
<nombre>Hospital Universitario Clínico San Cecilio</nombre>
<nombre>Hospital Universitario Virgen del Rocío</nombre>
:)

for $n in doc("LMSGI06.xml")//centro
order by $n/nombre ascending, $n/@cod descending
return $n/nombre

,

(: Ejercicio 4 :)
(: Obtener (usando let) el número total de productos y el importe total que costaría comprar cinco unidades de cada uno.
Resultado:
<totales>
   <productos>8</productos>
   <coste_total moneda="EUR">1040</coste_total>
</totales>
:)

let $producto := doc("LMSGI06.xml")//producto
return 
  <totales>
    <productos>{count($producto)}</productos>
    <coste_total moneda="EUR">{5*sum($producto/precio)}</coste_total>
  </totales>

,

(: Ejercicio 5 :)
(: Obtener el nombre de los productos que cuestan igual o más de 55€, su precio unitario, el número total de veces que ha sido comprado por todos los clientes, así como el valor total de esas ventas en €. 
Resultado:
<producto>
   <nombre>Pack mascarillas FFP3</nombre>
   <precio moneda="EUR">62</precio>
   <ventas>0</ventas>
   <total moneda="EUR">0</total>
</producto>
<producto>
   <nombre>Kit Protección</nombre>
   <precio moneda="EUR">55</precio>
   <ventas>3</ventas>
   <total moneda="EUR">165</total>
</producto>
:)

(: Variante 5.1 :)
for $a in doc("LMSGI06.xml")//producto[precio>=55]
return
    for $c in sum(
        for $b in doc("LMSGI06.xml")//cantidad 
        where 
        $b/@producto = $a/@cod
        return ($b)
        )        
    return
    <producto>
        {$a/nombre, $a/precio}
        <ventas>{$c}</ventas>
        <total moneda="EUR">{$c * $a/precio}</total>
    </producto>

,

(: Variante 5.2 :)
for $p in doc("LMSGI06.xml")//producto
where $p/precio >= 55
return 
    for $c in sum(for $b in doc("LMSGI06.xml")//cantidad 
    where   $b/@producto = $p/@cod return ($b))
    return
        <producto>{ $p/nombre, $p/precio }<ventas>{ $c } </ventas>
        <total moneda="EUR">{ $c * $p/precio}</total></producto>	

,

(: Variante 5.3 :)
for $pr in doc("LMSGI06.xml")//producto
let $cant := let $ca := doc("LMSGI06.xml")//compras/cantidad[@producto=$pr/@cod]  (: De cada producto seleccionado, obtenemos el total de las cantidades compradas :)
             return sum($ca)
where $pr/precio >= 55  (: Sólo trabajaremos con los productos cuyo coste es igual o superior a 55 € :)
return  <producto>
            {$pr/nombre,
            $pr/precio,
            <ventas>{ $cant }</ventas>,
            <total moneda="EUR">{ $cant*$pr/precio }</total>}
        </producto>

,

(: Ejercicio 6 :)
(: Obtener el nombre de la vacuna con el mayor número de unidades distribuidas y el de menor, así como su precio. 
Resultado:
<vacuna>
   <nombre>Astra Zéneca</nombre>
   <precio dosis="Doble" moneda="EUR">2</precio>
   <unidades>5500</unidades>
</vacuna>
<vacuna>
   <nombre>Curevac</nombre>
   <precio dosis="Doble" moneda="EUR">10</precio>
   <unidades>500</unidades>
</vacuna>
:)

(: Variante 6.1 :)
for $f in doc("LMSGI06.xml")//vacunacion,
	$c in doc("LMSGI06.xml")//vacuna
where $c/unidades = min($f//unidades) or $c/unidades = max($f//unidades)
return <vacuna>{$c/nombre, $c/precio, $c/unidades}</vacuna>

,

(: Variante 6.2 :)
for 
    $cursos in doc("LMSGI06.xml")//vacuna
where
    $cursos/unidades = max(for $p in doc("LMSGI06.xml")//vacuna/unidades return $p)
    or
    $cursos/unidades = min(for $p in doc("LMSGI06.xml")//vacuna/unidades return $p)
return
    <vacuna>
        {$cursos/nombre}
        <precio moneda="EUR">{$cursos/precio/text()}</precio>
    </vacuna>
    
,

(: Ejercicio 7 :)
(: Obtener, usando let, la suma (en €) de los salarios de los sanitarios que viven en las provincias de Jaén o Cádiz y tienen código B, excepto los que viven en las capitales. 
Resultado:
<total_salarios moneda="EUR">2900</total_salarios>
:) 

let $s := sum(doc("LMSGI06.xml")//pandemia/sanitarios/sanitario[(provincia="Jaén" and localidad!="Jaén") or (provincia="Cádiz" and localidad!="Cádiz") and @cod="B"]/salario)
return <total_salarios moneda="EUR">{$s}</total_salarios>

,

(: Ejercicio 8 :)
(: Obtener los nombres de todos los responsables de vacunación apellidados "Gómez", eliminando los repetidos e indicar todas los box en los que administra vacunas cada responsable, ordenados desde el nombre más largo al más corto. 
Estructura:
<responsable>
   <nombre>Nombre</nombre>
   <box>n1</box>
   <box>n2</box>
</responsable>
:)

(: Variante 8.1 :)
for $n in distinct-values(doc("LMSGI06.xml")//responsable)
where contains($n,"Gómez")
order by string-length($n) descending
return 
    <responsable>
        <nombre>{$n}</nombre>
        {for $a in doc("LMSGI06.xml")//vacuna let $f := $a/box where $a/responsable=$n return $f}
    </responsable>

,

(: Variante 8.2 :)
for $a in distinct-values (doc ("LMSGI06.xml")//vacuna [contains (responsable,"Gómez")]/responsable)
let $b := doc ("LMSGI06.xml")//vacuna [responsable = $a]/box
order by string-length($a) descending
return 
    <responsable>
    <nombre>{$a}</nombre>
    {$b}
    </responsable>
    
,

(: Ejercicio 9 :)
(: Obtener la media del salario de todos los sanitarios y la suma de los precios de las vacunas que se administran en el box 3 con igual o más de 1000 unidades.
Resultado:
<vacunacion>
   <media_salarios>1171.4285714285713</media_salarios>
   <total_box3 moneda="EUR">19</total_box3>
</vacunacion>
:)

let $m := avg(doc("LMSGI06.xml")//salario), 
    $s := sum(doc("LMSGI06.xml")//pandemia/vacunacion/vacuna[box="3" and unidades >= 1000]/precio) 
return
    <vacunacion>
        <media_salarios>{$m}</media_salarios>
        <total_box3 moneda="EUR">{$s}</total_box3>
    </vacunacion>

,

(: Ejercicio 10 :)
(: Obtener el nombre del periodo de vacunación más corto (menor duración en días), los días que dura, quién es el/la responsable, en qué box, su precio y el precio con un descuento por pago por anticipado del 25%.
Resultado:
<vacuna>
   <nombre>Curevac</nombre>
   <duracion unidad="dias">31</duracion>
   <responsable>Toni Klose</responsable>
   <box>3</box>
   <precio dosis="Doble" moneda="EUR">10</precio>
   <precio_pa moneda="EUR">7</precio_pa>
</vacuna>
:)

(: Variante 10.1 :)
for $curso in doc("LMSGI06.xml")//vacuna,
    $dur_min in min(for $cur in doc("LMSGI06.xml")//vacuna,
                        $dur in days-from-duration(xs:date(concat(substring($cur/fin,1,4), "-", substring($cur/fin,5,2), "-", substring($cur/fin,7,2)))-
                                                   xs:date(concat(substring($cur/comienzo,1,4), "-", substring($cur/comienzo,5,2), "-", substring($cur/comienzo,7,2))))
                     return $dur)
where $dur_min = days-from-duration(xs:date(concat(substring($curso/fin,1,4), "-", substring($curso/fin,5,2), "-", substring($curso/fin,7,2)))-
                                    xs:date(concat(substring($curso/comienzo,1,4), "-", substring($curso/comienzo,5,2), "-", substring($curso/comienzo,7,2))))                     
return <vacuna>
            {$curso/nombre}
            <duracion unidad="dias">{$dur_min}</duracion>
            {$curso/responsable,
              $curso/box,
              $curso/precio}
            <precio_pa moneda="EUR">{round($curso/precio * 0.75, 2)}</precio_pa>
       </vacuna>
       
 ,

(: Variante 10.2 :)
(for $vac in doc ("LMSGI06.xml")/pandemia/vacunacion/vacuna
let $fechaInicio := $vac/comienzo/concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))
let $fechaFin := $vac/fin/concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))
let $duracion :=  days-from-duration(xs:date($fechaFin) - (xs:date($fechaInicio)))
order by $duracion ascending
return
    <vacuna>{$vac/nombre}
        <duracion unidad="dias">{$duracion}</duracion>
        {$vac/responsable}
        {$vac/box}
        {$vac/precio}
        <precio_pa moneda="EUR">{($vac/precio)-($vac/precio*0.25)}</precio_pa>
    </vacuna>)[1]