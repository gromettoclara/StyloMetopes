<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2026 Yves Marcoux - Licence MIT -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xml:lang="fr-CA" xml:space="ignore"
  exclude-result-prefixes="#all">

  <xsl:output method="xml" version="1.0" indent="no" encoding="UTF-8"
    omit-xml-declaration="no" />

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="p|div|cit|bibl|figure|floatingText|list|table">
    <xsl:copy>
      <xsl:attribute name="xml:id" select=
        "name()||1+count((preceding::*|ancestor::*)[name() eq current()/name()])" />
      <xsl:apply-templates select="node()|@*"/>
<!-- NB: Pour les <bibl> de la bibliographie, ils ont déjà un xml:id, auquel
  le <xsl:apply-templates select="node()|@*"/> donne préséance;
  le <xsl:attribute> est donc sans effet. -->
    </xsl:copy>
  </xsl:template>

  <xsl:template match="note">
    <xsl:copy>
      <xsl:if test="@place">
        <xsl:variable name="notes" select="preceding::note|ancestor::note" />
        <xsl:variable name="noteCount" select="1+count($notes[@place])" />
        <xsl:variable name="matchingCount"
          select="1+count($notes[@place eq current()/@place])" />
        <xsl:variable name="matchingCountRoman">
          <xsl:number format="i" value="$matchingCount" />
        </xsl:variable>
        <xsl:attribute name="xml:id" select="'ftn'||$noteCount" />
        <xsl:attribute name="n"
          select="if (@place eq 'end') then $matchingCountRoman else $matchingCount" />
      </xsl:if>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
