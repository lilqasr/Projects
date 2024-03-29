# Nicaragua's Public investment
## Building a database based on information published by the central government

In Nicaragua, the information generated by the public sector is limited. 
There are few institution that publish relevant information about economy or social indicators. For example, 
The Central Bank of Nicaragua and the Ministry of Finance and Public Credit (MHCP) are among these; 
however, in terms of socio-demographic data, there is a notable lack of updated information. 

The population census has not been conducted for more than 15 years (last time in 2005); 
surveys on the standard of living (poverty) stopped being published since 2017. 
The only periodical publication published in this regard are the results of the Continuous Household Survey (ECH) 
that has been published quarterly by the National Institute of Development Information (INIDE). 

Depending on the subject that you want to study about public policies in Nicaragua, the information will be more or less. 
**For almost 10 years I have been analyzing the public finances of Nicaragua and some Central American countries and I have encountered these difficulties.
Nicaragua is at the tail end of fiscal transparency, so when we want to do this type of analysis we encounter many difficulties.** 

The Nicaraguan authorities that govern public finances to date have not been able to implement an information publication system that is easily 
accessible to analyze the data regarding this issue. For example, the BCN publishes most of its data in spreadsheet formats, 
implementing an "open data" policy to publicize the country's economic indicators; however, this has not been transferred to the MHCP. 

This project was one of the biggest chagellenge i've ever faced, but with the help of the recent tools learned, was easier than before. 
I needed to build this database on public investment in the different "departamentos" (regions or states) and municipalities of the country. 
For this I used the data published by the MHCP on the website of the National Public Investment System (SNIP). 
These are the only data that this ministry publishes in some form of "open data"[^1]. 

On this website you can find information on the public investment projects that the Non-Financial Public Sector implements in the country. 
There is data on the allocations (approved for the projects), as well as what is actually executed at the end of each year. 
It shows the institutions, projects, sectors, departments and municipalities, as well as the sources of financing. 

But not everything is easy; in order to build a complete database, it is necessary to join the information from the different files published on this site[^2].

### **Objectives and Methodology**.

The objective of this project was **to build a database in order to analyze how public investment in Nicaragua has evolved between 2017 and 2021**, knowing the following:

1. **which institutions execute**, 
2. **to which sectors the investment has been directed,** 
3. **who finances the projects, and above all,**
4. **to which departments and municipalities the resources are being directed**.

For this purpose, I made use of three files published by the SNIP. The first one presents information on the departments, municipalities, 
project and work and the institution in charge of executing it. 
The second shows information on the institutions and projects and the sources of financing. 
The third includes data on projects, sector and executing institution[^3].

Both the second file and the third one, the data published are the executed ones, but with the first one, they are updated budget data, that is, the last thing that is approved (or modified) during the year. This is not what is actually executed. Therefore, it was necessary to merge the data from the files where the departmental and municipal information is shown.

