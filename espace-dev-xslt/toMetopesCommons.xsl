<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2026 Yves Marcoux - Licence GNU GPL -->
<!--
Observations sur l’AST de pandoc (et donc tenues pour acquises dans cette XSLT) :

1- Il n’y a jamais aucun contenu textuel non blanc directement sous une Div.
2- La Div correspondant à la bibliographie générée par pandoc est toujours directement
   sous /Pandoc/blocks, et c’en est toujours le dernier enfant.
3- En l’absence de Div explicites (:::) dans le MD, tout se passe à un seul niveau :
   celui directement sous Pandoc/blocks. Par exemple, le premier titre (#) sera
   Pandoc/blocks/Header[1].

De plus, les choses suivantes sont tenues pour acquises (mais vérifiées en validation), en
vertu d’un protocole qu’on suppose respecté par les auteurs :

1- Toutes les Div (:::) ayant un rôle sémantique prédéterminé (par exemple, .ack)
   sont au niveau Pandoc/blocks/*; autrement dit, elles ne sont pas imbriquées dans une
   autre Div.
-->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:ym="http://www.marcouxmedias.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="" xml:lang="fr-CA" xml:space="ignore"
  exclude-result-prefixes="#all">

  <xsl:param name="imagePath" select="'../icono/br/'" />

  <xsl:include href="toMC-bibliography.xsl"/>
  <xsl:include href="toMC-TEIheader.xsl"/>
  <xsl:include href="toMC-front.xsl"/>
  <xsl:include href="toMC-validations.xsl"/>

  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"
    omit-xml-declaration="no" />
<!-- saxon:indent-spaces="2" avec xmlns:saxon="http://saxon.sf.net/"
  est possible avec saxon pour contrôler la taille de l’indentation,
  mais pas avec HE -->

  <xsl:function name="ym:lastIndexOf" as="xs:integer">
    <xsl:param name="str" />
    <xsl:param name="car" />
    <xsl:sequence select="if (contains($str, $car)) then
      max(for $i in (1 to string-length($str)) return
      if (substring($str, $i, 1) = $car) then $i else 0)
      else 0" />
  </xsl:function>

  <xsl:function name="ym:imageName">
    <xsl:param name="str" />
    <xsl:variable name="sep" select=
      "if (contains($str, '\')) then '\' else '/'" />
    <xsl:value-of select=
      "substring($str, ym:lastIndexOf($str, $sep)+1)" />
  </xsl:function>

  <xsl:function name="ym:mapPart">
    <xsl:param name="map" />
    <xsl:param name="key" />
    <xsl:sequence select="$map/entry[@key=$key]/*" />
  </xsl:function>

  <xsl:variable name="fpNoExt">
    <xsl:variable name="temp" select="base-uri(/)" />
<!-- ^ should end with ".AST.xml" -->
    <xsl:variable name="temp"
      select="substring($temp, 1, ym:lastIndexOf($temp, '.')-1)" />
    <xsl:value-of
      select="substring($temp, 1, ym:lastIndexOf($temp, '.'))" />
  </xsl:variable>

  <xsl:variable name="firstHeadLev" select="number(/Pandoc/blocks/Header[1]/@level)" />
<!-- ^ Ce niveau est ramené à 1 dans les div/@type='sectionN' produites en extrant. -->

  <xsl:variable name="docMeta" select="/Pandoc/meta" />

  <xsl:variable name="docLang" select="ym:mapPart($docMeta,'lang')" />

  <xsl:variable name="localizedContent"
    select="ym:mapPart($docMeta,'localizedContent')/*" />
<!-- ^ localizedContent is a MetaList of MetaMap’s; we return a list of MetaMap’s -->

<!-- Variables for keywords: -->
  <xsl:variable name="ckw" select="ym:mapPart($docMeta,'controlledKeywords')" />
  <xsl:variable name="kw" select="ym:mapPart($docMeta,'keywords')" />
  <xsl:variable name="lkw" select="$localizedContent[ym:mapPart(.,'keywords')]" />

  <xsl:variable name="thebib" select=
    "document($fpNoExt || 'bib.xml')/Pandoc/meta/entry[@key='references']
      /MetaList/MetaMap" />

  <xsl:variable name="formules" select=
    "document($fpNoExt || 'mathml.xml')/formules/p/m:math" />
<!-- Toutes les formules en MathML, à substituer au Math en LaTeX non interprété
  de pandoc. -->

  <xsl:variable name="nFormInt" select="count(//Math)" />
<!-- ^ Nombre de formules internes, dans .AST.xml, l’AST du document lui-même, incluant sa
  bibliographie formatée éventuelle, mais ne comptant pas celles dans .bib.xml,
  la bibliographie en XML générée séparément pour fins sémantiques. -->

  <xsl:variable name="laBiblioDiv" select="//Div[@id='refs']" />
<!-- ^ la bibliographie générée par pandoc (le cas échéant) -->

  <xsl:variable name="biblioHead" select=
    "$laBiblioDiv/preceding-sibling::Header[1]
      [not(following-sibling::*[not(self::RawBlock)
        and $laBiblioDiv >> .])]" />
<!-- ^ le dernier titre dans le document (le cas échéant) pour servir de titre pour la
  bibliographie; s’il n’y en a pas, on va en générer un, très sommairement localisé
  selon $docLang, la langue indiquée dans les métadonnées de l’article -->

  <xsl:variable name="laAckDiv" select="//Div[@class='ack']" />
  <xsl:variable name="laEpigDiv" select="//Div[@class='epigraph']" />
  <xsl:variable name="laSponsDiv" select="//Div[@class='sponsor']" />
  <xsl:variable name="laDedicDiv" select="//Div[@class='dedication']" />
  <xsl:variable name="laAutDiv" select="//Div[@class='notepre' and @origin='aut']" />
  <xsl:variable name="laPblDiv" select="//Div[@class='notepre' and @origin='pb']" />
  <xsl:variable name="laTrlDiv" select="//Div[@class='notepre' and @origin='trl']" />
  <xsl:variable name="laArgDiv" select="//Div[@class='argument']" />

  <xsl:variable name="ignoredDiv" select=
    "$laBiblioDiv | $laAckDiv | $laEpigDiv | $laSponsDiv | $laDedicDiv
      | $laAutDiv | $laPblDiv | $laTrlDiv | $laArgDiv" />
<!-- ^ Stuff to ignore in the normal flow of sectional elements, because they
  are relocated to predetermined places in the output (header, front or back) -->

  <xsl:variable name="fakeDiv" select="//Div[@class=('question', 'answer', 'sig',
    'quote-alt', 'quotcomplexe', 'trad', 'figure', 'credits', 'encadre')]" />
<!-- ^ Les Div qui ne sont pas déplacées et qui ne donnent pas lieu à une
    <div> dans l’extrant -->

  <xsl:variable name="trueDiv" select="//Div except ($ignoredDiv | $fakeDiv)" />

<!-- Miscellanées : -->
<!-- Encore à faire :
    Plain
-->
  <xsl:template match="SoftBreak"><xsl:text> </xsl:text></xsl:template>
<!-- Curieusement, mis par pandoc dans les bibliographies formatées…?! : -->
  <xsl:template match="Str"><xsl:value-of select="@content"/></xsl:template>
  <xsl:template match="Space"><xsl:text> </xsl:text></xsl:template>
  <xsl:template match="LineBreak"><lb /></xsl:template>
  <xsl:template match="Emph"><hi rend="italic"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="Strong"><hi rend="bold"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="SmallCaps"><hi rend="small-caps"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="Superscript"><hi rend="sup"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="Subscript"><hi rend="sub"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="Underline"><hi rend="underline"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="Strikeout"
    ><hi rend="strikethrough"><xsl:apply-templates /></hi></xsl:template>
  <xsl:template match="Figure"><figure><xsl:apply-templates /></figure></xsl:template>
  <xsl:template match="Image[not(ancestor::Figure)]"><figure rend="inline"
    ><graphic url="$imagePath || {ym:imageName(@src)}" /></figure></xsl:template>
  <xsl:template match="Image"><graphic url="{$imagePath || ym:imageName(@src)}" /></xsl:template>
  <xsl:template match="Caption"><p rend="caption"><xsl:apply-templates select="*" /></p></xsl:template>
  <xsl:template match="OrderedList"><list type="ordered"><xsl:apply-templates /></list></xsl:template>
  <xsl:template match="BulletList"><list type="unordered"><xsl:apply-templates /></list></xsl:template>
  <xsl:template match="item"><item><xsl:apply-templates select="*" /></item></xsl:template>
  <xsl:template match="Code"><code rend="inline"><xsl:apply-templates /></code></xsl:template>
  <xsl:template match="Note"><note place="foot"><xsl:apply-templates select="*" /></note></xsl:template>
  <xsl:template match="Quoted">« <xsl:apply-templates /> »</xsl:template>
  <xsl:template match="Link"><ref target="{@href}"><xsl:apply-templates /></ref></xsl:template>
  <xsl:template match="citations" />
  <xsl:template match="Span[@class='inlinequote']">
    <cit><quote><xsl:apply-templates /></quote></cit>
  </xsl:template>
  <xsl:template match="Para" name="Para"><xsl:text>
</xsl:text><p><xsl:apply-templates /></p></xsl:template>
  <xsl:template match="Para[Span[@class='verse']]">
    <lg><xsl:apply-templates select="Span[@class='verse']" /></lg>
<!-- If any Cite, put them here: -->
    <xsl:apply-templates select="Cite" />
  </xsl:template>
  <xsl:template match="BlockQuote[Para/Span[@class='verse']]">
    <cit><quote><xsl:apply-templates select="*" /></quote></cit>
  </xsl:template>
  <xsl:template match="BlockQuote">
    <cit><quote><xsl:apply-templates select=
          "if (count(Para) eq 1 and not(*[not(self::Para)]))
            then */node() else *" /></quote></cit>
  </xsl:template>
  <xsl:template match="Div[@class='quote-alt']">
    <cit><quote type="quotation2"><xsl:apply-templates select=
          "if (count(Para) eq 1 and not(*[not(self::Para)]))
            then */node() else *" /></quote></cit>
  </xsl:template>
<!-- ^ La façon dont Métopes représente "normalement" les BlockQuote est sans <p>,
ce qui exige que le contenu de chaque BlockQuote soit exactement un Para. Si ce
n’est pas le cas, on doit briser cette restriction. -->

  <xsl:template match="Div[@class='quotcomplexe']">
    <cit><quote>
        <xsl:if test="@lang">
          <xsl:attribute name="xml:lang" select="@lang" />
        </xsl:if>
        <xsl:apply-templates select="*" mode="quotcomplexe" />
<!-- Ne devrait contenir que des BlockQuote, des Para et des Div[@class='trad']. -->
    </quote></cit>
  </xsl:template>
  <xsl:template match="Div" mode="quotcomplexe">
<!-- Toutes les Div matchant auront @class='trad' et @lang. -->
    <quote type="trl" xml:lang="{@lang}">
      <xsl:apply-templates select="*" mode="quotcomplexe" />
    </quote>
  </xsl:template>
  <xsl:template match="BlockQuote" mode="quotcomplexe">
    <xsl:apply-templates select="*" />
  </xsl:template>
  <xsl:template match="Para" mode="quotcomplexe"><xsl:apply-templates /></xsl:template>
<!-- ^ Ces paragraphes ne devraient contenir que des <Cite>
    produisant uniquement un <bibl> -->

  <xsl:template match="Cite">
    <xsl:choose>
<!--  Tous les cas de citation : -->
      <xsl:when test="parent::Para[Span[@class='verse']]
        or parent::Para/parent::BlockQuote
        or parent::Para/parent::Div[@class=('quotcomplexe', 'quote-alt', 'trad')]
        or parent::Span[@class='inlinequote']">
        <xsl:choose>
          <xsl:when test="citations[
            (count(Citation) eq 1) and
            Citation/@mode[. eq 'NormalCitation'] and
            not(Citation/prefix)] and
            Link/following-sibling::node()[1][self::text() and . eq ')']">
