## Liminaires

::: {.ack}
remerciements
:::

::: {.dedication}
Voici une dédicace
:::


::: {.notepre origin=aut}
Note préliminaire de l'auteur
:::

::: {.notepre origin=pb}
Note préliminaire de l'éditeur
:::

::: {.notepre origin=trl}
Note préliminaire du traducteur
:::

::: {.argument}
ATTENTION: Ceci est un chapôt introductif
:::

::: {.epigraph}
Tant qu’il existera, par le fait des lois et des mœurs, une damnation sociale créant artificiellement, en pleine civilisation, des enfers, et compliquant d’une fatalité humaine la destinée qui est divine ; tant que les trois problèmes du siècle, la dégradation de l’homme par le prolétariat, la déchéance de la femme par la faim, l’atrophie de l’enfant par la nuit, ne seront pas résolus ; tant que, dans de certaines régions, l’asphyxie sociale sera possible ; en d’autres termes, et à un point de vue plus étendu encore, tant qu’il y aura sur la terre ignorance et misère, des livres de la nature de celui-ci pourront ne pas être inutiles. [@hugo1862miserables]
:::

:::{.sponsor}
Ce livre a été rendu possible grâce au soutien du CRSH. 
:::

## Citations

> Ceci est une citation. [@hugo1862miserables, 123-125]

Parfois j'écris un paragraphe et comme le disait @hugo1862miserables, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs.]{.inlinequote} De cette manière j'ai une citation innline. 

:::{.quote-alt}
c’est une pratique d’open edition, pas de notion sémantique, elle s’appelle juste citation bis dans le schéma commons.
:::

Il faut ensuite faire des citations plus complexes. 

:::{.quotcomplexe}
> tatitata (ça peut être des vers ou des didascalies)

:::{.trad lang=fr}
tatitata dans une autre langue
:::

[@hugo1862miserables, 123-125]
:::

Cette dernière citation a une traduction et la langue de la traduction.

## Figures

Certains auteurs vont insérer des images sans enrichir comme ceci : 

![légende](mkdreference/medias/image.png)

Mais ce qu'on voudrait c'est qu'ils soient plus précis en insérant un snippet de code pour récupérer plus d'information. 

:::{.figure}

[Titre de l'image dans laquelle on devrait mettre aussi des [crédits]{.credits}]{.head}

![légende](mkdreference/medias/image.png)

:::{.credits}
Cette image est sous licence [machin]{.credits} et est attribuée à @baudelaire_albatros_1857
:::
:::

On voit que les crédits peuvent : 

- être au sein d'autres éléments
- l'élément rédigé en lui-même (logique du présentationnel)

L'idée ici est de **détourner l'alt de l'image pour récupérer la caption**. Ainsi on alège un peu la syntaxe. 

## Encadrés

:::{.encadre titre=montitre}

[ [nom]{.surname}[prenom]{.forename}]{.auth}

Pour le moment on a un encadré minimal avec un titre et une autorité à récupérer 
dans `TEI/text/body//bibl[@type="sec_authority"]/author/persName/surname|forename`

:::

## Entretien

::: {.question}
[Clara]{.speaker} Une question est posée
:::
::: {.answ}
[Marcello]{.speaker} Réponse à la question
:::

## Titre choisi pour la bibliographie 

Le snippet de code biblio rajoute un titre de niveau 2 comme ci-dessus, qui sert à renseigner le titre de la bibliographie. 
En dessous directement est inséré la syntaxe pandoc pour imprimer la biblio. 

::: {#refs}
:::

