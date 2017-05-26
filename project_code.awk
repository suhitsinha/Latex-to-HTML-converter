function imagePrinting(imageLocation, imageno){
	print "<br>"
	print "<table align = 'center'> <tr><td>";
	print "<figure>";
	print "<img src = '"imageLocation"'>";
	print "<figcaption align = 'center'> Image :"imageno"</figcaption></figure>";
	print "</td></tr></table>";
	print "<br>"
}

function chapterPrint(chapterName){
	print "<h1>"chapterName"</h1>";
}

function sectionPrint(secName){
	print "<h3>"secName"</h3>";
}

BEGIN{
print "<html>";
print "<head>";
print "<title>Conversion from Latex to HTML</title>";
print "</head>";
print "<body>";
FS = "|";
chapno = 0;
secno = 0;
tableno = 0;
imageno = 0;
}
{
eleVal = 0;
newrow = 1;
formula = 0;

image_found=match($0,/includegraphics/);
title_found=match($0,/\\title{/);
author_found=match($0,/\\author{/);
chapter_found=match($0,/\\chapter{/);
section_found=match($0,/\\section{/);
table_found=match($0,/\\begin{table}/);
uolist_found=match($0,/\\begin{itemize}/);
olist_found=match($0,/\\begin{enumerate}/);
formula_found=match($0,/ *\$/);
text_found=!match($0,/\\/);
bf_found = match($0,/\\textbf{/);
it_found = match($0,/\\textit{/);

if(image_found){
	imageno++;
	split($0, chars, "{");
	split(chars[2], image, "}");
	imagePrinting(image[1],imageno);
}
if(chapter_found){
	chapno++;
	split($0, chars, "{");
	split(chars[2], chapname, "}");
	chapterPrint("Chapter "chapno"<br>"chapname[1]);
	secno = 0;
}
if(title_found){
	split($0, title, "{");
	split(title[2], titlename, "}");
	print "<h1 align = 'center'>"titlename[1]"</h1>";
}
if(author_found){
	split($0, author, "{");
	split(author[2], authorname, "}");
	print "<h2 align = 'center'>Author name: "authorname[1]"</h2>";
}
if(section_found){
	secno++;
	split($0, chars, "{");
	split(chars[2], secname, "}");
	sectionPrint(chapno"."secno" : "secname[1]);
}
if(table_found){
	tableno++;
	for (i = 1; i <= NF; i++)
	{
		#print $i;
		if($i ~ /^\\begin{table}[[:print:]]*/)
		{
			print "<table border = "1" width="400" align = 'center'>";
		}
		else if(match($i, /^\\\\$/))
		{
			print "</tr>";
		}
		else if(match($i, "&"))
		{
		}
		else if($i ~ /^\\end{table}[[:print:]]*/)
		{
			print "</table>";
		}
		else if($i ~ /^\\begin{tabular}[[:print:]]*/)
		{	
		}
		else if($i ~ /^\\end{tabular}[[:print:]]*/)
		{	
		}
		else if($i ~ /^\\captionof{table}[[:print:]]*/)
		{
			split($i, chars, "{");
			split(chars[3], caption, "}");
			print "<caption> Table "tableno" : "caption[1]"</caption>";
		}
		else if(match($i, "\\hline"))
		{
			
		}
		else if(match($i, /^l$/))
		{
			
		}
		else if($i ~ /^[[:print:]]*[a-zA-Z0-9]+[[:print:]]*/)
		{
			if(newrow == 1)
			{			
				print "<tr>"
				newrow = 0;
			}
			gsub(/^[ \t]+/, "", $i); 
			gsub(/[ \t]+$/, "", $i);
			print "<td>";
			print $i;
			print "</td>";
		}
	}
}


else if(uolist_found)
{
	for (i = 1; i <= NF; i++)
	{
		if($i ~ / *\\begin{itemize}[[:print:]]*/)
		{
			print "<ul>";
		}
		else if($i ~ /\\end{itemize}[[:print:]]*/)
		{
			print "</ul>";
		}
		else if ($i ~ /^[[:print:]]*[a-zA-Z0-9]+[[:print:]]*/)
		{
			print "<li>"$i"</li>";
		}
	}
}

else if(olist_found)
{
	for (i = 1; i <= NF; i++)
	{
		if($i ~ / *\\begin{enumerate}[[:print:]]*/)
		{
			print "<ol>";
		}
		else if($i ~ /\\end{enumerate}[[:print:]]*/)
		{
			print "</ol>";
		}
		else if ($i ~ /^[[:print:]]*[a-zA-Z0-9]+[[:print:]]*/)
		{
			print "<li>"$i"</li>";
		}
	}
}

else if(formula_found)
{
	for (i = 1; i <= NF; i++)
	{
		if($i ~ / *\\psi */)
		{
			print "&#x3C8; ";
		}
		else if ($i ~ / *\\neg */)
		{
			print "&not; ";
		}
		else if ($i ~ / *\\equiv */)
		{
			print "&#x2261; ";
		}
		else if ($i ~ / *\\lor */)
		{
			print "&#x222a; ";
		}
		else if ($i ~ / *\\land */)
		{
			print "&#x222a; ";
		}
		else if ($i ~ / *\\varphi */)
		{
			print "&#x3C6; ";
		}
		else if ($i ~ / *\\Leftrightarrow */)
		{
			print "&#x2194; ";
		}
		else if ($i ~ / *\\varphi */)
		{
			print "&#x3C6; ";
		}
		else if ($i ~ / *\\Leftarrow */)
		{
			print "&#x2190; ";
		}
		else if ($i ~ / *\\Rightarrow */)
		{
			print "&#x2192; ";
		}
	
		else if ($i ~ /\$/)
		{
			if(formula == 0)
			{
				#print "hello"formula;
				print "&nbsp;&nbsp;&nbsp;&nbsp;";
				formula = 1;
			}
			else
			{
				print "<br>";
				formula = 0;
			}
		}
		else
		{
			print $i;
		}
	}
}

else if((text_found && $0 ~ /^[[:print:]]*[a-zA-Z0-9]+[[:print:]]*/) || bf_found || it_found){
	print "<p>"$0"</p>";
}

}
END{
print "<br><p align = 'center'> Converted using Latex to HTML Converter</p>"
print "</body>";
print "</html>";};