<!-- Exactement les cas où on peut mettre juste le <Link>, car il n’y a aucun texte
  avoisinant autre que ( ) ^ -->
            <bibl><xsl:apply-templates select="Link" /></bibl>
          </xsl:when>
          <xsl:otherwise>
            <bibl><xsl:apply-templates /></bibl>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <bibl rend="inline"><xsl:apply-templates /></bibl>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="Span[@class='verse']">
    <xsl:variable name="count" select=
      "1+count(preceding-sibling::Span[@class='verse'])" />
    <l n="{$count}"><num><xsl:value-of select="@num"/></num>
      <xsl:text> </xsl:text><xsl:apply-templates />
    </l>
  </xsl:template>
<!-- Préliminaire et tentatif 2026-04-16 ^ -->

  <xsl:template match="RawBlock" />
<!-- Yes, we just ignore them (ça inclut les commentaires HTML dans le MD) ^ 
Avec l’existant stylo, la seule valeur de @format est 'html'. -->
  <xsl:template match="RawInline" />
<!-- On ignore le LaTeX / TeX / HTML non interprété ^
Les 3 valeurs de @format avec l’existant stylo sont 'html', 'latex', 'tex'. -->
  <xsl:template match="HorizontalRule"><p rend="break">- - -</p><pb /></xsl:template>
