<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xml:lang="en"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ex="http://exslt.org/dates-and-times"
                xmlns:em="http://exslt.org/math"
                xmlns:es="http://exslt.org/sets"
                xmlns:ec="http://exslt.org/common"
                xmlns:esets="http://exslt.org/sets"
                xmlns:p="tag:fenglich.fastmail.fm,2007:Pottery">


    <!-- Do some business logic validation. -->
    <xsl:template match="/">
        <!-- glazing referencing brushons. -->
        <xsl:variable name="invalidGlazeRef">
            <xsl:for-each select="//p:glazing">
                <xsl:variable name="name" select="@idref"/>
                <xsl:value-of select="//p:glaze[@xml:id = $name and @type = 'BrushOn']/@xml:id"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($invalidGlazeRef)) > 0">
            <xsl:message terminate="yes"><xsl:value-of select="$invalidGlazeRef"/> is referenced as a non-brushon, while it in fact is.</xsl:message>
        </xsl:if>

        <!-- brushons referencing non-brushons. -->
        <xsl:variable name="invalidBrushOnGlazeRef">
            <xsl:for-each select="//p:brushon">
                <xsl:variable name="name" select="@idref"/>
                <xsl:value-of select="//p:glaze[@xml:id = $name and @type != 'BrushOn']/@xml:id"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($invalidBrushOnGlazeRef)) > 0">
            <xsl:message terminate="yes"><xsl:value-of select="$invalidBrushOnGlazeRef"/> are referenced as a brushon, while it isn't.</xsl:message>
        </xsl:if>

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p:pottery">
        <book xml:lang="en">
            <info>
                <title>The Next Sample</title>
                <author>
                    <personname>
                        <firstname>Frans</firstname>
                        <surname>Englich</surname>
                    </personname>
                    <email>fenglich@fastmail.fm</email>
                    <address>
                        <phone>+46-702-411091</phone>
                    </address>
                </author>
                <pubdate><xsl:value-of select="ex:date()"/></pubdate>
                <legalnotice>
                    <para>Copyright (c) 2007-2008 Frans Englich</para>
                    <para>Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.2
