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
et loin d'être banal. Par de nombreux tests très diversifiés, décrits
avec plus ou moins de précision en [annexe](#annexe), voici les
conclusions auxquelles j'arrive.

**Vue d'ensemble**

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

> Pour les champs BibLaTeX `date`, `eventdate` et `year`, lorsque la
> date (ou l'année) est bien formée, elle est scindée en une liste de
> trois nombres (un seul si l'info provient de `year`) appelée
> `date-parts` dans le champ CSL-JSON `issued` ou `event-date`. Si la
> date (ou l'année) est mal formée, l'info présente est simplement
> copiée (comme `MetaString`), alors que la liste `date-parts` est
> laissée vide en CSL-JSON (`"date-parts": []`) et l'info mal formée est
> perdue.
>
> Tant pour `-t csljson` que pour `-t xml`, si `date` est indécodable
> (ou absente), c'est `year` (bien ou mal formée) qui est utilisée au
> lieu.

**Genres de prétraitement**

Mappage de noms de champs.

Séparation sémantique de certains champs (les « noms »).

Regroupement de certains champs.

Ignorance de certains champs.

Sémantique spécifique de certains champs BibLaTeX.

------------------------------------------------------------------------

## Annexe

------------------------------------------------------------------------