<!--  <xsl:template match="HorizontalRule"><milestone unit="section" rend="horizontal-rule"
    /></xsl:template>
2026-03-12 Tentatif: on dirait que c’est supporté en Métopes; je l’implante ! -->

  <xsl:template match="CodeBlock">
    <p><code><xsl:if test="@class">
        <xsl:attribute name="lang" select="@class" />
      </xsl:if><xsl:apply-templates /></code></p>
  </xsl:template>

  <xsl:template match="$thebib//Math">
    <formula notation="mml">
      <xsl:copy-of select="$formules[$nFormInt + count(current()/preceding::Math) + 1]"
        copy-namespaces="no" />
    </formula>
  </xsl:template>
<!-- ^ copy-namespaces="no" est presque assurément superflu -->
<!-- xsl:sequence ferait la même chose que copy-of ci-dessus ^ -->

  <xsl:template match="Math">
    <formula notation="mml">
      <xsl:copy-of select="$formules[count(current()/preceding::Math) + 1]"
        copy-namespaces="no" />
    </formula>
  </xsl:template>
<!-- ^ copy-namespaces="no" est presque assurément superflu -->
<!-- xsl:sequence ferait la même chose que copy-of ci-dessus ^ -->

  <xsl:template match="Table">
    <figure>
      <xsl:apply-templates select="Caption[normalize-space()]" />
      <table
        rows="{count(TableHead/Row | TableBody/body/Row | TableFoot/Row)}"
        cols="{count(colspecs/ColSpec)}"
        >
        <xsl:apply-templates select="*[not(self::Caption)]" />
      </table>
    </figure>
  </xsl:template>
  <xsl:template match="colspecs | TableHead | TableBody | TableFoot | TableBody/body">
    <xsl:apply-templates select="*" />
  </xsl:template>
  <xsl:template match="Row"><row><xsl:apply-templates select="*" /></row></xsl:template>
  <xsl:template match="Cell">
    <cell>
      <xsl:if test="@col-span">
        <xsl:attribute name="cols" select="@col-span" />
      </xsl:if>
      <xsl:if test="@row-span">
        <xsl:attribute name="rows" select="@row-span" />
      </xsl:if>
      <xsl:apply-templates select="*" />
    </cell>
  </xsl:template>
