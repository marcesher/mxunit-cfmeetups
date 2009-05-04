<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
<xsl:template match="attack"><xsl:value-of select="name" />|<xsl:value-of select="code" />|<xsl:value-of select="label" /><!--|<xsl:value-of select="browser" />-->
</xsl:template>
</xsl:stylesheet>