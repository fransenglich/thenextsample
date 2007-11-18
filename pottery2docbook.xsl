<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "-//OASIS//DTD DocBook V5.0//EN">
<xsl:stylesheet version="1.0"
                xml:lang="en"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ex="http://exslt.org/dates-and-times"
                xmlns:em="http://exslt.org/math"
                xmlns:es="http://exslt.org/sets"
                xmlns:p="tag:fenglich.fastmail.fm,2007:Pottery">


    <xsl:template match="/p:pottery">
        <book xml:lang="en">
            <title>Frans' Pottery Log</title>
            <info>
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
        <para/>
    </xsl:template>

    <xsl:template match="p:glazes">
        <chapter>
            <title>Glazes</title>
            <xsl:apply-templates/>
        </chapter>
    </xsl:template>

    <xsl:template match="p:glaze">
        <formalpara>
            <title>
                <xsl:value-of select="@name"/>
                <xsl:if test="@productID">, 
                    <xsl:value-of select="@productID"/>
                </xsl:if>
            </title>
            <para/>
        </formalpara>
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
        <segmentedlist>
            <title></title>
            <segtitle></segtitle>
            <seglistitem><seg></seg></seglistitem>
        </segmentedlist>
        <para><xsl:value-of select="string(p:note)"/></para>
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

    <!-- We don't want to process this. -->
    <xsl:template match="p:clays"/>

    <!-- Just swallow unmatched things for now. -->
    <xsl:template match="*">
        <xsl:message terminate="yes">
            Unmatched node: <xsl:value-of select="name()"/>
        </xsl:message>
    </xsl:template>

</xsl:stylesheet>

<!--
vim: et:ts=4:sw=4:sts=4
-->
