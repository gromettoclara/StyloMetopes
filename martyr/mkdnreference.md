Ceci est le doc de référence, martyr, pour baliser du texte destiné à Commons dans Stylo.

## Déjà on peut avoir plein de niveaux de titre, celui-ci est le premier... 

### Le deuxième 

#### Le troisième

## Liminaires

Notez que les sections "liminaires" sont relocalisées en "front" en conformité avec le
schéma Métopes. Elles n’apparaîtront donc pas en séquence ici. Il ne restera que
la "simple remarque".

::: {.ack}
Remerciements.
:::

::: {.dedication}
Voici une dédicace.
:::

Simple remarque : avec le schéma d'Érudit je suis confronté au problème suivant : ils sont très attaché à l'identité entre le pdf et le HTML produit à partie de leur XML. Or le markdown ne contraignant pas l'ordre des éléments, la dédicace ou les épigraphes se trouvent parfois mal placés dans l'article. C'est une idée à retenir et à enticiper pour la validation. Il faut "forcer" les écrivants et éditeurs sur stylo à placer ses blocs au bon endroit. 

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
ATTENTION: Ceci est un chapô introductif
:::

::: {.epigraph}
::: {.quotcomplexe}
> Tant qu’il existera, par le fait des lois et des mœurs, une damnation sociale créant artificiellement, en pleine civilisation, des enfers, et compliquant d’une fatalité humaine la destinée qui est divine ; tant que les trois problèmes du siècle, la dégradation de l’homme par le prolétariat, la déchéance de la femme par la faim, l’atrophie de l’enfant par la nuit, ne seront pas résolus ; tant que, dans de certaines régions, l’asphyxie sociale sera possible ; en d’autres termes, et à un point de vue plus étendu encore, tant qu’il y aura sur la terre ignorance et misère, des livres de la nature de celui-ci pourront ne pas être inutiles.

[@hugo1862miserables]
:::
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

Et là je veux citer @hugo1862miserables (sans les crochets \[\], ça met le
nom de l’auteur *avant* le lien cliquable entre parenthèses, plutôt que dedans).

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
::: {.answer}
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

> Ceci est une citation (qui inclut une référence, mais ce n’est pas obligatoire). [@hugo1862miserables, 123-125]

Cette citation a une source référencée entre crochets.

Parfois j'écris un paragraphe et comme le disait @hugo1862miserables, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs.]{.inlinequote} De cette manière j'ai une citation inline.

On peut aussi inscrire la référence dans le texte cité (habituellement à la fin) :

Comme le disait l’*Homme Océan*, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs. [@hugo1862miserables]]{.inlinequote} Ensuite, le paragraphe continue.

:::{.quote-alt}
c’est une pratique d’open edition, pas de notion sémantique, elle s’appelle juste citation bis  dans le schéma commons.
Si on veut une référence, on l’inscrit simplement avec le reste du texte cité. [@baudelaire_albatros_1857]
:::

### Citations complexes

Il faut ensuite faire des citations plus complexes.

Commençons doucement :

:::{.quotcomplexe}
> Un premier paragraphe.
>
> Un second paragraphe dans la même citation.
:::

On note que, comparativement aux citations simple (>) ou 'quot-alt', une 
'quotcomplexe' peut comporter plusieurs paragraphes.

En plus des références bibliographiques intégrées aux paragraphes,
on peut aussi en ajouter comme paragraphe(s) autonomes; elles
apparaîtront alors dissociées des paragraphes cités, mais toujours à l’intérieur
de l’élément quote (celles sans [] seront mises dans un \<p>, car elles
contiennent du texte en plus d'un \<bibl>) :

:::{.quotcomplexe}
> Un premier paragraphe [@baudelaire_albatros_1857].
>
> Un second paragraphe dans la même citation.

[@moliere_misanthrope_1666]
:::

On peut maintenant ajouter des traductions + références :

:::{.quotcomplexe lang=fr}
> tatitata (ça peut être des vers ou des didascalies)

:::{.trad lang=en}
> tatitata dans une autre langue

[@moliere_misanthrope_1666]
:::

[@baudelaire_albatros_1857]
:::

Cette dernière citation a traduction et références.

Si on préfère, la référence au texte en langue originale peut être
donnée avant la sous-section pour la traduction :

:::{.quotcomplexe}
> tatitata (ça peut être des vers ou des didascalies)

[@baudelaire_albatros_1857]

:::{.trad lang=en}
> tatitata dans une autre langue

[@moliere_misanthrope_1666]
:::
:::

### Citations complexes de vers

Que se passe-t-il quand on veut citer des vers ?

> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}

Pour ajouter une référence, on la met à la fin, dans la citation :

> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}
> [@baudelaire_albatros_1857, 1-3]

Ces vers peuvent être compris dans une citation complexe :

:::{.quotcomplexe}
> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}

