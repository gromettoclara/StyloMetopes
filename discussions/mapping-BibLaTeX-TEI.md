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

## [Réflexions en date du 2025-11-22](#d2e20)

## [L'existant bibliographique stylo](#d2e44)

### [Constats](#d2e144)

### [Conclusions provisoires](#d2e220)

## [Questions](#d2e238)

## [Les formules mathématiques LaTeX / MathML](#d2e304)

### [Une approche possible pour les formules mathématiques](#d2e380)

## [L'existant Métopes](#d2e432)

------------------------------------------------------------------------
:::

## Réflexions en date du 2025-11-22 {#d2e20}

Je me questionne sur un titre approprié pour ce document. Oui, il
s'agira de mapper du BibLaTeX en TEI, mais le fait que le mapping se
fasse par l'intermédiaire du CSL teinte l'entièreté du processus. Le
fait qu'il s'effectue à l'aide pandoc aussi.

Ce que pandoc fait -- et très bien -- est de mapper un *sous-ensemble*
de BibLaTeX sur un *sous-ensemble* de CSL. Ces sous-ensembles sont
décrits plutôt bien dans l'[autre document de
réflexion](bib-pretraitement-pandoc.md).

En réalité, ma job est de mapper *ce sous-ensemble* de CSL sur TEI (ce
qui, incidemment, se trouvera à définir *de facto* un autre
sous-ensemble, de TEI celui-là !).

Du point de vue des auteurs et d'un « protocole de rédaction » (réel ou
virtuel -- puisque, qu'on en soit conscient ou non, il y a toujours au
moins un protocole implicite : ce qui marche vs ce qui ne marche pas),
c'est autour du sous-ensemble de BibLaTeX qu'il doit s'articuler.

Quoique, en réalité, s'il est vrai que la plupart des `.bib` sont en
fait dérivés de Zotero, c'est plutôt en fonction de Zotero qu'il
faudrait formuler un protocole de rédaction.

------------------------------------------------------------------------

## L'existant bibliographique stylo {#d2e44}

Je fusionne tout ce que j'ai comme fichiers `.bib` qui n'est pas de moi,
pour me faire une idée des usages bibliographiques pratiqués
actuellement dans stylo.

Mettre tous les fichiers `.bib` voulus dans un sandbox. Commande PS
`cat *.bib -Encoding UTF8 > megabib.txt`. Donne un fichier UTF-16-BOM,
mais le contenu est correct. Convertir en UTF8 sans BOM avec np++.
Renommer `megabib.bib`.

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
10 types suivants :

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
entrée rencontrée.

Je vois par hasard que SP1376.bib -- référence `adorno_minima_2003`
contient un caractère incorrect (mauvaise ligature \"œ\" = 9C en
Windows-1252), que je corrige.

Il y a aussi trois fois le problème
`[INFO] Not rendering RawInline (Format "latex") "\\textbar"`, mais
seulement à la génération du HTML, que je demande accessoirement, pour
avoir une référence de rendu. Ces messages sont causés par des
`\textbar` dans trois références, mais ne se produisent pas à la
génération de l'AST en XML ni lors du `-f biblatex -t CSLJSON` ou du
`-f biblatex -t xml`. En fait, `\textbar` n'est pas une des commandes
LaTeX reconnues par pandoc.

Je remplace les 3 occurrences de `{\textbar}` par `{|}`.

Ce sont les deux seules modifs que je fais dans `megabib.bib`.

On trouve dans `megabib.bib` les 9 types CSL suivants :

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

Requête XPath (sur `megabib.xml`) pour cette dernière liste :

``` {xml:space="preserve"}
string-join(distinct-values(
/*/meta/entry[2]/MetaList/MetaMap/entry[@key='type']/normalize-space()
), ' ')
```

Plus bien sûr le type vide, auquel pandoc mappe les `@misc`.

Des 43 champs CSL possibles, avec l'existant stylo (`megabib.bib`), on
ne retrouve que les 30 suivants dans l'extrant :

``` {xml:space="preserve"}
abstract
accessed
annote
author
chapter-number
collection-number
collection-title
container-title
doi
edition
editor
genre
isbn
issn
issue
issued
keyword
language
note
number
number-of-pages
page
pmid
publisher
publisher-place
title
title-short
translator
url
volume
```

