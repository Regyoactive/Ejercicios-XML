<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
            <head>
                <title>Tarea 5 - LMSGI</title>
            </head>
            <body>
            <h3>1. Listado de los 10 primeros alumnos (indicar n�mero de orden mediante xls): </h3>
            <xsl:for-each select="alumnos/alumno[position() &lt;= 10]">
                    <xsl:value-of select="position()"/>
                    <xsl:text>.- </xsl:text>
                    <xsl:value-of select="apellidos"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="nombre"/>
                    <xsl:text>. </xsl:text>
                    <br />
            </xsl:for-each>
        
            <h3>2. Listado de los 10 primeros alumnos ordenados por localidad: </h3>
            <xsl:for-each select="alumnos/alumno[position() &lt;= 10]">
            <xsl:sort select="localidad"/>
                    <xsl:text>- </xsl:text>
                    <xsl:value-of select="nombre"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="apellidos"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="localidad"/>
                    <xsl:text>).</xsl:text>
                    <br />
            </xsl:for-each> 
        
        
            <h3>3. �ltimo alumno y su edad: </h3>
                    <xsl:value-of select="//alumno[last()]/nombre"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="//alumno[last()]/apellidos"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="//alumno[last()]/edad"/>
                    <xsl:text> a�os).</xsl:text>
        
            <h3>4. Total de alumnos: </h3>
                    <xsl:value-of select="count(alumnos/alumno)"/>
                    <xsl:text> alumnos en total.</xsl:text>
        
        
            <h3>5. Total de alumnos de "Zafra": </h3>
                    <xsl:text>Hay </xsl:text>
                    <xsl:value-of select="count(alumnos/alumno[localidad='ZAFRA'])"/>
                    <xsl:text> alumnos de Zafra. </xsl:text>	
        
            <h3>6. Suma de la edad de los alumnos de "Zafra" y la suma de todos los alumnos: </h3>
                    <xsl:text>Los alumnos de Zafra suman </xsl:text>
                    <xsl:value-of select="sum(alumnos/alumno[localidad='ZAFRA']/edad)"/>
                    <xsl:text> a�os (</xsl:text>
                    <xsl:value-of select="sum(alumnos/alumno/edad)"/>
                    <xsl:text> a�os en total).</xsl:text>
        
            <h3>7. Lista ordenada con el Nombre completo, Apellido y DNI de todos los alumnos que su nombre comience por Manuel, ordenados alfab�ticamente por Apellido: </h3>
            <xsl:for-each select="alumnos/alumno[starts-with(nombre,'MANUEL')]">
            <xsl:sort select="apellidos"/>
                    <xsl:value-of select="position()"/>
                    <xsl:text>.- </xsl:text>
                    <xsl:value-of select="nombre"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="apellidos"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="@dni"/>
                    <xsl:text>). </xsl:text>
                    <br />
            </xsl:for-each>
        
        
            <h3>8. Promedio de los alumnos de Zafra menores de 18 a�os y el promedio de todos los alumnos menores de 18 a�os de todas las localidades: </h3>
                <xsl:text>Los alumnos de Zafra menores de 18 a�os promedian una edad de </xsl:text>
                <xsl:value-of select="round(sum(alumnos/alumno[localidad='ZAFRA']/edad[. &lt;18]) 
                div count(alumnos/alumno[localidad='ZAFRA']/edad[. &lt;18])*100) div 100"/>
                <xsl:text> a�os de un promedio general de </xsl:text>
                <xsl:value-of select="round(sum(alumnos/alumno/edad[. &lt;18]) div count(alumnos/alumno/edad[. &lt;18])*100) div 100"/>
                <xsl:text> a�os. </xsl:text>
        
            <h3>9. Todas las localidades, ordenadas alfab�ticamente y el n�mero de alumnos que tienen: </h3>
                <xsl:for-each select="alumnos/alumno[not(localidad=preceding::localidad)]"> 
                    <xsl:sort select="localidad"/>
                    <xsl:variable name="loc" select="localidad"/>
                    <xsl:value-of select="$loc"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="count(//alumno[localidad=$loc])"/>
                    <xsl:text>)</xsl:text>
                    <!--Si no es la la �ltima posici�n, se a�ade una coma-->
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <!--Si es la �ltima posici�n, se finaliza con un punto-->
                    <xsl:if test="position() = last()">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </xsl:for-each>
        
        
            <h3>10. Alumnos de Zafra y de Medina de las Torres dentro de una tabla con su cabecera "Nombre" y "Localidad". 
            Cada localidad tendr� un color de fila diferente (Azul para Zafra y Rojo para Medina de las Torres),
            siendo todos los textos en blanco: </h3>
                <table border="bold">
                        <thead style="background-color:black; color:white"><th>NOMBRE</th><th>LOCALIDAD</th></thead>
                        <xsl:for-each select="alumnos/alumno[localidad='ZAFRA' or localidad='MEDINA DE LAS TORRES']">
                            <tr style="color:white">
                            <xsl:if test="localidad='ZAFRA'">
                                <td bgcolor="blue"><xsl:value-of select="nombre"/></td>
                                <td bgcolor="blue"><xsl:value-of select="localidad"/></td>
                            </xsl:if>
                            <xsl:if test="localidad='MEDINA DE LAS TORRES'">
                                <td bgcolor="red"><xsl:value-of select="nombre"/></td>
                                <td bgcolor="red"><xsl:value-of select="localidad"/></td>
                            </xsl:if>
                            </tr>
                        </xsl:for-each>
                    </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>