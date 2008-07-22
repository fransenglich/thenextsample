withIncludesResolved="`tempfile`"
sourceFile="sources.xml"
tempFiles="$sourceFile $withIncludesResolved"

# Generate the images.
./images.sh

xmllint --xinclude --output $withIncludesResolved --schema pottery.xsd pottery.xml || exit 1

echo '<?xml version="1.0" encoding="UTF-8"?>' > $sourceFile
echo '<sources xmlns="tag:fenglich.fastmail.fm,2007:Pottery">' >> $sourceFile
sources="                       \
         glazes.xml             \
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

# Let's just check it is ok
xmllint --noout $sourceFile || exit 2

xsltproc -o pottery.docbook pottery2docbook.xsl $withIncludesResolved || exit 3

xmllint --xinclude --noout --schema docbook.xsd pottery.docbook || exit 4

cd xhtml/
xsltproc --stringparam use.id.as.filename 1         \
         ../../docbook-xsl-1.73.2/xhtml/chunk.xsl   \
         ../pottery.docbook || exit 5

# vim: et:ts=4:sw=4:sts=4
