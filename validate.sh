xmllint --xinclude --noout --schema pottery.xsd pottery.xml
xsltproc --xinclude -o pottery.docbook pottery2docbook.xsl pottery.xml
xmllint --xinclude --noout --relaxng docbook.rng pottery.docbook
# vim: et:ts=4:sw=4:sts=4
