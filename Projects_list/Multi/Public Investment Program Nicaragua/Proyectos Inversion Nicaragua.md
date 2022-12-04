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

![Archivo 1](https://user-images.githubusercontent.com/112327873/205194045-b3744f0e-7bf7-48c8-ac5c-c85a02c311ff.png)

![Archivo 2](https://user-images.githubusercontent.com/112327873/205194088-69df7f7b-2f1f-463e-a4c7-74371420f8b4.png)

![Archivo 3](https://user-images.githubusercontent.com/112327873/205194118-e241bc2a-0749-4953-bb83-8089789a4f46.png)

### **Construcción de las bases de datos**

Para poder consolidar toda la información en una sola base de datos fue necesario unir los tres archivos; sin embargo, la estructura de estas bases de datos no tienen un esquema de registros por columnas, sino una especie de jerarquía, por lo que fue necesario, primero que todo, convertirlas cada una a un formato de registros por columnas. HE AQUÍ EL GRAN RETO!

Busqué algún ejemplo en internet sobre esto pero no encontré nada, porque no es algo común, así que lo hice de una manera algo rústica. Tuve que crear columnas para cada registro de las entidades de mi base de datos. Por ejemplo, en el primer archivo fueron: departamento, municipio, proyecto, obra, institución; en el segundo: Ente, institución, proyecto, obra, fuente; en el tercero: ente, sector, proyecto.

Lo que facilitó el trabajo fue que cada entidad tenía un color diferente, con lo que pude hacer lo siguiente, resumidamente: 

1)	En una nueva pestaña, copié la tabla con todos sus registros desagrupados:

![image](https://user-images.githubusercontent.com/112327873/205189252-edb79c21-766c-444d-94c0-822ecbfff0a8.png)

2)	Cree una columna para cada nivel de información.

![image](https://user-images.githubusercontent.com/112327873/205189450-52e47aaf-ed12-4686-afc8-a338d5e47e2a.png)

3)	Borré los registros que no pertenecían a cada columna, guiado por el color.

![image](https://user-images.githubusercontent.com/112327873/205189663-e3f19f2d-a433-4803-942a-956db012e91a.png)

4)	Rellené automáticamente cada columna con el registro al que pertenecía para que cada fila coincidiera al final con el último elemento. 

![image](https://user-images.githubusercontent.com/112327873/205189802-44146c40-425a-4f8e-89e1-85b492820973.png)

5)	Seguidamente fue necesario crear dos columnas para mostrar el tipo de fuente (interna o externa) y tipo de financiamiento (donación, préstamo, recursos del tesoro).
Para crear el tipo financiamiento usé la siguiente fórmula:

```
=IF(OR(H1103="Recursos del Tesoro", H1103="Recursos Propios", H1103="Ingresos con Destino Específico"), "Fondos Internos", "Fondos Externos")
```

Para crear el tipo de fuente (donación, préstamo o recurso interno), tuve que crear un fórmula que conectara las columnas de los datos de las fuentes de financiamiento:

```
=IF(M1106>0,"Recursos Propios", IF(N1106>0, "Recursos del Tesoro", IF(O1106>0, "Destino Específico", IF(P1106>0, "Donación", IF(Q1106>0, "Préstamo")))))
```

Nota: Antes de esto tuve problemas porque no identificaba bien la columna de la fuente con lo que había escrito en los códigos, por lo que tuve que eliminar los espacios iniciales de la columna con la función TRIM

![image](https://user-images.githubusercontent.com/112327873/205190946-e4b0d0f3-829d-4500-9478-8b732a72ac6a.png)

Este procedimiento lo apliqué con las tres bases de datos, para los años 2017-2022 y me quedó lo siguiente:

![image](https://user-images.githubusercontent.com/112327873/205191064-4a5dafec-6676-4fd2-b94f-a04be6c862f9.png)

Para el caso de esta base de datos, donde se muestra el sector al que pertenece el proyecto, tuve que agregar una columna con el nombre de la institución completa ya que el archivo solamente mostraba las siglas del nombre de la institución lo que iba afectar la conexión de la información. 
Nota: En esta parte, encontré una dificultad pues hay un proyecto y obra particular que se asigna a los recursos transferidos por el gobierno central a los municipios. En este caso, registraba el primer municipio que encontraba, por lo tanto se perdía la información de cada municipio en este particular. Por lo tanto, como en el caso anterior, concatené el proyecto con el municipio para conectar la información.

![image](https://user-images.githubusercontent.com/112327873/205191764-459c4fd4-d99f-4923-9397-58c9ccd86be0.png)

El siguiente paso fue unir las tres bases de datos en una sola para cada archivo. En este punto, decidí unir la información en el archivo donde me mostraba la fuente de financiamiento individual para cada proyecto, por lo tanto tenía que añadir las columnas para los demás datos: Departamento, Municipio, Sector.

Para conocer el municipio del proyecto conecté la columna obra/actividad con el municipio de la base de datos que brinda la información del municipio y departamento a través de la función XLOOKUP, y luego conecté el departamento con el municipio con la misma función. 

Para el caso del sector tuve que conectar los datos con el proyecto, pues hasta este nivel llegaba la información en estos archivos. Además,  creé una columna concatenando el Ente y la institución a la que pertenecía el proyecto para luego unirla con la información base que estaba creando. 

![image](https://user-images.githubusercontent.com/112327873/205191956-ceb72b7b-17b1-489e-8ec2-2ed9616130c6.png)

Finalmente, solamente restaba unir la información de todos los años en un solo archivo. Para esto tuve que hacer uso de Python, ya que en Mac, la opción de unir bases de datos en un solo archivo (através de power query) aún no está disponible. Por lo tanto, copie cada pestaña, que se convirtió en los datos para un solo año, en un solo archivo. 

![image](https://user-images.githubusercontent.com/112327873/189502572-5e24ca4d-0e22-4241-8c5a-17ff0bc566ea.png)

No sabía cómo realizar esto en Python, pero sabía que con Pandas había una solución y la encontré en la comunidad https://towardsdatascience.com/a-simple-trick-to-load-multiple-excel-worksheets-in-pandas-3fae4124345b; según este autor, es necesario leer el archivo de Excel y convertirlo en un diccionario de base de datos. Una vez hecho esto, se necesita concatenar las bases de datos (para esto es necesario colocar los mismos nombres para los encabezados de las columnas).

```python
import pandas as pd

df_dict = pd.read_excel('name and pathfile', sheet_name=None)

pip2017_2022 = pd.concat(df_dict.values(), ignore_index=True)
```

### **Limpiar la base de datos**

Otra parte complicada de esta base de datos fue su limpieza. Lo que facilitó el trabajo de unir toda esta información fue que la información individual más importante y la que guiaba la conexión de los datos fue la fuente de financiamiento de cada obra. Por lo que fue necesario homogenizar los nombres de las fuentes de información, que posiblemente cambiaron con el pasar de los años. También fue necesario hacer esto mismo para los campos de las instituciones, y sobre todos los Sectores, que su clasificación ha venido cambiando con el pasar de los años. 

Para realizar esta tarea existe una herramienta que se llama **[“Open refine”](https://openrefine.org/)**, una herramienta creada por la comunidad de software libre para trabajar con la limpieza de los datos. Esta herramienta es sumamente importante cuando se construyen este tipo de base de datos las cuales son de gran cantidad de registros y cuando se duda de la homogeneidad de su información. 

La herramienta es sumamente fácil de utilizar. Funciona con un programa ejecutador que se abre en tu navegador predeterminado y necesitas importar el archivo. Una vez importado te hará crear un proyecto y te enviará a la interfaz final donde se realizarán los cambios que deseas realizar a la base de datos.

![image](https://user-images.githubusercontent.com/112327873/205193631-fb0e888d-ca70-46cf-b308-b13813fa7b11.png)

Lo que me interesaba era lo que mencioné anteriormente, que los nombres de la información más importante fueran los mismos. Para eso se utiliza la herramienta de cluster, el cual se encuentra seleccionando la columna que se quiere transformar. Con esta opción se pueden hacer búsqueda de registros similares, pero que se identifican distintos pues difieren en su escritura.

![image](https://user-images.githubusercontent.com/112327873/205193803-0154a609-d582-42a1-a8b5-334d9492af37.png)

![image](https://user-images.githubusercontent.com/112327873/205193869-d99339fa-3810-4ed0-9afb-a8b395b83b6f.png)

Una vez limpia la base de datos, es posible descargar el archivo en cualquier formato. En ocasiones es posible repetir el proceso porque podría ser que al utilizar el programa para analizar los datos, se haya quedado algún dato sin limpiar








[^1]: www.snip.gob.ni
[^2]: http://snip.gob.ni/Portada/PipAnual
[^3]: Es necesario destacar que la información que se publica en este sitio web es de toda la inversión pública del sector público no financiero: gobierno central, empresas públicas. Incluye parte de la inversión pública que hacen los gobiernos municipales, pero la que es financiada a través de las transferencias del gobierno central; no toma en cuenta las posibles inversiones que estos hacen con sus propios recursos, porque en muchos casos hay una deficiente contabilidad
