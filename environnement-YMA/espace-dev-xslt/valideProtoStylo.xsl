<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2026 Yves Marcoux - Licence MIT -->
<!--
Validation des conventions de codage propres à Stylo en Markdown.
Note : C’est l’AST construit par Pandoc et non le Markdown lui-même qui est validé.
-->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:ym="http://www.marcouxmedias.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xp="http://www.w3.org/2005/xpath-functions"
  xpath-default-namespace="" xml:lang="fr-CA" xml:space="ignore"
  exclude-result-prefixes="#all">

  <xsl:param name="imagePath" select="'../icono/br/'" />

  <xsl:include href="toMC-validations.xsl"/>

  <xsl:output method="json" indent="yes" />

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
  <xsl:variable name="laAutDiv" select="//Div[@class='prenote' and @origin='aut']" />
  <xsl:variable name="laPblDiv" select="//Div[@class='prenote' and @origin='pb']" />
  <xsl:variable name="laTrlDiv" select="//Div[@class='prenote' and @origin='trl']" />
  <xsl:variable name="laArgDiv" select="//Div[@class='argument']" />

  <xsl:variable name="ignoredDiv" select=
    "$laBiblioDiv | $laAckDiv | $laEpigDiv | $laSponsDiv | $laDedicDiv
      | $laAutDiv | $laPblDiv | $laTrlDiv | $laArgDiv" />
<!-- ^ Stuff to ignore in the normal flow of sectional elements, because they
  are relocated to predetermined places in the output (header, front or back) -->

  <xsl:variable name="fakeDiv" select="//Div[@class=('question', 'answer', 'sig',
    'quote-alt', 'rich-quote', 'translation', 'figure', 'credits', 'box')]" />
<!-- ^ Les Div qui ne sont pas déplacées et qui ne donnent pas lieu à une
    <div> dans l’extrant -->

  <xsl:variable name="trueDiv" select="//Div except ($ignoredDiv | $fakeDiv)" />

  <xsl:template name="message">
<!-- template appelé par toMC-validations.xsl -->
    <xsl:param name="severity" select="'W'" as="xs:string" />
    <xsl:param name="text" as="xs:string" />
    <xsl:param name="object" as="node()" />
    <xp:map>
      <xp:string key="severity"><xsl:value-of select="$severity"/></xp:string>
      <xp:string key="messageText"><xsl:value-of select="$text"/></xp:string>
      <xp:string key="xpath"><xsl:value-of select="path($object)" /></xp:string>
      <xp:string key="nameInAST"><xsl:value-of select="$object/name()" /></xp:string>
      <xp:array key="attributes">
        <xsl:for-each select="$object/@*">
          <xp:map>
            <xp:string key="name"><xsl:value-of select="name()"/></xp:string>
            <xp:string key="value"><xsl:value-of select="."/></xp:string>
          </xp:map>
        </xsl:for-each>
      </xp:array>
      <xsl:variable name="nearestTitle" select=
        "($object/self::Header, $object/preceding::Header[1])[1]" />
      <xp:string key="nearestTitle">
        <xsl:for-each select="1 to $nearestTitle/@level">#</xsl:for-each>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$nearestTitle" />
      </xp:string>
      <xp:string key="faultyTextPretty">
        <xsl:value-of select="ym:pretty($object)" />
      </xp:string>
      <xp:string key="faultyTextRaw"><xsl:value-of select="string($object)"
      /></xp:string>
    </xp:map>
    <xsl:message terminate="{if ($severity=('F','f')) then 'yes' else 'no'}" />
  </xsl:template>

  <xsl:template match="Pandoc/blocks">
    <xsl:variable name="messages">
      <xp:array>
        <xsl:call-template name="validations" />
      </xp:array>
    </xsl:variable>
    <xsl:sequence select="parse-json(xml-to-json($messages))" />
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="Pandoc/blocks" />
  </xsl:template>

</xsl:stylesheet>
