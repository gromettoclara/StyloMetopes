<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2026 Yves Marcoux - Licence GNU GPL -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:ym="http://www.marcouxmedias.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="" xml:lang="fr-CA" xml:space="ignore"
  exclude-result-prefixes="#all">

  <xsl:template name="front">
    <front>
      <div type="titlePage">
        <xsl:for-each select="ym:mapPart($docMeta,'title')">
          <p rend="title-main"><xsl:apply-templates /></p>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart($docMeta,'subtitle')">
          <p rend="title-sub"><xsl:apply-templates /></p>
        </xsl:for-each>
        <xsl:for-each select="$localizedContent">
          <xsl:for-each select="ym:mapPart(.,'title')">
            <p rend="title-trl" xml:lang="{ym:mapPart(../..,'lang')}">
              <xsl:apply-templates />
              <xsl:for-each select="ym:mapPart(../..,'subtitle')">
                <xsl:text> : </xsl:text>
                <xsl:apply-templates />
              </xsl:for-each>
            </p>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart($docMeta,'authors')/MetaMap">
          <p rend="author-aut">
            <xsl:apply-templates select="ym:mapPart(.,'forename')"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="ym:mapPart(.,'surname')"/>
          </p>
          <xsl:for-each select="ym:mapPart(.,'affiliations')[self::MetaInlines]
            | ym:mapPart(.,'affiliations')/MetaInlines">
            <p rend="authority_affiliation"><xsl:apply-templates /></p>
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart($docMeta,'translators')/MetaMap">
          <p rend="editor-trl">
            <xsl:apply-templates select="ym:mapPart(.,'forename')"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="ym:mapPart(.,'surname')"/>
          </p>
          <xsl:for-each select="ym:mapPart(.,'affiliations')[self::MetaInlines]
            | ym:mapPart(.,'affiliations')/MetaInlines">
            <p rend="authority_affiliation"><xsl:apply-templates /></p>
          </xsl:for-each>
        </xsl:for-each>
      </div>
      <xsl:for-each select="ym:mapPart($docMeta,'abstract')">
        <div type="abstract" xml:lang="{$docLang}">
          <p><xsl:apply-templates /></p>
        </div>
      </xsl:for-each>
      <xsl:if test="$kw | $ckw">
          <div type="keywords" xml:lang="{$docLang}">
            <xsl:if test="$kw">
              <p><hi rend="bold">Mots-clés :</hi><xsl:text> </xsl:text>
                <xsl:for-each select="$kw/*">
                  <xsl:if test="position() ne 1">, </xsl:if>
                  <xsl:apply-templates select="." />
                </xsl:for-each>
              </p>
            </xsl:if>
            <xsl:if test="$ckw">
              <p><hi rend="bold">Mots-clés (RAMEAU) :</hi><xsl:text> </xsl:text>
                  <xsl:for-each select="$ckw/*">
                  <xsl:if test="position() ne 1">, </xsl:if>
                  <xsl:apply-templates select="ym:mapPart(.,'label')" />
                </xsl:for-each>
              </p>
            </xsl:if>
          </div>
      </xsl:if>
      <xsl:for-each select="$localizedContent">
        <xsl:for-each select="ym:mapPart(.,'abstract')">
          <div type="abstract" xml:lang="{ym:mapPart(../..,'lang')}">
            <p><xsl:apply-templates /></p>
          </div>
        </xsl:for-each>
        <xsl:for-each select="ym:mapPart(.,'keywords')">
          <div type="keywords" xml:lang="{ym:mapPart(../..,'lang')}">
            <p><hi rend="bold">Mots-clés (<xsl:value-of
                  select="ym:mapPart(../..,'lang')"/>) :</hi><xsl:text> </xsl:text>
              <xsl:for-each select="*">
                <xsl:if test="position() ne 1">, </xsl:if>
                <xsl:apply-templates select="." />
              </xsl:for-each></p>
          </div>
        </xsl:for-each>
      </xsl:for-each>

<!-- funder & sponsor : -->
      <xsl:for-each select="ym:mapPart(ym:mapPart($docMeta,'funder'),'organization')">
        <div type="funder"><p><xsl:apply-templates /></p></div>
      </xsl:for-each>
      <xsl:for-each select="$laSponsDiv">
        <div type="sponsor"><xsl:apply-templates select="*"/></div>
      </xsl:for-each>

<!-- Ici les acknowledgements (2 sources possibles : $laAckDiv et le YAML,
        on donne priorité à la première) : -->
      <xsl:choose>
        <xsl:when test="$laAckDiv">
          <div type="ack"><xsl:apply-templates select="$laAckDiv/*" /></div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="ym:mapPart($docMeta,'acknowledgements')">
            <div type="ack"><p><xsl:apply-templates /></p></div>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

<!-- dedication : -->
      <xsl:for-each select="$laDedicDiv">
        <div type="dedication"><xsl:apply-templates select="*" /></div>
      </xsl:for-each>

<!-- Les notes préliminaires : -->
      <xsl:for-each select="$laAutDiv">
        <note type="aut"><xsl:apply-templates select="*" /></note>
      </xsl:for-each>
      <xsl:for-each select="$laPblDiv">
        <note type="pbl"><xsl:apply-templates select="*" /></note>
      </xsl:for-each>
      <xsl:for-each select="$laTrlDiv">
        <note type="trl"><xsl:apply-templates select="*" /></note>
      </xsl:for-each>

<!-- L’argument : -->
      <xsl:for-each select="$laArgDiv">
        <argument><xsl:apply-templates select="*" /></argument>
      </xsl:for-each>

<!-- Ici l’épigraphe : -->
      <xsl:for-each select="$laEpigDiv">
        <epigraph><xsl:apply-templates select="*" /></epigraph>
      </xsl:for-each>
    </front>
  </xsl:template>
</xsl:stylesheet>
