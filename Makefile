# purge implicites rules 
.SUFFIXES:
.SUFFIXES: .pdf .tex

all: latex marp

marp : julia-marp.md
	marp $<
	CHROME_PATH=/snap/chromium/current/usr/lib/chromium-browser/chrome marp --allow-local-files --pdf $<

latex : julia.tex 
	latexmk -output-directory=tmp -pdf $<
	mv tmp/julia.pdf julia.pdf

# clean the directory
clean::clean_pdf clean_aux

clean_pdf: 
	@echo Cleaning pdf File... 
	@rm -f julia.pdf

clean_aux:
	@echo Cleaning Auxiliary files... 
	@rm -f core *.nav *.vrb *.loa *.bbl julia.out  
	@rm -f *.aux *.toc *.lof *.log *.snm 
