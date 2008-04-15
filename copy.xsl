<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xml:lang="en"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:p="tag:fenglich.fastmail.fm,2007:Pottery"
                xmlns="tag:fenglich.fastmail.fm,2007:Pottery"
                exclude-result-prefixes="p"
>


        <xsl:template match="p:sample">
                <sample>
                    <xsl:copy-of select="@*"/>
                    <xsl:copy-of select="p:tile/@*"/>
                    <xsl:copy-of select="node()[name() != 'tile']"/>
                </sample>
        </xsl:template>

        <xsl:template match="@*|node()">
              <xsl:copy>
                      <xsl:apply-templates select="@*|node()"/>
                        </xsl:copy>
                    </xsl:template>
</xsl:stylesheet>

<!--
vim: et:ts=4:sw=4:sts=4
-->
