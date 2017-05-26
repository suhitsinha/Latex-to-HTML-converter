BEGIN{
FS = " ";
OFS = " ";
}
{
headfound = match($0, "^ *<head>");
bf_found = match($0,/\\textbf{/);
it_found = match($0,/\\textit{/);
if(headfound)
{
	print $0;
	print "<link rel='stylesheet' type='text/css' href='"cssname"'>";
}
else if(bf_found || it_found)
{
	for (i = 1; i <= NF; i++)
	{
		if($i ~ / *\\textbf[[:print:]]*/)
		{	
			split($i, bold, "{");
			split(bold[2], boldtext, "}");
			print "<b>"boldtext[1]" </b>";
		}
		else if($i ~ / *\\textit[[:print:]]*/)
		{	
			split($i, ita, "{");
			split(ita[2], itatext, "}");
			print "<i>"itatext[1]" </i>";
		}
		else
		{
			print $i" ";
		}
	}
}
else
	print $0;
}
END{
}


