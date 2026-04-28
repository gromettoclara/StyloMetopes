<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2026 Yves Marcoux - Licence MIT -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:ym="http://www.marcouxmedias.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="" xml:lang="fr-CA" xml:space="ignore"
  exclude-result-prefixes="#all">

  <xsl:template name="bibliographie">
    <div type="bibliography" xml:id="bibliography">
      <xsl:choose>
        <xsl:when test="$biblioHead">
          <head><xsl:apply-templates select="$biblioHead/node()" /></head>
        </xsl:when>
        <xsl:when test="starts-with($docLang,'fr')">
          <head>Bibliographie</head>
        </xsl:when>
        <xsl:otherwise>
          <head>Bibliography</head>
        </xsl:otherwise>
      </xsl:choose>
<!-- Each embedded Div is a reference -->
      <xsl:for-each select="$laBiblioDiv/Div">
        <listBibl>
<!-- First, output the formatted reference. N.B.: Even if a reference always consists
in a single Para element, which we don’t want converted to a <p>, because
TEI does not allow <p> directly inside <bibl>. -->
          <bibl xml:id="{@id}">
            <xsl:choose>
<!-- S’il y a une formule (Math) sous la référence (Para) mais pas dans un Emph, il faut
tout wrapper dans un note, car formula n’est pas permis directement sous bibl
(sauf si dans hi). On pourrait le faire systématiquement, mais je le fais seulement
si effectivement requis : -->
<!-- On pourrait aussi ajouter la possibilité de formula comme contenu dans bibl au
niveau du RNG/ODD de Métopes, mais alors ce serait un ajout non présent
dans TEI P5 All Plus, alors que j’essaie de conserver la compatibilité. -->
              <xsl:when test="Para//Math[not(ancestor::Emph)]">
                <note><xsl:apply-templates select="Para/node()" /></note>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="Para/node()" />
              </xsl:otherwise>
            </xsl:choose>
          </bibl>
<!-- Now, output the semantic biblStruct: -->
<!-- We must skip the 'ref-' prefix that pandoc adds : -->
          <xsl:variable name="refid" select="substring(@id, 5)" />
          <xsl:variable name="theref" select=
            "($thebib/self::MetaMap[ym:mapPart(.,'id')=$refid])[last()]" />
<!-- [last()] en cas de doublon dans le BibLaTeX et pour faire comme pandoc,
  qui prend la dernière ^ -->
          <xsl:apply-templates select="$theref" />
          <xsl:if test="not($theref)">
            <xsl:message select="'RÃ©fÃ©rence introuvable : ' || $refid" />
          </xsl:if>
        </listBibl>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="Span[@class='csl-block']">
<!-- 2025-11-26 ^ Sert pour les Résumés et Annotations en bibliographies formatées
(rare : la plupart des formats CSL ne traitent ni l’un ni l’autre, mais je fais mes
tests avec un CSL qui je me suis fait et qui traite les deux). -->
    <note><xsl:apply-templates /></note>
  </xsl:template>

  <xsl:template match="$thebib">
<!-- Matche les références MetaMap ($theref) du .bib.xml -->
<!-- TEI suggère @type pour le type de ressource. -->
<!-- On ramène à 'misc' tous les types mappés à '' par pandoc : -->
    <biblStruct type="{let $t := ym:mapPart(.,'type')
      return if ($t ne '') then $t else 'misc'}"
      xml:id="{'semref-' || ym:mapPart(.,'id')}">

<!-- for-each with at most one thing, but maybe 0, is used heavily down here,
to avoid having to either define a variable (either empty or with
just one thing) and use it as both an if@test and apply-templates@select,
or repeating the same expression as both if@test and apply-templates@select: -->

<!-- Selon https://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-analytic.html
analytic est utilisé pour des items publiés dans une ressource plus vaste, et non
comme publication indépendante. -->

      <xsl:variable name="analytic" select="ym:mapPart(.,'container-title') or
        ym:mapPart(.,'issue')"/>
      <xsl:if test="$analytic">
        <analytic>
          <xsl:call-template name="movable" />
          <xsl:for-each select="ym:mapPart(.,'title')">
            <title level="a">
              <xsl:apply-templates />
            </title>
          </xsl:for-each>
          <xsl:for-each select="ym:mapPart(.,'title-short')">
            <title level="a" type="short">
              <xsl:apply-templates />
            </title>
          </xsl:for-each>
          <xsl:if test="ym:mapPart(.,'language') and
            (ym:mapPart(.,'title') or ym:mapPart(.,'title-short'))">
            <textLang><xsl:value-of select="ym:mapPart(.,'language')" /></textLang>
          </xsl:if>
        </analytic>
      </xsl:if>
      <monogr>
        <xsl:choose>
          <xsl:when test="$analytic">
            <xsl:variable name="title-level" select=
              "if (starts-with(ym:mapPart(.,'type'), 'article'))
              then 'j' else 'm'" />
            <xsl:for-each select="ym:mapPart(.,'container-title')">
              <title level="{$title-level}"><xsl:apply-templates /></title>
            </xsl:for-each>
            <xsl:if test="ym:mapPart(.,'language') and ym:mapPart(.,'container-title') 
              and not((ym:mapPart(.,'title') or ym:mapPart(.,'title-short')))">
              <textLang><xsl:value-of select="ym:mapPart(.,'language')" /></textLang>
            </xsl:if>