<!-- Hypothèse du 2026-04-16 pour Table ^ -->

  <xsl:template match="$ignoredDiv" />

  <xsl:template match="$trueDiv">
<!-- Les Div déplaçables (bibliographie, épigraphe, etc., en fait les $ignoredDiv)
  sont traitées - en pull-mode - ailleurs. -->
<!-- Les Div non déplaçables, mais sémantiquement significatives (question, answer, etc.;
  NB: ces Div ne peuvent *pas*, par protocole, contenir de Div déplaçables) sont
  traitées ailleurs, en push-mode. -->
<!-- Les Div de la bibliographie sont traitées dans toMC-bibliography.xsl -->
<!-- La problématique particulière des Div / div est qu’en TEI, une div peut commencer
par des contenus éparpillés, mais s’il y a une div imbriquée, on ne peut revenir
après cette div à d’autre contenus éparpillés, il faut que toute la suite soit
elle-même structurée en div. Ce qui n’est pas le cas dans l’AST de pandoc : -->
    <div type="{@class}">
<!-- 2026-03-01 Mes observations indiquent que l’@type est toujours présent. ^ -->
      <xsl:apply-templates select="*[not(
        preceding-sibling::Div[. intersect $trueDiv]
        )]" />
<!-- ^ En cas de Div imbriquée, ce qui suit à l’air libre la première
Div imbriquée est traité par le template de cette première Div imbriquée. -->
    </div>
    <xsl:variable name="airlibre" select=
      "following-sibling::*[not(
        self::RawBlock or
        self::Header or
        preceding-sibling::Header[. >> current()] or
        preceding-sibling::Div[(. intersect $trueDiv) and . >> current()]
        )]" />
    <xsl:if test="$airlibre">
      <div><xsl:apply-templates select="$airlibre" /></div>
    </xsl:if>
    <xsl:call-template name="nextDiv" />
  </xsl:template>
