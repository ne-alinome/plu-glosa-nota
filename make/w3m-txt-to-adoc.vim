" w3m-txt-to-adoc.vim

" This file is part of the _Plu Glosa Nota_ project. 

" By Marcos Cruz (programandala.net)

" 2018-11-21

" Hide the image markups:
"%s@^\s\+\(\[\[.\+\)$@\r\/\/ \1\r@c

" Adapt the image markups:
%s@^\s\+\(\[.\{-}]\)$@\\\1@c

" Hide the page number notes:
"%s@^\s*\(- pagina \d: -\).*$@\/\/ \1@c

" Adapt the page number notes:
"%s@^\s*- \(pagina \d:\) -.*$@\\[\1]@e

" Convert the main heading into a code block:
"%s@┏\_.\{-}━\n@\.\.\.\.\r&\.\.\.\.\r@c

" Hide the glosa.org footnotes:
"%s@^\s\+\[\d\+]\(www\.glosa\.org.\+\)$@\/\/ http:\/\/\1@c
