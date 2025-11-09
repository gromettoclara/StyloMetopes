---
DC.creator: Yves MARCOUX
lang: fr-CA
title: Mapping BibLaTeX → TEI
viewport: width=device-width, initial-scale=1.0
---

# Mapping BibLaTeX → TEI

Yves Marcoux

------------------------------------------------------------------------

## Comparaison BibTeX ↔ BibLaTeX {#d2e35}

2025-11-05 Je décide de comparer exhaustivement les formats BibTeX et
BibLaTeX, tels que vus par pandoc (puisque ultimement, c'est sur lui
qu'on s'appuie pour produire nos données-sources).

Basé sur
`D:\_YmaProjets\MarcelloVR\Haskell\pandoc-ym\src\Text\Pandoc\Citeproc\BibTeX.hs`.

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

Le manuel BibTex inclut deux types additionnels :

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

------------------------------------------------------------------------

## L'existant bibliographique stylo {#d2e125}

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

### Constats {#d2e190}

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

### Conclusions provisoires {#d2e279}

Selon moi, deux conclusions s'imposent :

1.  Il faut considérer qu'on travaille *de facto* en BibLaTeX. Donc,
    viser une méthodologie (protocole) axée sur ce format.
2.  Il **faut continuer à spécifier `-f biblatex`** pour l'opération
    `-t CSLJSON` car la suppression des `location` n'est pas viable.

------------------------------------------------------------------------

## Questions {#d2e304}

1.  Y aurait-il d'autres fichiers .bib plus « frais » à utiliser pour
    tester ?

2.  Certains de ces .bib semblent résulter d'un traitement
    automatique... d'où viennent-ils en fait ?

3.  Quelle est la politique / prescription pour le contenu TeX / LaTeX
    dans les données ? Exemples : `XIX$^{\textrm{e}}$ siècle` dans
    `dauphin_ces_1995`, `\textbar` dans `noauthor_tianjin_nodate`,
    `17$^{\textrm{eme}}$ siècle` dans `sauret_revue_2020`.

    Je note cependant que, dans ce dernier cas, le TeX est mal codé; il
    faudrait plutôt écrire : `17$^{\textrm{eme}}$ siècle`.

    Également,

4.  Même question pour les balises HTML ? Exemples : et `&lt;/p&gt;`
    (sûrement inutiles) dans `sauret_revue_2020`, `&lt;i&gt;` et
    `&lt;/i&gt;` dans `pierre-jean_raymonde_1993`.

    Une analyse plus poussée semble montrer que ces balises HTML sont en
    fait « codées » dans les .bib via des équivalents TeX, p.ex.
    `{\textless}p{\textgreater}` pour `&lt;p&gt;`.

5.  Comment des caractères Windows-1252 peuvent-ils se retrouver dans
    les .bib ?

6.  Serait-il pensable de passer les .bib dans une espèce de filtre de
    nettoyage avant ou après leur sauvegarde ?

    Un problème potentiel à considérer ici est si la clé d'id est
    elle-même fautive et doit être modifiée. Alors, ça implique une
    modification dans le .md de l'article, pour pointer à la clé
    modifiée.

------------------------------------------------------------------------

## Les formules mathématiques LaTeX / MathML {#d2e384}

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

------------------------------------------------------------------------
