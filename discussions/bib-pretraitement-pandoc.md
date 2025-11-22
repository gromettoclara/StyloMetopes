---
DC.creator: Yves MARCOUX
lang: fr-CA
title: Prétraitement du BibLaTeX par pandoc
viewport: width=device-width, initial-scale=1.0
---

# Prétraitement du BibLaTeX par pandoc

Yves Marcoux

------------------------------------------------------------------------

## Généralités {#d2e19}

Le prétraitement du BibLaTeX par pandoc est finalement assez alambiqué
et loin d'être banal. J'ai analysé ce prétraitement avec de nombreux
tests diversifiés, décrits avec plus ou moins de précision en
[annexe](#annexe). Ce document présente les conclusions auxquelles
j'arrive.

Même si ce prétraitement n'est pas toujours optimal sémantiquement
(comme nous verrons, certaines séparations d'information présentes dans
le BibLaTeX sont parfois perdues), l'utilisation du BibLaTeX traité par
pandoc demeure une excellente option pour produire un bibliographie
sémantique (en TEI ou autre, d'ailleurs), notamment à cause de la prise
en charge des formules mathématiques. Cependant, *si* la possibilité de
présentait de disposer des données brutes dans un autre format que
BibLaTeX, par exemple dans un XML riche sémantiquement qui sortirait
directement de Zotero, il serait pertinent de reconsidérer cette option.

### Vue d'ensemble {#d2e29}

Le traitement effectué par pandoc est fortement influencé par trois
spécifications : celle de BibLaTeX, exposée dans [The `biblatex`
package](http://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf),
celle de
[CSL](https://citationstyles.org/developers/#/language-specification) et
celle de
[CSL-JSON](https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html).

Même quand pandoc prépare les données pour un autre format que CSL-JSON
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
    (ou absente), c'est `year` (bien ou mal formée) qui est utilisée au
    lieu.

2.  Interprétation des formules LaTeX. Les formules LaTeX ne sont jamais
    récupérables dans le CSL-JSON. Elles sont toujours reproduites comme
    telles en caractères, mais dans certains cas les \"\$\" sont
    éliminés. Dans les XML et dans *certains* champs, les formules LaTeX
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

Cependant, il est possible de contrôler jusqu'à un certain point la
typographie avec quelques commandes LaTeX et TeX qui sont reconnues et
interprétées dans *certains* champs.

1.  upright \\textup{Sample Text 0123} \\upshape *À vérifier*

2.  italic \\textit{Sample Text 0123} \\itshape

3.  ~~slanted \\textsl{Sample Text 0123} \\slshape~~

4.  ~~small caps \\textsc{Sample Text 0123} \\scshape~~

5.  {\\em } \\emph \\textrm

Dans le cas de bibliographies produites par `-t html --citeproc`, ces
commandes sont traduites dans les équivalents HTML. Dans notre cas,
elles seront récupérées du `-f biblatex -t xml` et traduites dans les
équivalents Métopes.

Dans une bibliographie sémantique, ces commandes typographiques doivent
être utilisées avec parcimonie et ne devraient surtout pas viser à
imiter un style bibliographique formaté.

Dans une bibliographie formatée, il faut être conscient que ces
commandes typographiques peuvent interférer avec les directives de
formatage du CSL appliqué. C'est bien sûr le cas des bibliographies
produites par `-t html --citeproc`, mais ce pourrait aussi être le cas
des versions formatées des références bibliographiques produites à
partir du `-t xml --citeproc`, si la conversion vers Métopes prévoit
ultimement la coexistence des références bibliographiques formatées et
sémantiques.

### Genres de prétraitement {#d2e150}

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

    Neuf types (parmi les 55 analysés) sont mappés à \"pas de type\"
    (i.e. `<entry key="type"><MetaString/></entry>`) (sans compter
    `@commentary`, voir ci-dessous) :

    - bibnote (pas surprenant : présenté comme un type « spécial »)
    - conference (*A legacy alias for* `@inproceedings`)
    - customa -- customf
    - misc

3.  **Mappage de noms de champ**

    La plupart des champs BibLaTeX sont mappés à des champs qui portent
    un nom différent. Par exemple, `series` est mappé sur
    `collection-title`, `shortjournal` sur `container-title-short`.

    Le champ `location` est ignoré, sauf dans les types `patent`, où il
    est mappé sur `jurisdiction`.

    Il y a des exceptions, par exemple : `abstract`, `doi`, `edition` ne
    changent pas de nom.

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

    Le type `@commentary` ne produit absolument aucun extrant, peu
    importe son contenu. Je soupçonne un bogue (ou du moins une
    idiosyncrasie très singulière) de pandoc dans ce cas, car rien dans
    le manuel BibLaTeX ne semble justifier ce comportement.

Tout ça peut devenir très complexe, et mes tests sont loin d'être
exhaustifs, mais ils montrent qu'on peut faire confiance à pandoc pour
la pertinence de ces prétraitements. Le plus important est donc d'être
conscient que ces prétraitements sont possibles.

------------------------------------------------------------------------

## Annexe

Les recensions suivantes faites avec `gigabib.bib`, la concaténation de
tous les exemples BibLaTeX que j'ai sous la main, incluant mes tests et
les exemples récents fournis par Clara dans le github `StyloMetopes`;
total 84 fichiers `.bib`, pour 578 références.

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

À l'interne, les références sont gérées dans pandoc avec cet ensemble de
99 variables :

(Source : `citeproc-jgm-3.8\src\Citeproc\Types.hs`)

``` {xml:space="preserve"}
abstract
accessed
annote
archive
archive-place
archive_collection
archive_location
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

Cette liste correspond probablement à l'ensemble des variables
manipulables en CSL. Clairement, une notice BibLaTeX, même pleinement
populée, ne renseigne qu'une partie de ces variables.

Noter que certaines variables sont composites, par exemple, tout ce qui
est nom de personne peut se décliner en `family`, `given`, etc.

De ces 99 variables, seules les 43 suivantes sont utilisées par pandoc
avec un intrant en BibLaTeX (ce pourrait être différent avec un intrant
en CSLJSON, par exemple) :

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
original-publisher
original-publisher-place
original-title
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
l'extrant `-t xml`. Noter qu'à ce stade, ils sont tous en minuscules
seulement.

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

De ces champs, seuls les 56 suivants sont traités par pandoc
(vérifications faites avec `megabib.bib`, ne comptant que mes 58
références à contenu contrôlé) :

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
```

Les 92 autres champs sont ignorés.

------------------------------------------------------------------------
