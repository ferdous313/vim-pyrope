" Vim syntax file
" Language:		Pyrope
" Maintainer:		Nilufar
" URL:			https://github.com/vim-pyrope/vim-pyrope
" Release Coordinator:	
" ----------------------------------------------------------------------------
"
" 
" Thanks to perl.vim and ruby.vim authors
" ----------------------------------------------------------------------------

if exists("b:current_syntax")
  finish
endif

if has("folding") && exists("pyrope_fold")
  setlocal foldmethod=syntax
endif

syn cluster pyropeNotTop contains=@pyropeExtendedStringSpecial,@pyropeRegexpSpecial,@pyropeDeclaration,pyropeConditional,pyropeExceptional,pyropeMethodExceptional,pyropeTodo

if exists("pyrope_space_errors")
  if !exists("pyrope_no_trail_space_error")
    syn match pyropeSpaceError display excludenl "\s\+$"
  endif
  if !exists("pyrope_no_tab_space_error")
    syn match pyropeSpaceError display " \+\t"me=e-1
  endif
endif

" Operators
if exists("pyrope_operators")
  syn match  pyropeOperator "[~!^&|*/%+-]\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\*\*\|\.\.\.\|\.\.\|::"
  syn match  pyropeOperator "->\|-=\|/=\|\*\*=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!\~\|!="
  syn region pyropeBracketOperator matchgroup=pyropeOperator start="\%(\w[?!]\=\|[]})]\)\@<=\[\s*" end="\s*]" contains=ALLBUT,@pyropeNotTop
endif

" Expression Substitution and Backslash Notation
syn match pyropeStringEscape "\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}"						    contained display
syn match pyropeStringEscape "\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)" contained display
syn match pyropeQuoteEscape  "\\[\\']"											    contained display

syn region pyropeInterpolation	      matchgroup=pyropeInterpolationDelimiter start="#{" end="}" contained contains=ALLBUT,@pyropeNotTop
syn match  pyropeInterpolation	      "#\%(\$\|@@\=\)\w\+"    display contained contains=pyropeInterpolationDelimiter,pyropeInstanceVariable,pyropeClassVariable,pyropeGlobalVariable,pyropePredefinedVariable
syn match  pyropeInterpolationDelimiter "#\ze\%(\$\|@@\=\)\w\+" display contained
syn match  pyropeInterpolation	      "#\$\%(-\w\|\W\)"       display contained contains=pyropeInterpolationDelimiter,pyropePredefinedVariable,pyropeInvalidVariable
syn match  pyropeInterpolationDelimiter "#\ze\$\%(-\w\|\W\)"    display contained
syn region pyropeNoInterpolation	      start="\\#{" end="}"            contained
syn match  pyropeNoInterpolation	      "\\#{"		      display contained
syn match  pyropeNoInterpolation	      "\\#\%(\$\|@@\=\)\w\+"  display contained
syn match  pyropeNoInterpolation	      "\\#\$\W"		      display contained

syn match pyropeDelimEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region pyropeNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=pyropeString end=")"	transparent contained
syn region pyropeNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=pyropeString end="}"	transparent contained
syn region pyropeNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=pyropeString end=">"	transparent contained
syn region pyropeNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=pyropeString end="\]"	transparent contained

