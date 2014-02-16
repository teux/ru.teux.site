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
  <xsl:variable name="treeName">
	<xsl:text>ltocent</xsl:text>
	<xsl:value-of select="count(preceding-sibling::*[contains(@class, ' bookmap/part ')])+1"/>
	<xsl:text>.js</xsl:text>
  </xsl:variable>
  
  <xsl:result-document href="{$treeName}" method="text" encoding="UTF-8" indent="no">
    <xsl:text>//Local TOC for </xsl:text><xsl:value-of select="./@ohref"/><xsl:value-of select="$newline"/> 
  	<xsl:text>var TITEMS = [</xsl:text><xsl:value-of select="$newline"/> 
	  <xsl:call-template name="tocEntry"/>
		<xsl:text>];</xsl:text>
  </xsl:result-document>
</xsl:template>


<xsl:template name="tocEntry">
  <xsl:for-each select="*[contains(@class, ' map/topicref ')]">
	<xsl:for-each select="ancestor::*[contains(@class, ' map/topicref ')]">
	  <xsl:text>  </xsl:text> <!-- отступ слева на уровень вложенности -->
	</xsl:for-each>
  	<xsl:text>["</xsl:text>
	  <xsl:value-of select="if (@navtitle) then @navtitle else topicmeta/navtitle"/>
	<xsl:text>", "</xsl:text>
	  <xsl:value-of select="replace(@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"/>
    <xsl:text>", "</xsl:text>
    <!-- номер иконки зависит от наличия подразделов -->
    <xsl:choose>
	  <xsl:when test="*[contains(@class, ' map/topicref ')]">
	    <xsl:text>1", </xsl:text><xsl:value-of select="$newline"/>
	    <xsl:call-template name="tocEntry"/>
		<xsl:for-each select="ancestor::*[contains(@class, ' map/topicref ')]">
		  <xsl:text>  </xsl:text> <!-- отступ слева на уровень вложенности -->
		</xsl:for-each>
		<xsl:text>]</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>11"]</xsl:text>
	  </xsl:otherwise>
    </xsl:choose>
	<!-- Последний/непоследний -->
	<xsl:if test="following-sibling::*[contains(@class, ' map/topicref ')]">
	  <xsl:text>,</xsl:text>
	</xsl:if>
	<xsl:value-of select="$newline"/>
  </xsl:for-each>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-templates select="//opentopic:map/*[contains(@class, ' bookmap/part ')]"/>
</xsl:template>

</xsl:stylesheet>
