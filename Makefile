LATEX=platex
#LATEX=uplatex
LATEX_OPT=-shell-escape -output-directory=tex
PANDOC=pandoc
PANDOC_OPT=-f markdown+yaml_metadata_block --toc -V fontsize=12 -V twocolumn

NAME=paper
SRC=$(NAME).md
PDF=$(NAME).pdf
all: $(PDF)

$(PDF): $(SRC) template.tex
	mkdir -p tex
	$(PANDOC) $(PANDOC_OPT) --template=template.tex -o tex/$(NAME).tex $(SRC)
	sed -i -e 's/includegraphics{/includegraphics[width=\\columnwidth]{/g' tex/$(NAME).tex
	sed -i -e 's/\[htbp\]/\[H\]/g' tex/$(NAME).tex
	$(LATEX) $(LATEX_OPT) tex/$(NAME).tex
	$(LATEX) $(LATEX_OPT) tex/$(NAME).tex
	dvipdfmx -o $(PDF) tex/$(NAME).dvi

clean:
	rm -rf tex *.pdf *.xbb
