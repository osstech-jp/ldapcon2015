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

all: $(PDF) hamano-slide.pdf hamano-bio.pdf

$(TEX): $(SRC) template.tex
	$(PANDOC) $(PANDOC_OPT) --template=template.tex -o $(TEX) $(SRC)

$(DVI): $(TEX)
	sed -i -e 's/includegraphics{/includegraphics[width=0.9\\columnwidth]{/g' $^
	sed -i -e 's/\[htbp\]/\[H\]/g' $^
	$(LATEX) $(LATEX_OPT) $^
	$(LATEX) $(LATEX_OPT) $^

$(PDF): $(DVI)
	dvipdfmx $(DVIPDFMX_OPT) -o $@ $^

hamano-slide.tex: hamano-slide.md
	$(PANDOC) -t beamer --template=osstech_beamer.tex -V fontsize:14pt -o $@ $^

hamano-slide.dvi: hamano-slide.tex
	$(LATEX) $(LATEX_OPT) $^

hamano-slide.pdf: hamano-slide.dvi
	dvipdfmx -o $@ $^

hamano-bio.pdf: hamano-bio.md
	$(PANDOC) -o $@ $^

clean:
	rm -rf *.log *.aux *.out *.toc *.dvi *.nav *.snm

archive:
	git archive --format=zip --prefix=hamano-paper/ master > hamano-paper.zip

