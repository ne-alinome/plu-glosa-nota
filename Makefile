# Makefile of _Plu Glosa Nota_

# By Marcos Cruz (programandala.net)

# Last modified 201812101456
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc
# - pdfimages
# - tesseract

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
# Extract the texts from the original scanned PDF

# NOTE:
#
# This is only a tool to facilite extracting texts from individual pages of the
# old issues of _Plu Glosa Nota_.  The OCR-ed texts are not automatically
# integrated into the target documents.
#
# The original PDF files, from www.glosa.org, must be in the <original>
# directory.

# ----------------------------------------------
# OCR individual pages

# Usage example for extracting the text from page 5 of PGN 41:
#
# 	make original/pgn041-005.txt

original/%.txt: original/%.ppm

original/%-001.ppm: original/%.pdf
	pdfimages -p -f 1 -l 1 $< $(basename $<)
	mv $(basename $<)-001-000.ppm $@

original/%-002.ppm: original/%.pdf
	pdfimages -p -f 2 -l 2 $< $@
	mv $(basename $<)-002-000.ppm $@

original/%-003.ppm: original/%.pdf
	pdfimages -p -f 3 -l 3 $< $@
	mv $(basename $<)-003-000.ppm $@

original/%-004.ppm: original/%.pdf
	pdfimages -p -f 4 -l 4 $< $@
	mv $(basename $<)-004-000.ppm $@

original/%-005.ppm: original/%.pdf
	pdfimages -p -f 5 -l 5 $< $@
	mv $(basename $<)-005-000.ppm $@

original/%-006.ppm: original/%.pdf
	pdfimages -p -f 6 -l 6 $< $@
	mv $(basename $<)-006-000.ppm $@

original/%-007.ppm: original/%.pdf
	pdfimages -p -f 7 -l 7 $< $@
	mv $(basename $<)-007-000.ppm $@

original/%.txt: original/%.ppm
	tesseract $< $(basename $@)

# ----------------------------------------------
# OCR all PDF

# XXX TODO -- Finish and test.

pdf_files=$(sort $(notdir $(basename $(wildcard original/*.pdf))))

.PHONY: ocr
ocr:
	for file in $(pdf_files);\
	do \
		pdfimages original/$${file}.pdf original/$${file};\
		for image in $$(ls original/$${file}*.ppm);\
		do \
			tesseract $${image} $${image};\
		done;\
	done

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
#
# 2018-12-10: Add rules to OCR the original PDFs.
