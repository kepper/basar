# Basar App
This is a small app for the the XML database [eXist] (versions 2.1 and 2.2 should work fine). In order to use, you need to zip the
contents from the basar-0.2 folder into basar-02.zip, rename that file to basar-02.xar. Then, in eXist's dashboard, 
open the Package Manager and install the basar app as new package. 

##Todos
A [node.js] / [grunt]-based version to facilitate the installation and development process would be great. 
The major issue of this application is input validation. Right now, almost nothing is done to prevent faulty input. Some Javascript validation is desperately needed here. 

In order to use the application, all *storing* xqueries need to have the right admin password. Right now, it uses eXist's default (admin pass unset). 



[eXist]:http://eXist-db.org
[node.js]:http://nodejs.org
[grunt]:http://gruntjs.com
