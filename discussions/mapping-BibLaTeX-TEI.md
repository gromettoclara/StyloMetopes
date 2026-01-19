---
DC.creator: Yves MARCOUX
lang: fr-CA
title: Mapping BibLaTeX → TEI
viewport: width=device-width, initial-scale=1.0
---

# Mapping BibLaTeX → TEI

Yves Marcoux

------------------------------------------------------------------------

::: {#tHe_TDM}
# Table des matières

## [Réflexions en date du 2025-11-22, 2026-01-17](#d2e20)

## [L'existant bibliographique stylo](#d2e41)

### [Composition du corpus](#d2e45)

### [Premiers constats et conséquences](#d2e73)

### [Nettoyage du corpus](#d2e167)

### [Qualité des données bibliographiques entrantes](#d2e251)

## [Aperçu de BibLaTeX](#d2e309)

### [Types bibliographiques BibLaTeX](#d2e310)

### [Champs BibLaTeX](#d2e319)

## [Aperçu de CSL](#d2e325)

### [Types bibliographiques CSL](#d2e326)

### [Champs CSL](#d2e331)

## [Prétraitement du BibLaTeX par pandoc](#d2e349)

### [Généralités](#d2e350)

### [Vue d'ensemble](#d2e356)

### [Commandes typographiques LaTeX](#d2e432)

### [Genres de prétraitement](#d2e563)

## [Les formules mathématiques LaTeX / MathML](#d2e818)

### [Une approche possible pour les formules mathématiques](#d2e894)

## [L'existant stylo une fois converti en CSL](#d2e939)

## [L'existant Métopes](#d2e1229)

## [Annexe](#annexe)

### [Mappage des types](#d2e1287)

### [Mappage des champs](#d2e1574)

### [Conclusions](#d2e1621)

------------------------------------------------------------------------
:::

## Réflexions en date du 2025-11-22, 2026-01-17 {#d2e20}

Je me questionne sur un titre approprié pour ce document. Oui, il
s'agira de mapper du BibLaTeX en TEI, mais le fait que le mapping se
fasse par l'intermédiaire du CSL teinte l'entièreté du processus. Le
fait qu'il s'effectue à l'aide pandoc aussi.

Ce que pandoc fait -- et très bien -- est de mapper un *sous-ensemble*
de BibLaTeX sur un *sous-ensemble* de CSL. Ces sous-ensembles sont
décrits plutôt bien ci-dessous. Et en réalité, ma job est de mapper *ce
sous-ensemble* de CSL sur TEI (ce qui, incidemment, se trouvera à
définir *de facto* un autre sous-ensemble, de TEI celui-là !).

Du point de vue des auteurs et d'un « protocole de rédaction » (réel ou
virtuel -- puisque, qu'on en soit conscient ou non, il y a toujours au
moins un protocole implicite : ce qui marche vs ce qui ne marche pas),
c'est autour du sous-ensemble de BibLaTeX qu'il doit s'articuler. Cela
dit, s'il est vrai que la plupart des `.bib` sont en fait dérivés de
Zotero, c'est plutôt en fonction de Zotero qu'il faudrait formuler un
protocole de rédaction.

