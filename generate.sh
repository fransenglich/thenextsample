withIncludesResolved="`tempfile`"
sourceFile="sources.xml"
tempFiles="$sourceFile $withIncludesResolved"

xmllint --xinclude --output $withIncludesResolved --schema pottery.xsd pottery.xml || exit 1

xsltproc -o pottery.docbook pottery2docbook.xsl $withIncludesResolved || exit 2

xmllint --xinclude --noout --relaxng docbook.rng pottery.docbook || exit 3

echo '<?xml version="1.0" encoding="UTF-8"?>' > $sourceFile
echo '<sources xmlns="tag:fenglich.fastmail.fm,2007:Pottery">' >> $sourceFile
sources="                       \
         pieces.xml             \
         pottery.xml            \
         pottery.xsd            \
         pottery2docbook.xsl    \
         samples.xml            \
         $0"
for source in $sources; do
    # Yes, the last hash outputted is the latest one.
    echo "<source href=\"$source\" \
                  gitSHA1=\"`git log --pretty=format:'%h" date="%cd"' $source | tail -n1` \
                  />" >> $sourceFile
done
echo '</sources>' >> $sourceFile

cd xhtml/
xsltproc ../../../src/docbook-xsl-1.73.2/xhtml/chunk.xsl ../pottery.docbook || exit 4

#rm -f $tempFiles

# vim: et:ts=4:sw=4:sts=4
