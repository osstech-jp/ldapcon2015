LATEX=uplatex
LATEX_OPT=-shell-escape
PANDOC=pandoc
PANDOC_OPT=-f markdown+yaml_metadata_block -V twocolumn -V fontsize:11pt --listings
#DVIPDFMX_OPT=-f ptex-hiragino

NAME=hamano-paper
SRC=$(NAME).md
TEX=$(NAME).tex
DVI=$(NAME).dvi
PDF=$(NAME).pdf
TEMPLATE=paper-template.tex

all: $(PDF) hamano-bio.pdf

$(TEX): $(SRC) $(TEMPLATE)
	$(PANDOC) $(PANDOC_OPT) --template=$(TEMPLATE) -o $(TEX) $(SRC)

$(DVI): $(TEX)
	sed -i -e 's/includegraphics{/includegraphics[width=0.9\\columnwidth]{/g' $^
	sed -i -e 's/\[htbp\]/\[H\]/g' $^
	$(LATEX) $(LATEX_OPT) $^
	$(LATEX) $(LATEX_OPT) $^

$(PDF): $(DVI)
	dvipdfmx $(DVIPDFMX_OPT) -o $@ $^

hamano-bio.pdf: hamano-bio.md
	$(PANDOC) -o $@ $^

clean:
	rm -rf $(DVI) $(TEX) *.log *.aux *.out *.toc *.pdf

archive:
	git archive --format=zip --prefix=hamano-paper/ master > hamano-paper.zip