" These are mostly Oniguruma ready
syn region pyropeRegexpComment	matchgroup=pyropeRegexpSpecial   start="(?#"								  skip="\\)"  end=")"  contained
syn region pyropeRegexpParens	matchgroup=pyropeRegexpSpecial   start="(\(?:\|?<\=[=!]\|?>\|?<[a-z_]\w*>\|?[imx]*-[imx]*:\=\|\%(?#\)\@!\)" skip="\\)"  end=")"  contained transparent contains=@pyropeRegexpSpecial
syn region pyropeRegexpBrackets	matchgroup=pyropeRegexpCharClass start="\[\^\="								  skip="\\\]" end="\]" contained transparent contains=pyropeStringEscape,pyropeRegexpEscape,pyropeRegexpCharClass oneline
syn match  pyropeRegexpCharClass	"\\[DdHhSsWw]"	       contained display
syn match  pyropeRegexpCharClass	"\[:\^\=\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\):\]" contained
syn match  pyropeRegexpEscape	"\\[].*?+^$|\\/(){}[]" contained
syn match  pyropeRegexpQuantifier	"[*?+][?+]\="	       contained display
syn match  pyropeRegexpQuantifier	"{\d\+\%(,\d*\)\=}?\=" contained display
syn match  pyropeRegexpAnchor	"[$^]\|\\[ABbGZz]"     contained display
syn match  pyropeRegexpDot	"\."		       contained display
syn match  pyropeRegexpSpecial	"|"		       contained display
syn match  pyropeRegexpSpecial	"\\[1-9]\d\=\d\@!"     contained display
syn match  pyropeRegexpSpecial	"\\k<\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\=>" contained display
syn match  pyropeRegexpSpecial	"\\k'\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\='" contained display
syn match  pyropeRegexpSpecial	"\\g<\%([a-z_]\w*\|-\=\d\+\)>" contained display
syn match  pyropeRegexpSpecial	"\\g'\%([a-z_]\w*\|-\=\d\+\)'" contained display

syn cluster pyropeStringSpecial	      contains=pyropeInterpolation,pyropeNoInterpolation,pyropeStringEscape
syn cluster pyropeExtendedStringSpecial contains=@pyropeStringSpecial,pyropeNestedParentheses,pyropeNestedCurlyBraces,pyropeNestedAngleBrackets,pyropeNestedSquareBrackets
syn cluster pyropeRegexpSpecial	      contains=pyropeInterpolation,pyropeNoInterpolation,pyropeStringEscape,pyropeRegexpSpecial,pyropeRegexpEscape,pyropeRegexpBrackets,pyropeRegexpCharClass,pyropeRegexpDot,pyropeRegexpQuantifier,pyropeRegexpAnchor,pyropeRegexpParens,pyropeRegexpComment

" Numbers and ASCII Codes
syn match pyropeASCIICode	"\%(\w\|[]})\"'/]\)\@<!\%(?\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\=\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)\)"
syn match pyropeInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\%(_\x\+\)*\>"								display
syn match pyropeInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)\>"						display
syn match pyropeInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[oO]\=\o\+\%(_\o\+\)*\>"								display
syn match pyropeInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[bB][01]\+\%(_[01]\+\)*\>"								display
syn match pyropeFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*\>"					display
syn match pyropeFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)\>"	display

" Identifiers
syn match pyropeLocalVariableOrMethod "\<[_[:lower:]][_[:alnum:]]*[?!=]\=" contains=NONE display transparent
syn match pyropeBlockArgument	    "&[_[:lower:]][_[:alnum:]]"		 contains=NONE display transparent

syn match  pyropeConstant		"\%(\%([.@$]\@<!\.\)\@<!\<\|::\)\_s*\zs\u\w*\%(\>\|::\)\@=\%(\s*(\)\@!"
syn match  pyropeClassVariable	"@@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*" display
syn match  pyropeInstanceVariable "@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"  display
syn match  pyropeGlobalVariable	"$\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\|-.\)"
syn match  pyropeSymbol		"[]})\"':]\@<!:\%(\^\|\~\|<<\|<=>\|<=\|<\|===\|[=!]=\|[=!]\~\|!\|>>\|>=\|>\||\|-@\|-\|/\|\[]=\|\[]\|\*\*\|\*\|&\|%\|+@\|+\|`\)"
syn match  pyropeSymbol		"[]})\"':]\@<!:\$\%(-.\|[`~<=>_,;:!?/.'"@$*\&+0]\)"
syn match  pyropeSymbol		"[]})\"':]\@<!:\%(\$\|@@\=\)\=\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"
syn match  pyropeSymbol		"[]})\"':]\@<!:\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\%([?!=]>\@!\)\="
syn match  pyropeSymbol		"\%([{(,]\_s*\)\@<=\l\w*[!?]\=::\@!"he=e-1
syn match  pyropeSymbol		"[]})\"':]\@<!\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*[!?]\=:\s\@="he=e-1
syn match  pyropeSymbol		"\%([{(,]\_s*\)\@<=[[:space:],{]\l\w*[!?]\=::\@!"hs=s+1,he=e-1
syn match  pyropeSymbol		"[[:space:],{]\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*[!?]\=:\s\@="hs=s+1,he=e-1
syn region pyropeSymbol		start="[]})\"':]\@<!:'"  end="'"  skip="\\\\\|\\'"  contains=pyropeQuoteEscape fold
syn region pyropeSymbol		start="[]})\"':]\@<!:\"" end="\"" skip="\\\\\|\\\"" contains=@pyropeStringSpecial fold

