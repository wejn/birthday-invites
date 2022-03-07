all:
	bash gen-geo.sh
	ruby generate.rb
	pdfcslatex invitations-kid1.tex
	pdfcslatex invitations-kid2.tex
	pdfcslatex envelopes-kid1.tex
	pdfcslatex envelopes-kid2.tex
	pdftk envelopes-kid1.pdf cat 1-endwest output envelopes-kid1.rot.pdf
	pdftk envelopes-kid2.pdf cat 1-endwest output envelopes-kid2.rot.pdf
	rm -f *.aux *.log
	cat howtoprint.txt

clean:
	rm -f *.aux *.log *.tex *.pdf
