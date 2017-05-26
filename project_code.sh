flex parse.l
g++ lex.yy.c -o parser
./parser $1 > intermediet
gawk -f project_code.awk intermediet > intermediet2
gawk -f addCSS.awk -v cssname=$3 intermediet2 > $2
rm -f intermediet intermediet2