syn match  pyropeBlockParameter	  "\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*" contained
syn region pyropeBlockParameterList start="\%(\%(\<do\>\|{\)\s*\)\@<=|" end="|" oneline display contains=pyropeBlockParameter

syn match pyropeInvalidVariable	 "$[^ A-Za-z_-]"
syn match pyropePredefinedVariable #$[!$&"'*+,./0:;<=>?@\`~]#
syn match pyropePredefinedVariable "$\d\+"										   display
syn match pyropePredefinedVariable "$_\>"											   display
syn match pyropePredefinedVariable "$-[0FIKadilpvw]\>"									   display
syn match pyropePredefinedVariable "$\%(deferr\|defout\|stderr\|stdin\|stdout\)\>"					   display
syn match pyropePredefinedVariable "$\%(DEBUG\|FILENAME\|KCODE\|LOADED_FEATURES\|LOAD_PATH\|PROGRAM_NAME\|SAFE\|VERBOSE\)\>" display
syn match pyropePredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(MatchingData\|ARGF\|ARGV\|ENV\)\>\%(\s*(\)\@!"
syn match pyropePredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(DATA\|FALSE\|NIL\)\>\%(\s*(\)\@!"
syn match pyropePredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(STDERR\|STDIN\|STDOUT\|TOPLEVEL_BINDING\|TRUE\)\>\%(\s*(\)\@!"
syn match pyropePredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(RUBY_\%(VERSION\|RELEASE_DATE\|PLATFORM\|PATCHLEVEL\|REVISION\|DESCRIPTION\|COPYRIGHT\|ENGINE\)\)\>\%(\s*(\)\@!"

" Normal Regular Expression
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="\%(\%(^\|\<\%(and\|or\|while\|until\|unless\|if\|elif\|when\|not\|then\|else\|elif\)\|[;\~=!|&(,[<>?:*+-]\)\s*\)\@<=/" end="/[iomxneus]*" skip="\\\\\|\\/" contains=@pyropeRegexpSpecial fold
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="\%(\h\k*\s\+\)\@<=/[ \t=]\@!" end="/[iomxneus]*" skip="\\\\\|\\/" contains=@pyropeRegexpSpecial fold

" Generalized Regular Expression
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="%r\z([~`!@#$%^&*_\-+=|\:;"',.? /]\)" end="\z1[iomxneus]*" skip="\\\\\|\\\z1" contains=@pyropeRegexpSpecial fold
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="%r{"				 end="}[iomxneus]*"   skip="\\\\\|\\}"	 contains=@pyropeRegexpSpecial fold
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="%r<"				 end=">[iomxneus]*"   skip="\\\\\|\\>"	 contains=@pyropeRegexpSpecial,pyropeNestedAngleBrackets,pyropeDelimEscape fold
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="%r\["				 end="\][iomxneus]*"  skip="\\\\\|\\\]"	 contains=@pyropeRegexpSpecial fold
syn region pyropeRegexp matchgroup=pyropeRegexpDelimiter start="%r("				 end=")[iomxneus]*"   skip="\\\\\|\\)"	 contains=@pyropeRegexpSpecial fold

" Normal String and Shell Command Output
syn region pyropeString matchgroup=pyropeStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@pyropeStringSpecial,@Spell fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="'"	end="'"  skip="\\\\\|\\'"  contains=pyropeQuoteEscape,@Spell    fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="`"	end="`"  skip="\\\\\|\\`"  contains=@pyropeStringSpecial fold

" Generalized Single Quoted String, Symbol and Array of Strings
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[qwi]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[qwi]{"				   end="}"   skip="\\\\\|\\}"	fold contains=pyropeNestedCurlyBraces,pyropeDelimEscape
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[qwi]<"				   end=">"   skip="\\\\\|\\>"	fold contains=pyropeNestedAngleBrackets,pyropeDelimEscape
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[qwi]\["				   end="\]"  skip="\\\\\|\\\]"	fold contains=pyropeNestedSquareBrackets,pyropeDelimEscape
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[qwi]("				   end=")"   skip="\\\\\|\\)"	fold contains=pyropeNestedParentheses,pyropeDelimEscape
syn region pyropeString matchgroup=pyropeStringDelimiter start="%q "				   end=" "   skip="\\\\\|\\)"	fold
syn region pyropeSymbol matchgroup=pyropeSymbolDelimiter start="%s\z([~`!@#$%^&*_\-+=|\:;"',.? /]\)"   end="\z1" skip="\\\\\|\\\z1" fold
syn region pyropeSymbol matchgroup=pyropeSymbolDelimiter start="%s{"				   end="}"   skip="\\\\\|\\}"	fold contains=pyropeNestedCurlyBraces,pyropeDelimEscape
syn region pyropeSymbol matchgroup=pyropeSymbolDelimiter start="%s<"				   end=">"   skip="\\\\\|\\>"	fold contains=pyropeNestedAngleBrackets,pyropeDelimEscape
syn region pyropeSymbol matchgroup=pyropeSymbolDelimiter start="%s\["				   end="\]"  skip="\\\\\|\\\]"	fold contains=pyropeNestedSquareBrackets,pyropeDelimEscape
syn region pyropeSymbol matchgroup=pyropeSymbolDelimiter start="%s("				   end=")"   skip="\\\\\|\\)"	fold contains=pyropeNestedParentheses,pyropeDelimEscape

" Generalized Double Quoted String and Array of Strings and Shell Command Output
" Note: %= is not matched here as the beginning of a double quoted string
syn region pyropeString matchgroup=pyropeStringDelimiter start="%\z([~`!@#$%^&*_\-+|\:;"',.?/]\)"	    end="\z1" skip="\\\\\|\\\z1" contains=@pyropeStringSpecial fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[QWIx]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" contains=@pyropeStringSpecial fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[QWIx]\={"				    end="}"   skip="\\\\\|\\}"	 contains=@pyropeStringSpecial,pyropeNestedCurlyBraces,pyropeDelimEscape    fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[QWIx]\=<"				    end=">"   skip="\\\\\|\\>"	 contains=@pyropeStringSpecial,pyropeNestedAngleBrackets,pyropeDelimEscape  fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[QWIx]\=\["				    end="\]"  skip="\\\\\|\\\]"	 contains=@pyropeStringSpecial,pyropeNestedSquareBrackets,pyropeDelimEscape fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[QWIx]\=("				    end=")"   skip="\\\\\|\\)"	 contains=@pyropeStringSpecial,pyropeNestedParentheses,pyropeDelimEscape    fold
syn region pyropeString matchgroup=pyropeStringDelimiter start="%[Qx] "				    end=" "   skip="\\\\\|\\)"   contains=@pyropeStringSpecial fold

" Here Document
syn region pyropeHeredocStart matchgroup=pyropeStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)+	 end=+$+ oneline contains=ALLBUT,@pyropeNotTop
syn region pyropeHeredocStart matchgroup=pyropeStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs"\%([^"]*\)"+ end=+$+ oneline contains=ALLBUT,@pyropeNotTop
syn region pyropeHeredocStart matchgroup=pyropeStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs'\%([^']*\)'+ end=+$+ oneline contains=ALLBUT,@pyropeNotTop
syn region pyropeHeredocStart matchgroup=pyropeStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs`\%([^`]*\)`+ end=+$+ oneline contains=ALLBUT,@pyropeNotTop

syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<\z(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=pyropeStringDelimiter end=+^\z1$+ contains=pyropeHeredocStart,pyropeHeredoc,@pyropeStringSpecial fold keepend
syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<"\z([^"]*\)"\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=pyropeStringDelimiter end=+^\z1$+ contains=pyropeHeredocStart,pyropeHeredoc,@pyropeStringSpecial fold keepend
syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<'\z([^']*\)'\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=pyropeStringDelimiter end=+^\z1$+ contains=pyropeHeredocStart,pyropeHeredoc			fold keepend
syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<`\z([^`]*\)`\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=pyropeStringDelimiter end=+^\z1$+ contains=pyropeHeredocStart,pyropeHeredoc,@pyropeStringSpecial fold keepend

syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-\z(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3    matchgroup=pyropeStringDelimiter end=+^\s*\zs\z1$+ contains=pyropeHeredocStart,@pyropeStringSpecial fold keepend
syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-"\z([^"]*\)"\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3  matchgroup=pyropeStringDelimiter end=+^\s*\zs\z1$+ contains=pyropeHeredocStart,@pyropeStringSpecial fold keepend
syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-'\z([^']*\)'\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3  matchgroup=pyropeStringDelimiter end=+^\s*\zs\z1$+ contains=pyropeHeredocStart		     fold keepend
syn region pyropeString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-`\z([^`]*\)`\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3  matchgroup=pyropeStringDelimiter end=+^\s*\zs\z1$+ contains=pyropeHeredocStart,@pyropeStringSpecial fold keepend


syn match  pyropeAliasDeclaration    "[^[:space:];#.()]\+" contained contains=pyropeSymbol,pyropeGlobalVariable,pyropePredefinedVariable nextgroup=pyropeAliasDeclaration2 skipwhite
syn match  pyropeAliasDeclaration2   "[^[:space:];#.()]\+" contained contains=pyropeSymbol,pyropeGlobalVariable,pyropePredefinedVariable
syn match  pyropeMethodDeclaration   "[^[:space:];#(]\+"	 contained contains=pyropeConstant,pyropeBoolean,pyropePseudoVariable,pyropeInstanceVariable,pyropeClassVariable,pyropeGlobalVariable
syn match  pyropeClassDeclaration    "[^[:space:];#<]\+"	 contained contains=pyropeConstant,pyropeOperator
syn match  pyropeModuleDeclaration   "[^[:space:];#<]\+"	 contained contains=pyropeConstant,pyropeOperator
syn match  pyropeFunction "\<[_[:alpha:]][_[:alnum:]]*[?!=]\=[[:alnum:]_.:?!=]\@!" contained containedin=pyropeMethodDeclaration
syn match  pyropeFunction "\%(\s\|^\)\@<=[_[:alpha:]][_[:alnum:]]*[?!=]\=\%(\s\|$\)\@=" contained containedin=pyropeAliasDeclaration,pyropeAliasDeclaration2
syn match  pyropeFunction "\%([[:space:].]\|^\)\@<=\%(\[\]=\=\|\*\*\|[+-]@\=\|[*/%|&^~]\|<<\|>>\|[<>]=\=\|<=>\|===\|[=!]=\|[=!]\~\|!\|`\)\%([[:space:];#(]\|$\)\@=" contained containedin=pyropeAliasDeclaration,pyropeAliasDeclaration2,pyropeMethodDeclaration

syn cluster pyropeDeclaration contains=pyropeAliasDeclaration,pyropeAliasDeclaration2,pyropeMethodDeclaration,pyropeModuleDeclaration,pyropeClassDeclaration,pyropeFunction,pyropeBlockParameter

" Keywords
" Note: the following keywords have already been defined:
" begin case class def do end for if module unless until while
" lima
syn match   pyropeControl	       "\<\%(and\|break\|in\|next\|not\|or\|redo\|rescue\|retry\|try\|return\|as\)\>[?!]\@!"
syn match   pyropeOperator       "\<defined?" display
syn match   pyropeKeyword	       "\<\%(super\|yield\|stage\|I\|puts\)\>[?!]\@!"
syn match   pyropeBoolean	       "\<\%(true\|false\)\>[?!]\@!"
syn match   pyropePseudoVariable "\<\%(nil\|self\|__ENCODING__\|__FILE__\|__LINE__\|__callee__\|__method__\)\>[?!]\@!" " TODO
                                  
syn match   pyropePseudoVariable "\<\%(_ref\|_obj\|_lenght\|_block\|_size\|_range\|clock\)\>[?!]\@!"  

syn match   pyropeBeginEnd       "\<\%(BEGIN\|END\)\>[?!]\@!"

" Expensive Mode - match 'end' with the appropriate opening keyword for syntax
" based folding and special highlighting of module/class/method definitions
if !exists("b:pyrope_no_expensive") && !exists("pyrope_no_expensive")
  syn match  pyropeDefine "\<alias\>"  nextgroup=pyropeAliasDeclaration  skipwhite skipnl
  syn match  pyropeDefine "\<def\>"    nextgroup=pyropeMethodDeclaration skipwhite skipnl
  syn match  pyropeDefine "\<undef\>"  nextgroup=pyropeFunction	     skipwhite skipnl
  syn match  pyropeClass	"\<class\>"  nextgroup=pyropeClassDeclaration  skipwhite skipnl
  syn match  pyropeModule "\<module\>" nextgroup=pyropeModuleDeclaration skipwhite skipnl

  syn region pyropeMethodBlock start="\<def\>"	matchgroup=pyropeDefine end="\%(\<def\_s\+\)\@<!\<end\>" contains=ALLBUT,@pyropeNotTop fold
  syn region pyropeBlock	     start="\<class\>"	matchgroup=pyropeClass  end="\<end\>"		       contains=ALLBUT,@pyropeNotTop fold
  syn region pyropeBlock	     start="\<module\>" matchgroup=pyropeModule end="\<end\>"		       contains=ALLBUT,@pyropeNotTop fold

  " modifiers
  syn match pyropeConditionalModifier "\<\%(if\|unless\)\>"    display
  syn match pyropeRepeatModifier	     "\<\%(while\|until\)\>" display

  syn region pyropeDoBlock      matchgroup=pyropeControl start="\<do\>" end="\<end\>"                 contains=ALLBUT,@pyropeNotTop fold
  " curly bracket block or hash literal
  syn region pyropeCurlyBlock	matchgroup=pyropeCurlyBlockDelimiter  start="{" end="}"				contains=ALLBUT,@pyropeNotTop fold
  syn region pyropeArrayLiteral	matchgroup=pyropeArrayDelimiter	    start="\%(\w\|[\]})]\)\@<!\[" end="]"	contains=ALLBUT,@pyropeNotTop fold

  " statements without 'do'
  syn region pyropeBlockExpression       matchgroup=pyropeControl	  start="\<begin\>" end="\<end\>" contains=ALLBUT,@pyropeNotTop fold
  syn region pyropeCaseExpression	       matchgroup=pyropeConditional start="\<case\>"  end="\<end\>" contains=ALLBUT,@pyropeNotTop fold
  syn region pyropeConditionalExpression matchgroup=pyropeConditional start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+=-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![?!]\)\s*\)\@<=\%(if\|unless\)\>" end="\%(\%(\%(\.\@<!\.\)\|::\)\s*\)\@<!\<end\>" contains=ALLBUT,@pyropeNotTop fold

  syn match pyropeConditional "\<\%(then\|else\|elif\|when\)\>[?!]\@!"	contained containedin=pyropeCaseExpression
  syn match pyropeConditional "\<\%(then\|else\|elif\)\>[?!]\@!" contained containedin=pyropeConditionalExpression

  syn match pyropeExceptional	  "\<\%(\%(\%(;\|^\)\s*\)\@<=rescue\|else\|ensure\)\>[?!]\@!" contained containedin=pyropeBlockExpression
  syn match pyropeMethodExceptional "\<\%(\%(\%(;\|^\)\s*\)\@<=rescue\|else\|ensure\)\>[?!]\@!" contained containedin=pyropeMethodBlock

  " statements with optional 'do'
  syn region pyropeOptionalDoLine   matchgroup=pyropeRepeat start="\<for\>[?!]\@!" start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=pyropeOptionalDo end="\%(\<do\>\)" end="\ze\%(;\|$\)" oneline contains=ALLBUT,@pyropeNotTop
  syn region pyropeRepeatExpression start="\<for\>[?!]\@!" start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=pyropeRepeat end="\<end\>" contains=ALLBUT,@pyropeNotTop nextgroup=pyropeOptionalDoLine fold

  if !exists("pyrope_minlines")
    let pyrope_minlines = 500
  endif
  exec "syn sync minlines=" . pyrope_minlines