Le traitement que fait pandoc du BibLaTeX n'est pas toujours optimal
sémantiquement (par exemple, plusieurs types BibLaTeX sont mappés sur le
même type CSL et certaines séparations d'information présentes dans le
BibLaTeX sont parfois perdues). Malgré tout, l'utilisation du BibLaTeX
traité par pandoc demeure une excellente option pour produire un
bibliographie sémantique (en TEI ou autre, d'ailleurs), notamment à
cause de la prise en charge des formules mathématiques. Cependant, *si*
la possibilité se présentait de disposer des données brutes dans un
autre format que BibLaTeX, par exemple dans un XML riche sémantiquement
qui sortirait directement de Zotero, il serait pertinent de reconsidérer
cette option.

------------------------------------------------------------------------

## L'existant bibliographique stylo {#d2e41}

*Section vérifiée courante 2026-01-17.*

### Composition du corpus {#d2e45}

Je fusionne tout ce que j'ai comme fichiers `.bib` qui n'est pas de moi,
pour me faire une idée des usages bibliographiques pratiqués
actuellement dans stylo.

> **Pour ce faire :**
>
> Mettre tous les fichiers `.bib` voulus dans un sandbox. Commande PS
> `cat *.bib -Encoding UTF8 > megabib.txt`. Donne un fichier UTF-16-BOM,
> mais le contenu est correct. Convertir en UTF8 sans BOM avec np++.
> Renommer `megabib.bib`.

Cet existant (`megabib.bib`) compte les 23 bibliographies suivantes :

``` {xml:space="preserve"}
calculer-la-semantique-avec-ieml.bib
copy-copy-litteratube-chap1.bib
copy-psp1486.bib
copy-rf0038.bib
copy-savard-arseneault-article.bib
copy-sp1785-introduction-remediation.bib
demo-2023-09-29.bib
essai-HN-fictif.bib
HN-02.bib
humanistica2022-proposition-crcen.bib
nvcq02003.bib
nvcq02005.bib
nvcq02008.bib
nvcq02009.bib
SP1339.bib
SP1368.bib
SP1376.bib
SP1391.bib
SP1395.bib
SP1407.bib
SP1414.bib
SP1423.bib
SP1436.bib
```

Ce qui totalise 519 occurrences de référence, dont 508 distinctes, des
10 types bibliographiques suivants :

``` {xml:space="preserve"}
@article
@audio
@book
@incollection
@inproceedings
@misc
@movie
@phdthesis
@techreport
@unpublished
```

et comportant des champs des 43 types suivants :

``` {xml:space="preserve"}
abstract 
address 
annote 
author 
booktitle 
chapter 
collaborator 
copyright 
date 
doi 
edition 
editor 
editora 
editoratype 
editorb 
editorbtype 
file 
institution 
isbn 
issn 
issue 
journal 
journaltitle 
keywords 
language 
location 
month 
note 
number 
pages 
pagetotal 
pmid 
publisher 
school 
series 
shorttitle 
title 
translator 
type 
url 
urldate 
volume 
year
```

### Premiers constats et conséquences {#d2e73}

**Premier constat (2025-11-05) :** Les .bib de l'existant stylo, **sont
en fait du BibLaTeX**, tant par les *types* de références (qui incluent
un type \"movie\", qui n'existe pas en BibTeX, traduit par pandoc en
\"motion_picture\"), que (surtout) par les *champs* qu'ils contiennent,
dont beaucoup n'existent qu'en BibLaTeX, par exemple `keywords`, `isbn`,
`issn` et `urldate`.

**Deuxième constat :** Le fait de spécifier `-f bibtex` ou `-f biblatex`
ne semble changer que très peu de choses dans l'opération `-t CSLJSON`
de pandoc. Il ne semble en tout cas *pas* affecter la reconnaissance des
champs BibLaTeX, y compris ceux qui n'existent qu'en BibLaTeX.

Pour en avoir le cœur net, je génère deux bibliographies en XML
(résultat de la conversion du CSLJSON en XML par saxon) :
`tests-YMA.bib-BIBTEX.xml` et `tests-YMA.bib-BIBLATEX.xml` et les
compare dans np++. Voici les différences observées :

1.  Le champ `publisher` est traité en BibLaTeX comme un champ \"noms\"
    (donc, où les \"and\" sont traités sémantiquement comme séparateurs
    d'occurrences), alors qu'il est traité comme un champ texte en
    BibTeX.
2.  Le champ `location` est traité comme synonyme de `address` en
    BibLaTeX alors qu'il est ignoré en BibTeX.

Dans le second cas, le résultat avec BibLaTeX est toujours meilleur
qu'avec BibTeX. Mais dans le premier cas, ça dépend si le remplacement
des \"and\" par un \";\" est heureux ou non. Dans mes tests (clé
`fillmore_case_1968` dans `calculer-la-semantique-avec-ieml`), le
changement est malheureux, résultant en :

> \"publisher\": \"Holt, Rinehart,; Winston\"

avec BibLaTeX au lieu de :

> \"publisher\": \"Holt, Rinehart, and Winston\"

avec BibTeX. Le remède est de flanquer le `and` d'accolades dans le
`.bib` : `Hold, Rinehart, {and} Winston` (ce que je fais, en plus
d'enlever la virgule d'Oxford, qui n'est *pas* dans le nom officiel). Ce
détail est aussi à préciser par protocole ou, si nécessaire,
automatiser.

Évidemment, ces tests ne sont pas exhaustifs, il n'est donc pas exclus
qu'il y ait d'autres différences.

2025-11-15 Je m'oriente maintenant vers `-f biblatex -t xml`, qui
résulte en quelque chose de plus riche que `-t CSLJSON`, mais cela ne
compromet pas la validité des constats présentés.

**Deux conséquences de ces constats :**

1.  Il faut considérer qu'on travaille *de facto* en BibLaTeX. Donc,
    viser une chaîne de traitement axée sur ce format.
2.  Il **faut continuer à spécifier `-f biblatex`** pour l'opération
    `-t xml` car la suppression des `location` n'est pas viable.

### Nettoyage du corpus {#d2e167}

Filtrer sur @ pour avoir les clés. Expression régulière à utiliser pour
repérer les mauvais caractères dans les clés :
`[^a-z0-9\,\{\}\@\012\015 \-\.\_]`.

Clés \"douteuses\" repérées, contenant caractères accentués ou un de
\"`/:`\" (interdits dans les `@xml:id`) :

1.  \@BOOK{luisdegóngora1582,
2.  \@INCOLLECTION {anamaríabarranechea1988,
3.  \@book{louvel_texte/image_2002,
4.  \@book{mbembe_postcolonie:\_2000,
5.  \@book{stael_litterature:\_1998,

Apparemment, pandoc accepte tout ça sans broncher. À surveiller dans la
conversion vers XML.

Il ne bronche pas non plus sur les duplications de clé (qui n'arrivent
jamais en temps normal); selon mes tests sommaires, il prend la dernière
entrée rencontrée. Je prends quand même la peine d'**éliminer les
doublons (1)**, conservant pour chacun la version la plus riche (le plus
de champs).

Je vois par hasard que SP1376.bib -- référence `adorno_minima_2003`
contient un caractère incorrect (mauvaise ligature \"œ\" = 9C en
Windows-1252), que **je corrige (2)**.

Il y a aussi trois fois le problème
`[INFO] Not rendering RawInline (Format "latex") "\\textbar"`, mais
seulement à la génération du HTML, que je demande accessoirement, pour
avoir une référence de rendu. Ces messages sont causés par des
`\textbar` dans trois références, mais ne se produisent pas à la
génération de l'AST en XML ni lors du `-f biblatex -t CSLJSON` ou du
`-f biblatex -t xml`. En fait, `\textbar` n'est pas une des commandes
LaTeX reconnues par pandoc.

**Je remplace (3)** les 3 occurrences de `{\textbar}` par `{|}`.

Ce sont les **trois seules modifs** que je fais dans `megabib.bib`;
j'appelle le résultat `megabib-sans-doublon.bib`.

**Un problème particulier**, découvert sur le tard 2026-01-18 et que je
n'ai **pas corrigé** est que l'article SP1436 comporte quatre références
(ndiaye_y_2011, cointe_y_2012, heymann_y_nodate,
l.\_hart_nibbrig_voix_2008) utilisant les champs `editora` et
`editoratype = {collaborator}`, qui ne sont pas traités par pandoc, donc
entièrement ignorés. Pourtant, leur utilisation ici semble tout à fait
en accord avec ce qui est dit sur le champ `editortype` en page 19 du
manuel BibLaTeX, pour coder un collaborateur. pandoc pourrait très bien
traiter le cas `editoratype = {collaborator}` en plaçant en extrant les
noms des `editora` dans le champ CSL `contributor`.

À moins d'interdire par protocole l'utilisation de ces champs (et de
proposer une solution de rechange), il faudrait probablement faire une
issue pour demander à JGM que pandoc traite correctement le cas
`editoratype = {collaborator}`.

Noter que l'article SP1436 comporte une cinquième référence avec
`editoratype = {collaborator}` (taieb_interview_nodate), mais il s'agit
d'une erreur, car le champ `editora` n'y est pas renseigné.

### Qualité des données bibliographiques entrantes {#d2e251}

Ces points devraient être considérés en réfléchissant à un éventuel
protocole pour les données entrantes.

1.  Quelle est la politique / prescription pour le contenu TeX / LaTeX
    dans les données ? Exemples : `XIX$^{\textrm{e}}$ siècle` dans
    `dauphin_ces_1995` (article `essai-HN-fictif.bib`), `\textbar` dans
    `noauthor_tianjin_nodate` (article `HN-02.bib`),
    `17$^{\textrm{eme}}$ siècle` dans `sauret_revue_2020` (article
    `humanistica2022-proposition-crcen`) et `\emph` dans
    `pierre-jean_raymonde_1993` (article `SP1339`).

2.  Même question pour des balises HTML « simulées » en TeX ? Exemples :
    `{\textless}p{\textgreater}` et `{\textless}/p{\textgreater}` dans
    `sauret_revue_2020` (article `humanistica2022-proposition-crcen`).

3.  Comment des caractères Windows-1252 peuvent-ils se retrouver dans
    les .bib ?

4.  Serait-il pensable de passer les .bib dans une espèce de filtre de
    nettoyage avant ou après leur sauvegarde ?

    Un problème potentiel à considérer ici est si la clé d'id est
    elle-même fautive et doit être modifiée. Alors, ça implique une
    modification dans le .md de l'article, pour pointer à la clé
    modifiée.

------------------------------------------------------------------------

## Aperçu de BibLaTeX {#d2e309}

### Types bibliographiques BibLaTeX {#d2e310}

Le manuel BibLaTeX mentionne 56 types bibliographiques suivants :

``` {xml:space="preserve"}
article
artwork
audio
bibnote
book
bookinbook
booklet
collection
commentary
conference
customa
customb
customc
customd
custome
customf
dataset
electronic
image
inbook
incollection
inproceedings
inreference
jurisdiction
legal
legislation
letter
manual
mastersthesis
misc
movie
music
mvbook
mvcollection
mvproceedings
mvreference
online
patent
performance
periodical
phdthesis
proceedings
reference
report
review
software
standard
suppbook
suppcollection
suppperiodical
techreport
thesis
unpublished
video
www
xdata
```

Cependant le type `@xdata` n'est pas utilisé pour produire une
référence, ce qui laisse 55 types utilisables.

### Champs BibLaTeX {#d2e319}

Le manuel BibLaTeX mentionne les 148 champs suivants :

``` {xml:space="preserve"}
abstract
addendum
address
afterword
annotation
annotator
annote
archiveprefix
author
authortype
bookauthor
bookpagination
booksubtitle
booktitle
booktitleaddon
chapter
commentator
crossref
date
doi
edition
editor
editora
editoratype
editorb
editorbtype
editorc
editorctype
editortype
eid
entryset
entrysubtype
eprint
eprintclass
eprinttype
eventdate
eventtitle
eventtitleaddon
execute
file
foreword
gender
holder
howpublished
ids
indexsorttitle
indextitle
institution
introduction
isan
isbn
ismn
isrn
issn
issue
issuesubtitle
issuetitle
issuetitleaddon
iswc
journal
journalsubtitle
journaltitle
journaltitleaddon
key
keywords
label
langid
langidopts
language
library
lista
listb
listc
listd
liste
listf
location
mainsubtitle
maintitle
maintitleaddon
month
namea
nameaddon
nameatype
nameb
namebtype
namec
namectype
note
number
options
organization
origdate
origlanguage
origlocation
origpublisher
origtitle
pages
pagetotal
pagination
part
pdf
presort
primaryclass
publisher
pubstate
related
relatedoptions
relatedstring
relatedtype
reprinttitle
school
series
shortauthor
shorteditor
shorthand
shorthandintro
shortjournal
shortseries
shorttitle
sortkey
sortname
sortshorthand
sorttitle
sortyear
subtitle
title
titleaddon
translator
type
url
urldate
usera
userb
userc
userd
usere
userf
venue
verba
verbb
verbc
version
volume
volumes
xdata
xref
year
```

Le manuel LaTeX précise qu'une entrée peut contenir d'autres champs (que
ceux énumérés) et qu'ils sont simplement ignorés lorsque le style
bibliographique ne les utilise pas.

------------------------------------------------------------------------

## Aperçu de CSL {#d2e325}

### Types bibliographiques CSL {#d2e326}

La doc de CSL -- en particulier son schéma RNG -- mentionne ces 45 types
bibliographiques :

``` {xml:space="preserve"}
article
article-journal
article-magazine
article-newspaper
bill
book
broadcast
chapter
classic
collection
dataset
document
entry
entry-dictionary
entry-encyclopedia
event
figure
graphic
hearing
interview
legal_case
legislation
manuscript
map
motion_picture
musical_score
pamphlet
paper-conference
patent
performance
periodical
personal_communication
post
post-weblog
regulation
report
review
review-book
software
song
speech
standard
thesis
treaty
webpage
```

### Champs CSL {#d2e331}

La doc de CSL -- en particulier son schéma RNG -- mentionne ces 98
champs, qu'ils appellent « variables » :

``` {xml:space="preserve"}
abstract
accessed
annote
archive
archive-place
archive_collection (sic)
archive_location (sic)
author
authority
available-date
call-number
chair
chapter-number
citation-key
citation-label
citation-number
collection-editor
collection-number
collection-title
compiler
composer
container-author
container-title
container-title-short
contributor
curator
dimensions
director
division
DOI
edition
editor
editor-translator
editorial-director
event
event-date
event-place
event-title
executive-producer
first-reference-note-number
genre
guest
host
illustrator
interviewer
ISBN
ISSN
issue
issued
jurisdiction
keyword
language
license
locator
medium
narrator
note
number
number-of-pages
number-of-volumes
organizer
original-author
original-date
original-publisher
original-publisher-place
original-title
page
page-first
part-number
part-title
performer
PMCID
PMID
printing-number
producer
publisher
publisher-place
recipient
references
reviewed-author
reviewed-genre
reviewed-title
scale
script-writer
section
series-creator
source
status
submitted
supplement-number
title
title-short
translator
URL
version
volume
volume-title
year-suffix
```

De son côté, pandoc gère les références bibliographiques avec ces mêmes
variables, plus une : `container`, de type Date (donc 99 variables en
tout). Je n'ai pas investigué comment pandoc utilise la variable
additionnelle. (Source :
<https://hackage.haskell.org/package/citeproc-0.12/docs/Citeproc-Types.html>)

Noter que certaines variables sont composites, par exemple, tout ce qui
est nom de personne peut se décliner en `family`, `given`, etc.

------------------------------------------------------------------------

## Prétraitement du BibLaTeX par pandoc {#d2e349}

### Généralités {#d2e350}

Le prétraitement du BibLaTeX par pandoc est finalement assez alambiqué
et loin d'être banal. J'ai analysé ce prétraitement avec de nombreux
tests diversifiés, décrits avec plus ou moins de précision en
[annexe](#annexe). Ce document présente les conclusions auxquelles
j'arrive.

### Vue d'ensemble {#d2e356}

Le traitement effectué par pandoc est fortement influencé par trois
spécifications : celle de BibLaTeX, exposée dans [The `biblatex`
package](http://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf),
celle de
[CSL](https://citationstyles.org/developers/#/language-specification) et
celle de
[CSL-JSON](https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html).

Même quand pandoc prépare les données pour un format autre que CSL-JSON
(par exemple, pour XML lors d'un `-f biblatex -t xml` ou en préparation
d'une bibliographie lors d'un `-t html --citeproc`), le traitement et la
structuration résultante sont essentiellement les mêmes que pour une
sortie en CSL-JSON.

Spécifiquement entre `-t csljson` et `-t xml`, les seules différences
notées sont :

1.  Pour les champs BibLaTeX `date`, `eventdate` et `year`, lorsque la
    date (ou l'année) est bien formée, elle est scindée en une liste de
    trois nombres (un seul si l'info provient de `year`) appelée
    `date-parts` dans le champ CSL-JSON `issued` ou `event-date`. Si la
    date (ou l'année) est mal formée, l'info présente est simplement
    copiée dans le XML (comme `MetaString`), alors que la liste
    `date-parts` est laissée vide en CSL-JSON (`"date-parts": []`) et
    l'info mal formée est perdue.

    Tant pour `-t csljson` que pour `-t xml`, si `date` est indécodable
    (ou absente), c'est `year` (bien ou mal formée) qui est utilisée.

2.  Interprétation des formules LaTeX. Les formules LaTeX ne sont jamais
    récupérables dans le CSL-JSON. Elles sont toujours reproduites comme
    telles en caractères, mais dans certains cas les \"\$\" sont
    éliminés. Dans le XML et dans *certains* champs, les formules LaTeX
    sont taguées `Math` avec `@math-type="InlineMath"` ou
    `"DisplayMath"`, selon que la formule est flanquée de \"\$\" simples
    ou doubles. Dans les autres champs, cependant, elles sont traitées
    comme en CSL-JSON, c'est-à-dire qu'elles sont reproduites comme des
    suites de caractères avec, dans certains cas, les \"\$\" éliminés.

Une réalité pour les deux formats de sortie (et pour toute forme de
restitution de ce qui vient de BibLaTeX) est la non reconnaissance du
Markdown ou du HTML imbriqué (de quelque façon que ce soit). Il n'est
donc pas possible de jouer avec la typographie en utilisant du Markdown
ou du HTML imbriqué dans les références BibLaTeX.

### Commandes typographiques LaTeX {#d2e432}

Cependant, il est possible de contrôler jusqu'à un certain point la
typographie avec *quelques* commandes de formatage LaTeX et TeX
reconnues *hors mode mathématique* (i.e. sans \$ ou \$\$ comme
délimiteurs) et interprétées dans *certains* champs BibLaTeX. À 95% de
certitude, selon mes tests sommaires, ce sont les mêmes champs que ceux
où les *formules mathématiques* LaTeX sont permises et correctement
interprétées.

Tout indique que `citeproc` (et non un writer quelconque) traduit déjà
ces commandes dans l'AST en éléments pandoc habituels, tels `<Emph>`,
`<Strong>` et `<SmallCaps>`.

Voici une recension préliminaire des commandes typographiques LaTeX qui
fonctionnent *hors mode mathématique* dans *certains* champs BibLaTeX :

  Commande        Traduction dans l'AST `-t xml`
  --------------- --------------------------------
  {\\rm ...}      \<Span\>
  \\textrm{...}   \<Span class=\"roman\"\>
  {\\em ...}      \<Emph\>
  {\\it ...}      \<Emph\>
  {\\sl ...}      \<Emph\>
  \\textit{...}   \<Emph\>
  {\\bf ...}      \<Strong\>
  \\textbf{...}   \<Strong\>
  {\\tt ...}      \<Code\>
  \\texttt{...}   \<Code\>
  \\textup{...}   \<Span class=\"upright\"\>
  \\textsf{...}   \<Span class=\"sans-serif\"\>
  \\textsc{...}   \<SmallCaps\>

  : Commandes LaTeX reconnues en BibLaTeX

Noter les deux formes différentes de commande LaTeX.

Noter aussi qu'aucune de ces commandes ne fonctionne hors mode
mathématique en Markdown; ceci ne concerne pas le BibLaTeX, où le MD est
ignoré, mais s'applique à l'article lui-même et aux métadonnées
(intégrées à l'article ou dans un YAML séparé).

Noter enfin que ce traitement, très particulier, de ces commandes
spécifiques n'a rien à voir avec le mode mathématique de LaTeX. En mode
mathématique (i.e. avec \$ ou \$\$ comme délimiteurs), ces commandes
peuvent ou non fonctionner. La question relève du sous-ensemble précis
de LaTeX reconnu par `texmath` (le package utilisé par pandoc pour
traiter le LaTeX). Je n'ai pas fait de test sur ce point.

Dans le cas de bibliographies produites par `-t html --citeproc`, ces
commandes, traduites en éléments AST, sont converties en équivalents
HTML. Dans notre cas, elles seront récupérées de l'AST en XML (produit
par `-f biblatex -t xml`) et traduites dans les équivalents Métopes.

**Considération protocolaire pour auteurs :** Dans une bibliographie
sémantique, ces commandes typographiques *ne devraient pas être
utilisées*, puisque la présentation relève du CSL. Si elles sont
utilisées, elles doivent l'être utilisées avec extrême parcimonie. En
effet, il faut être conscient que, dans une bibliographie formatée, ces
commandes typographiques peuvent interférer avec les directives de
formatage du CSL appliqué. C'est bien sûr le cas des bibliographies
produites par `-t html --citeproc`, mais ce pourrait aussi être le cas
des versions formatées des références bibliographiques produites à
partir du `-t xml --citeproc`, si le schéma (ODD) Métopes prévoit
ultimement la coexistence des références bibliographiques formatées et
sémantiques (ce qui correspond à ce que j'ai implanté en date du
2025-12-04, et semble bien reçu par Métopes).

Illustration de la structure de bibliographie proposée par mon
implantation le 2025-12-04:

``` {xml:space="preserve"}
<listBibl>
   <bibl subtype="formatted" xml:id="ref-rollet_bebes_2000">
      <p>Rollet, Catherine, et Marie-France Morel. 2000.
        <hi rend="italic">Des bébés et des hommes.
        Traditions et modernité des soins aux tout-petits</hi>. Albin Michel.</p>
   </bibl>
   <biblStruct subtype="semantic" type="book" xml:id="semref-rollet_bebes_2000">
      <monogr>
         <title level="m">Des bébés et des hommes.
           Traditions et modernité des soins aux tout-petits</title>
         <imprint>
            <date>2000</date>
            <pubPlace>Paris</pubPlace>
            <publisher>Albin Michel</publisher>
         </imprint>
      </monogr>
   </biblStruct>
</listBibl>
```

### Genres de prétraitement {#d2e563}

Les prétraitements réellement effectués pour une référence (entrée)
donnée varient en fonction du type de référence, des champs présents, de
leurs valeurs et même parfois du fichier de références dans son ensemble
(par exemple via le champ `crossref`).

1.  **Traitement des abréviations**

    S'il y a des commandes `@string{`*`abrev`*` = "`*`chaîne`*`"}`
    (section B.1.3 du manuel LaTeX) n'importe où dans le fichier
    BibLaTeX, elles sont exécutées et globalement prises en compte dans
    l'analyse du fichier.

2.  **Mappage de types**

    Par exemple, `letter` est mappé sur le type CSL
    `personal_communication`, `image` et `artwork` sur `graphic`.

    Des 55 types BibLaTeX utilisables, 46 sont mappés à \"quelque
    chose\", alors que les 9 suivants sont mappés à \"pas de type\"
    (i.e. `<entry key="type"><MetaString/></entry>`) :

    - `@bibnote` (pas surprenant : présenté comme un type « spécial »)
    - `@conference` (*A legacy alias for* `@inproceedings`)
    - `@customa` -- `@customf`
    - `@misc` (pourtant documenté dans le livre LaTeX comme un type en
      bonne et due forme)

    Je traiterai ces 9 types de la même façon:
    `biblStruct[@type='misc']`, une fois rendus en TEI Métopes. On peut
    arguer que pandoc devrait mapper `@conference` sur
    `paper-conference`, puisque c'est sur ce type que `@inproceedings`
    est mappé, mais on n'y peut rien.

    Le mappage de types n'est cependant pas unique, il peut être affecté
    par les champs présents dans la notice. En l'occurrence,
    `@unpublished` est le plus souvent mappé à `manuscript`, mais si un
    des champs `eventtitle`, `eventdate` et `venue` est présent, il est
    mappé sur `speech`. Surprenamment, c'est le seul cas.

    Aussi, tel que mentionné ailleurs, le mappage de types n'est pas
    injectif : plusieurs types BibLaTeX sont mappés sur le même type
    CSL.

3.  **Mappage de noms de champ**

    **REVOIR À PARTIR D'ICI**

    La plupart des champs BibLaTeX sont mappés à des champs qui portent
    un nom différent. Par exemple, `series` est mappé sur
    `collection-title`, `shortjournal` sur `container-title-short`.

    En l'absence du champ `address`, `location` est considéré comme son
    synonyme. Cependant, si `address` est présent, `location` est
    ignoré, sauf dans les types `patent`, où il est mappé sur
    `jurisdiction`.

    `annote` est synonyme d'`annotation`. Cependant, si ce dernier est
    présent, `annote` est ignoré.

    `journal` est synonyme de `journaltitle`. Cependant, si ce dernier
    est présent, `journal` est ignoré.

    Il y a des exceptions, par exemple : `abstract`, `doi`, `edition`
    sont mappés sur des champs de même nom.

4.  **Séparation sémantique de certains champs (les « noms »)**

    Dans les champs susceptibles de contenir des noms, les noms sont
    séparés l'un de l'autre sur présence du mot `and`. De plus, chaque
    nom est découpé en `family`, `given`, de même que d'éventuelles
    particules, comme `dropping-particle` ou `non-dropping-particle`.

5.  **Modification sémantique de certains champs**

    Dans certains champs, le mot `and` indique une séparation, mais ne
    donne pas lieu à une subdivision du champ; le `and` est plutôt
    remplacé par de la ponctuation. Par exemple, dans le champ
    `address`, qui est mappé sur `publisher-place`, le `and` est
    remplacé par un point-virgule.

6.  **Regroupement de certains champs (avec ponctuation)**

    Par exemple, les champs `issuetitle` et `issuesubtitle` sont
    ignorés, sauf dans les types `periodical`, où ils sont fusionnés
    (avec ponctuation) avec `maintitleaddon` et mappés sur `title`.

7.  **Ignorance de certains champs**

    92 des 148 champs BibLaTeX sont ignorés par pandoc. Voir ci-dessous.

8.  **Actuation de la sémantique spécifique de certains champs
    BibLaTeX**

    Les champs `crossref` et `xref` se comportent de façon très
    particulière, mise en application par pandoc.

9.  **Actuation de la sémantique de certains types BibLaTeX (ou bogue de
    pandoc)**

    Certains types entraînent l'ajout automatique de certains champs
    avec une valeur prédéterminée. Par exemple, le type `phdthesis` est
    mappé à `thesis`, mais avec l'ajout automatique du champ `genre`
    avec valeur `Master’s thesis` (à moins que le champ `type` soit
    présent dans l'entrée, dans quel cas il est mappé à `genre`).

    Le type `@xdata` se comporte de façon très particulière, mise en
    application par pandoc.

Tout ça peut devenir très complexe, et mes tests sont loin d'être
exhaustifs, mais ils montrent qu'on peut faire confiance à pandoc pour
la pertinence de ces prétraitements. Le plus important est donc d'être
conscient que ces prétraitements sont possibles.

------------------------------------------------------------------------

## Les formules mathématiques LaTeX / MathML {#d2e818}

Mes essais avec les bibliographies me font bifurquer vers la question
des formules mathématiques en général, pas seulement dans la
bibliographie, qui risquent d'être un problème épineux, même si peu
fréquent. Le problème est que le MathML en pandoc est pris en charge par
le *writer HTML !* Ce qui veut dire que dans l'AST, tout ce qu'on a,
c'est les formules LaTeX crues.

L'extension `-f markdown+tex_math_dollars` (qui est activée par défaut
pour du md en intrant) ne change pratiquement rien lorsque `-t XML`; ce
que je retiens de mes tests, c'est qu'il ne faut pas la désactiver (sans
l'extension, les `$` sont considérés comme du texte, notamment, ce qui
n'est pas souhaitable; sinon, c'est pas mal du pareil au même, avec un
balisage différent...) !

Fait quand même étonnant : même quand on désactive `tex_math_dollars`
(`-f markdown-tex_math_dollars`), elle est quand même appliquée dans le
traitement de la bibliographie.

L'option `--mathml`, sur laquelle on aurait pu fonder quelque espoir, ne
change rigoureusement rien pour un `-f md -t XML` (vérification faite).

J'avais pensé au départ (2025-11-06) de créer une issue sur pandoc pour
demander qu'avec l'option `--mathml` et l'extension `+tex_math_dollars`,
le `-t XML` (et, pourquoi pas, `-t json`) appelle texmath (une autre
librairie de JGM, qui est déjà requise par pandoc) pour traduire le
LaTeX en MathML et mettre le MathML (je ne sais pas encore sous quelle
forme exactement) dans l'AST plutôt que les
`<Math math-type="InlineMath">…</Math>` ou
`<Math math-type="DisplayMath">…</Math>`.

Finalement, j'ai eu une autre idée (ci-dessous), avalisée par Marcello,
qui ne demande pas de modification a pandoc.

Notes sur le LaTeX accepté par `texmath` (qui fait le travail pour
pandoc) :

1.  Il semble y avoir un bug avec `\textrm`, quand on veut l'utiliser
    avec un seul caractère, il faut quand même mettre ce caractère entre
    {}. Contrairement, p.ex., à `\texttt`, avec lequel on peut omettre
    les {}. En fait, ça semble plutôt que `\texttt` bénéficie d'un
    traitement de faveur, comparé aux autres.
2.  Jusqu'ici, j'ai essayé `\textrm`, `\texttt` et `\textbf`;
    probablement que d'autres marchent aussi (`\textit`).
3.  Il ne reconnaît ni `\mit`, ni `\cal`.
4.  On ne peut mettre aucune commande de police dans une `\mbox{}`.

Cela dit, c'est extrêmement impressionnant tout ce qu'il arrive à gérer
et, qui plus est, à traduire en MathML. Ce que les navigateurs (comme
Firefox) arrivent à faire avec le MathML est aussi très impressionnant.

### Une approche possible pour les formules mathématiques {#d2e894}

pandoc est très accueillant pour LaTeX dans le md. Il serait donc
naturel que les formules math. soient rédigées en LaTeX dans le md.

Comme mentionné, c'est l'option `--mathml` du writer HTML qui gère la
traduction en MathML (via le package `texmath`, aussi de JGM et intégré
à pandoc). L'idée est d'ajouter des étapes à la chaîne de traitement
pour faire du `-f md -t html` et récupérer le MathML. Ça semble tordu,
mais ça marche, et avec un overhead très faible.

Pour les formules dans l'article lui-même, c'est très simple. Mais pour
les formules en bibliographie (dans un titre, par exemple, ou un
sous-titre, en fait n'importe quel champ qui n'est pas traité par pandoc
comme un simple chaîne de caractères^\*^), c'est tout aussi faisable,
mais ça demande encore une ou peut-être deux étapes additionnelles (peu
coûteuses, cependant, encore une fois).

^\*^Il faut comprendre la limite suivante, intrinsèque au traitement
sémantique que fait pandoc du BibLaTeX : certains champs (en général,
les champs « courts ») sont traités comme de simples chaînes de
caractères et ne peuvent donc pas avoir de formules, ni d'artifices
typographiques MD (e.g. `*…*` pour l'italique). Ce type de champ inclut
les différentes parties d'un nom de personne ou le nom d'une maison
d'édition (même si on pourrait *a priori* légitimement appeler une
maison d'édition "Les éditions √π").

Le fin mot de l'histoire est que :

- Nulle part dans une référence BibLaTeX le MD habituel n'est reconnu
  comme tel (`*…*`, `**…**`, etc.).
- Cependant, dans les champs qui sont convertis en `MetaInlines` (plutôt
  qu'en `MetaString`), les formules LaTeX sont reconnues et taguées
  comme telles dans l'AST de la bibliographie.

> *2025-11-10* En visio avec Clara et Marcello, on décide qu'on va de
> l'avant avec cette approche.

Prochaine étape : répertorier exactement les champs BibLaTeX qui sont
traduits en `MetaInlines`. Ça correspondra aux champs où il est possible
de mettre des formules LaTeX (utile pour un éventuel protocole).

------------------------------------------------------------------------

## L'existant stylo une fois converti en CSL {#d2e939}

**RENDU ICI**

Des 98 variables CSL possibles, mes tests montrent que seuls les 46
champs CSL suivants peuvent être produits en extrant par pandoc avec un
intrant en BibLaTeX (ce pourrait probablement être différent avec un
intrant dans un autre format, CSLJSON par exemple) :

``` {xml:space="preserve"}
abstract
accessed
annote
author
call-number
chapter-number
collection-number
collection-title
container-author
container-title
container-title-short
doi
edition
editor
event
event-date
event-place
genre
isbn
issn
issue
issued
jurisdiction
keyword
language
note
number
number-of-pages
number-of-volumes
original-date
original-publisher
original-publisher-place
original-title
other-ids
page
pmid
publisher
publisher-place
status
title
title-short
translator
url
version
volume
volume-title
```

Il s'agit des noms de champ qu'on retrouve comme `entry/@key` dans
l'extrant `-t xml` (excluant `id` et `type`). Noter qu'à ce stade, ils
sont tous en minuscules seulement.

Requête XPath (sur `gigabib.xml`) pour liste précédente :

``` {xml:space="preserve"}
for $mot in tokenize("
abstract
accessed
annote
archive
archive-place
archive_collection
archive_location
archive-collection
archive-location
author
authority
available-date
call-number
chair
chapter-number
citation-key
citation-label
citation-number
collection-editor
collection-number
collection-title
compiler
composer
container
container-author
container-title
container-title-short
contributor
curator
dimensions
director
division
doi
edition
editor
editor-translator
editorial-director
event
event-date
event-place
event-title
executive-producer
first-reference-note-number
genre
guest
host
illustrator
interviewer
isbn
issn
issue
issued
jurisdiction
keyword
language
license
locator
medium
narrator
note
number
number-of-pages
number-of-volumes
organizer
original-author
original-date
original-publisher
original-publisher-place
original-title
page
page-first
part-number
part-title
performer
pmcid
pmid
printing-number
producer
publisher
publisher-place
recipient
references
reviewed-author
reviewed-genre
reviewed-title
scale
script-writer
section
series-creator
source
status
submitted
supplement-number
title
title-short
translator
url
version
volume
volume-title
year-suffix
") return $mot || " " ||
    count(/*/meta/entry[2]/MetaList/MetaMap/entry[@key=$mot])
```

------------------------------------------------------------------------

Le fichier `megabib-sans-doublon.bib` génère en extrant XML des
références des 9 types CSL suivants :

``` {xml:space="preserve"}
book
article-journal
chapter
report
paper-conference
thesis
manuscript
motion_picture
song
```

> Requête XPath (sur `megabib-sans-doublon.xml`) pour cette dernière
> liste :
>
> ``` {xml:space="preserve"}
> string-join(distinct-values(
> /*/meta/entry[2]/MetaList/MetaMap/entry[@key='type']/normalize-space()
> ), ' ')
> ```

Plus bien sûr le type vide, auquel pandoc mappe les `@misc`.

Des 46 champs CSL possibles, on ne retrouve que les 30 suivants dans
l'extrant XML produit par l'existant stylo (`megabib-sans-doublon.bib`).
Les voici par ordre de priorité descendante (fréquence sur 508
entrées) :

  -------------------------- -----
  title                      507
  issued                     503
  author                     487
  publisher                  321
  publisher-place            303
  container-title            193
  title-short                159
  page                       139
  url                        124
  isbn                       107
  issue                      104
  volume                     95
  note                       83
  abstract                   79
  collection-title           67
  accessed                   65
  doi                        63
  issn                       46
  keyword                    41
  edition                    39
  editor                     31
  translator                 20
  language                   17
  collection-number          14
  pmid                       13
  number-of-pages            7
  chapter-number             6
  genre                      6
  annote                     3
  number                     3
  call-number                0
  container-author           0
  container-title-short      0
  event                      0
  event-date                 0
  event-place                0
  jurisdiction               0
  number-of-volumes          0
  original-date              0
  original-publisher         0
  original-publisher-place   0
  original-title             0
  other-ids                  0
  status                     0
  version                    0
  volume-title               0
  -------------------------- -----

Requête XPath sur `megabib-sans-doublon.xml` :

``` {xml:space="preserve"}
for $mot in tokenize("
abstract
… (liste des (46 - 2) autres champs possibles)
volume-title
") return $mot || " " ||
count(/*/meta/entry[2]/MetaList/MetaMap/entry[@key=$mot])
```

Ce serait donc les 10 types (9 ci-dessus + type vide) et 30 champs CSL à
traiter en priorité. (Vérifié 2026-01-17.)

------------------------------------------------------------------------

## L'existant Métopes {#d2e1229}

2025-11-26 Il n'y a actuellement *aucun* élément `biblStruct` dans la
totalité des fichiers fournis comme exemples.

Il y a cependant des `bibl` à profusion. Ils semblent se décliner en
deux types de contenu très différents, selon qu'ils sont sous
`publicationStmt` ou non.

Ce qu\'on trouve sous `bibl` hors `publicationStmt` :

``` {xml:space="preserve"}
text()
hi
author
ref
title
date
biblScope
```

De plus, les `p` ne sont actuellement pas permis, il me semble qu'ils
devraient l'être.

Sous `publicationStmt`, `bibl` n'a aucun contenu mixte, que ces
sous-éléments :

``` {xml:space="preserve"}
publisher
availability
date
biblScope
idno
ref
distributor
dim
name
```

`formula` y est interdit et devrait être permis, selon moi.

J'ai constaté, un peu avec effroi, que le MathML est embarqué dans leur
TEI *sans namespace*. Autrement dit, tous les éléments MathML se
retrouvent comme éléments TEI. 2026-01-16 Lors de la visio du 4 décembre
2025 à l'UdeM avec Métopes, ils ont reconnu que c'était un faux pas et
qu'ils allaient faire les modifications requises pour que le MathML soit
bel et bien dans son namespace.

Notes en vrac 2025-11-26:

J'ai fait quelques mods dans le .rng (version appelée
commons-publishing-metopes-YMA.rng) et je définis un scénario pour
valider avec lui (je garde aussi le scénario pour le .rng actuel
intouché). Mes mods représentent en fait des suggestions.

Une d'elles est de garder le MathML dans son namespace naturel, car les
outils se basent là-dessus pour reconnaître et traiter le MathML
(browser, oXygen, feuilles de style standard TEI).

À part pour cette modif, as of 2025-11-26 midi, tous les documents dans
histoire-indent valident avec mon rng (autant qu'avec l'intouché). Ce
n'est pas le cas de unit_tests-indent, mais ceux-là ne valident pas non
plus avec l'intouché.

Je me plie à l'intouché pour les codeblock's (donc inline indiqué
explicitement; sinon block par défaut). Je modifie mon ajout css local
en conséquence (\"D:\_YmaProjets\\MarcelloVR\\codeblock.YMA.css\").

------------------------------------------------------------------------

## Annexe {#annexe}

Analyses basées sur la référence ultime sur BibLaTeX : le manuel "The
biblatex Package," disponible en PDF
[ici](https://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf)
(j'en ai une copie dans mes `ressources-diverses`).

### Mappage des types {#d2e1287}

Voici le mapping de types fait par pandoc :

  ---------------- ------------------------
  BibLaTeX         CSL
  article          article-journal
  artwork          graphic
  audio            song
  bibnote          
  book             book
  bookinbook       chapter
  booklet          pamphlet
  collection       book
  commentary       book
  conference       
  customa          
  customb          
  customc          
  customd          
  custome          
  customf          
  dataset          dataset
  electronic       webpage
  image            graphic
  inbook           chapter
  incollection     chapter
  inproceedings    paper-conference
  inreference      entry-encyclopedia
  jurisdiction     legal_case
  legal            treaty
  legislation      legislation
  letter           personal_communication
  manual           book
  mastersthesis    thesis
  misc             
  movie            motion_picture
  music            song
  mvbook           book
  mvcollection     book
  mvproceedings    book
  mvreference      book
  online           webpage
  patent           patent
  performance      speech
  periodical       article-journal
  phdthesis        thesis
  proceedings      book
  reference        book
  report           report
  review           review
  software         software
  standard         legislation
  suppbook         chapter
  suppcollection   chapter
  suppperiodical   article-journal
  techreport       report
  thesis           thesis
  unpublished      manuscript *ou* speech
  video            motion_picture
  www              webpage
  ---------------- ------------------------

  : Mapping de types fait par pandoc

Rappelons que le mapping de `unpublished` est affecté par les champs
présents dans la notice (voir plus haut).

### Mappage des champs {#d2e1574}

Certains des 148 champs BibLaTeX sont traités dans tous les 55 types de
références bibliographiques. C'est le cas par exemple de `abstract`,
`addendum` et `title`. D'autres ne sont traités que dans certains types
de références ou lorsque d'autres champs spécifiques sont aussi
présents. Par exemple, les champs `subtitle` et `titleaddon` ne sont en
général traités que si le champ `title` est aussi présent. Cependant,
dans certains types bibliographiques, comme par exemple `mastersthesis`
et `phdthesis`, tous les champs sont traités, peu importe les autres
champs éventuellement présents.

Il faut aussi savoir que certains champs BibLaTeX sont parfois fusionnés
dans l'extrant CSL. Ainsi, les

seuls les 58 suivants sont traités par pandoc (vérifications faites avec
`kilobib.bib`, ne comptant que mes 55 références à contenu contrôlé) :

``` {xml:space="preserve"}
abstract
addendum
address
annotation
author
bookauthor
booksubtitle
booktitle
booktitleaddon
chapter
date
doi
edition
editor
eventtitle
howpublished
ids
institution
isbn
issn
issue
issuesubtitle
issuetitle
journalsubtitle
journaltitle
keywords
langid
library
location
mainsubtitle
maintitle
maintitleaddon
note
number
organization
origlocation
origpublisher
origtitle
pages
pagetotal
part
publisher
pubstate
school
series
shortjournal
shorttitle
subtitle
title
titleaddon
translator
type
url
venue
version
volume
volumes
year
```

Requête XPath (sur `kilobib.xml`) pour liste précédente :

``` {xml:space="preserve"}
for $mot in tokenize("
abstract
addendum
address
afterword
annotation
annotator
annote
archiveprefix
author
authortype
bookauthor
bookpagination
booksubtitle
booktitle
booktitleaddon
chapter
commentator
crossref
date
doi
edition
editor
editora
editoratype
editorb
editorbtype
editorc
editorctype
editortype
eid
entryset
entrysubtype
eprint
eprintclass
eprinttype
eventdate
eventtitle
eventtitleaddon
execute
file
foreword
gender
holder
howpublished
ids
indexsorttitle
indextitle
institution
introduction
isan
isbn
ismn
isrn
issn
issue
issuesubtitle
issuetitle
issuetitleaddon
iswc
journal
journalsubtitle
journaltitle
journaltitleaddon
key
keywords
label
langid
langidopts
language
library
lista
listb
listc
listd
liste
listf
location
mainsubtitle
maintitle
maintitleaddon
month
namea
nameaddon
nameatype
nameb
namebtype
namec
namectype
note
number
options
organization
origdate
origlanguage
origlocation
origpublisher
origtitle
pages
pagetotal
pagination
part
pdf
presort
primaryclass
publisher
pubstate
related
relatedoptions
relatedstring
relatedtype
reprinttitle
school
series
shortauthor
shorteditor
shorthand
shorthandintro
shortjournal
shortseries
shorttitle
sortkey
sortname
sortshorthand
sorttitle
sortyear
subtitle
title
titleaddon
translator
type
url
urldate
usera
userb
userc
userd
usere
userf
venue
verba
verbb
verbc
version
volume
volumes
xdata
xref
year
") return $mot || " " ||
    count(/*/meta/entry[2]//*[(self::MetaInlines or self::MetaString) and tokenize(.)=$mot])
```

résultat auquel il faut ajouter `annote`, `date`, `journal` et `year` à
la main (pour les raisons données plus haut).

~~Les 92 autres champs sont ignorés.~~ 2026-01-16 Faux, aucun des champs
n'est complètement ignoré.

### Conclusions {#d2e1621}

Traiter les 30 champs CSL identifiés ci-dessus.

Voici ce qu'on peut retrouver directement sous `MetaInlines` dans le
`-t xml` (`distinct-values(/*/meta/entry[2]//MetaInlines/*/name())`) :

``` {xml:space="preserve"}
Emph
Math
Quoted
Space
Span
Str
```

Si on regarde tous les descendants
(`distinct-values(/*/meta/entry[2]//MetaInlines//*/name())`), ça ajoute
juste `RawInline`.

------------------------------------------------------------------------
