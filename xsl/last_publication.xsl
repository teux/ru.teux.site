<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:opentopic="http://www.idiominc.com/opentopic"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:teux="http://teux.ru"
	exclude-result-prefixes="exsl opentopic">

<xsl:output method="text" encoding="Windows-1251" indent="no"/>

<xsl:param name="DITAEXT"/>
<xsl:param name="OUTEXT"/>

<!-- Define a newline character -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>


<!-- Функция сортировки -->
<xsl:function name="teux:dSort">
  <xsl:param name="in"/>
  <xsl:perform-sort select="$in">
     <xsl:sort select="xs:date(@date)" order="descending"/>
  </xsl:perform-sort>
</xsl:function>


<!-- Основной шаблон    -->
<xsl:template match="/">
	
	<!-- Временное дерево с элементами dTopic -->
	<xsl:variable name="datedTopic">
  	<!-- Отобрать элементы chapter в карте  -->
		<xsl:for-each select="//opentopic:map//*[contains(@class, ' bookmap/chapter ')]">
	  	<xsl:variable name="id" select="@id"/>
	  	<xsl:variable name="ref" select="replace(@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"/>
	  	
	  	<!-- Отобрать разделы уровня chapter, у которых задана дата публикации  -->
			<xsl:for-each select="//*[contains(@class, ' topic/topic ')][@id = $id][prolog/critdates/created/@date ne '']">
				<xsl:element name="dTopic">
					<!-- Название раздела -->
					<xsl:attribute name="name">
						<xsl:value-of select="title"/>
					</xsl:attribute>
					<!-- Ссылка на файл -->
					<xsl:attribute name="ref">
						<xsl:value-of select="$ref"/>
					</xsl:attribute>
					<!-- Дата публикации в формате ISO -->
					<xsl:attribute name="date">
						<xsl:analyze-string select="prolog/critdates/created/@date" flags="x" regex="^(\d+) \. (\d+) \. (\d+)$">
							<xsl:matching-substring>
								<!-- Год -->
								<xsl:variable name="year" select="regex-group(3)"/>
								<xsl:if test="string-length($year) = 2">
									<xsl:value-of select="if (number($year) gt 80) then '19' else '20'"/>
								</xsl:if>
								<xsl:value-of select="$year"/>
								<xsl:text>-</xsl:text>
								<!-- Месяц -->
								<xsl:variable name="mon" select="regex-group(2)"/>
								<xsl:value-of select="if (string-length($mon) = 1) then '0' else ''"/>
								<xsl:value-of select="$mon"/>
								<xsl:text>-</xsl:text>
								<!-- День -->
								<xsl:variable name="day" select="regex-group(1)"/>
								<xsl:value-of select="if (string-length($day) = 1) then '0' else ''"/>
								<xsl:value-of select="$day"/>
								<xsl:text>+03:00</xsl:text>
							</xsl:matching-substring>
						</xsl:analyze-string>
					</xsl:attribute>
				</xsl:element>
			</xsl:for-each>
	  </xsl:for-each>
  </xsl:variable>
  
  <xsl:text>document.write('&lt;div id="last-published"&gt;');</xsl:text> <xsl:value-of select="$newline"/>
  <xsl:text>document.write('  &lt;h3&gt;Последние публикации:&lt;/h3&gt;');</xsl:text> <xsl:value-of select="$newline"/>
  <xsl:text>document.write('  &lt;ul&gt;');</xsl:text> <xsl:value-of select="$newline"/>
  
  <xsl:apply-templates select="teux:dSort(exsl:node-set($datedTopic)/*)[position() = 1]">
  	<xsl:with-param name="class" select="'first'"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="teux:dSort(exsl:node-set($datedTopic)/*)[position() = 2 to 5]"/>
    
  <xsl:text>document.write('  &lt;/ul&gt;');</xsl:text> <xsl:value-of select="$newline"/>
  <xsl:text>document.write('&lt;/div&gt;');</xsl:text> <xsl:value-of select="$newline"/>

</xsl:template>

<!-- Вставить пункт списка -->  
<xsl:template match="dTopic">
	<xsl:param name="class"/>
	<xsl:text>document.write('	&lt;li</xsl:text>
	<xsl:if test="$class ne ''">
		<xsl:text> class="</xsl:text>
		<xsl:value-of select="$class"/>
		<xsl:text>"</xsl:text>
	</xsl:if>
	<xsl:text>&gt;&lt;img src="images/newpub.gif" width="32" height="32"/&gt;');</xsl:text> <xsl:value-of select="$newline"/>
	<xsl:text>document.write('	  &lt;a href="</xsl:text>
	<xsl:value-of select="@ref"/>
	<xsl:text>"&gt;</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>&lt;/a&gt;&lt;br/&gt;</xsl:text>  	
	<xsl:value-of select="format-date(@date, '[D].[M].[Y]')"/>
	<xsl:text>&lt;/li&gt;');</xsl:text><xsl:value-of select="$newline"/>
  
</xsl:template>



</xsl:stylesheet>
