#Purge implicites rules 
.SUFFIXES:
.SUFFIXES: .pdf .tex

# Tools 
TEX = pdflatex 
BIBMAKE = bibtex
# name of Pdf File 


julia.pdf : julia.tex 
	$(TEX) $<	
# Clean the directory
clean::clean_pdf clean_aux


clean_pdf: 
	@echo Cleaning pdf File... 
	@rm -f julia.pdf
clean_aux:
	@echo Cleaning Auxiliary files... 
	@rm -f core *.nav *.vrb *.loa *.bbl julia.out  
	@rm -f *.aux *.toc *.lof *.log *.snm 