<!-- Traiter 'container-title-short' ici si nécessaire. -->
          </xsl:when>
          <xsl:otherwise>
<!-- not($analytic) -->
            <xsl:call-template name="movable" />
            <xsl:variable name="title-level" select=
              "if (ym:mapPart(.,'type') eq 'periodical') then 'j'
              else if (ym:mapPart(.,'type') = 'thesis') then 'u' else 'm'"/>
            <xsl:for-each select="ym:mapPart(.,'title')">
              <title level="{$title-level}"><xsl:apply-templates /></title>
            </xsl:for-each>
            <xsl:for-each select="ym:mapPart(.,'title-short')">
              <title type="short" level="{$title-level}"><xsl:apply-templates /></title>
            </xsl:for-each>
            <xsl:if test="ym:mapPart(.,'language') and
                (ym:mapPart(.,'title') or ym:mapPart(.,'title-short'))">
              <textLang><xsl:value-of select="ym:mapPart(.,'language')" /></textLang>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="ym:mapPart(.,'editor')/MetaMap">
          <editor><xsl:call-template name="personne"/></editor>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'edition')">
          <edition><xsl:apply-templates /></edition>
        </xsl:for-each>
        <imprint>
          <xsl:for-each select="ym:mapPart(.,'issued')">
            <date><xsl:value-of select="."/></date>
          </xsl:for-each>
          <xsl:for-each select="ym:mapPart(.,'publisher-place')">
            <pubPlace><xsl:apply-templates /></pubPlace>
          </xsl:for-each>
          <xsl:for-each select="ym:mapPart(.,'publisher')">
            <publisher><xsl:apply-templates /></publisher>
          </xsl:for-each>
          <xsl:if test="not(ym:mapPart(.,'issued') | ym:mapPart(.,'publisher-place')
            | ym:mapPart(.,'publisher'))">
<!-- imprint ne peut pas être vide et est obligatoire… -->
          <date>n.d.</date>
<!-- abréviation recommandée par l’OQLF pour "non déterminé(e)" -->
          </xsl:if>
        </imprint>
        <xsl:for-each select="ym:mapPart(.,'volume')">
          <biblScope unit="volume"><xsl:apply-templates /></biblScope>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'issue')">
          <biblScope unit="issue"><xsl:apply-templates /></biblScope>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'page')">
          <biblScope unit="pages"><xsl:apply-templates /></biblScope>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'number-of-pages')">
          <biblScope unit="number-of-pages"><xsl:apply-templates /></biblScope>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'number')">
          <biblScope unit="number"><xsl:apply-templates /></biblScope>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'chapter-number')">
<!-- Devrait probablement être chapter-number, mais dans l’existant stylo, ce champ
contient plutôt des (n = 2) titres de chapitre que des numéros : -->
          <biblScope unit="chapter"><xsl:apply-templates /></biblScope>
        </xsl:for-each>
      </monogr>
      <xsl:if test="ym:mapPart(.,'collection-title') or
        ym:mapPart(.,'collection-number')">
        <series>
          <xsl:for-each select="ym:mapPart(.,'collection-title')">
          <title level="s"><xsl:apply-templates /></title>
          </xsl:for-each>
          <xsl:if test="ym:mapPart(.,'language') and ym:mapPart(.,'collection-title') and
            not(ym:mapPart(.,'title') or ym:mapPart(.,'title-short')
            or ym:mapPart(.,'container-title'))">
