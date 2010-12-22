# We do two things:
#
#   * Find all the raw files and convert them to PNG files
#   * List all the PNGs and their meta data in an XML file such
#     that we can link it up wen generating the main document.

rawImages=`find Images/Tiles/ -name "*.dng"`
outXMLFile="imageMetaData.xml"

# Each raw file follow this pattern:
#
#   LNNN_tag_HNN_WNN.dng
#
# where L is either T or W, the "tag_" part optional, and the two subsequent numbers the
# height and width in millimeters. For instance: T41_H70_W50.dng.

echo '<imageMetaData xmlns:d="http://docbook.org/ns/docbook">' > $outXMLFile

for raw in $rawImages; do
    basename=`basename $raw`
    id=`echo "$basename" | sed -e 's/^\([^_]*\)_.*/\1/'`
    width=`echo "$basename" | sed -e 's/.*_W\([0-9]*\)\.dng$/\1/'`
    height=`echo "$basename" | sed -e 's/.*_H\([0-9]*\)\_.*$/\1/'`
    idTag="$id"
    path=`dirname $raw`
    nameOfExport="$id.png"
    pathOfExport="$path/$nameOfExport"

    pushd `dirname $raw`
    convert -rotate -90 $basename $nameOfExport
    popd

    echo "<d:mediaobject xml:id=\"TileImage_$idTag\"><d:imageobject>" >> $outXMLFile
    echo "<d:imagedata fileref=\"../$pathOfExport\" format=\"PNG\" contentdepth=\"$height"mm"\" contentwidth=\"$width"mm"\"/>" >> $outXMLFile
    echo "</d:imageobject></d:mediaobject>" >> $outXMLFile
done

echo "</imageMetaData>" >> $outXMLFile