<!-- Fusionner ? ^ : -->
  <xsl:template name="nextDiv">
    <xsl:apply-templates select=
      "following-sibling::Div[(. intersect $trueDiv) and
        not(preceding-sibling::Header[. >> current()]
      )][1]" />
  </xsl:template>

  <xsl:template match="Div/Header">
<!-- There should be no Header in a non-sectional Div.
If there are, they will be reported by validation, and rendered as paragraphs. -->
    <xsl:call-template name="Para" />
  </xsl:template>

  <xsl:template match="Span[@class='endnote']">
    <note place="end"><p><xsl:apply-templates /></p></note>
  </xsl:template>

<!-- Les entrées d’index : -->
  <xsl:template match="Span[@class='personnalite']">
    <xsl:apply-templates select="node()"/>
    <index indexName="Index des noms propres">
      <term><xsl:value-of select="@id" /></term>
    </index>
  </xsl:template>
  <xsl:template match="Span[@class='lieu']">
    <xsl:apply-templates select="node()"/>
    <index indexName="Index géographique">
      <term><xsl:value-of select="@id" /></term>
    </index>
  </xsl:template>
  <xsl:template match="Span[@class='oeuvre']">
    <xsl:apply-templates select="node()"/>
    <index indexName="Index thématique:Œuvre">
      <term><xsl:value-of select="@id" /></term>
    </index>
  </xsl:template>
  <xsl:template match="Span[@class='institution']">
    <xsl:apply-templates select="node()"/>
    <index indexName="Index thématique:Institution">
      <term><xsl:value-of select="@id" /></term>
    </index>
  </xsl:template>

