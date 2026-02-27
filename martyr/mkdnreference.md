Ceci est le doc de référence, martyre, pour baliser du texte destiné à Commons dans Stylo.

## Déjà on peut avoir plein de niveaux de titre, celui-ci est le premier... 

### Le deuxième 

#### Le troisième

## Liminaires

::: {.ack}
remerciements
:::

::: {.dedication}
Voici une dédicace
:::

Simple remarque : avec le schéma d'Érudit je suis confronté au problème suivant : ils sont très attaché à l'identité entre le pdf et le HTML produit à partie de leur XML. Or le markdown ne contraignant pas l'ordre des éléments, la dédicace ou les épigraphes se trouvent parfois mal placés dans l'article. C'est une idée à retenir et à enticiper pour la validation. Il faut "forcer" les écrivants et éditeurs sur stylo à placer ses blocs au bon endroit. 

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
[Clara]{.speaker} Une question est posée
:::
::: {.answ}
[Marcello]{.speaker} Réponse à la question
:::

## Notes 

Bablebliblablou, comme l'indique la note en bas de page.[^1]

[^1]: Ceci est une note de bas de page.

Ou alors on peut faire cette syntaxe^[Cette manière de faire des notes de bas de page est aussi possible.] aussi.

Il faut inventer une autre syntaxe si on veut que les notes soient les notes de fin (`TEI/text/body//note[@place="end"][@n][@type="standard"][@xml:id"]`).

Il me semble plus propre d'inventer une nouvelle syntaxe que de détourner celle de Pandoc: 

Par exemple je veux mattre une note de fin ici[Voici ce que je veux dire et qui apparaît en fin de document.]{.endnote}. Elle sera nmérotée incrémentalement. 

## Citations

> Ceci est une citation. [@hugo1862miserables, 123-125]

Cette citation a une source référencée entre crochets.

Parfois j'écris un paragraphe et comme le disait @hugo1862miserables, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs.]{.inlinequote} De cette manière j'ai une citation innline. 

:::{.quote-alt}
c’est une pratique d’open edition, pas de notion sémantique, elle s’appelle juste citation bis  dans le schéma commons.
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

Que se passe-t-il quand on veut encoder des vers ? 

> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}
> [@baudelaire_albatros_1857, 1-3]

Ces vers peuvent être compris dans une citation complexe

:::{.quotcomplexe}
> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}

:::{.trad lang=en}
> [Often, to amuse themselves, the sailors]{.verse num=1}
> [Catch albatrosses, vast birds of the seas,]{.verse num=2}
> [Who follow, indolent companions of the voyage,]{.verse num=3}
:::

[@baudelaire_albatros_1857, 1-3]
:::

Nous nous sommes arrêtés ici en ce qui a trait aux citations. Il faudra penser à un système qui reste lisible et pas trop lours pour le théâtre et la linguistique. 

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

[Platon]{.personnalite id=Platon} est un philosophe de l'Antiquité grecque, élève de [Socrate]{.personnalite id=Socrate} et maître d'[Aristote]{.personnalite id=Aristote}.

Il fonda l'[Académie]{.lieu id=Academie} à [Athènes]{.lieu id=Athenes}, vers 387 av. J.-C.

Ses œuvres majeures, comme la [République]{.oeuvre id=Republique_Platon} ou le [Banquet]{.oeuvre id=Banquet_Platon}, ont profondément influencé la pensée occidentale.

[Aristote]{.personnalite id=Aristote}, après avoir quitté l'Académie, devint le précepteur du jeune [Alexandre le Grand]{.personnalite id=Alexandre_le_Grand}, avant de fonder sa propre école, le [Lycée]{.lieu id=Lycee}, également à [Athènes]{.lieu id=Athenes}.

## Le code 

```python
def bonjour(nom):
    print(f"Bonjour, {nom} !")

bonjour("monde")
```

On peut aussi mettre du code inline : `<div>Voici du code inline</div>`

## Titre choisi pour la bibliographie 

Le snippet de code biblio rajoute un titre de niveau 2 comme ci-dessus, qui sert à renseigner le titre de la bibliographie. 
En dessous directement est inséré la syntaxe pandoc pour imprimer la biblio. 

::: {#refs}
:::





