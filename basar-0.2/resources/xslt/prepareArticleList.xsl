<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="urn:schemas-microsoft-com:office:component:spreadsheet" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x2="http://schemas.microsoft.com/office/excel/2003/xml" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xs math xd" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Jan 2, 2015</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> johannes</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output indent="yes" method="xml"/>
    <xsl:param name="seller.name"/>
    <xsl:param name="seller.mail"/>
    <xsl:param name="maxItems"/>
    <xsl:variable name="max" select="round(number($maxItems)) cast as xs:integer"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ss:Worksheet/ss:Table/ss:Row[1]/ss:Cell[2]">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
            <xsl:value-of select="$seller.name"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="ss:Worksheet/ss:Table/ss:Row[2]/ss:Cell[2]">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
            <xsl:value-of select="$seller.mail"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="ss:Worksheet/ss:Table/ss:Row[3]">
        <xsl:variable name="row.template" select="."/>
        <xsl:for-each select="(1 to $max)">
            <xsl:variable name="i" select="."/>
            <xsl:copy>
                <xsl:apply-templates select="$row.template/node() | $row.template/@*" mode="numbering">
                    <xsl:with-param name="number" select="$i" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="text()" mode="numbering">
        <xsl:param name="number" tunnel="yes"/>
        <xsl:value-of select="$number"/>
    </xsl:template>
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>