else
  syn match pyropeControl "\<def\>[?!]\@!"    nextgroup=pyropeMethodDeclaration skipwhite skipnl
  syn match pyropeControl "\<class\>[?!]\@!"  nextgroup=pyropeClassDeclaration  skipwhite skipnl
  syn match pyropeControl "\<module\>[?!]\@!" nextgroup=pyropeModuleDeclaration skipwhite skipnl
  syn match pyropeControl "\<\%(case\|begin\|do\|for\|if\|unless\|while\|until\|else\|elif\|ensure\|then\|when\|end\)\>[?!]\@!"
  syn match pyropeKeyword "\<\%(alias\|undef\)\>[?!]\@!"
endif

" Special Methods
if !exists("pyrope_no_special_methods")
  syn keyword pyropeAccess    public protected private public_class_method private_class_method public_constant private_constant module_function
  " attr is a common variable name
  syn match   pyropeAttribute "\%(\%(^\|;\)\s*\)\@<=attr\>\(\s*[.=]\)\@!"
  syn keyword pyropeAttribute attr_accessor attr_reader attr_writer
  syn match   pyropeControl   "\<\%(exit!\|\%(abort\|at_exit\|exit\|fork\|loop\|trap\)\>[?!]\@!\)"
  syn keyword pyropeEval	    eval class_eval instance_eval module_eval
  syn keyword pyropeException raise fail catch throw
  " false positive with 'include?'
  syn match   pyropeInclude   "\<include\>[?!]\@!"
  syn keyword pyropeInclude   autoload extend load prepend require require_relative
  syn keyword pyropeKeyword   callcc caller lambda proc
