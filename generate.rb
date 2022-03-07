#!/usr/bin/env ruby
# encoding: utf-8

Invitation = Struct.new(:from, :to, :salutation, :date)
city = "|8000 Zürich"
local_ = "Jirků|Musterstrasse 1" + city
kid2 = "Kid2 " + local_
kid1 = "Kid1 " + local_
date_kid2 = '1.2.2022'
date_kid1 = '2.2.2022'

kid1_invitations = [
	Invitation.new(kid1, "Adam First|Musterstrasse 5" + city, "Lieber Adam", date_kid1),
	Invitation.new(kid1, "Eva Second|Musterstrasse 5" + city, "Liebe Eva", date_kid1),
]

kid2_invitations = [
	Invitation.new(kid2, "Adam First|Musterstrasse 5" + city, "Lieber Adam", date_kid2),
	Invitation.new(kid2, "Eva Second|Musterstrasse 5" + city, "Liebe Eva", date_kid2),
]

def envelopes_for(bg, invitations)
	out = []
	out << <<-'EOS'
\documentclass{article}
\usepackage[margin=1cm,top=1cm,papersize={114mm,162mm},landscape,twoside=false]{geometry}
\usepackage[utf8]{inputenc}
\usepackage{wallpaper}

\setlength\parskip{0pt}
\setlength\parindent{0pt}
\pagestyle{empty}

\def\envelope#1#2{%
\small\begin{tabular}{l}#1%
\end{tabular}\par{}\vspace{25mm}%
\begin{flushright}\Huge\begin{tabular}{l}#2%
\end{tabular}\end{flushright}\newpage{}}

\addtolength{\wpXoffset}{-5cm}
\addtolength{\wpYoffset}{-2cm}
\begin{document}
	EOS
	out << "\\CenterWallPaper{0.6}{#{bg}}"
	def texify(str)
		str.gsub(/\|/, '\\\\\\\\').sub(/CZ$/, 'Czech Republic')
	end
	invitations.each do |invitation|
		out << "\\envelope{#{texify(invitation.from)}}{#{texify(invitation.to)}}"
	end
	out << %s[\end{document}]
	out.join("\n")
end

def invitations_for(bg, invitations)
	out = []
	out << <<-'EOS'
\documentclass{article}
\usepackage[margin=2cm,top=2cm,papersize={210mm,297mm},landscape,twoside=false]{geometry}
\usepackage[utf8]{inputenc}
\usepackage{wallpaper}
\renewcommand{\familydefault}{\sfdefault}
\usepackage{graphicx}

\setlength\parskip{0pt}
\setlength\parindent{0pt}
\pagestyle{empty}

\def\invitation#1#2{%
\begin{tabular}{p{0.5\textwidth}p{0.5\textwidth}}
	&\begin{minipage}[t]{0.5\textwidth}
		{\huge #1,}\\[2em]
		{\LARGE
		du bist zu meiner Geburtstagsparty eingeladen.\\

		{\bfseries Wann:} Samstag, #2 14:30 -- ca. 17:00\\
		{\bfseries Wo:} Ein spassiger Ort, Musterstrasse 1, Kloppenburg
		\begin{center}\includegraphics{geo.png}\end{center}\vspace{1.5em}

		{\bfseries Bitte gib mir bis zum 1.2.2022 Bescheid ob du kommst:
		070 123 45 67} (iMessage, SMS, Signal, oder WhatsApp){\bfseries .}\\[2em]}

		\rule{\textwidth}{0.4pt}\\[2em]

		{\Large
		Auch die Eltern dürfen gerne bleiben. Es wird ein paar Erfrischungen und einen Sitzplatz geben.\\

		Und wenn Sie weitere Fragen haben, stehen wir Ihnen gerne zur Verfügung.
		}

	\end{minipage}\end{tabular}\newpage{}}

\begin{document}
	EOS
	out << "\\LLCornerWallPaper{1.0}{#{bg}}"
	def texify(str)
		str.gsub(/\|/, '\\\\\\\\').sub(/CZ$/, 'Czech Republic')
	end
	invitations.each do |invitation|
		out << "\\invitation{#{texify(invitation.salutation)}}{#{texify(invitation.date)}}"
	end
	out << %s[\end{document}]
	out.join("\n")
end

File.open('envelopes-kid1.tex', 'w') { |f| f.puts envelopes_for('env-kid1.png', kid1_invitations) }
File.open('envelopes-kid2.tex', 'w') { |f| f.puts envelopes_for('env-kid2.png', kid2_invitations) }
File.open('invitations-kid1.tex', 'w') { |f| f.puts invitations_for('inv-kid1.png', kid1_invitations) }
File.open('invitations-kid2.tex', 'w') { |f| f.puts invitations_for('inv-kid2.png', kid2_invitations) }
