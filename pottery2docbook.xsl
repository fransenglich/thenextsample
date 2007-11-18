<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "-//OASIS//DTD DocBook V5.0//EN">
<xsl:stylesheet version="1.0"
                xml:lang="en"
                xmlns="http://docbook.org/ns/docbook"
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

            <xsl:apply-templates/>

            <xsl:call-template name="sourcesAppendix"/>
        </book>
    </xsl:template>

    <xsl:template match="p:pieces">
        <chapter>
            <title>Pieces</title>

            <section>
                <title>Statistics</title>
                <para>A total of <xsl:value-of select="count(p:piece)"/> pieces.</para>

                <!--<para><x, <xsl:value-of select="em:max(p:piece/@id)"/> - </para>-->
            </section>

            <section>
                <title>Pieces</title>
                <xsl:apply-templates/>
            </section>
        </chapter>
    </xsl:template>

    <xsl:template match="p:piece">
            <section>
                <title>
                    <xsl:value-of select="substring(@xml:id, 2)"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="p:note[1]/@date"/>
                </title>
                <xsl:apply-templates/>
            </section>
    </xsl:template>

    <xsl:template match="p:clayref">
        <para><emphasis>Clay</emphasis>: <phrase xlink:href="#{@id}"><xsl:value-of select="/p:pottery/p:clays/p:clay[@xml:id = current()/@id]/@name"/></phrase><xsl:apply-templates select="@weightWhenWet"/></para>
    
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
            <xsl:apply-templates/>
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
            <para/>
        </section>
    </xsl:template>

    <xsl:template match="p:samples">
        <chapter>
            <title>Samples</title>

            <section>
                <title>Statistics</title>

               <para>A total of <xsl:value-of select="count(p:sample)"/> samples.</para>
            </section>

            <section>
                <title>Samples</title>

                <xsl:apply-templates/>
            </section>

        </chapter>
    </xsl:template>

    <xsl:template match="p:sample">
        <section>
            <title><xsl:apply-templates select="p:brick"/></title>
            
            <xsl:apply-templates select="p:glazing | p:note"/>
        </section>
    </xsl:template>

    <xsl:template match="p:sample/p:note">
        <formalpara>
                <title><xsl:value-of select="../@date"/></title>
                <para><xsl:value-of select="."/></para>
        </formalpara>
    </xsl:template>

    <xsl:template match="p:glazing">
        <para><emphasis>Glaze</emphasis>: <phrase xlink:href="#{@id}"><xsl:value-of select="/p:pottery/p:glazes/p:glaze[@xml:id = current()/@id]/@name"/></phrase>
            <xsl:apply-templates select="@viscosity | @trickled"/>
        </para>
    </xsl:template>

    <xsl:template match="@viscosity">
        <xsl:text>, </xsl:text><emphasis>viscosity</emphasis>:
        <constant><xsl:value-of select="."/></constant>
    </xsl:template>

    <xsl:template match="@trickled">
        <xsl:text>, </xsl:text><emphasis>trickled</emphasis>:
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
