# La inversión pública en Nicaragua
## Un análisis a partir de la información publicada por el Gobierno de Nicaragua

### **Introducción**

En Nicaragua, la información generada por el sector público es limitada. El Banco Central de Nicaragua y el Ministerio de Hacienda y Crédito Público (MHCP) son de las instituciones que más publican información cuantitativa sobre la economía del país; sin embargo, en cuanto a datos sociodemográficos, es notable la falta de información actualizada. El censo poblacional no se realiza desde más de 15 años (última vez en 2005); encuestas sobre el nivel de vida (pobreza) se dejaron de publicar desde 2017. La única publicación periódica que se publica al respecto son los resultados de la Encuesta Continua de Hogares (ECH) que se ha estado publicando trimestralmente por el Instituto Nacional de Información de Desarrollo (INIDE). 

Dependiendo de la temática que se quiera estudiar sobre políticas públicas en Nicaragua, la información será mayor o menor. Durante ya casi 10 años he estado realizando análisis sobre las finanzas públicas de Nicaragua y algunos países centroamericano y me he encontrado con estas dificultades. Nicaragua está en la cola de la transparencia fiscal, así que cuando se desean hacer este tipo de análisis nos encontramos con muchas dificultades. 

Las autoridades nicaragüenses que rigen las finanzas públicas hasta la fecha no han logrado implementar un sistema de publicación de información que sea de fácil acceso para estudiar los datos respecto a este tema. Por ejemplo, el BCN publica la mayoría de sus datos en formatos de hojas de cálculo, implementando una política de “datos abiertos” para dar a conocer los indicadores económicos del país;  sin embargo, esto no se ha logrado trasladar al MHCP. 

El proyecto reciente que trabajé fue el de construir una base de datos sobre la inversión pública en los diferentes departamentos y municipios del país. Para esto utilicé los datos que publica el MHCP en la página web del Sistema Nacional de Inversión Pública (SNIP). Estos son los únicos datos que este ministerio publica en cierta forma de “datos abiertos”[^1]. 

En esta web se puede encontrar información sobre los proyectos de inversión pública que el Sector Público no Financiero implementa en el país. Hay datos sobre las asignaciones (aprobado para los proyectos), así como lo realmente ejecutado al finalizar cada año. Muestra las instituciones, los proyectos, los sectores, los departamentos y municipios, así como las fuentes de financiamiento. 

Pero no todo es fácil; para poder construir una base de datos completa, es necesario unir la información de los diferentes archivos que se publican en este sitio[^2].

### **Objetivos y Metodología**

El objetivo de este proyecto es **analizar cómo ha evolucionado la inversión pública en Nicaragua entre los años 2017 y 2021**, conociendo lo siguiente:

1. **qué instituciones ejecutan**, 
2. **hacia qué sectores ha estado dirigida la inversión,** 
3. **quiénes financian los proyectos, y sobre todo,** 
4. **hacia qué departamentos y municipios se están enfocando los recursos**.

Para esto, hice uso de tres archivos que publica el SNIP. En el primero se presenta información de los departamentos, municipios, proyecto y obra y la institución encargada de ejecutarla. En el segundo se muestra información sobre las instituciones y los proyectos y las fuentes de financiamiento. El tercero incluye datos sobre los proyectos, el sector y la institución de ejecución[^3].

Tanto el segundo archivo como el tercero, los datos publicados son los ejecutados, pero con el primero, son datos de presupuestos actualizados, es decir, lo último que se aprueba (o se modifica) durante el año. Esto no es lo que realmente se ejecuta. Por lo tanto, fue necesario unir los datos de los archivos donde se muestra la información departamental y municipal.

