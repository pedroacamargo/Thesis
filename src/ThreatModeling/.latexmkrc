# The editor invokes `latexmk -pdf`, so route that recipe through LuaLaTeX.
# LuaLaTeX is required by fontspec and the system-installed Calibri font.
$pdflatex = 'lualatex %O %S';
