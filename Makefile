LATEX=platex
LATEX_OPT=-shell-escape
PANDOC=pandoc
PANDOC_OPT=-f markdown+yaml_metadata_block --toc -V fontsize=12 -V twocolumn

NAME=paper
SRC=$(NAME).md
TEX=$(NAME).tex
DVI=$(NAME).dvi
PDF=$(NAME).pdf

all: $(PDF)

$(TEX): $(SRC) template.tex
	$(PANDOC) $(PANDOC_OPT) --template=template.tex -o $(TEX) $(SRC)

$(DVI): $(TEX)
	sed -i -e 's/includegraphics{/includegraphics[width=\\columnwidth]{/g' $^
	sed -i -e 's/\[htbp\]/\[H\]/g' $^
	$(LATEX) $(LATEX_OPT) $^
	$(LATEX) $(LATEX_OPT) $^

$(PDF): $(DVI)
	dvipdfmx -o $@ $^

clean:
	rm -rf *.log *.aux *.out *.dvi
