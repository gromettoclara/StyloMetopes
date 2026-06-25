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

<!-- Pour que les messages d’erreur soient écrits dans le log en UTF-8, il faut le
  paramètre suivant dans la commande java : java -Dfile.encoding=UTF-8 -jar … -->

  <xsl:template name="validations">
<!-- Appelé à partir de Pandoc/blocks.
Appelle le template "message", qui doit être défini dans la feuille appelante. -->

    <xsl:for-each select=".//Div[not(@id='refs') and @class[not(. = (
      'ack',
      'answer',
      'argument',
      'credits',
      'csl-entry',
      'dedication',
      'box',
      'epigraph',
      'figure',
      'prenote',
      'question',
      'quote-alt',
      'rich-quote',
      'sig',
      'sponsor',
      'translation'
      ))]]">
      <xsl:call-template name="message">
        <xsl:with-param name="text">Section (:::) de type inconnu '<xsl:value-of
            select="@class" />'</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select=".//Span[@class[not(. = (
      'auth',
      'credits',
      'csl-block',
      'endnote',
      'forename',
      'head',
      'inlinequote',
      'institution',
      'lieu',
      'nocase',
      'oeuvre',
      'personnalite',
      'speaker',
      'surname',
      'verse'
      ))]]">
      <xsl:call-template name="message">
        <xsl:with-param name="text">Segment […] de type inconnu '<xsl:value-of
            select="@class" />'</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="Header[
      number(preceding-sibling::Header[1]/@level) lt number(@level)-1
      or number(@level) lt $firstHeadLev]">
      <xsl:call-template name="message">
        <xsl:with-param name="text">Titre (niveau <xsl:value-of select="@level"
/>) hors séquence</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select=".//Div/Header[preceding-sibling::*[not(self::RawBlock)]]">
      <xsl:call-template name="message">
        <xsl:with-param name="text">Titre (niveau <xsl:value-of select="@level"
/>) inclus dans une section (:::), sera traité comme paragraphe</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="$ignoredDiv[ancestor::Div]">
      <xsl:call-template name="message">
        <xsl:with-param name="text">Section '<xsl:value-of select="@class"
/>' imbriquée dans une autre section; résultats imprévisibles</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select=".//Span[@class='verse' and not(parent::Para/parent::BlockQuote)]">
      <xsl:call-template name="message">
        <xsl:with-param name="text"
          >Segment 'verse' rencontré hors citation normale (❯&#x200b;)</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

<!-- The presence of &x200b; (zero-width space) fixes (mysteriously) a bug which
  prevents Notepad++ to display ❯ correctly while visualizing the log.
  (Notepad or Firefox don’t have that bug.) -->
<!--
2026-06-24 Realized multiple paragraphs in quotations are not a problem:

<xsl:for-each select=".//BlockQuote[not(ancestor-or-self::*[@class eq 'rich-quote'])
      and ((count(*) > 1 or *[not(self::Para)]))]">
      <xsl:call-template name="message">
        <xsl:with-param name="text"
          >Citation normale (❯&#x200b;) contenant plus d’un paragraphe</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select=".//Div[@class='quote-alt'
      and ((count(*) > 1 or *[not(self::Para)]))]">
      <xsl:call-template name="message">
        <xsl:with-param name="text"
          >Citation 'quote-alt' contenant plus d’un paragraphe</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>
-->
    <xsl:for-each select=".//Div[@class='translation' and not(parent::Div[@class='rich-quote'])]">
      <xsl:call-template name="message">
        <xsl:with-param name="text"
          >Section 'translation' rencontrée hors section 'rich-quote'</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select=".//Div[@class='rich-quote' and not(BlockQuote)]">
      <xsl:call-template name="message">
        <xsl:with-param name="text"
          >Section 'rich-quote' ne contenant aucune citation normale (❯&#x200b;)</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select=".//Div[@class='translation' and not(BlockQuote)]">
      <xsl:call-template name="message">
        <xsl:with-param name="text"
          >Section 'translation' ne contenant aucune citation normale (❯&#x200b;)</xsl:with-param>
        <xsl:with-param name="object" select="." />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:if test="$laAckDiv and ym:mapPart($docMeta,'acknowledgements')">
      <xsl:call-template name="message">
        <xsl:with-param name="severity" select="'I'" />
        <xsl:with-param name="text"
          >Métadonnée 'acknowledgements' ignorée au profit de la section 'ack'</xsl:with-param>
        <xsl:with-param name="object" select="ym:mapPart($docMeta,'acknowledgements')" />
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

<!-- Fonction ym:pretty et mode pretty centralisés ici pour être disponibles pour
  utilisation par le template "message" fourni par la feuille appelante : -->

  <xsl:template mode="pretty" match="*">
    <xsl:apply-templates mode="pretty" />
  </xsl:template>
  <xsl:template mode="pretty" match="text()">
    <xsl:value-of select="." />
  </xsl:template>
  <xsl:template mode="pretty" match="LineBreak | SoftBreak | Space">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:function name="ym:pretty">
    <xsl:param name="object" as="node()" />
    <xsl:variable name="pretty">
      <xsl:apply-templates select="$object" mode="pretty" />
    </xsl:variable>
    <xsl:value-of select="normalize-space($pretty)"/>
  </xsl:function>

</xsl:stylesheet>
