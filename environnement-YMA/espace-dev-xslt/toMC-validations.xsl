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
<!-- Appelé à partir de Pandoc/blocks. -->
    <xsl:if test="Header[
      number(preceding-sibling::Header[1]/@level) lt number(@level)-1
      or number(@level) lt $firstHeadLev]">
      <xsl:message>ATTENTION : Niveaux de titre non consécutifs, des sections seront promues.</xsl:message>
    </xsl:if>
    <xsl:if test=".//Div/Header[preceding-sibling::*[not(self::RawBlock)]]">
      <xsl:message>ATTENTION : Les titres dans une division (:::) sont traités comme de simples paragraphes.</xsl:message>
    </xsl:if>
    <xsl:if test="$ignoredDiv/ancestor::Div">
      <xsl:message>ATTENTION : Au moins une division sémantique ({.ack}, etc.) est imbriquée dans une autre division, résultats imprévisibles.</xsl:message>
    </xsl:if>
<!--    <xsl:if test="//HorizontalRule">
      <xsl:message>ATTENTION : Les lignes horizontales (-\-\-) seront ignorées.</xsl:message>
    </xsl:if> 2026-03-15 Métopes les supporte, finalement. -->
    <xsl:if test=".//BlockQuote[not(ancestor-or-self::*[@class eq 'quotcomplexe'])
      and ((count(*) > 1 or *[not(self::Para)]))]">
      <xsl:message>ATTENTION : Au moins une citation normale (❯&#x200b;) contient plus d’un paragraphe.</xsl:message>
<!-- The presence of &x200b; (zero-width space) fixes (mysteriously) a bug which prevents Notepad++ 
    to display ❯ correctly while visualizing the log. (Notepad or Firefox don’t have that bug.) -->
    </xsl:if>
    <xsl:if test=".//Div[@class='quote-alt'
      and ((count(*) > 1 or *[not(self::Para)]))]">
      <xsl:message>ATTENTION : Au moins une citation 'quote-alt' contient plus d’un paragraphe.</xsl:message>
    </xsl:if>
    <xsl:if test=".//Div[@class='trad' and not(parent::Div[@class='quotcomplexe'])]">
      <xsl:message>ATTENTION : Au moins une section 'trad' n’est pas dans une section 'quotcomplexe'.</xsl:message>
    </xsl:if>
    <xsl:if test=".//Span[@class='verse' and not(parent::Para/parent::BlockQuote)]">
      <xsl:message>ATTENTION : Au moins un segment 'verse' n’est pas dans une citation normale (❯&#x200b;).</xsl:message>
    </xsl:if>
    <xsl:if test=".//Div[@class='quotcomplexe' and not(BlockQuote)]">
      <xsl:message>ATTENTION : Au moins une section 'quotcomplexe' ne contient aucune citation normale (❯&#x200b;).</xsl:message>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
