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

Spécifiquement entre `-t csljson` et `-t xml`, la seule différence notée
est :

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

Une réalité pour les deux formats de sortie est la non prise en charge
du Markdown. Il n'est donc pas possible de jouer avec la typographie en
utilisant le Markdown. *vérifier lorsque -t html*

Certains auteurs ont pris l'habitude de « tricher » en codant des
balises HTML dans les différents champs, mais bien que cet artifice
fonctionne pour un `-t html` *vérifier*, ça ne pourra pas marcher en
biblio sémantique.

### Genres de prétraitement {#d2e113}

Mappage de noms de champs.

Séparation sémantique de certains champs (les « noms »).

Regroupement de certains champs.

Ignorance de certains champs.

Sémantique spécifique de certains champs BibLaTeX.

------------------------------------------------------------------------

## Annexe

*À venir.*

------------------------------------------------------------------------
