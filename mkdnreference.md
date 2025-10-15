Ceci est le doc de référence pour vérifier comment pandoc gère le balisage infratextuel / sémantique 


## Vérifier les niveaux de titre 

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

::: {.argument}
ATTENTION: Ceci est un chapôt introductif
:::

::: {.epigraph}
Tant qu’il existera, par le fait des lois et des mœurs, une damnation sociale créant artificiellement, en pleine civilisation, des enfers, et compliquant d’une fatalité humaine la destinée qui est divine ; tant que les trois problèmes du siècle, la dégradation de l’homme par le prolétariat, la déchéance de la femme par la faim, l’atrophie de l’enfant par la nuit, ne seront pas résolus ; tant que, dans de certaines régions, l’asphyxie sociale sera possible ; en d’autres termes, et à un point de vue plus étendu encore, tant qu’il y aura sur la terre ignorance et misère, des livres de la nature de celui-ci pourront ne pas être inutiles. [@hugo1862miserables]
:::

:::{.sponsor}
Ce livre a été rendu possible grâce au soutien du CRSH. 
:::

:::{.endnote}
Note de fin. 
:::


## Texte 

Du texte 

Un saut de ligne 

Une ligne\
Une ligne à la suite 

- - -

Et là je veux citer @hugo1862miserables

::: {.sig}
Ceci est une signature
:::

- liste 
- liste 
    - sous liste 
    - sous liste


1. liste numérotée
2. liste numérotée
    1. sous liste numérotée
    2. sous liste numérotée

**Il manque  les contenus additionnels !!!**

## Entretien

::: {.question}
[Ta sœur]{.speaker} Une question est posée
:::
::: {.answ}
[Ma grand-mère]{.speaker} Réponse à la question
:::

## Notes 

Bablebliblablou, comme l'indique la note en bas de page.[^1]

[^1]: Ceci est une note de bas de page.

Ou alors on peut faire cette syntaxe^[Cette manière de faire des notes de bas de page est aussi possible.] aussi.

## Citations

> Ceci est une citation. [@hugo1862miserables, 123-125]

Parfois j'écris un paragraphe et comme le disait @hugo1862miserables, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs.]{.inlinequote} 

:::{.quote-alt}
c’est une pratique d’open edition, pas de notion sémantique, elle s’appelle juste citation bis
:::


Il faut ensuite faire des citations plus complexes. 

:::{.quotcomplexe}
> tatitata (ça peut être des vers ou des didascalies)

:::{.trad lang=fr}
tatitata dans une autre langue
:::

[@hugo1862miserables, 123-125]
:::

Vérifions ce qui se passe quand on veut encoder des vers ou le théâtre.

> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}
> [@baudelaire_albatros_1857, 1-3]


**Le théâtre il faut trouver un meilleur système.**

Voici la citation linguistique.

::: {.ling lang=fr num=123 label=ex1 }

[Titre de l'exemple]{.head}

> pomme

::: {.glose}
fruit
:::

::: {.trl lang=en}
apple
:::

[@moliere_misanthrope_1666]

:::

## Figures

:::{.figure}

[Titre de l'image dans laquelle on devrait mettre aussi des [crédits]{.credits}]{.head}

![caption](image.png)

:::{.credits}
Cette image est sous licence [machin]{.credits} et est attribuée à @baudelaire_albatros_1857
:::
:::


## Typographie

_italique_ ou *italique*

**gras**

**_gras et italique_**

[en petites majuscules]{.smallcaps}

[_petites majuscules en italique_]{.smallcaps}

1^er^

3^_eme_^

A~a~

Trouver comment souligne ?? 

~~texte barré~~

## Index 

[Platon]{.personnalite idsp="Platon" idwiki="https://www.wikidata.org/wiki/Q859"}