<!-- Les $fakeDiv, i.e. les Div sémantiquement significatives, qui ne sont pas déplacées,
  et qui ne donnent pas lieu à une <div> dans l’extrant : -->
  <xsl:template match="Div[@class=('question', 'answer')]">
    <sp rend="{@class}"
        ><xsl:apply-templates /></sp>
  </xsl:template>

  <xsl:template match="Span[@class='speaker']">
    <name type="speaker"><xsl:apply-templates /></name>
  </xsl:template>

  <xsl:template match="Div[@class='sig']">
    <p rend="signature"><xsl:apply-templates select="*/node()" /></p>
  </xsl:template>

  <xsl:template match="Div[@class='figure']">
    <figure>
      <head>
        <xsl:apply-templates select="Para/Span[@class='head']" />
      </head>
      <xsl:apply-templates select="Figure/*" />
      <xsl:variable name="credits" select="
        if (Div[@class='credits']) then
        Div[@class='credits']/Para/node() else
        (Figure/Caption/* | Para/Span[@class='head'])/Span[@class='credits']
        " />
      <xsl:if test="$credits">
        <p rend="credits">
          <xsl:apply-templates select="$credits" />
        </p>
      </xsl:if>
    </figure>
  </xsl:template>

  <xsl:template match="Div[@class='encadre']">
    <floatingText type="encadre"><body><p>
        <xsl:apply-templates select="*[position() > 1]/node()" />
        <bibl type="sec_authority"><author><persName>
          <surname><xsl:value-of select="Para/Span/Span[@class='surname']"/></surname>
          <forename><xsl:value-of select="Para/Span/Span[@class='forename']"/></forename>
        </persName></author></bibl>
    </p></body></floatingText>
  </xsl:template>

  <xsl:template match="Pandoc/blocks">
    <xsl:call-template name="validations" />
<!-- S’il y a des choses avant le premier Header, on les met telles quelles,
avant de traiter les entêtes : -->
    <xsl:apply-templates select="*[not(
        self::Header or 
        preceding-sibling::Header or
        preceding-sibling::Div[. intersect $trueDiv]
      )]"/>

<!-- Ensuite, on traite les entêtes "enfants" d’un pseudo-Header de niveau 0 qui viendrait
au tout début de Pandoc/blocks : -->
    <xsl:variable name="childHead" select="Header[let $descLev := @level return not(
      preceding-sibling::Header[@level lt $descLev])]"/>
    <xsl:apply-templates select="$childHead except $biblioHead" />
  </xsl:template>

  <xsl:template match="Header">
<!-- L’éventuel Header commençant la bibliographie est traité dans toMC-bibliography.xsl-->
    <div type="section{number(@level)-$firstHeadLev+1}">
      <head><xsl:apply-templates /></head>
<!-- S’il y a des trucs avant d’éventuels sous-headers, les traiter ici : -->
      <xsl:apply-templates select=
        "following-sibling::*[not(
          self::Header or
          preceding-sibling::Header[. >> current()] or
          preceding-sibling::Div[. intersect $trueDiv and . >> current()] or
          . intersect $ignoredDiv
        )]" />
      <xsl:variable name="descHead" select=
        "let $lev := @level return if
        (not(following-sibling::Header[@level le $lev])) then following-sibling::Header
        else following-sibling::Header[@level gt $lev and
        not(preceding-sibling::Header[@level le $lev and . >> current()])]" />
      <xsl:variable name="childHead" select="$descHead[let $descLev := @level return not(
        preceding-sibling::Header[@level lt $descLev] intersect $descHead)]"/>
      <xsl:apply-templates select="$childHead except $biblioHead" />
    </div>
  </xsl:template>

  <xsl:template match="/">
<!--    <xsl:message select="count($formules) || ' ' || count($thebib) ||
      ' ' || $nFormInt" />-->
    <xsl:text>
</xsl:text>
    <TEI xml:space="default" xml:lang="{$docLang}">
      <xsl:call-template name="TEIheader" />
      <text xml:id="text" type="article">
        <xsl:call-template name="front" />
        <body>
          <xsl:apply-templates select="Pandoc/blocks" />
        </body>
        <xsl:if test="$laBiblioDiv">
          <back>
<!-- Mettre la bibliographie ici : -->
            <xsl:call-template name="bibliographie" />            
          </back>
        </xsl:if>
      </text>
    </TEI>
  </xsl:template>

</xsl:stylesheet>

<!--  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>-->

<!-- 2026-02-17 Les 56 éléments présents dans les AST pandoc de mes 24 articles :

BlockQuote
blocks
body
BulletList
Caption
Cell
Citation
citations
Cite
Code
CodeBlock
ColSpec
colspecs
Div
Emph
entry
Figure
Header
header
HorizontalRule
Image
item
LineBreak
Link
Math
meta
MetaBlocks
MetaBool
MetaInlines
MetaList
MetaMap
MetaString
Note
OrderedList
Pandoc
Para
Plain
prefix
Quoted
RawBlock
RawInline
Row
SmallCaps
SoftBreak
Space
Span
Str
Strikeout
Strong
Subscript
suffix
Superscript
Table
TableBody
TableFoot
TableHead
-->

<!-- 2026-02-17 Les 72 éléments présents dans
  "D:\_YmaProjets\MarcelloVR\2025-10-30-exemplier-metopes\indent\histoire-indent" :

ab
affiliation
anchor
appInfo
application
author
availability
back
bibl
biblScope
body
cell
change
cit
date
desc
dim
distributor
div
editor
editorialDecl
email
encodingDesc
epigraph
figDesc
figure
fileDesc
foreign
forename
front
funder
graphic
head
hi
idno
index
item
keywords
label
language
langUsage
lb
licence
list
listBibl
listChange
name
normalization
note
orgName
p
persName
profileDesc
publicationStmt
publisher
quote
ref
rendition
revisionDesc
row
seriesStmt
sourceDesc
surname
table
tagsDecl
TEI
teiHeader
term
text
textClass
title
titleStmt
-->