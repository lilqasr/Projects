When I was learning SQL I read a lot of information about which projects to do in order to show the skills learnt. One that attracted a lot my attention was the analysis of your Spotify history. It is something interesting because this a very popular platform to listening music, podcast and others; also, a lot of my friends has it. And you know that at the end of the year Spotify sends you the resume of your year.

So, I decided to analize this data, and I read this article where the author gave me an idea of how to do it. The first thing is to get into your account and ask for your data. There is multiple data that this app keep from you (as like every app in the world), but you will need the request your “Account Data” which includes your streaming history of the past year. You can also request the “Your Extended streaming history”. They send you the first one in about 5 days, and the second one about 30 days. So I request both of them.

You will received a zip file with all the information containing multiple json file. For the Account Data you get a json file called Streaming history which is the data from the last year. That is what you will import to your DBMS, in this case I used mysql workbench.

This first file gives you information about the End Time of the song/track, the artist name, the track name, and the milliseconds played.

The second file is the extended streaming history, which includes the history for the lifetime of your account.



[This is my last year Streaming analysis:](https://github.com/lilqasr/Projects/blob/main/Projects_list/SQL/spotify2022.sql)

And [This is my extended Streaming history analysis:](https://github.com/lilqasr/Projects/blob/main/Projects_list/SQL/StremHistSpotify.sql)
