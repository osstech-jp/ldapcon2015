LATEX=uplatex
LATEX_OPT=-shell-escape
PANDOC=pandoc
PANDOC_OPT=-t beamer --listings
#DVIPDFMX_OPT=-f ptex-hiragino

NAME=hamano-slide
SRC=$(NAME).md
TEX=$(NAME).tex
DVI=$(NAME).dvi
PDF=$(NAME).pdf
TEMPLATE=osstech_beamer.tex

all: $(PDF)

$(TEX): $(SRC) $(TEMPLATE)
	$(PANDOC) $(PANDOC_OPT) --template=$(TEMPLATE) -o $@ $<

$(DVI): $(TEX)
	$(LATEX) $(LATEX_OPT) $^

$(PDF): $(DVI)
	dvipdfmx $(DVIPDFMX_OPT) -o $@ $^

clean:
	rm -rf *.log *.aux *.out *.toc *.nav *.snm $(TEX) $(DVI) $(PDF)

