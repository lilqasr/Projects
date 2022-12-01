# PROJECT DESCRIPTION

This project was made as a part of a research that aimed to know the details of the Audit Reports published on the website of the Supreme Audit Institution in Nicaragua, "Contraloría General de la República".

The final product can be checked on this link: [Situación de la transparencia municipal en Nicaragua](https://urnasabiertas.com/wp-content/uploads/2022/09/UA_Situacion-de-la-Transparencia-Municipal.pdf)

The project consisted in build a database with the information published on the website of this public institution to compare with the Anual Institution Report, where it is informed how many audit reports are made every year. So, in order to do that, the process was divided in 2 main parts:

1.  Extracting the published files and getting the dataframe
2.  Cleaning the Dataframe
3.  Analysis of the Dataframe

## 1. [Extracting the published files and getting the dataframe](https://github.com/lilqasr/Projects/blob/c29e4352995d38e9987fc7ce17b90d74be68bc74/Projects_list/Python/Building%20dataset%20from%20website/1%20-%20Extract%20Files%20and%20Get%20Dataframe.ipynb)

In this part, i downloaded the files and the information to create the database by using the BeautifulSoup library. (In the above link you can find the Jupyter notebook file with all the codes i used - [Part 2](https://github.com/lilqasr/Projects/blob/c29e4352995d38e9987fc7ce17b90d74be68bc74/Projects_list/Python/Building%20dataset%20from%20website/2%20-%20Create%20DataSet%20from%20PDF%20Files-part2.ipynb)).

Once i downloaded the data and detect the information i needed for the dataframe, i saved it in a csv file to then, clean the data.

## 2. [Cleaning the dataframe](https://github.com/lilqasr/Projects/blob/main/Projects_list/Python/Building%20dataset%20from%20website/3%20-%20Clean%20dataset.ipynb)

After done the construction of the database, it was necessary to clean it, because i found that the information related to the name of the institution audited was so rough. So, for this purpose, i search out a library called **FuzzyWuzzy** that helps to clean string that are the same but written in differents ways.

Once this cleaning was done, i created a new column for my database were i get the correct names of the intitutions. The unique values for that column was reduced significantly.

## 3. [Analysis of the Dataframe]()
