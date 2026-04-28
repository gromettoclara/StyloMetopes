<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2026 Yves Marcoux - Licence MIT -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ym="http://www.marcouxmedias.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="" xml:lang="fr-CA" xml:space="default">

  <xsl:output method="text" indent="no" encoding="UTF-8"
    omit-xml-declaration="yes" />

  <xsl:function name="ym:lastIndexOf" as="xs:integer">
    <xsl:param name="str" />
    <xsl:param name="car" />
    <xsl:sequence select="if (contains($str, $car)) then
      max(for $i in (1 to string-length($str)) return
      if (substring($str, $i, 1) = $car) then $i else 0)
      else 0" />
  </xsl:function>

  <xsl:variable name="thebib">
    <xsl:variable name="temp" select="base-uri(/)" />
    <xsl:variable name="temp"
      select="substring($temp, 1, ym:lastIndexOf($temp, '.')-1)" />
    <xsl:variable name="temp"
      select="substring($temp, 1, ym:lastIndexOf($temp, '.'))" />
    <xsl:sequence select=
      "document($temp || 'bib.xml')/Pandoc/meta/entry[@key='references']/MetaList" />
  </xsl:variable>

  <xsl:template match="/">
    <xsl:for-each select="descendant::Math, $thebib//Math">
      <xsl:variable name="delim" select=
        "if (@math-type='DisplayMath') then '$$' else '$'" />
      <xsl:text>


</xsl:text>
      <xsl:value-of select="$delim" />
      <xsl:value-of select="." />
      <xsl:value-of select="$delim" />
      <xsl:text>


</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
