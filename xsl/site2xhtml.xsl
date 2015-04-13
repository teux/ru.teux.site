<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	            xmlns:exsl="http://exslt.org/common"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
	            exclude-result-prefixes="exsl opentopic">

	<xsl:import href="../../org.dita.xhtml/xsl/dita2html5.xsl"/>

	<xsl:output method="html" encoding="UTF-8" indent="no"/>

    <xsl:param name="DITAEXT" select="'.dita'"/>
    <xsl:param name="MERGED"
        select="'/Users/teux/WebstormProjects/teux.github/temp/teux_MERGED.xml'"/>

	<xsl:variable name="curid">
		<xsl:variable name="id" select="/*/@id"/>
		<xsl:value-of
			select="document($MERGED)//*[contains(@class, ' topic/topic ')][@oid = $id]/@id"/>
	</xsl:variable>
	<xsl:variable name="map" select="document($MERGED)/*/opentopic:map"/>
	<xsl:variable name="curPart"
		select="$map/*[contains(@class, ' bookmap/part ')][descendant-or-self::*[@id=$curid]]"/>

	<!-- Head -->
	<xsl:template name="chapterHead">
		<xsl:variable name="head">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<xsl:call-template name="generateChapterTitle"/>
				<!-- Generate the <title> element -->
				<xsl:call-template name="generateKeywords"/>
				<!-- Generate keywords -->
				<link type="text/css" rel="stylesheet" href="stylesheets/screen_styles.css"/>
				<link type="text/css" media="screen" rel="stylesheet"
					href="stylesheets/colorbox.css"/>
                <link rel="shortcut icon" href="images/favicon.ico"/>
				<script type="text/javascript" src="scripts/jquery.min.js"/>
				<script type="text/javascript" src="scripts/main.js"/>
				<script type="text/javascript" src="scripts/menu.js"/>
				<script type="text/javascript" src="arrays/menuent.js"/>
				<script type="text/javascript" src="scripts/ltoc.js"/>
				<script type="text/javascript">
			  $(document).ready(function(){
				  $("a[rel='cbgroup']").colorbox({transition:"elastic", speed:"700", current:"фото {current} из {total}", width:"70%"});
				  $("a[rel='slideshow']").colorbox({slideshow:"true", slideshowAuto:"true", slideshowSpeed:"4000", slideshowStart:"Начать показ", slideshowStop:"Остановить показ", current:"фото {current} из {total}", width:"70%"});
			  });
		  </script>
				<script type="text/javascript" src="scripts/jquery.colorbox.js"/>
				<!-- Ссылка на локальное меню - зависит от номера части главного меню -->
				<xsl:variable name="treeName">
					<xsl:variable name="partId"
						select="$map/*[contains(@class, ' bookmap/part ')][descendant-or-self::*/@id=$curid]/@id"/>
					<xsl:text>arrays/ltocent</xsl:text>
					<xsl:value-of
						select="count($map/*[contains(@class, ' bookmap/part ')]
				  [following-sibling::*[contains(@class, ' bookmap/part ')][@id=$partId]] )+1"/>
					<xsl:text>.js</xsl:text>
				</xsl:variable>
				<script type="text/javascript">
		  	<xsl:attribute name="src"><xsl:value-of select="$treeName"/></xsl:attribute>
		  </script>
				<!-- Имя страницы и окна-->
				<script type="text/JavaScript">
			  <xsl:text>window.pageid = "</xsl:text>
				<xsl:for-each select="$map//*[@id=$curid]">
					<xsl:value-of select="replace(@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"/>
				</xsl:for-each>
				<xsl:text>";</xsl:text>
			</script>
				<!-- Проверка версии JavaScript (нужно для счетчика 1GB) -->
				<!--<script language="javascript1.1" type="text/javascript">cgb_js="1.1";</script>
			<script language="javascript1.2" type="text/javascript">cgb_js="1.2";</script>
			<script language="javascript1.3" type="text/javascript">cgb_js="1.3"</script>-->

				<link rel="Shortcut Icon" type="image/ico" href="images/favicon.ico"/>
				<xsl:call-template name="processHDF"/>
			</head>
		</xsl:variable>
		<xsl:apply-templates select="$head" mode="copy-with-indent"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>


	<!-- Body  -->
	<xsl:template name="chapterBody">
		<xsl:variable name="topnav">
			<body
				onload="if (navigator.appName.indexOf('Microsoft')!=-1) window.jstree.OpenTreeNode(window.pageid);">
				<xsl:call-template name="setidaname"/>
				<!-- [Teux ]Top navigation -->
				<div id="container">
					<xsl:call-template name="top-navigation"/>
					<xsl:call-template name="tools"/>
					<xsl:call-template name="dashboard"/>
					<!-- [Teux ]Main content -->
					<div id="content_main" class="with-info">
						<!-- [Teux ]Chain of links -->
						<xsl:call-template name="chain"/>

						<!-- Original topic translation -->
						<xsl:call-template name="generateBreadcrumbs"/>
						<xsl:call-template name="gen-user-header"/>
						<!-- include user's XSL running header here -->
						<xsl:call-template name="processHDR"/>
						<!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
						<xsl:call-template name="gen-user-sidetoc"/>
						<xsl:apply-templates/>
                        <!--Discqus widget-->
                        <xsl:if test="contains(/*/@otherprops, 'use-disqus')">
                            <div id="disqus_thread"></div>
                            <script type="text/javascript">
                                var disqus_shortname = "teux",
                                    disqus_identifier = "<xsl:value-of select="/*/@id"/>",
                                    disqus_url = "http://www.teux.ru/<xsl:value-of select="concat(/*/@id, $OUTEXT)"/>";
                                (function() {
                                var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
                                dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
                                (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
                                })();
                            </script>
                        </xsl:if>
					</div>
					<xsl:call-template name="bottom"/>
				</div>
				<script>if (navigator.appName.indexOf('Microsoft')==-1 &amp;&amp; window.jstree) window.jstree.OpenTreeNode(window.pageid);</script>
			</body>
		</xsl:variable>
		<xsl:apply-templates select="$topnav" mode="copy-with-indent"/>
	</xsl:template>


	<!-- Шапка с меню -->
	<xsl:template name="top-navigation">
		<div id="branding">
			<h1>
				<a href="http://www.teux.ru">Андрей Коперский — фотографии походов</a>
				<!-- Yandex.Metrika counter -->
				<script type="text/javascript">(function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter4829635 = new Ya.Metrika({id:4829635}); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks");</script>
				<!-- /Yandex.Metrika counter -->
			</h1>
			<p>Фотографии походов, приглашаю в поход</p>
		</div>
		<div id="navigation_main">

			<ul>
				<xsl:for-each select="$map/*[contains(@class, ' bookmap/part ')]">
					<li>
						<!-- атрибут class -->
						<xsl:choose>
							<xsl:when test="not(preceding-sibling::part)">
								<xsl:attribute name="class">
									<xsl:value-of
										select="if(@id = $curid) then 'first current' else 'first'"
									/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="descendant-or-self::*/@id = $curid">
								<xsl:attribute name="class">
									<xsl:text>current</xsl:text>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of
									select="replace(@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"
								/>
							</xsl:attribute>
							<!-- атрибуты для отображение java-меню -->
							<xsl:if test="preceding-sibling::*[contains(@class, ' bookmap/part ')]">
								<xsl:attribute name="onmouseover">
									<xsl:text>dropdownmenu(this, event, menu</xsl:text>
									<xsl:value-of
										select="count(preceding-sibling::*[contains(@class, ' bookmap/part ')])+1"/>
									<xsl:text>ent , '')</xsl:text>
								</xsl:attribute>
								<xsl:attribute name="onmouseout">
									<xsl:text>delayhidemenu()</xsl:text>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of
								select="if (@navtitle) then @navtitle else topicmeta/navtitle"/>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>


	<!-- Инструменты в шапке -->
	<xsl:template name="tools">
		<div id="tools">
			<h3>Page Tools</h3>
			<ul id="page_tools">
				<!--     <li id="page_size">Text Size:<a href="../../#" id="size_large" alt="Small Text"><img src="../../images/Text_Small.gif" width="14" height="18" /></a><a href="../../#" id="size_medium" alt="Medium Text"><img src="../../images/Text_Medium.gif" width="14" height="18" /></a><a href="../../#" id="size_large" alt="Large Text"><img src="../../images/Text_Large.gif" width="14" height="18" /></a></li>
          <li id="tool_links">
            <span class="label">Page Tool Links</span>
            <ul>
              <li class="first" id="quote_link">
                <a href="../../Language_Services/Quote_Request.aspx">Quote Request</a>
              </li>
              <li id="site_map_link">
                <a href="../../Sitemap.aspx">Site Map</a>
              </li>
              <li class="last" id="newsletter_link">
                <a href="../../Language_Tech_Center/Multilingual_Standard.aspx">Newsletter</a>
              </li>
            </ul>
          </li> -->
				<li id="search">
					<form method="get" action="http://www.google.com/search" target="_blank">
						<input onfocus="this.className='txt-very-dark-gray'; this.value=''"
							class="txt-light-gray" id="search_text" type="text" name="q" size="30"
							maxlength="255" value="Поиск по сайту через Google"/>
						<input type="hidden" name="sitesearch" value="teux.ru"/>
						<input id="search_button" type="submit" value="&gt;"/>
					</form>
				</li>
			</ul>
		</div>
	</xsl:template>


	<!-- Левое меню -->
	<xsl:template name="dashboard">
		<div id="dashboard">
			<!-- Local toc -->
			<div id="navigation_secondary">
				<xsl:if test="$curPart/*[contains(@class, ' map/topicref ')]">
					<p class="title">Разделы:</p>
					<div id="ltoc">
						<script type="text/JavaScript">window.jstree = new MakeTree(window.TITEMS, false);</script>
					</div>
				</xsl:if>
			</div>
			<!-- last published -->
			<script type="text/javascript" src="arrays/lastpub.js"/>
			<!-- other boards -->
			<script type="text/javascript" src="arrays/dashboard.js"/>
		</div>
	</xsl:template>


	<!-- Подвал -->
	<xsl:template name="bottom">
		<xsl:variable name="curTopic" select="$map//*[@id=$curid]"/>
		<xsl:variable name="parentTopic"
			select="$curTopic/parent::*[contains(@class, ' map/topicref ')]"/>
		<xsl:variable name="nextTopic"
			select="$curTopic/following-sibling::*[contains(@class, ' map/topicref ')][1]"/>
		<xsl:variable name="prevTopic"
			select="$curTopic/preceding-sibling::*[contains(@class, ' map/topicref ')][1]"/>

		<!-- Supplemental Navigation -->
		<div id="navigation_supplemental">
			<h3>Quick Navigation</h3>
			<ul id="quick_links"> </ul>
			<h3>Language Links</h3>
			<ul id="inner_navigation">
				<li class="first">
					<strong>Вперед:</strong>
					<xsl:call-template name="getLink">
						<xsl:with-param name="topic" select="$nextTopic"/>
					</xsl:call-template>
				</li>
				<li>
					<strong>Назад:</strong>
					<xsl:call-template name="getLink">
						<xsl:with-param name="topic" select="$prevTopic"/>
					</xsl:call-template>
				</li>
				<li class="last">
					<strong>Вверх:</strong>
					<xsl:call-template name="getLink">
						<xsl:with-param name="topic" select="$parentTopic"/>
					</xsl:call-template>
				</li>
			</ul>
		</div>
	</xsl:template>

	<!-- Ссылка на следующий/предыдущий/вышестоящий раздел -->
	<xsl:template name="getLink">
		<xsl:param name="topic"/>
		<xsl:choose>
			<xsl:when test="$topic/self::*">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of
							select="replace($topic/@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"
						/>
					</xsl:attribute>
					<xsl:value-of
						select="if ($topic/@navtitle) then $topic/@navtitle else $topic/topicmeta/navtitle"
					/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>нет</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Chain of links before main content -->
	<xsl:template name="chain">
		<div id="breadcrumbs">
			<p>
				<span>Расположение: </span>
				<xsl:variable name="topPart"
					select="$map//*[@id=$curid]/ancestor-or-self::*[contains(@class,' bookmap/part')]"/>
				<xsl:for-each select="$topPart/descendant-or-self::*[.//*/@id=$curid]">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of
								select="replace(@ohref, concat('(.+)',$DITAEXT), concat('$1',$OUTEXT))"
							/>
						</xsl:attribute>
						<xsl:value-of select="if (@navtitle) then @navtitle else topicmeta/navtitle"
						/>
					</a>
					<xsl:text> &gt; </xsl:text>
				</xsl:for-each>
				<strong>
					<!-- Название текущего раздела -->
					<xsl:for-each select="$map//*[@id=$curid]">
						<xsl:value-of select="if (@navtitle) then @navtitle else topicmeta/navtitle"
						/>
					</xsl:for-each>
				</strong>
			</p>
		</div>
	</xsl:template>


	<!-- Generate keywords -->
	<xsl:template name="generateKeywords">
		<xsl:variable name="keyString">
			<xsl:for-each select="$map//*[contains(@class, ' topic/keyword ')]">
				<xsl:value-of select="text()"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:for-each select="//*[contains(@class, ' topic/keyword ')]">
				<xsl:value-of select="text()"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="$keyString != ''">
			<meta name="keywords">
				<xsl:attribute name="content">
					<xsl:value-of select="$keyString"/>
				</xsl:attribute>
			</meta>
		</xsl:if>
	</xsl:template>


	<!-- Из оригинального шаблона убран вызов next-prev-parent-links -->
	<xsl:template match="*[contains(@class,' topic/related-links ')]" name="topic.related-links">
		<p class="toc">В этом разделе</p>
		<xsl:apply-imports/>
	</xsl:template>

	<!-- Из оригинального шаблона убрана вставка перевода строки -->
	<xsl:template match="*[contains(@class,' topic/ul ')]" mode="ul-fmt">
		<xsl:call-template name="setaname"/>
		<ul>
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="@compact"/>
			<xsl:call-template name="setid"/>
			<xsl:apply-templates/>
		</ul>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<!-- Из оригинального шаблона убрана вставка перевода строки -->
	<xsl:template match="*[contains(@class,' topic/ol ')]" name="topic.ol">
		<xsl:variable name="olcount"
			select="count(ancestor-or-self::*[contains(@class,' topic/ol ')])"/>
		<xsl:call-template name="setaname"/>
		<ol>
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="@compact"/>
			<xsl:choose>
				<xsl:when test="$olcount mod 3 = 1"/>
				<xsl:when test="$olcount mod 3 = 2">
					<xsl:attribute name="type">a</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">i</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="setid"/>
			<xsl:apply-templates/>
		</ol>
		<xsl:value-of select="$newline"/>
	</xsl:template>


	<!-- Make indent -->
	<xsl:template match="node() | @*" mode="copy-with-indent">
		<xsl:choose>
			<xsl:when test="self::*">
				<!-- Перенос строки и выключка для открывающего тэга (только если среди братьев нет значимых текстовых узлов) -->
				<xsl:if test="not(../text()[normalize-space(self::text()) != ''])">
					<xsl:value-of select="$newline"/>
					<xsl:for-each select="ancestor-or-self::*">
						<xsl:text>  </xsl:text>
					</xsl:for-each>
				</xsl:if>
				<!-- Скопировать элемент, его атрибуты и дочерние узлы -->
				<xsl:copy>
					<xsl:apply-templates select="node() | @*" mode="copy-with-indent"/>
				</xsl:copy>
				<!-- Перенос строки и левый отступ для завершающего тэга (только если среди братьев нет значимых текстовых узлов)-->
				<xsl:if test="empty(following-sibling::node())">
					<xsl:value-of select="$newline"/>
					<xsl:for-each select="ancestor::*">
						<xsl:text>  </xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<!-- Не копировать текстовый узел, если на текущем уровне нет значимых текстовых узлов  -->
			<xsl:when test="self::text() and not(../text()[normalize-space(self::text()) != ''])"/>
			<!-- Копировать атрибуты и текстовые узлы -->
			<xsl:otherwise>
				<xsl:copy/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