![Archivo 1](https://user-images.githubusercontent.com/112327873/205194045-b3744f0e-7bf7-48c8-ac5c-c85a02c311ff.png)

![Archivo 2](https://user-images.githubusercontent.com/112327873/205194088-69df7f7b-2f1f-463e-a4c7-74371420f8b4.png)

![Archivo 3](https://user-images.githubusercontent.com/112327873/205194118-e241bc2a-0749-4953-bb83-8089789a4f46.png)

## Construction of the data bases

In order to consolidate all the information in a single database it was necessary to merge the three files; 
however, the structure of these databases does not have a columnar record scheme, but a kind of hierarchy, so it was necessary, first of all, 
to convert each of them to a columnar record format. HERE IS THE BIG CHALLENGE!

I looked for some example on the internet about this but I didn't find anything, because it's not a common thing, so I did it in a kind of rustic way. 
I had to create columns for each record of the entities in my database. 
For example, in the first file were: department, municipality, project, work, institution; in the second: entity, institution, project, work, source; 
in the third: entity, sector, project.

What made the work easier was that each entity had a different color, so I was able to do the following, in brief: 

1) In a new tab, I copied the table with all its records ungrouped:

![image](https://user-images.githubusercontent.com/112327873/205189252-edb79c21-766c-444d-94c0-822ecbfff0a8.png)

2) Create a column for each level of information.

![image](https://user-images.githubusercontent.com/112327873/205189450-52e47aaf-ed12-4686-afc8-a338d5e47e2a.png)

3) I deleted the records that did not belong to each column, guided by the color.

![image](https://user-images.githubusercontent.com/112327873/205189663-e3f19f2d-a433-4803-942a-956db012e91a.png)

4) I automatically filled each column with the record it belonged to so that each row would match the last element at the end. 

![image](https://user-images.githubusercontent.com/112327873/205189802-44146c40-425a-4f8e-89e1-85b492820973.png)

5) Next it was necessary to create two columns to show the type of source (internal or external) and type of funding (grant, loan, treasury resources).
To create the type of funding I used the following formula:

```
=IF(OR(H1103="Recursos del Tesoro", H1103="Recursos Propios", H1103="Ingresos con Destino Específico"), "Fondos Internos", "Fondos Externos")
```

To create the source (of funding) type (grant, loan or internal resource), I had to create a formula to connect the columns of funding source data:

```
=IF(M1106>0,"Recursos Propios", IF(N1106>0, "Recursos del Tesoro", IF(O1106>0, "Destino Específico", IF(P1106>0, "Donación", IF(Q1106>0, "Préstamo")))))
```

Note: Before this, I had problems because I did not identify well the source column with what I had written in the codes, 
so I had to eliminate the initial spaces of the column with the TRIM function

![image](https://user-images.githubusercontent.com/112327873/205190946-e4b0d0f3-829d-4500-9478-8b732a72ac6a.png)

I applied this procedure with the three databases, for the years 2017-2022 and I was left with the following:

![image](https://user-images.githubusercontent.com/112327873/205191064-4a5dafec-6676-4fd2-b94f-a04be6c862f9.png)

In the case of this database, where the sector to which the project belongs is shown, I had to add a column with the name of the complete institution, 
since the file only showed the acronym of the name of the institution, which would affect the connection of the information. 

Note: In this part, I found a difficulty because there is a particular project and work that is assigned to the resources transferred by 
the central government to the municipalities. In this case, it registered the first municipality it found, 
therefore the information of each municipality in this particular was lost. Therefore, as in the previous case, 
I concatenated the project with the municipality to connect the information.

![image](https://user-images.githubusercontent.com/112327873/205191764-459c4fd4-d99f-4923-9397-58c9ccd86be0.png)

The next step was to merge the three databases into one for each file. At this point, I decided to merge the information in the file where it showed me the individual funding source for each project, so I had to add the columns for the other data: Department, Municipality, Sector.

To know the municipality of the project I connected the work/activity column with the municipality of the database that provides the information of the municipality and department through the XLOOKUP function, and then I connected the department with the municipality with the same function. 

In the case of the sector, I had to connect the data with the project, since the information in these files reached this level. In addition, I created a column concatenating the Entity and the institution to which the project belonged and then joined it with the base information I was creating. 

![image](https://user-images.githubusercontent.com/112327873/205191956-ceb72b7b-17b1-489e-8ec2-2ed9616130c6.png)

Finally, the only thing left to do was to merge the information of all the years in a single file. For this I had to make use of Python, since on Mac, the option to merge databases into a single file (through power query) is not yet available. Therefore, I copied each tab, which became the data for a single year, into a single file. 

![image](https://user-images.githubusercontent.com/112327873/189502572-5e24ca4d-0e22-4241-8c5a-17ff0bc566ea.png)

I did not know how to do this in Python, but I knew that with Pandas there was a solution and I found it in the community https://towardsdatascience.com/a-simple-trick-to-load-multiple-excel-worksheets-in-pandas-3fae4124345b; according to this author, you need to read the Excel file and convert it into a database dictionary. Once this is done, you need to concatenate the databases (for this you need to put the same names for the column headers).

```python

import pandas as pd

df_dict = pd.read_excel('name and pathfile', sheet_name=None)

pip2017_2022 = pd.concat(df_dict.values(), ignore_index=True)
```

## Cleaning the database

Another challenged part of building this database was the cleaning. But What made easier the cleaning part was that there was an individual information guiding the connection of each part of the database, which was the "Fuente de financiamiento" column. In this case was necessary to homogenize the names of this, that changed dependingo on year registered. The same thing was necessary to apply for the "institucion" column, and with "sectores"

To perform this task there is a tool called **[“Open refine”](https://openrefine.org/)**, that was created by the open source community to work on the cleaning of the "messy data". I found this extremely important when building this type of databases with a large number of records and when there is doubt about the homogenity of the information.

The tool is so easy to use it, and it works with a runner program that opens in your default browser. Once is open you have to upload the file interested on cleaning, and after that it will send you to the final interface where you make the changes.

![image](https://user-images.githubusercontent.com/112327873/205193631-fb0e888d-ca70-46cf-b308-b13813fa7b11.png)

In order to homogenize the names i was interested on, it used the cluster option, that is presented in every column as an option to clean the data. With this, you can identify the values/records that are similar and could be the same.

![image](https://user-images.githubusercontent.com/112327873/205193803-0154a609-d582-42a1-a8b5-334d9492af37.png)

![image](https://user-images.githubusercontent.com/112327873/205193869-d99339fa-3810-4ed0-9afb-a8b395b83b6f.png)

Once the cleaning is made, you can save the file in any data format. But then,  sometimes it is possible to repeat the process, because when you use the tool to analyse the data you can find out that there still remain uncleaned records.

## DATA ANALYSIS

The deep analysis of this data was made in a report that has not yet been published, but you can find a general analysis here:

**[PIP_2017-2022_ANALYSIS](https://nbviewer.org/github/lilqasr/Projects/blob/main/Projects_list/Multi/Public%20Investment%20Program%20Nicaragua/Public_Investment_Program%202017-2022%20Analysis.ipynb)**


[^1]: www.snip.gob.ni
[^2]: http://snip.gob.ni/Portada/PipAnual
[^3]: should be noted that the information published on this website is for all public investment in the non-financial public sector: central government, public enterprises. It includes part of the public investment made by the municipal (local) governments, which are financed through transfers from the central government; it does not take into account the possible investments that these make with their own resources, because in many cases there is a deficient accounting system.
