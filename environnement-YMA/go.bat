@echo off
rem Exemple : go martyr bib ast lat met num html
chcp 65001
set fich=%1
set dossin=articles\%fich%
set dossout=articles\%fich%\OUT
set dossaux=espace-dev-xslt

if "%2" == "bib" set dobib=oui
if "%3" == "bib" set dobib=oui
if "%4" == "bib" set dobib=oui
if "%5" == "bib" set dobib=oui
if "%6" == "bib" set dobib=oui
if "%7" == "bib" set dobib=oui
if "%2" == "ast" set doast=oui
if "%3" == "ast" set doast=oui
if "%4" == "ast" set doast=oui
if "%5" == "ast" set doast=oui
if "%6" == "ast" set doast=oui
if "%7" == "ast" set doast=oui
if "%2" == "lat" set dolat=oui
if "%3" == "lat" set dolat=oui
if "%4" == "lat" set dolat=oui
if "%5" == "lat" set dolat=oui
if "%6" == "lat" set dolat=oui
if "%7" == "lat" set dolat=oui
if "%2" == "met" set domet=oui
if "%3" == "met" set domet=oui
if "%4" == "met" set domet=oui
if "%5" == "met" set domet=oui
if "%6" == "met" set domet=oui
if "%7" == "met" set domet=oui
if "%2" == "num" set donum=oui
if "%3" == "num" set donum=oui
if "%4" == "num" set donum=oui
if "%5" == "num" set donum=oui
if "%6" == "num" set donum=oui
if "%7" == "num" set donum=oui
if "%2" == "htm" set dohtml=oui
if "%3" == "htm" set dohtml=oui
if "%4" == "htm" set dohtml=oui
if "%5" == "htm" set dohtml=oui
if "%6" == "htm" set dohtml=oui
if "%7" == "htm" set dohtml=oui
if "%2" == "html" set dohtml=oui
if "%3" == "html" set dohtml=oui
if "%4" == "html" set dohtml=oui
if "%5" == "html" set dohtml=oui
if "%6" == "html" set dohtml=oui
if "%7" == "html" set dohtml=oui

echo #### Début job #### > %dossout%\%fich%.log
@echo off

if "%dobib%" == "oui" pandoc --standalone --verbose ^
  -f biblatex -t xml %dossin%\%fich%.bib -o %dossout%\%fich%.bib.xml ^
  2>> %dossout%\%fich%.log
if "%dobib%" == "oui" echo on
if "%dobib%" == "oui" echo #### Fin BIB XML #### >> %dossout%\%fich%.log
@echo off

if "%doast%" == "oui" pandoc --standalone --verbose --citeproc ^
  -f markdown+raw_html -t xml --metadata=link-citations:true ^
  --bibliography %dossin%\%fich%.bib ^
  --csl %dossaux%\chicago-author-date-YMA.csl ^
  --metadata-file %dossin%\%fich%.yaml ^
  %dossin%\%fich%.md -o %dossout%\%fich%.AST.xml ^
  2>> %dossout%\%fich%.log
rem --section-divs --mathml +tex_math_dollars (ces options ne changent rien en -t xml)
if "%doast%" == "oui" echo on
if "%doast%" == "oui" echo #### Fin AST XML #### >> %dossout%\%fich%.log
@echo off

if "%dolat%" == "oui" java -jar "C:\ProgMesProg\saxon\saxon-he-12.9.jar" ^
  -xsl:%dossaux%\latex2md.xsl ^
  -o:%dossout%\%fich%.latex.md -s:%dossout%\%fich%.AST.xml ^
  2>> %dossout%\%fich%.log
if "%dolat%" == "oui" pandoc --standalone --verbose ^
  -f markdown -t html4 --mathml -o %dossout%\%fich%.mathml.xml ^
  --template %dossaux%\template-body.txt ^
  %dossout%\%fich%.latex.md 2>> %dossout%\%fich%.log
if "%dolat%" == "oui" echo on
if "%dolat%" == "oui" echo #### Fin md2mathml #### >> %dossout%\%fich%.log
@echo off

if "%domet%" == "oui" java -Dfile.encoding=UTF-8 ^
  -jar "C:\ProgMesProg\saxon\saxon-he-12.9.jar" ^
  -xsl:%dossaux%\toMetopesCommons.xsl ^
  -s:%dossout%\%fich%.AST.xml -o:%dossout%\%fich%.metopesCommons.xml ^
  imagePath="../icono/br/" !indent=yes ^
  2>> %dossout%\%fich%.log
if "%domet%" == "oui" echo on
if "%domet%" == "oui" echo #### Fin XML Métopes #### >> %dossout%\%fich%.log
@echo off

if "%donum%" == "oui" java -jar "C:\ProgMesProg\saxon\saxon-he-12.9.jar" ^
  -xsl:%dossaux%\toMC-numerotation.xsl ^
  -s:%dossout%\%fich%.metopesCommons.xml -o:%dossout%\%fich%.metopesCommonsFinal.xml ^
  2>> %dossout%\%fich%.log
if "%donum%" == "oui" echo on
if "%donum%" == "oui" echo #### Fin Métopes numérotation #### >> %dossout%\%fich%.log
@echo off

if "%dohtml%" == "oui" pandoc --standalone --verbose --section-divs ^
  --table-of-contents --citeproc ^
  -f markdown+tex_math_dollars+raw_html -t html --mathml ^
  --bibliography %dossin%\%fich%.bib ^
  --csl %dossaux%\chicago-author-date-YMA.csl ^
  %dossin%\%fich%.yaml ^
  %dossin%\%fich%.md -o %dossout%\%fich%.html ^
  2>> %dossout%\%fich%.log
if "%dohtml%" == "oui" echo on
if "%dohtml%" == "oui" echo #### Fin HTML #### >> %dossout%\%fich%.log
