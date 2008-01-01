<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "-//OASIS//DTD DocBook V5.0//EN">
<xsl:stylesheet version="1.0"
                xml:lang="en"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ex="http://exslt.org/dates-and-times"
                xmlns:em="http://exslt.org/math"
                xmlns:es="http://exslt.org/sets"
                xmlns:p="tag:fenglich.fastmail.fm,2007:Pottery">


    <xsl:template match="p:pottery">
        <book xml:lang="en">
            <info>
                <title>Frans' Pottery Log</title>
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
            </info>

            <chapter>
                <title>Oven Programs</title>

                <para>Unless otherwise stated, all burns were done with the following settings.</para>
                <table>
                    <title/>
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
                </table>

            </chapter>

            <xsl:apply-templates select="p:pieces"/>
            <xsl:apply-templates select="p:glazes"/>
            <xsl:apply-templates select="p:clays"/>

            <xsl:call-template name="sourcesAppendix"/>
        </book>
    </xsl:template>

    <xsl:template match="p:pieces">
        <chapter>
            <title>Pieces</title>

            <section>
                <title>Statistics</title>
                <para>A total of <xsl:value-of select="count(p:piece)"/> pieces.</para>

                <!--<para><x, <xsl:value-of select="em:max(p:piece/@idref)"/> - </para>-->
            </section>

            <section>
                <title>Pieces</title>

                <para>The IDs assigned to pieces are arbitrary and not sequential, reflects cronologically
                      or anything like that. However, they are sorted numerically in this document for quick lookup.</para>

                <xsl:apply-templates select="p:piece">
                    <xsl:sort data-type="number" select="number(substring(@xml:id, 2))"/>
                </xsl:apply-templates>
            </section>
        </chapter>
    </xsl:template>

    <xsl:template match="p:piece">
            <section>
                <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
               <title>
                    <xsl:value-of select="substring(@xml:id, 2)"/>
                </title>
                <xsl:apply-templates/>
            </section>
    </xsl:template>

    <xsl:template match="p:clayref">
        <para><emphasis>Clay</emphasis>: <phrase xlink:href="#{@idref}"><xsl:value-of select="/p:pottery/p:clays/p:clay[@xml:id = current()/@idref]/@name"/></phrase><xsl:apply-templates select="@weightWhenWet"/></para>
    
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
        <chapter>
            <title>Glazes</title>

            <xsl:apply-templates select="p:glaze">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </chapter>
    </xsl:template>

    <xsl:template match="p:glaze">
        <section>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <title>
                <xsl:value-of select="@name"/>
                <xsl:if test="@productID">, 
                    <xsl:value-of select="@productID"/>
                </xsl:if>
            </title>

            <xsl:if test="@description">
                <para>
                    <xsl:value-of select="@description"/>
                </para>
            </xsl:if>

            <xsl:apply-templates select="//p:samples/p:sample[p:glazing/@idref = current()/@xml:id]">
                <xsl:sort data-type="number" select="number(p:glazing/@gravity)"/>
                <xsl:with-param name="mainGlaze" select="@xml:id"/>
            </xsl:apply-templates>
        </section>
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
            <title><xsl:apply-templates select="p:brick"/></title>
            
            <para>
                <xsl:apply-templates select="p:glazing[@idref = $mainGlaze]" mode="lowKeyGlazing"/>
            </para>
            <xsl:variable name="additionalGlazes" select="p:glazing[@idref != $mainGlaze]"/>
            <xsl:if test="p:glazing[@idref != $mainGlaze]">
                <para>Additional glaze<xsl:if test="count($additionalGlazes) > 1">s</xsl:if>:</para>
                <xsl:apply-templates select="p:glazing[@idref != $mainGlaze]"/>
            </xsl:if>
            <xsl:apply-templates select="db:para"/>
            <xsl:apply-templates mode="doImage" select="p:brick"/>
        </section>
    </xsl:template>

    <xsl:template mode="doImage" match="p:brick">
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

    <xsl:template match="p:glazing" mode="lowKeyGlazing">
            <xsl:apply-templates select="@gravity"/>
            <xsl:apply-templates select="@sieved"/>
    </xsl:template>

    <xsl:template match="@gravity">
        <emphasis>gravity</emphasis>:
        <constant><xsl:value-of select="."/></constant>
    </xsl:template>

    <xsl:template match="@sieved">
        <xsl:text>, </xsl:text><emphasis>sieved</emphasis>:
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="p:brick">
        <xsl:value-of select="@xml:id"/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template name="sourcesAppendix">
        <appendix>
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
        <chapter>
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

    <xsl:template match="db:date">
        <emphasis><xsl:value-of select="."/></emphasis>
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- We don't use it directly. -->
    <xsl:template match="p:samples"/>

    <!-- Flag things we miss. -->
    <xsl:template match="* | @*">
        <xsl:message terminate="yes">
            Unmatched node: <xsl:value-of select="name()"/>
        </xsl:message>
    </xsl:template>

</xsl:stylesheet>

<!--
vim: et:ts=4:sw=4:sts=4
-->
