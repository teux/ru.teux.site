<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:opentopic="http://www.idiominc.com/opentopic"
	exclude-result-prefixes="exsl opentopic">

<xsl:output method="text" encoding="UTF-8" indent="no"/>

<xsl:param name="DITAEXT"/>
<xsl:param name="OUTEXT"/>

<!-- Define a newline character -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>


<xsl:template match="*[contains(@class, ' bookmap/part ')]">
  <xsl:variable name="partNum" select="count(preceding-sibling::*[contains(@class, ' bookmap/part ')])+1" />
	<xsl:variable name="menuId" select="concat('menu', $partNum, 'ent')"/>
  
  <xsl:text>//Menu entries for </xsl:text><xsl:value-of select="./@ohref"/><xsl:value-of select="$newline" />
  <xsl:text>var </xsl:text><xsl:value-of select="$menuId"/><xsl:text>=new Array();</xsl:text>
  
  <xsl:for-each select="*[contains(@class, ' map/topicref')]">
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$menuId"/>
    <xsl:text>[</xsl:text><xsl:value-of select="count(preceding-sibling::*[contains(@class, ' map/topicref ')])"/><xsl:text>]</xsl:text>
    <xsl:text>='&lt;a href="</xsl:text>
    <xsl:value-of select="replace(@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"/>
    <xsl:text>"&gt;</xsl:text>
    <xsl:value-of select="if (@navtitle) then @navtitle else topicmeta/navtitle"/>
    <xsl:text>&lt;/a&gt;';</xsl:text>
  </xsl:for-each>
  <xsl:value-of select="$newline"/><xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-templates select="//opentopic:map/*[contains(@class, ' bookmap/part ')]"/>
</xsl:template>

</xsl:stylesheet>