endif

" Comments and Documentation
syn match   pyropeSharpBang "\%^#!.*" display
syn keyword pyropeTodo	  FIXME NOTE TODO OPTIMIZE XXX todo contained
syn match   pyropeComment   "#.*" contains=pyropeSharpBang,pyropeSpaceError,pyropeTodo,@Spell
if !exists("pyrope_no_comment_fold")
  syn region pyropeMultilineComment start="\%(\%(^\s*#.*\n\)\@<!\%(^\s*#.*\n\)\)\%(\(^\s*#.*\n\)\{1,}\)\@=" end="\%(^\s*#.*\n\)\@<=\%(^\s*#.*\n\)\%(^\s*#\)\@!" contains=pyropeComment transparent fold keepend
  syn region pyropeDocumentation	  start="^=begin\ze\%(\s.*\)\=$" end="^=end\%(\s.*\)\=$" contains=pyropeSpaceError,pyropeTodo,@Spell fold
else
  syn region pyropeDocumentation	  start="^=begin\s*$" end="^=end\s*$" contains=pyropeSpaceError,pyropeTodo,@Spell
endif

" Note: this is a hack to prevent 'keywords' being highlighted as such when called as methods with an explicit receiver
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(alias\|and\|begin\|break\|case\|class\|def\|defined\|do\|else\)\>" transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(elif\|end\|ensure\|false\|for\|if\|in\|module\|next\|nil\)\>"  transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(not\|or\|redo\|rescue\|retry\|try\|return\|self\|super\|then\|true\)\>" transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(undef\|unless\|until\|when\|while\|yield\|stage\|I\|BEGIN\|END\|__FILE__\|__LINE__\)\>" transparent contains=NONE