:::{.trad lang=en}
> [Often, to amuse themselves, the sailors]{.verse num=1}
> [Catch albatrosses, vast birds of the seas,]{.verse num=2}
> [Who follow, indolent companions of the voyage,]{.verse num=3}

[@moliere_misanthrope_1666]
:::

[@baudelaire_albatros_1857, 1-3]
:::

Si on préfère, la référence au texte en langue originale peut être
donnée avant la sous-section pour la traduction :

:::{.quotcomplexe}
> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=3}
> [@baudelaire_albatros_1857, 1-3]

:::{.trad lang=en}
> [Often, to amuse themselves, the sailors]{.verse num=1}
> [Catch albatrosses, vast birds of the seas,]{.verse num=2}
> [Who follow, indolent companions of the voyage,]{.verse num=3}
> [@moliere_misanthrope_1666]
:::

:::

Nous nous sommes arrêtés ici en ce qui a trait aux citations. Il faudra penser à un système qui reste lisible et pas trop lours pour le théâtre et la linguistique. 

## Figures

Certains auteurs vont insérer des images sans enrichir comme ceci : 

![légende](mkdreference/medias/image.png)

Mais ce qu'on voudrait c'est qu'ils soient plus précis en insérant un snippet de code pour récupérer plus d'information. 

:::{.figure}

[Titre de l'image dans laquelle on ~~devrait~~ pourrait mettre aussi des [crédits]{.credits}]{.head}

![légende](mkdreference/medias/image.png)

:::{.credits}
Cette image est sous licence [machin]{.credits} et est attribuée à [@baudelaire_albatros_1857].
:::
:::

On voit que les crédits peuvent : 

- être au sein d'autres éléments
- une sous-section 'credits' (qui a alors préséance sur les spans 'credits' éventuels)

Exemple illustrant le premier cas de figure (mauvais jeu de mot) :

:::{.figure}
[L’image dans sa splendeur, telle qu’on peut l’admirer au [Musée du Louvre]{.credits}]{.head}

![Image mirobolante](mkdreference/medias/image.png)
:::

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

[Trouvé comment souligner]{.underline}

~~texte barré~~

## Index 

[Platon]{.personnalite id=Platon} est un philosophe de l'Antiquité grecque, élève de [Socrate]{.personnalite id=Socrate} et maître d'[Aristote]{.personnalite id=Aristote}.

Il fonda l'[Académie]{.institution id=Academie} à [Athènes]{.lieu id=Athenes}, vers 387 av. J.-C.

Ses œuvres majeures, comme la [République]{.oeuvre id=Republique_Platon} ou le [Banquet]{.oeuvre id=Banquet_Platon}, ont profondément influencé la pensée occidentale.

[Aristote]{.personnalite id=Aristote}, après avoir quitté l'Académie, devint le précepteur du jeune [Alexandre le Grand]{.personnalite id=Alexandre_le_Grand}, avant de fonder sa propre école, le [Lycée]{.institution id=Lycee}, également à [Athènes]{.lieu id=Athenes}.

## Le code 

```python
def bonjour(nom):
    print(f"Bonjour, {nom} !")

bonjour("monde")
```

On peut aussi mettre du code inline : `<div>Voici du code inline</div>`

## Formules mathématiques

Voici des formules "inline", $\pi^2$, $\pi \times {\sqrt 2}$, $\pi^2$ et $\pi \times {\sqrt[3] 7}$.

Voici trois formules en blocs : $$\pi \times {\sqrt 2}$$ $$\pi^2$$
$$\pi \times {\sqrt[3] 7}$$

Cela conclut notre section sur les formules.

## Tableaux

Les tableaux suivants me semblent d’une complexité suffisante pour illustrer pas
mal de choses.

+---------------------+------------+
| Property            | -89.2 °C   |
+=============+=======+============+
|             | min   | 1. Earth   |
|             |       | 2. Mercury |
|             |       | 3. Jupiter |
| Temperature +-------+------------+
| 1961-1990   | mean  | 14 °C      |
|             +-------+------------+
|             | max   | 56.7 °C    |
+-------------+-------+------------+
: Tableau _trafiqué_ du manuel de pandoc

+---------------------+------------+
| Property            | -89.2 °C   |
+=============+=======+============+
|             | *minimum* on Earth |
| Temperature +--------------------+
| 1961-1990   | maximum de 56.7 °C |
+-------------+                    |
| Alpinisme   | minimum de 14 °C   |
+=============+====================+
| 1961-1990   | moyenne de 28 °C   |
+=============+====================+
: Tableau **ultra-traficoté** du manuel de pandoc

Fin de la section sur les tableaux.

## Titre choisi pour la bibliographie 

Le snippet de code biblio rajoute un titre de niveau 2 comme ci-dessus, qui sert à renseigner le titre de la bibliographie. 
En dessous directement est inséré la syntaxe pandoc pour imprimer la biblio. 

::: {#refs}
:::





