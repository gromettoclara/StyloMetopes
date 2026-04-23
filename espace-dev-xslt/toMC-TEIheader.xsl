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

  <xsl:template name="TEIheader">
    <teiHeader>
      <fileDesc>
        <titleStmt>
          <xsl:for-each select="ym:mapPart($docMeta,'title')">
            <title type="main"><xsl:apply-templates /></title>
          </xsl:for-each>
          <xsl:for-each select="ym:mapPart($docMeta,'subtitle')">
            <title type="sub"><xsl:apply-templates /></title>
          </xsl:for-each>
          <xsl:for-each select="$localizedContent">
            <xsl:for-each select="ym:mapPart(.,'title')">
              <title type="trl" xml:lang="{ym:mapPart(../..,'lang')}">
                <xsl:apply-templates />
                <xsl:for-each select="ym:mapPart(../..,'subtitle')">
                  <xsl:text> : </xsl:text>
                  <xsl:apply-templates />
                </xsl:for-each>
              </title>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:for-each select="ym:mapPart($docMeta,'authors')/MetaMap">
            <author role="aut">
              <persName>
                <forename>
                  <xsl:apply-templates select="ym:mapPart(.,'forename')" />
                </forename>
                <surname>
                  <xsl:apply-templates select="ym:mapPart(.,'surname')" />
                </surname>
              </persName>
              <xsl:for-each select="ym:mapPart(.,'isni')">
                <idno type="ISNI"><xsl:value-of select="."/></idno>
              </xsl:for-each>
              <xsl:for-each select="ym:mapPart(.,'orcid')">
                <idno type="ORCID"><xsl:value-of select="."/></idno>
              </xsl:for-each>
              <xsl:for-each select="ym:mapPart(.,'viaf')">
                <idno type="VIAF"><xsl:value-of select="."/></idno>
              </xsl:for-each>
              <xsl:for-each select="let $t := ym:mapPart(.,'affiliations') return
                $t[self::MetaInlines] | $t/MetaInlines">
<!-- Pattern TRÈS INTÉRESSANT pour couvrir les cas où une méta est simple ou multiple
d’un seul coup ^ -->
                <affiliation>
                  <orgName><xsl:apply-templates /></orgName>
                </affiliation>
              </xsl:for-each>
            </author>
          </xsl:for-each>
          <xsl:for-each select="let $t := ym:mapPart($docMeta,'translators') return
            $t[self::MetaMap] | $t/MetaMap">
            <editor role="trl">
              <persName>
                <forename>
                  <xsl:apply-templates select="ym:mapPart(.,'forename')" />
                </forename>
                <surname>
                  <xsl:apply-templates select="ym:mapPart(.,'surname')" />
                </surname>
              </persName>
              <xsl:for-each select="ym:mapPart(.,'isni')">
                <idno type="ISNI"><xsl:value-of select="."/></idno>
              </xsl:for-each>
              <xsl:for-each select="ym:mapPart(.,'orcid')">
                <idno type="ORCID"><xsl:value-of select="."/></idno>
              </xsl:for-each>
              <xsl:for-each select="ym:mapPart(.,'viaf')">
                <idno type="VIAF"><xsl:value-of select="."/></idno>
              </xsl:for-each>
              <xsl:for-each select="ym:mapPart(.,'affiliations')[self::MetaInlines]
                | ym:mapPart(.,'affiliations')/MetaInlines">
<!-- Pattern très intéressant pour couvrir les cas où une méta est simple ou multiple
d’un seul coup ^ -->
                <affiliation>
                  <orgName><xsl:apply-templates /></orgName>
                </affiliation>
              </xsl:for-each>
            </editor>
          </xsl:for-each>
          <xsl:for-each select="ym:mapPart(ym:mapPart($docMeta,'funder'),'organization')">
<!-- Si seul id est présent (sans organization), ce template ne produit rien.
Rien n’empêcherait de changer ça. -->
            <funder><orgName><xsl:apply-templates /></orgName>
              <idno>