![Archivo 1](https://user-images.githubusercontent.com/112327873/189492022-570004f1-294e-4cc8-a6e8-886f66583e38.png) 

![Archivo 2](https://user-images.githubusercontent.com/112327873/189492041-49625f65-216c-4a0c-b721-3d63edc9db72.png)

![Archivo 3](https://user-images.githubusercontent.com/112327873/189492068-1e392e96-318d-4346-867e-5311c8f30e38.png)

### **Construcción de las bases de datos**

Para poder consolidar toda la información en una sola base de datos fue necesario unir los tres archivos; sin embargo, la estructura de estas bases de datos no tienen un esquema de registros por columnas, sino una especie de jerarquía, por lo que fue necesario, primero que todo, convertirlas cada una a un formato de registros por columnas. HE AQUÍ EL GRAN RETO!

Busqué algún ejemplo en internet sobre esto pero no encontré nada, porque no es algo común, así que lo hice de una manera algo rústica. Tuve que crear columnas para cada registro de las entidades de mi base de datos. Por ejemplo, en el primer archivo fueron: departamento, municipio, proyecto, obra, institución; en el segundo: Ente, institución, proyecto, obra, fuente; en el tercero: ente, sector, proyecto.

Lo que facilitó el trabajo fue que cada entidad tenía un color diferente, con lo que pude hacer lo siguiente, resumidamente: 

1)	En una nueva pestaña, copié la tabla con todos sus registros desagrupados:
 ![image](https://user-images.githubusercontent.com/112327873/189502508-4c9c67d5-8d26-4bc2-89aa-55d031effd25.png)

2)	Cree una columna para cada nivel de información.
 ![image](https://user-images.githubusercontent.com/112327873/189502519-84f737a3-de59-4f69-a1fe-0b705de73880.png)

3)	Borré los registros que no pertenecían a cada columna, guiado por el color.
 ![image](https://user-images.githubusercontent.com/112327873/189502523-b455feda-342b-4d71-b715-5b8c3d4801c6.png)

4)	Rellené automáticamente cada columna con el registro al que pertenecía para que cada fila coincidiera al final con el último elemento. 
![image](https://user-images.githubusercontent.com/112327873/189502538-5fd36014-75e6-4424-9a13-2ac8da08e5da.png)

5)	Seguidamente fue necesario crear dos columnas para mostrar el tipo de fuente (interna o externa) y tipo de financiamiento (donación, préstamo, recursos del tesoro).
Para crear el tipo financiamiento usé el siguiente código:
=IF(OR(H1103="Recursos del Tesoro", H1103="Recursos Propios", H1103="Ingresos con Destino Específico"), "Fondos Internos", "Fondos Externos")

Para crear el tipo de fuente (donación, préstamo o recurso interno), tuve que crear un código que conectara las columnas de los datos de las fuentes de financiamiento:

=IF(M1106>0,"Recursos Propios", IF(N1106>0, "Recursos del Tesoro", IF(O1106>0, "Destino Específico", IF(P1106>0, "Donación", IF(Q1106>0, "Préstamo")))))

Nota: Antes de esto tuve problemas porque no identificaba bien la columna de la fuente con lo que había escrito en los códigos, por lo que tuve que eliminar los espacios iniciales de la columna con la función TRIM
![image](https://user-images.githubusercontent.com/112327873/189502545-63179e75-296b-4bb0-b40a-0b10c1cfb978.png)

Este procedimiento lo apliqué con las tres bases de datos, para los años 2017-2022 y me quedó lo siguiente:
![image](https://user-images.githubusercontent.com/112327873/189502556-1dd6cd46-3d5c-4183-8f91-8ada04945dda.png)

Para el caso de esta base de datos, donde se muestra el sector al que pertenece el proyecto, tuve que agregar una columna con el nombre de la institución completa ya que el archivo solamente mostraba las siglas del nombre de la institución lo que iba afectar la conexión de la información. 
Nota: En esta parte, encontré una dificultad pues hay un proyecto y obra particular que se asigna a los recursos transferidos por el gobierno central a los municipios. En este caso, registraba el primer municipio que encontraba, por lo tanto se perdía la información de cada municipio en este particular. Por lo tanto, como en el caso anterior, concatené el proyecto con el municipio para conectar la información.
![image](https://user-images.githubusercontent.com/112327873/189502563-16e2c8e9-a454-4715-9567-b3343f264e45.png)

El siguiente paso fue unir las tres bases de datos en una sola para cada archivo. En este punto, decidí unir la información en el archivo donde me mostraba la fuente de financiamiento individual para cada proyecto, por lo tanto tenía que añadir las columnas para los demás datos: Departamento, Municipio, Sector.

Para conocer el municipio del proyecto conecté la columna obra/actividad con el municipio de la base de datos que brinda la información del municipio y departamento a través de la función XLOOKUP, y luego conecté el departamento con el municipio con la misma función. 

Para el caso del sector tuve que conectar los datos con el proyecto, pues hasta este nivel llegaba la información en estos archivos. Además,  creé una columna concatenando el Ente y la institución a la que pertenecía el proyecto para luego unirla con la información base que estaba creando. 
![image](https://user-images.githubusercontent.com/112327873/189502570-9c8281bf-2ff2-4d2f-b6ac-459f1e410f2e.png)

Finalmente, solamente restaba unir la información de todos los años en un solo archivo. Para esto tuve que hacer uso de Python, ya que en Mac, la opción de unir bases de datos en un solo archivo (através de power query) aún no está disponible. Por lo tanto, copie cada pestaña, que se convirtió en los datos para un solo año, en un solo archivo. 

![image](https://user-images.githubusercontent.com/112327873/189502572-5e24ca4d-0e22-4241-8c5a-17ff0bc566ea.png)










[^1]: www.snip.gob.ni
[^2]: http://snip.gob.ni/Portada/PipAnual
[^3]: Es necesario destacar que la información que se publica en este sitio web es de toda la inversión pública del sector público no financiero: gobierno central, empresas públicas. Incluye parte de la inversión pública que hacen los gobiernos municipales, pero la que es financiada a través de las transferencias del gobierno central; no toma en cuenta las posibles inversiones que estos hacen con sus propios recursos, porque en muchos casos hay una deficiente contabilidad