syn match pyropeKeywordAsMethod "\<\%(alias\|begin\|case\|class\|def\|do\|end\)[?!]" transparent contains=NONE
syn match pyropeKeywordAsMethod "\<\%(if\|module\|undef\|unless\|until\|while\)[?!]" transparent contains=NONE

syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(abort\|at_exit\|attr\|attr_accessor\|attr_reader\)\>"	transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(attr_writer\|autoload\|callcc\|catch\|caller\)\>"		transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(eval\|class_eval\|instance_eval\|module_eval\|exit\)\>"	transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(extend\|fail\|fork\|include\|lambda\)\>"			transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(load\|loop\|prepend\|private\|proc\|protected\)\>"		transparent contains=NONE
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(public\|require\|require_relative\|raise\|throw\|trap\)\>"	transparent contains=NONE
"lima
syn match pyropeKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(_ref\|_obj\|_lenght\|_block\|_size\|_range\|clock\)\>"
" __END__ Directive
syn region pyropeData matchgroup=pyropeDataDirective start="^__END__$" end="\%$" fold

hi def link pyropeClass			pyropeDefine
hi def link pyropeModule		pyropeDefine
hi def link pyropeMethodExceptional	pyropeDefine
hi def link pyropeDefine		Define
hi def link pyropeFunction		Function
hi def link pyropeConditional		Conditional
hi def link pyropeConditionalModifier	pyropeConditional
hi def link pyropeExceptional		pyropeConditional
hi def link pyropeRepeat		Repeat
hi def link pyropeRepeatModifier	pyropeRepeat
hi def link pyropeOptionalDo		pyropeRepeat
hi def link pyropeControl		Statement
hi def link pyropeInclude		Include
hi def link pyropeInteger		Number
hi def link pyropeASCIICode		Character
hi def link pyropeFloat			Float
hi def link pyropeBoolean		Boolean
hi def link pyropeException		Exception
if !exists("pyrope_no_identifiers")
  hi def link pyropeIdentifier		Identifier