<!-- 2026-04-01 Uncomment for dynamic call to public API:
Pour info sur un organisme : https://doi.org/10.13039/«id»
                <xsl:variable name="orgRec" select="
    'https://api.crossref.org/funders?query=' || string(.) ||
    '&amp;mailto=ym@marcouxmedias.com'
                  " />
                <xsl:variable name="orgRec" select="unparsed-text($orgRec)" />
                <xsl:variable name="orgRec" select="json-to-xml($orgRec)" />
                <xsl:variable name="idno" select=
    "$orgRec/map/map[@key='message']/array[@key='items']/map[1]/string[@key='id']"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions" />
-->
                <xsl:variable name="idno" select="ym:mapPart(../..,'id')" />
                <xsl:choose>
                  <xsl:when test="$idno"><xsl:value-of select="$idno" /></xsl:when>
                  <xsl:otherwise>XXXX</xsl:otherwise>
                </xsl:choose>
              </idno>
            </funder>
          </xsl:for-each>
<!--          <xsl:for-each select="$laSponsDiv">
            <sponsor><orgName>
                <xsl:apply-templates select="*/node()"/>
            </orgName></sponsor>
          </xsl:for-each> 2026-03-15 Ils ne le veulent pas ici. -->
        </titleStmt>
        <publicationStmt>
          <ab><bibl>
            <xsl:for-each select=
              "ym:mapPart(ym:mapPart($docMeta,'production'),'entities')
                /MetaMap[entry[@key='type' and *='publisher']
                  and normalize-space(ym:mapPart(.,'name'))]">
              <publisher><xsl:apply-templates select="ym:mapPart(.,'name')"
                /></publisher>
            </xsl:for-each>
            <xsl:for-each select="ym:mapPart($docMeta,'publicationDate')">
              <date><xsl:apply-templates /></date>
            </xsl:for-each>
            <xsl:for-each select="ym:mapPart($docMeta,'license')">
              <availability><licence><xsl:apply-templates /></licence></availability>
<!-- Selon le portail linguistique du Canada, "licence" est britannique/canadien, alors
  que "license" est américain. -->
            </xsl:for-each>
            <xsl:for-each select="ym:mapPart(ym:mapPart($docMeta,'journal'),'name')">
              <title level="j"><xsl:apply-templates /></title>
            </xsl:for-each>
          </bibl></ab>
        </publicationStmt>
        <sourceDesc>
          <p>Document créé sous forme numérique en Markdown dans Stylo.</p>
        </sourceDesc>
      </fileDesc>
      <profileDesc>
        <langUsage>
          <language ident="{$docLang}" />
        </langUsage>
        <xsl:if test="$ckw | $kw | $lkw">
          <textClass>
            <xsl:for-each select="$kw">
              <keywords scheme="keyword" xml:lang="{$docLang}">
                <list>
                  <xsl:for-each select="MetaInlines">
                    <item><xsl:apply-templates /></item>
                  </xsl:for-each>
                </list>
              </keywords>
            </xsl:for-each>
            <xsl:for-each select="$ckw">
              <keywords scheme="rameau" xml:lang="{$docLang}">
                <list>
                  <xsl:for-each select="MetaMap">
                    <item><xsl:apply-templates select="ym:mapPart(.,'label')" /></item>
                  </xsl:for-each>
                </list>
              </keywords>
            </xsl:for-each>
            <xsl:for-each select="$lkw">
              <keywords scheme="keyword" xml:lang="{ym:mapPart(.,'lang')}">
                <list>
                  <xsl:for-each select="ym:mapPart(.,'keywords')/MetaInlines">
                    <item><xsl:apply-templates /></item>
                  </xsl:for-each>
                </list>
              </keywords>
            </xsl:for-each>
          </textClass>
        </xsl:if>
      </profileDesc>
      <revisionDesc>
        <listChange>
          <change type="creation" when=
            "{translate(substring(string(current-dateTime()), 1, 10), 'T', ' ')}"
            >XML-TEI file creation</change>
        </listChange>
      </revisionDesc>
    </teiHeader>
  </xsl:template>
</xsl:stylesheet>
