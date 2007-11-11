<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "-//OASIS//DTD DocBook V5.0//EN">
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:p="tag:fenglich.fastmail.fm,2007:GlazeSamples">


    <xsl:template match="/">
        <book>
            <title>Frans' Pottery Log</title>

            <xsl:apply-templates/>
        </book>
    </xsl:template>

    <xsl:template match="p:pieces">
        <chapter>
            <title>PiecePieces</title>
            <xsl:apply-templates/>
        </chapter>
    </xsl:template>

    <xsl:template match="p:piece">
    </xsl:template>

    <!-- Just swallow unmatched things for now. -->
    <xsl:template match="node()">
        <!--
        <xsl:message terminate="yes">
            Unmatched node: <xsl:value-of select="name()"/>
        </xsl:message>
        -->
    </xsl:template>

</xsl:stylesheet>

<!--
vim: et:ts=4:sw=4:sts=4
-->
