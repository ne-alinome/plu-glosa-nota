# Makefile of _Plu Glosa Nota_

# By Marcos Cruz (programandala.net)

# Last modified 201811220057
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc

# ==============================================================
# Config

target=target

VPATH=./src:./$(target)

book=plu_glosa_nota

# ==============================================================
# Interface

.PHONY: all
all: epub html odt pdf

.PHONY: docbook
docbook: $(target)/$(book).adoc.xml

.PHONY: epub
epub: $(target)/$(book).adoc.xml.pandoc.epub

.PHONY: picdir
picdir:
	ln --force --symbolic --target-directory=$(target) ../src/pic

.PHONY: html
html: picdir $(target)/$(book).adoc.html $(target)/$(book).adoc.plain.html $(target)/$(book).adoc.xml.pandoc.html

.PHONY: odt
odt: $(target)/$(book).adoc.xml.pandoc.odt

.PHONY: pdf
pdf: $(target)/$(book).adoc.pdf

.PHONY: rtf
rtf: $(target)/$(book).adoc.xml.pandoc.rtf

.PHONY: clean
clean:
	rm -f \
		$(target)/*.epub \
		$(target)/*.html \
		$(target)/*.odt \
		$(target)/*.pdf \
		$(target)/*.rtf \
		$(target)/*.xml

# ==============================================================
# Convert to DocBook

$(target)/$(book).adoc.xml: $(book).adoc
	asciidoctor --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert to EPUB

# NB: Pandoc does not allow alternative templates. The default templates must
# be modified or redirected instead. They are the following:
# 
# /usr/share/pandoc-1.9.4.2/templates/epub-coverimage.html
# /usr/share/pandoc-1.9.4.2/templates/epub-page.html
# /usr/share/pandoc-1.9.4.2/templates/epub-titlepage.html

$(target)/$(book).adoc.xml.pandoc.epub: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=epub \
		--output=$@ \
		$<

# ==============================================================
# Convert to HTML

$(target)/$(book).adoc.plain.html: $(book).adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=$@ \
		$<

$(target)/$(book).adoc.html: $(book).adoc
	adoc --out-file=$@ $<

$(target)/$(book).adoc.xml.pandoc.html: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=html \
		--output=$@ \
		$<

# ==============================================================
# Convert to ODT

$(target)/$(book).adoc.xml.pandoc.odt: $(target)/$(book).adoc.xml
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--output=$@ \
		$<

# ==============================================================
# Convert to PDF

$(target)/$(book).adoc.pdf: $(book).adoc
	asciidoctor-pdf --out-file=$@ $<

# ==============================================================
# Convert to RTF

# XXX FIXME -- Both LibreOffice Writer and AbiWord don't read this RTF file
# properly. The RTF marks are exposed. It seems they don't recognize the format
# and take it as a plain file.

$(target)/$(book).adoc.xml.pandoc.rtf: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=rtf \
		--output=$@ \
		$<

# ==============================================================
# Change log

# 2018-11-22: Start. Copy from the project _18 Steps to Fluency in Euro-Glosa_.