else
  hi def link pyropeIdentifier		NONE
endif
hi def link pyropeClassVariable		pyropeIdentifier
hi def link pyropeConstant		Type
hi def link pyropeGlobalVariable	pyropeIdentifier
hi def link pyropeBlockParameter	pyropeIdentifier
hi def link pyropeInstanceVariable	pyropeIdentifier
hi def link pyropePredefinedIdentifier	pyropeIdentifier
hi def link pyropePredefinedConstant	pyropePredefinedIdentifier
hi def link pyropePredefinedVariable	pyropePredefinedIdentifier
hi def link pyropeSymbol		Constant
hi def link pyropeKeyword		Keyword
hi def link pyropeOperator		Operator
hi def link pyropeBeginEnd		Statement
hi def link pyropeAccess		Statement
hi def link pyropeAttribute		Statement
hi def link pyropeEval			Statement
hi def link pyropePseudoVariable	Constant

hi def link pyropeComment		Comment
hi def link pyropeData			Comment
hi def link pyropeDataDirective		Delimiter
hi def link pyropeDocumentation		Comment
hi def link pyropeTodo			Todo

hi def link pyropeQuoteEscape		pyropeStringEscape
hi def link pyropeStringEscape		Special
hi def link pyropeInterpolationDelimiter Delimiter
hi def link pyropeNoInterpolation	pyropeString
hi def link pyropeSharpBang		PreProc
hi def link pyropeRegexpDelimiter	pyropeStringDelimiter
hi def link pyropeSymbolDelimiter	pyropeStringDelimiter
hi def link pyropeStringDelimiter	Delimiter
hi def link pyropeHeredoc		pyropeString
hi def link pyropeString		String
hi def link pyropeRegexpEscape		pyropeRegexpSpecial
hi def link pyropeRegexpQuantifier	pyropeRegexpSpecial
hi def link pyropeRegexpAnchor		pyropeRegexpSpecial
hi def link pyropeRegexpDot		pyropeRegexpCharClass
hi def link pyropeRegexpCharClass	pyropeRegexpSpecial
hi def link pyropeRegexpSpecial		Special
hi def link pyropeRegexpComment		Comment
hi def link pyropeRegexp		pyropeString

hi def link pyropeInvalidVariable	Error
hi def link pyropeError			Error
hi def link pyropeSpaceError		pyropeError

let b:current_syntax = "prp"

" vim: nowrap sw=2 sts=2 ts=8 noet:
