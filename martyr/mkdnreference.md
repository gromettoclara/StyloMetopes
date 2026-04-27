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

Simple remarque : avec le schéma d'Érudit je suis confronté au problème suivant : ils sont très attaché à l'identité entre le pdf et le HTML produit à partie de leur XML. Or le markdown ne contraignant pas l'ordre des éléments, la dédicace ou les épigraphes se trouvent parfois mal placés dans l'article. C'est une idée à retenir et à anticiper pour la validation. Il faut "forcer" les écrivants et éditeurs sur stylo à placer ses blocs au bon endroit.

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
nom de l’auteur *avant* le lien cliquable, plutôt que dedans).

::: {.sig}
Ceci est une signature.
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
[Clara]{.speaker} Une question est posée.
:::
::: {.answer}
[Marcello]{.speaker} Réponse à la question.
:::

## Notes 

Bablebliblablou, comme l'indique la note en bas de page.[^1]

[^1]: Ceci est une note de bas de page.

Ou alors on peut faire cette syntaxe^[Cette manière de faire des notes de bas de page est aussi possible.] aussi.

Il faut inventer une autre syntaxe si on veut que les notes soient les notes de fin (`TEI/text/body//note[@place="end"][@n][@type="standard"][@xml:id"]`).

Il me semble plus propre d'inventer une nouvelle syntaxe que de détourner celle de Pandoc: 

Par exemple je veux mettre une note de fin ici[Voici ce que je veux dire et qui apparaît en fin de document.]{.endnote}. Elle sera numérotée séquentiellement.

## Citations

Une citation est un bout de texte présenté comme provenant d’une source externe.

Une citation est codée différemment selon qu’elle :

  1. contient un ou plusieurs paragraphes ou éléments 
     structurels tels figure, liste, tableau; ou
  3. ne constitue qu’une partie d’un paragraphe.

Appelons les premières "conteneurs" et les secondes "inline".

### Citations conteneurs

Les citations conteneurs peuvent être codées de deux façons : comme
citations normales pandoc-MD (>), ou comme sections `:::{.quote-alt}` (ou, de façon 
équivalente, `:::quote-alt`), ces dernières correspondant aux citations "alternatives"
de Métopes :

> Ceci est une citation normale pandoc-MD. Elle consiste en
> exactement un paragraphe.

:::{.quote-alt}
Ceci est une citation alternative de Métopes. Encore ici,
un seul paragraphe.
:::

Exemples un peu plus complexes :

> Ceci est une citation normale pandoc-MD.
>
> Elle consiste en
> deux paragraphes suivis d’une liste.
>
> 1. Le soleil.
> 2. La lune.

:::{.quote-alt}
Ceci est une citation alternative de Métopes.

+------------+--------------+
|            | Toute garnie |
| Pizza      +--------------+
|            | Hawaïenne    |
+------------+--------------+
| Spaghetti  | Bolognese    |
+------------+--------------+

Elle contient un tableau entre deux paragraphes.
:::

Les citations conteneurs contenant exactement un paragraphe (et rien d'autre)
sont traitées de façon particulière par la moulinette d’exportation et donnent
lieu à la forme "normale" de citation Métopes. Toutes les autres "étirent" un
peu le modèle Métopes et pourraient donner des résultats sous-optimaux (bien
qu’entièrement valides selon le schéma Métopes). Le mot d’ordre est ici "essai
et erreur".

### Citations inline

Les citations inline (ne constituant qu’un segment d’un paragraphe) sont codées comme des
*segments* (span) `[…]{.inlinequote}`. Elles peuvent survenir partout où un
span peut se trouver. Voici un exemple :

Comme le disait l’*Homme Océan*, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs.]{.inlinequote} Ensuite, le paragraphe continue.

### Références bibliographiques

Pour inclure une *référence bibliographique* dans une citation, il suffit de l’inscrire
à l’endroit voulu dans le texte.

Une référence bibliographique prend une des deux formes `@cléIdRessource` et `[@cléIdRessource]`.
La forme avec crochets accepte un préfixe et/ou suffixe en plus de la 
`@cléIdRessource`, par exemple :

`[@baudelaire_albatros_1857 1-3]`

`[Voir @hugo1862miserables, *passim*]`

Les deux formes (avec et sans `[…]`) sont traitées légèrement différemment par pandoc; les différences
sont subtiles et se découvrent à l’usage.

Habituellement, on met une seule référence par citation et on la met à la fin, mais
il n’y a pas de règle sur ces deux points.

Voici quelques exemples de citations avec références bibliographiques :

> Ceci est une citation d’un grand écrivain. [@hugo1862miserables, 123-125]

:::{.quote-alt}
Citation alternative, avec référence bibliographique. [@baudelaire_albatros_1857, 1-3]
:::

> "Les outardes sont bleues," dit-il.
> 
> "Bleues sont les outardes," répondit l’autre.
> 
> [@moliere_misanthrope_1666]

Comme le disait l’*Homme Océan*, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs. [@hugo1862miserables 10-12]]{.inlinequote}. Que peut-on dire de plus ?

L’exemple suivant ne contient pas de référence dans une citation, mais il illustre
une façon courante d’articuler une référence et une citation :

Comme le disait @hugo1862miserables, [Il n’y a ni mauvaises herbes ni mauvais hommes. Il n’y a que de mauvais cultivateurs.]{.inlinequote}. Que peut-on ajouter ?

L’exemple démontre aussi qu’une référence bibliographique peut survenir ailleurs que dans
une citation. Il s’agit alors d’une référence *inline*, identifiée dans
Métopes par la valeur d’attribut `@rend="inline"`.

### Citations complexes

Métopes possède ce qu’on appelle des citations "complexes".
Il s’agit d’un type de citation conteneur ayant la propriété de pouvoir
contenir d’autres citations conteneurs, qui sont des traductions de la
citation principale.

Un citation complexe est codée comme section `:::{.quotcomplexe}`, ou
`:::{.quotecomplexe lang="zz"}`, si on veut spécifier la langue de la citation
principale.

Le contenu de la citation complexe *doit* commencer par la citation principale,
laquelle *doit* être donnée sous la forme d’une citation normale pandoc-MD (>)
à l’intérieur de la citation complexe :

:::{.quotcomplexe lang=fr}
> Ceci est la citation principale; un premier paragraphe.
>
> Et un second paragraphe.
:::

La citation principale peut contenir tout ce qui peut se retrouver dans une citation
normale pandoc-MD.

*Après* la citation principale, la citation complexe contiendra normalement
(mais facultativement) une ou plusieurs
sous-sections `:::{.trad lang="zz"}`, chacune donnant une traduction de la citation
principale, codée de la même façon que la citation principale :

:::{.quotcomplexe lang=fr}
> Tatitata en francais.
>
> Sur deux paragraphes.

:::{.trad lang=en}
> Tatitata in English.
>
> On two paragraphs.
:::

:::{.trad lang=no}
> Tatitata på norsk bokmål.
>
> På to avsnitt.
:::

:::

Des références bibliographiques peuvent être insérées un peu
partout, notamment après la citation principale, à la fin des sections des traductions
et après la dernière traduction. Par exemple :

:::{.quotcomplexe}
> Un premier paragraphe.
>
> Un second paragraphe dans la même citation.

[@moliere_misanthrope_1666]
:::

Autre exemple :

:::{.quotcomplexe lang=fr}
> Tatitata en français.
>
> Sur deux paragraphes.

:::{.trad lang=en}
> Tatitata in English.
>
> On two paragraphs.

[@moliere_misanthrope_1666]
:::

:::{.trad lang=no}
> Tatitata på norsk bokmål.
>
> På to avsnitt.

[@moliere_misanthrope_1666]
:::

[@baudelaire_albatros_1857]
:::

