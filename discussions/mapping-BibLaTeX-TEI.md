---
DC.creator: Yves MARCOUX
lang: fr-CA
title: Mapping BibLaTeX → TEI
viewport: width=device-width, initial-scale=1.0
---

# Mapping BibLaTeX → TEI

Yves Marcoux

------------------------------------------------------------------------

## Comparaison BibTeX ↔ BibLaTeX {#d2e19}

2025-11-05 Je décide de comparer exhaustivement les formats BibTeX et
BibLaTeX, tels que vus par pandoc (puisque ultimement, c'est sur lui
qu'on s'appuie pour produire nos données-sources).

Basé sur
`D:\_YmaProjets\MarcelloVR\Haskell\pandoc-ym\src\Text\Pandoc\Citeproc\BibTeX.hs`.

### Types de référence {#d2e25}

D'abord, les *types* BibTeX et BibLaTeX. Des lignes 97-133, je déduis
les types BibTeX suivants :

1.  article
2.  book
3.  booklet
4.  inbook
5.  incollection
6.  inproceedings (synonyme = conference)
7.  mastersthesis
8.  phdthesis
9.  techreport
10. unpublished
11. misc

Le manuel LaTeX inclut deux types additionnels :

1.  manual
2.  proceedings

Cela doit impliquer que pandoc ne produira jamais en extrant des entrées
de ce type; cependant, il les accepte en intrant : les deux sont mappés
sur book (tests faits avec \@mvr2025_1 et \@mvr2025_2).

BibLaTeX ajoute les types suivants :

1.  dataset
2.  online
3.  inreference
4.  patent
5.  report
6.  artwork
7.  music
8.  jurisdictionN (probablement une typo)
9.  legislation
10. legal
11. letter
12. movie
13. review
14. software

### Les champs {#d2e65}

Des lignes 135 à 190, on constate les champs suivants pour **BibTeX** :

1.  \"author\"
2.  \"editor\"
3.  \"translator\"
4.  \"publisher\"
5.  \"title\"
6.  \"booktitle\"
7.  \"journal\"
8.  \"series\"
9.  \"edition\"
10. \"volume\"
11. \"number\"
12. \"pages\"
13. \"year\"
14. \"month\"
15. \"address\"
16. \"type\"
17. \"note\"
18. \"annote\"
19. \"url\" \-- not officially supported, but supported by some styles

Le manuel LaTeX ajoute :

1.  \"howpublished\"
2.  \"institution\"
3.  \"organization\"
4.  \"key\"
5.  \"school\"

Le manuel LaTeX dit que \"key\" devrait être fourni lorsque \"author\"
et \"editor\" sont tous les deux absents.

Il faudra faire des tests pour savoir ce que pandoc fait avec ces champs
quand ils sont présents. À vue de nez, je dirais qu'il les mappe à autre
chose.

S'ajoutent les champs suivants pour **BibLaTeX** :

1.  \"volumes\"
2.  \"pagetotal\"
3.  \"version\"
4.  \"date\"
5.  \"eventdate\"
6.  \"urldate\"
7.  \"doi\"
8.  \"isbn\"
9.  \"issn\"
10. \"entrysubtype\"
11. \"langid\"
12. \"abstract\"
13. \"keywords\"

Le manuel LaTeX précise qu'une entrée peut contenir d'autres champs (que
ceux énumérés) et qu'ils sont simplement ignorés lorsque le style
bibliographique ne les utilise pas.

Je pense que la référence ultime sur BibLaTeX est le manuel "The
biblatex Package" disponible en PDF
[ici](https://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf)
(j'en ai une copie dans mes `ressources-diverses`).

------------------------------------------------------------------------

## L'existant bibliographique stylo {#d2e129}

Je fusionne tous mes fichiers `.bib` (ou presque), pour me faire une
idée des pratiques bibliographiques supportées actuellement par stylo.

Mettre tous les fichiers `.bib` dans un sandbox. Commande PS
`cat *.bib -Encoding UTF8 > bigbib.txt`. Donne un fichier UTF-16-BOM,
mais le contenu est correct. Convertir en UTF8 sans BOM avec np++.
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

Apparemment, pandoc accepte tout ça sans broncher. Mais à tenir en
compte dans la conversion XML. Idéalement, ce serait de les interdire
directement dans les fichiers `.bib`.

Pour pouvoir obtenir du bon XML de pandoc, je corrige les \"/\" et
\":\", qui causent problème.

Je vois aussi par hasard que SP1376.bib contient un caractère incorrect
(mauvaise ligature \"œ\" = 9C en Windows-1252), que je corrige.

Il y a aussi un problème
`[INFO] Not rendering RawInline (Format "latex") "\\textbar"`, mais
seulement à la génération du HTML, que je demande accessoirement, pour
avoir une référence de rendu. Ce message est causé par un `\textbar`
dans la référence `noauthor_tianjin_nodate`, mais pas à la génération de
l'AST en XML ni lors du `-t CSLJSON`. En fait, `\textbar` n'est pas une
des commandes LaTeX reconnues par pandoc. La conséquence de cette erreur
est probablement la simple omission d'un caractère. Je l'ignore sans
scrupule.

J'appelle le résultat `tests-YMA-LOURDE.bib`.

### Constats {#d2e177}

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

### Conclusions provisoires {#d2e253}

Selon moi, deux conclusions s'imposent :

1.  Il faut considérer qu'on travaille *de facto* en BibLaTeX. Donc,
    viser une méthodologie (protocole) axée sur ce format.
2.  Il **faut continuer à spécifier `-f biblatex`** pour l'opération
    `-t xml` car la suppression des `location` n'est pas viable.

------------------------------------------------------------------------

## Questions {#d2e271}

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

## Les formules mathématiques LaTeX / MathML {#d2e337}

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

### Une approche possible pour les formules mathématiques {#d2e413}

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