<!-- Si le collection-title est le seul titre disponible, et que language est spécifié,
alors ce dernier n’a pas encore dans l’extrant ^ : -->
            <textLang><xsl:value-of select="ym:mapPart(.,'language')" /></textLang>
          </xsl:if>
          <xsl:for-each select="ym:mapPart(.,'collection-number')">
            <biblScope unit="number"><xsl:apply-templates /></biblScope>
          </xsl:for-each>
        </series>
      </xsl:if>
      <xsl:for-each select="ym:mapPart(.,'url')">
        <xsl:variable name="strVal" select="normalize-space()"/>
        <ref target="{$strVal}" type="URL">
          <xsl:value-of select="$strVal" />
          <xsl:for-each select="ym:mapPart(../..,'accessed')">
            <date type="accessed"><xsl:apply-templates /></date>
          </xsl:for-each>
        </ref>
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'doi')">
        <xsl:variable name="strVal" select="normalize-space()"/>
        <ref target="https://doi.org/{$strVal}" type="DOI">
          <xsl:value-of select="$strVal" />
          <xsl:for-each select="if (ym:mapPart(../..,'url'))
              then () else ym:mapPart(../..,'accessed')">
            <date type="accessed"><xsl:apply-templates /></date>
          </xsl:for-each>
        </ref>
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'pmid')">
        <xsl:variable name="strVal" select="normalize-space()"/>
        <ref target="https://www.ncbi.nlm.nih.gov/pubmed/{$strVal}" type="PubMedId">
          <xsl:value-of select="$strVal" />
          <xsl:for-each select="if (ym:mapPart(../..,'url') | ym:mapPart(../..,'doi'))
            then () else ym:mapPart(../..,'accessed')">
            <date type="accessed"><xsl:apply-templates /></date>
          </xsl:for-each>
        </ref>
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'isbn')">
        <xsl:variable name="strVal" select="normalize-space()"/>
        <ref target="https://isbnsearch.org/search?s={$strVal}" type="ISBN">
          <xsl:value-of select="$strVal" />
        </ref>
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'genre')">
        <note type="genre"><xsl:value-of select="translate(.,'{}','')"/></note>
<!-- We must remove {}’s because pandoc treats this field as a string, but
stylo usage treats it as inlines, and thus make ample use of {}’s, probably
to prevent change of capitalisation.
It is also not possible to use biblStruct@subtype for the genre (as would be natural),
because biblStruct@subtype must be a "word", and stylo usage does not go that way. -->
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'abstract')">
        <note type="abstract"><xsl:apply-templates /></note>
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'keyword')">
        <note type="keywords"><xsl:apply-templates /></note>
      </xsl:for-each>
      <xsl:for-each select="ym:mapPart(.,'annote') | ym:mapPart(.,'note')">
        <note type="annotation"><xsl:apply-templates /></note>
      </xsl:for-each>
    </biblStruct>
  </xsl:template>

  <xsl:template name="movable">
<!-- Fait les trucs qui peuvent être soit dans analytic soit dans monogr : -->
    <xsl:for-each select="ym:mapPart(.,'author')/MetaMap">
      <author><xsl:call-template name="personne" /></author>
    </xsl:for-each>
    <xsl:for-each select="ym:mapPart(.,'translator')/MetaMap">
      <editor role="trl"><xsl:call-template name="personne" /></editor>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="personne">
    <xsl:for-each select="entry">
      <xsl:element name=
        "{if (@key=('family', 'literal')) then 'surname'
        else if (@key='given') then 'forename'
        else if (@key='suffix') then 'genName'
        else 'nameLink'}">
        <xsl:if test="not(@key = ('given', 'family'))">
<!-- Particle, literal or suffix: indicate in @type : -->
          <xsl:attribute name="type" select="@key" />
        </xsl:if>
        <xsl:value-of select="MetaString" />
      </xsl:element>
    </xsl:for-each>
  </xsl:template> 

<!--
https://www.tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#COBIOT suggère carrément
une correspondance entre BibTeX et TEI !!!!!! Malheureusement, pas CSL…

Fréquences de la présence des 46 champs CSL produisibles par pandoc dans
l’existant bibliographique (508 références dans megabib-sans-doublon.bib).
Implanter les champs CSL dans cet ordre.
30 champs ont une fréquence de présence > 0.

*title	507
*issued	503
*author	487
*publisher	321
*publisher-place	303
*container-title	193
*title-short	159
*page	139
*url	124 (utiliser ref@target https://www.tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#COBIXR-egXML-ad)
*isbn	107
*issue	104
*volume	95
*note	83
*abstract	79
*collection-title	67
*accessed	65
*doi	63
*issn	46
*keyword	41
*edition	39
*editor	31
*translator	20
*language	17 (voir https://www.tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#COBICON)
  (aussi https://github.com/jgm/pandoc/issues/11451 sur langid / language de BibLaTeX
  pandoc mappe BibLaTeX langid sur language, et ignore le champ BibLaTeX language, mais
  devrait mapper langue sur language et ignorer langid)
*collection-number	14
*pmid	13
*number-of-pages	7
*chapter-number	6
*genre	6
*annote	3
*number	3
call-number	0
container-author	0
container-title-short	0
event	0
event-date	0
event-place	0
jurisdiction	0
number-of-volumes	0
original-date	0
original-publisher	0
original-publisher-place	0
original-title	0
other-ids	0
status	0
version	0
volume-title	0
-->
</xsl:stylesheet>
