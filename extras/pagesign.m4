define(`_PROLOGUE', maketemp(`/tmp/PROLOGUE_XXXXXX'))dnl
define(`_HTML', maketemp(`/tmp/HTML_XXXXXX'))dnl
define(`_EPILOGUE', maketemp(`/tmp/EPILOGUE_XXXXXX'))dnl
define(`_OUTFILE', maketemp(`/tmp/OUTFILE_XXXXXX'))dnl
esyscmd(echo "<!doctype html>" >> _PROLOGUE)dnl
esyscmd(echo "<!--" >> _PROLOGUE)dnl
esyscmd(echo "--> <html>HTML HERE</html> <!--" >> _HTML)dnl
esyscmd(echo "-->" >> _EPILOGUE)dnl
divert(1)dnl
define(`_PROLOGUEHASH', esyscmd(sha256sum _PROLOGUE | cut -d' ' -f 1 -z))dnl
define(`_EPILOGUEHASH', esyscmd(sha256sum _EPILOGUE | cut -d' ' -f 1 -z))dnl
dnl TODO: Total length calculation should be changed to include signature length
define(`_TOTALLENGTH', eval(len(esyscmd(cat _PROLOGUE)) + len(esyscmd(cat _HTML)) + len(esyscmd(cat _EPILOGUE))))dnl
esyscmd(echo "len:" `_TOTALLENGTH' >> _OUTFILE)dnl
esyscmd(echo "prologuehash:" `_PROLOGUEHASH' >> _OUTFILE)dnl
esyscmd(echo "epiloguehash:" `_EPILOGUEHASH' >> _OUTFILE)dnl
esyscmd(cat _HTML >> _OUTFILE)dnl
divert(2)dnl
esyscmd(cat _PROLOGUE)dnl
dnl Signed block start
esyscmd(gpg --clearsign -o - _OUTFILE)dnl
dnl Signed block end
esyscmd(cat _EPILOGUE)dnl
undivert(2)dnl