or any later version published by the Free Software Foundation;
with no Invariant Sections, no Front-Cover Texts, and no Back-Cover
Texts.  A copy of the license can be obtained at the <phrase xlink:href="http://www.gnu.org/licenses/fdl.html">Free Software Foundation's website</phrase> or by contacting the author.</para>
                </legalnotice>
            </info>

            <xsl:apply-templates select="p:pieces"/>
            <xsl:apply-templates select="p:glazes"/>

            <chapter xml:id="NonGlazeSamples">
                <title>Non-glaze Samples</title>
                <para>This section contains samples which aren't of glazes,
                    such as melt tests. See also the samples that have at least
                    <phrase xlink:href="#Transparent">transparent
                        glaze</phrase> as glazing, which contains similar kind
                    of samples.</para>

                <xsl:apply-templates select="p:samples/p:sample[not(p:glazing | p:brushon)]"/>
            </chapter>

            <chapter xml:id="OvenPrograms">
                <title>Oven Programs</title>

                <para>Unless otherwise stated, all firings were done with the following settings.</para>
                <informaltable>
                    <tgroup cols="8">
                        <thead>
                            <row>
                                <entry>Program Code</entry>
                                <entry>Type</entry>
                                <entry>C/h 1</entry>
                                <entry>Temp 1</entry>
                                <entry>Time 1</entry>
                                <entry>C/h 2</entry>
                                <entry>Temp 2</entry>
                                <entry>Time 2</entry>
                                <entry>C/h 3</entry>
                            </row>
                        </thead>
                        <tbody>
                            <row>
                                <entry>P1</entry>
                                <entry>Bisque</entry>
                                <entry>80</entry>
                                <entry>80</entry>
                                <entry>300</entry>
                                <entry>150</entry>
                                <entry>960</entry>
                                <entry>30</entry>
                                <entry>700</entry>
                            </row>
                            <row>
                                <entry>P2</entry>
                                <entry>Decal &amp; Luster</entry>
                                <entry>150</entry>
                                <entry>650</entry>
                                <entry>0</entry>
                                <entry>200</entry>
                                <entry>780</entry>
                                <entry>0</entry>
                                <entry>700</entry>
                            </row>
                            <row>
                                <entry>P3</entry>
                                <entry>Unused Bisque Program</entry>
                                <entry>80</entry>
                                <entry>80</entry>
                                <entry>540</entry>
                                <entry>150</entry>
                                <entry>960</entry>
                                <entry>0</entry>
                                <entry>500</entry>
                            </row>
                            <row>
                                <entry>P4</entry>
                                <entry>Glaze</entry>
                                <entry>150</entry>
                                <entry>600</entry>
                                <entry>0</entry>
                                <entry>200</entry>
                                <entry>1240</entry>
                                <entry>10</entry>
                                <entry>500</entry>
                            </row>
                        </tbody>
                    </tgroup>
                </informaltable>

            </chapter>

            <xsl:apply-templates select="p:clays"/>

            <xsl:call-template name="sourcesAppendix"/>
        </book>
    </xsl:template>

    <xsl:template match="p:pieces">
        <chapter xml:id="Pieces">
            <title>Pieces</title>

            <para>A total of <xsl:value-of select="count(p:piece)"/> pieces.</para>

            <para>The IDs assigned to pieces are arbitrary and not sequential. They don't reflect cronologically
                the creation. However, they are sorted numerically in this document for quick lookup.</para>

            <xsl:apply-templates select="p:piece">
                <xsl:sort data-type="number" select="number(substring(@xml:id, 2))"/>
            </xsl:apply-templates>
        </chapter>
    </xsl:template>

    <xsl:template match="p:piece">
        <section>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:attribute name="xreflabel"><xsl:value-of select="@xml:id"/></xsl:attribute>
           <title>
                <xsl:value-of select="substring(@xml:id, 2)"/>
            </title>
            <xsl:apply-templates/>
            <xsl:call-template name="createReferences"/>
        </section>
    </xsl:template>

    <xsl:template match="p:clayref">
        <para>
            <emphasis>Clay</emphasis>: <phrase xlink:href="#{@idref}">
                <xsl:value-of select="/p:pottery/p:clays/p:clay[@xml:id = current()/@idref]/@name"/></phrase>
            <xsl:apply-templates select="@weightWhenWet"/>
        </para>

    </xsl:template>

    <xsl:template match="@weightWhenWet">
        <xsl:text>, weight </xsl:text>
        <emphasis>when wet</emphasis>:
        <constant><xsl:value-of select="."/></constant> g
    </xsl:template>

    <xsl:template match="p:note">
        <formalpara>
            <title><xsl:value-of select="@date"/></title>
            <para><xsl:value-of select="."/></para>
        </formalpara>
    </xsl:template>

    <xsl:template match="p:glazes">
        <chapter xml:id="Glazes">
            <title>Glazes by Color</title>

            <para>A total of <xsl:value-of select="count(//p:sample)"/> sample tiles.</para>

            <xsl:for-each select="esets:distinct(p:glaze/@category)">
                <xsl:sort select="."/>

                <section>
                    <xsl:attribute name="xml:id"><xsl:value-of select="."/></xsl:attribute>
                    <title><xsl:value-of select="."/></title>
                    <xsl:apply-templates select="(/)//p:glaze[@category = current()]">
                        <xsl:sort select="@name"/>
                    </xsl:apply-templates>
                </section>
            </xsl:for-each>
        </chapter>
    </xsl:template>

    <xsl:template match="p:glaze">
        <section>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:attribute name="xreflabel"><xsl:value-of select="@name"/></xsl:attribute>
            <title>
                <xsl:value-of select="@name"/>
                <xsl:if test="@productID">,
                    <xsl:value-of select="@productID"/>
                </xsl:if>
                <xsl:if test="@type = 'BrushOn'"> (brush-on)</xsl:if>
            </title>

            <xsl:apply-templates select="@manufacturer"/>
            <xsl:apply-templates select="db:para"/>

            <xsl:apply-templates select="p:recipe"/>

            <xsl:call-template name="createReferences"/>

            <xsl:variable name="piecesUsing" select="//p:pieces/p:piece[p:glazing/@idref = current()/@xml:id]/@xml:id"/>
            <xsl:if test="$piecesUsing">
                <db:para>Used on
                    <xsl:choose>
                        <xsl:when test="count($piecesUsing) > 1">pieces</xsl:when>
                        <xsl:otherwise>piece</xsl:otherwise>
                    </xsl:choose>

                    <xsl:text> </xsl:text>

                    <xsl:call-template name="listItems">
                        <xsl:with-param name="items" select="$piecesUsing"/>
                    </xsl:call-template>
                </db:para>
            </xsl:if>

            <db:para/>
            <xsl:variable name="secondaryTiles" select="//p:samples/p:sample[(p:brushon | p:glazing)[position() > 1][@idref = current()/@xml:id]]/@xml:id"/>

            <xsl:if test="$secondaryTiles">
                <para>Appears as a secondary glaze on
                    <xsl:choose>
                        <xsl:when test="count($piecesUsing) > 1">tiles</xsl:when>
                        <xsl:otherwise>tile</xsl:otherwise>
                    </xsl:choose>

                    <xsl:text> </xsl:text>

                    <xsl:call-template name="listItems">
                        <xsl:with-param name="items" select="$secondaryTiles"/>
                    </xsl:call-template>
                </para>
            </xsl:if>

            <xsl:variable name="tiles" select="//p:samples/p:sample[(p:brushon | p:glazing)[1][@idref = current()/@xml:id]]"/>
            <xsl:apply-templates select="$tiles">
                <!-- TODO This just doesn't seem to work. -->
                <xsl:sort data-type="number" select="number(substring(@xml:id, 2))"/>
                <!--<xsl:sort data-type="number" select="number(p:glazing/@hydrometerGravity)"/>-->
                <xsl:with-param name="mainGlaze" select="@xml:id"/>
            </xsl:apply-templates>
        </section>
    </xsl:template>

    <xsl:template match="p:glaze/@manufacturer">
        <db:para>From: <xsl:value-of select="."/>.</db:para>
    </xsl:template>

    <xsl:template name="listItems">
        <xsl:param name="items"/>

        <xsl:for-each select="$items">
            <xsl:sort select="."/>
            <db:xref xlink:href="#{.}"/>
            <xsl:if test="position() = last() - 1">
                <xsl:text> and </xsl:text>
            </xsl:if>
            <xsl:if test="position() &lt; last() - 1">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:text>.</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="imageForSample">
        <xsl:param name="sampleName"/>
        <xsl:param name="imageName"/>
        <mediaobject>
            <imageobject>
                <imagedata align="right" format="JPG" fileref="../Images/Samples/{$sampleName}/{$imageName}.jpg"/>
            </imageobject>
        </mediaobject>
    </xsl:template>

    <xsl:template match="p:piece/p:image">
        <mediaobject>
            <imageobject>
                <imagedata align="right" format="JPG" fileref="../Images/Pieces/{../@xml:id}/{.}.jpg"/>
            </imageobject>
        </mediaobject>
    </xsl:template>

    <xsl:template match="p:sample">
        <xsl:param name="mainGlaze"/>
        <section>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:attribute name="xreflabel"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <title><xsl:value-of select="@xml:id"/></title>

            <para><date><xsl:value-of select="@date"/></date></para>
            <para>
                <xsl:apply-templates select="(p:glazing | p:brushon)[@idref = $mainGlaze]" mode="lowKeyGlazing"/>
            </para>
            <xsl:variable name="additionalGlazes" select="(p:brushon | p:glazing)[@idref != $mainGlaze]"/>
            <xsl:if test="(p:brushon | p:glazing)[@idref != $mainGlaze]">
                <para>Additional glaze<xsl:if test="count($additionalGlazes) > 1">s</xsl:if>:</para>
                <xsl:apply-templates select="(p:brushon | p:glazing)[@idref != $mainGlaze]"/>
            </xsl:if>
            <xsl:apply-templates select="p:clayref"/>

            <xsl:call-template name="createReferences"/>

            <xsl:apply-templates select="db:para"/>
            <xsl:apply-templates mode="doImage" select="."/>
        </section>
    </xsl:template>

    <xsl:template name="createReferences">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="referencedFrom" select="(/)//@xml:id[parent::node()//@xlink:href[substring-after(., '#') = $id]]"/>

        <xsl:if test="$referencedFrom">
            <para>
                <xsl:text>Referenced by </xsl:text>
                <xsl:call-template name="listItems">
                    <xsl:with-param name="items" select="$referencedFrom"/>
                </xsl:call-template>
            </para>
        </xsl:if>
    </xsl:template>

    <xsl:template mode="doImage" match="p:sample">
        <xsl:call-template name="imageForSample">
            <xsl:with-param name="sampleName" select="@xml:id"/>
            <xsl:with-param name="imageName" select="@xml:id"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="p:sample/p:para">
        <formalpara>
                <title><xsl:value-of select="../@date"/></title>
                <xsl:copy>
                    <xsl:apply-templates select="."/>
                </xsl:copy>
        </formalpara>
    </xsl:template>

    <xsl:template match="p:glazing">
        <para><phrase xlink:href="#{@idref}"><xsl:value-of select="/p:pottery/p:glazes/p:glaze[@xml:id = current()/@idref]/@name"/></phrase>,
            <xsl:apply-templates select="." mode="lowKeyGlazing"/>
        </para>
    </xsl:template>

    <xsl:template match="p:brushon">
        <para><phrase xlink:href="#{@idref}"><xsl:value-of select="/p:pottery/p:glazes/p:glaze[@xml:id = current()/@idref]/@name"/></phrase></para>
    </xsl:template>

    <xsl:template match="p:glazing" mode="lowKeyGlazing">
            <xsl:choose>
                <xsl:when test="@hydrometerGravity">
                    <xsl:apply-templates select="@hydrometerGravity"/>
                </xsl:when>
                <xsl:otherwise>
                    <emphasis>hydrometer gravity unknown</emphasis>,
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@sieved"/>
    </xsl:template>

    <xsl:template match="@hydrometerGravity">
        <emphasis>hydrometer gravity</emphasis>
        <xsl:text> </xsl:text>
        <constant><xsl:value-of select="."/></constant>,
    </xsl:template>

    <xsl:template match="@sieved">
        <emphasis>
            <xsl:choose>
                <xsl:when test=". = 'WithMixer'">
                    with mixer
                </xsl:when>
                <xsl:when test=". = 'no'">
                    not sieved
                </xsl:when>
                <xsl:otherwise>
                    sieved with mesh size <constant><xsl:value-of select="."/></constant>
                </xsl:otherwise>
            </xsl:choose>
        </emphasis>
    </xsl:template>

    <xsl:template name="sourcesAppendix">
        <appendix xml:id="SourceFiles">
            <title>Sources</title>
            <para>This document was generated from the following sources. The string following the file date is the git SHA1 checksum.</para>
            <itemizedlist>
                <xsl:apply-templates select="document('sources.xml')/p:sources/p:source"/>
            </itemizedlist>
        </appendix>
    </xsl:template>

    <xsl:template match="p:source">
        <listitem>
            <para>
                <filename><xsl:value-of select="@href"/></filename>
                <xsl:text>, </xsl:text>
                <date><xsl:value-of select="@date"/></date>
                <xsl:text>, </xsl:text>
                <systemitem><xsl:value-of select="@gitSHA1"/></systemitem>
            </para>
        </listitem>
    </xsl:template>

    <xsl:template match="p:clays">
        <chapter xml:id="Clays">
            <title>Clays</title>
            <xsl:apply-templates/>
        </chapter>
    </xsl:template>

    <xsl:template match="p:clay">
        <section>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <title>
                <xsl:value-of select="@name"/>
                <xsl:if test="@productID">,
                    <xsl:value-of select="@productID"/>
                </xsl:if>
            </title>
            <para/>
        </section>
    </xsl:template>

    <xsl:template match="@* | db:* | @xlink:*">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p:recipe">
        <informaltable>
            <tgroup cols="2">
                <xsl:variable name="hasReplacement" select="p:component/@replacementFor"/>
                <thead>
                    <row>
                        <entry>Component</entry>
                        <xsl:if test="$hasReplacement">
                            <entry>Source/Replacement For</entry>
                        </xsl:if>
                        <entry>Parts</entry>
                        <entry>Price/kg for <phrase xlink:href="http://www.we.no/">Waldm. Ellefsen AS</phrase> 2003, MVA, NOK</entry>
                    </row>
                </thead>
                <tfoot>
                    <row>
                        <entry/>
                        <xsl:if test="sum(p:component/@parts) &lt; 100">
                            <xsl:message terminate="yes">The components for glaze <xsl:value-of select="../@name"/> amount to less than 100 parts</xsl:message>
                        </xsl:if>
                        <xsl:if test="$hasReplacement">
                            <entry/>
                        </xsl:if>
                        <entry><xsl:value-of select="sum(p:component/@parts)"/></entry>
                        <entry>
                            <xsl:variable name="componentPrices">
                                <xsl:apply-templates mode="computePrice" select="p:component"/>
                            </xsl:variable>

                            <xsl:value-of select="sum(ec:node-set($componentPrices)/*)"/>
                        </entry>
                    </row>
                </tfoot>
                <tbody>
                    <xsl:apply-templates select="p:component">
                        <xsl:with-param name="hasReplacement" select="$hasReplacement"/>
                    </xsl:apply-templates>
                </tbody>
            </tgroup>
        </informaltable>
    </xsl:template>

    <xsl:template match="p:component">
        <xsl:param name="hasReplacement"/>

        <row>
            <xsl:variable name="component" select="/p:pottery/p:components/p:component[@xml:id = current()/@idref]"/>
            <xsl:call-template name="checkComponentRef">
                <xsl:with-param name="component" select="$component"/>
                <xsl:with-param name="name" select="@idref"/>
            </xsl:call-template>
            <entry><xsl:copy-of select="$component/node()"/></entry>
            <xsl:if test="@replacementFor">
                <xsl:variable name="replacement" select="/p:pottery/p:components/p:component[@xml:id = current()/@replacementFor]"/>
                <xsl:call-template name="checkComponentRef">
                    <xsl:with-param name="component" select="$replacement"/>
                    <xsl:with-param name="name" select="@replacementFor"/>
                </xsl:call-template>
                <entry><xsl:copy-of select="$replacement/node()"/></entry>
            </xsl:if>

            <xsl:if test="$hasReplacement and not(@replacementFor)">
                <entry/>
            </xsl:if>
            <entry><constant><xsl:value-of select="@parts"/></constant></entry>

            <entry>
                <xsl:apply-templates mode="computePrice" select="."/>
            </entry>
        </row>
    </xsl:template>

    <xsl:template mode="computePrice" match="p:component">
        <constant>
            <xsl:variable name="price" select="number(/p:pottery/p:components/p:component[@xml:id = current()/@idref]/@price)"/>
            <xsl:variable name="priceIsFor" select="number(/p:pottery/p:components/p:component[@xml:id = current()/@idref]/@priceIsFor)"/>

            <xsl:value-of select="((($price div ($priceIsFor div 1000.0)) * (@parts div 100.0)) * 1.25)"/>
        </constant>
    </xsl:template>

    <xsl:template match="p:measurementsWhenDone">
        <para>Measurements: height <constant><xsl:value-of select="@height"/></constant> mm,

            <xsl:if test="@width = @depth">
                <xsl:message>If the depth is the same as the width, the
                    depth shouldn't be specified. Detected for
                    <xsl:value-of select="../@xml:id"/></xsl:message>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="not(@depth)">
                    diameter <constant><xsl:value-of select="@width"/></constant> mm
                </xsl:when>
                <xsl:otherwise>
                    width <constant><xsl:value-of select="@width"/></constant> mm,
                    depth <constant><xsl:value-of select="@depth"/></constant> mm
                </xsl:otherwise>
            </xsl:choose>
        </para>
    </xsl:template>

    <xsl:template name="checkComponentRef">
        <xsl:param name="component"/>
        <xsl:param name="name"/>

        <xsl:if test="not($component)">
            <xsl:message terminate="yes">Component for reference <xsl:value-of select="$name"/> couldn't be found.</xsl:message>
        </xsl:if>
    </xsl:template>

    <!-- We don't use it directly. -->
    <xsl:template match="p:samples"/>

    <!-- Flag things we miss. -->
    <xsl:template match="* | @*">
        <xsl:message terminate="yes">
            Unmatched node: <xsl:value-of select="name()"/> <xsl:value-of select="string()"/>
        </xsl:message>
    </xsl:template>

</xsl:stylesheet>

<!--
vim: et:ts=4:sw=4:sts=4
-->