Dans ce dernier exemple, la citation principale a deux traductions avec chacune
sa référence, et la référence à la citation originale est donnée *après* la 
dernière traduction.

Si on préfère, la référence à la citation en langue originale pourrait être
donnée *avant* les sous-sections pour les traductions :

:::{.quotcomplexe lang=fr}
> Tatitata en français.
>
> Sur deux paragraphes.

[@baudelaire_albatros_1857]

:::{.trad lang=en}
> Tatitata in English.
>
> On two paragraphs.

[@moliere_misanthrope_1666]
:::

:::{.trad lang=no}
> Tatitata på norsk bokmål.
>
> På to avsnitt.

[@moliere_misanthrope_1666]
:::
:::

### Citations de vers

Comment citer des vers ? On utilise cette forme spéciale
de citation normale pandoc-MD :

> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=5}

Pour ajouter une référence, on la met à la fin de la citation :

> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=5}
> [@baudelaire_albatros_1857, 1-3]

Si on veut donner une ou plusieurs traductions de la citation, il faut
utiliser une citation complexe. Les références sont alors données
de la façon prévue pour les citations complexes :

:::{.quotcomplexe}
> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=5}

:::{.trad lang=en}
> [Often, to amuse themselves, the sailors]{.verse num=1}
> [Catch albatrosses, vast birds of the seas,]{.verse num=2}
> [Who follow, indolent companions of the voyage,]{.verse num=5}

[@moliere_misanthrope_1666]
:::

[@baudelaire_albatros_1857, 1-3]
:::

Si on préfère, la référence au texte en langue originale peut être
donnée avant la sous-section pour la traduction, ainsi :

:::{.quotcomplexe}
> [Souvent, pour s’amuser, les hommes d’équipage]{.verse num=1} 
> [Prennent des albatros, vastes oiseaux des mers,]{.verse num=2}
> [Qui suivent, indolents compagnons de voyage,]{.verse num=5}

[@baudelaire_albatros_1857, 1-3]

:::{.trad lang=en}
> [Often, to amuse themselves, the sailors]{.verse num=1}
> [Catch albatrosses, vast birds of the seas,]{.verse num=2}
> [Who follow, indolent companions of the voyage,]{.verse num=5}

[@moliere_misanthrope_1666]
:::
:::

Nous nous sommes arrêtés ici en ce qui a trait aux citations. Il faudra penser à un système qui reste lisible et pas trop lourd pour le théâtre et la linguistique.

## Figures

Certains auteurs vont insérer des images sans enrichir comme ceci : 

![Légende](mkdreference/medias/image.png)

Mais ce qu'on voudrait c'est qu'ils soient plus précis en insérant un snippet de code pour récupérer plus d'information.

**Exemples :**

:::{.figure}

[Titre de l'image]{.head}

![Légende](mkdreference/medias/image.png)

:::{.credits}
Cette image est sous licence machin et est attribuée à [@baudelaire_albatros_1857].
:::

:::

:::{.figure}

[Titre de l'image]{.head}

![Photo de Montréal, [Collection privée Jean Valjean]{.credits}](mkdreference/medias/image.png)

:::

:::{.figure}
[L’image dans sa splendeur, telle qu’on peut l’admirer au [Musée du Louvre]{.credits}]{.head}

![Image mirobolante](mkdreference/medias/image.png)
:::

On voit que les crédits peuvent être : 

- une sous-section 'credits'.
- intégrés au sein du titre (.head) ou de la légende, dans un span 'credits'.

Notons qu’une sous-section 'credits' a préséance sur d’éventuels spans 'credits'.

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

## À propos du titre de la bibliographie

Si le MD se termine par un titre, ce dernier sera utilisé comme titre de la
bibliographie. Autrement, le mot "Bibliographie" ou "Bibliography" sera utilisé,
selon que la métadonnée `lang` commence par `fr` ou non.

Avec le titre ci-après, la bibliographie sera intitulée "Références".

## Références