Même requête que pour `gigabib.bib` dans le [document sur le
prétraitement](bib-pretraitement-pandoc.mb), mais avec `megabib.bib`.

Ce serait donc les 10 types et 30 champs CSL à traiter en priorité.

### Constats {#d2e144}

**Premier constat (2025-11-05) :** Les .bib que j'utilise dans mes tests
(et qui proviennent donc de stylo, sauf quelques références de mon cru)
**sont en fait du BibLaTeX**, tant par les *types* de références (qui
incluent un type \"movie\", qui n'existe pas en BibTeX, traduit par
pandoc en \"motion_picture\"), que (surtout) par les *champs* qu'ils
contiennent, dont beaucoup n'existent qu'en BibLaTeX, par exemple
`keywords`, `isbn`, `issn` et `urldate`.

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

### Conclusions provisoires {#d2e220}

Selon moi, deux conclusions s'imposent :

1.  Il faut considérer qu'on travaille *de facto* en BibLaTeX. Donc,
    viser une méthodologie (protocole) axée sur ce format.
2.  Il **faut continuer à spécifier `-f biblatex`** pour l'opération
    `-t xml` car la suppression des `location` n'est pas viable.

------------------------------------------------------------------------

## Questions {#d2e238}

1.  Y aurait-il d'autres fichiers .bib plus « frais » à utiliser pour
    tester ?

2.  Certains de ces .bib semblent résulter d'un traitement
    automatique... d'où viennent-ils en fait ?

3.  Quelle est la politique / prescription pour le contenu TeX / LaTeX
    dans les données ? Exemples : `XIX$^{\textrm{e}}$ siècle` dans
    `dauphin_ces_1995` (article `essai-HN-fictif.bib`), `\textbar` dans
    `noauthor_tianjin_nodate` (article `HN-02.bib`),
    `17$^{\textrm{eme}}$ siècle` dans `sauret_revue_2020` (article
    `humanistica2022-proposition-crcen`) et `\emph` dans
    `pierre-jean_raymonde_1993` (article `SP1339`).

4.  Même question pour des balises HTML « simulées » en TeX ? Exemples :
    `{\textless}p{\textgreater}` et `{\textless}/p{\textgreater}` dans
    `sauret_revue_2020` (article `humanistica2022-proposition-crcen`).

5.  Comment des caractères Windows-1252 peuvent-ils se retrouver dans
    les .bib ?

6.  Serait-il pensable de passer les .bib dans une espèce de filtre de
    nettoyage avant ou après leur sauvegarde ?

    Un problème potentiel à considérer ici est si la clé d'id est
    elle-même fautive et doit être modifiée. Alors, ça implique une
    modification dans le .md de l'article, pour pointer à la clé
    modifiée.

------------------------------------------------------------------------

## Les formules mathématiques LaTeX / MathML {#d2e304}

Mes essais avec les bibliographies me font bifurquer vers la question
des formules mathématiques, qui risquent d'être un problème épineux,
même si peu fréquent. Le problème est que le MathML en pandoc est pris
en charge par le *writer HTML !* Ce qui veut dire que dans l'AST, tout
ce qu'on a, c'est les formules LaTeX crues.

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

Mon idée actuellement (2025-11-06) est de créer une issue sur pandoc
pour demander qu'avec l'option `--mathml` et l'extension
`+tex_math_dollars`, le `-t XML` (et, pourquoi pas, `-t json`) appelle
texmath (une autre librairie de JGM, qui est déjà requise par pandoc)
pour traduire le LaTeX en MathML et mettre le MathML (je ne sais pas
encore sous quelle forme exactement) dans l'AST plutôt que les
`<Math math-type="InlineMath">…</Math>` ou
`<Math math-type="DisplayMath">…</Math>`.

*Voir plus bas une autre idée qui ne demande pas de modification a
pandoc.*

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

### Une approche possible pour les formules mathématiques {#d2e380}

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
typographiques (e.g. `*…*` pour l'italique). Ce type de champ inclut les
différentes parties d'un nom de personne ou le nom d'une maison
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
de mettre des formules LaTeX.

> *2025-11-12* Cette recension s'avère finalement assez laborieuse pour
> justifier son propre [document de
> réflexion](bib-pretraitement-pandoc.md).

------------------------------------------------------------------------

## L'existant Métopes {#d2e432}

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
retrouvent comme éléments TEI.

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
