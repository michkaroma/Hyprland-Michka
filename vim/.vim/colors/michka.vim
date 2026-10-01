" ~/.vim/colors/michka.vim
" Thème Michka : fond #000000, texte blanc, accents rouge #ff0000

hi clear
if exists('syntax_on')
  syntax reset
endif
set background=dark
let g:colors_name = 'michka'

" [truecolor, 256 couleurs]
let s:p = {
      \ 'bg':    ['#000000', 16],
      \ 'bg1':   ['#0d0d0d', 233],
      \ 'bg2':   ['#1a1a1a', 234],
      \ 'bg3':   ['#2e2e2e', 236],
      \ 'grey':  ['#5c5c5c', 240],
      \ 'grey2': ['#8a8a8a', 245],
      \ 'fg2':   ['#bfbfbf', 250],
      \ 'fg':    ['#ffffff', 231],
      \ 'red':   ['#ff0000', 196],
      \ 'red2':  ['#ff5555', 203],
      \ 'dred':  ['#5f0000', 52],
      \ 'none':  ['NONE', 'NONE'],
      \ }

function! s:hi(group, fg, bg, ...) abort
  let l:attr = a:0 ? a:1 : 'NONE'
  execute printf('hi %s guifg=%s guibg=%s ctermfg=%s ctermbg=%s gui=%s cterm=%s',
        \ a:group, s:p[a:fg][0], s:p[a:bg][0], s:p[a:fg][1], s:p[a:bg][1], l:attr, l:attr)
endfunction

" --- Interface ---
call s:hi('Normal',       'fg',    'bg')
call s:hi('LineNr',       'grey',  'bg')
call s:hi('CursorLineNr', 'red',   'bg',   'bold')
call s:hi('CursorLine',   'none',  'bg1')
call s:hi('CursorColumn', 'none',  'bg1')
call s:hi('ColorColumn',  'none',  'bg1')
call s:hi('SignColumn',   'grey',  'bg')
call s:hi('FoldColumn',   'grey',  'bg')
call s:hi('Folded',       'grey2', 'bg1',  'italic')
call s:hi('VertSplit',    'bg3',   'bg')
call s:hi('EndOfBuffer',  'bg',    'bg')
call s:hi('NonText',      'bg3',   'none')
call s:hi('SpecialKey',   'bg3',   'none')
call s:hi('Visual',       'none',  'bg3')
call s:hi('Search',       'fg',    'dred', 'bold')
call s:hi('IncSearch',    'bg',    'red',  'bold')
call s:hi('CurSearch',    'bg',    'red',  'bold')
call s:hi('MatchParen',   'red',   'none', 'bold,underline')
call s:hi('Pmenu',        'fg2',   'bg2')
call s:hi('PmenuSel',     'bg',    'red',  'bold')
call s:hi('PmenuSbar',    'none',  'bg2')
call s:hi('PmenuThumb',   'none',  'grey')
call s:hi('WildMenu',     'bg',    'red',  'bold')
call s:hi('StatusLine',   'fg',    'bg2')
call s:hi('StatusLineNC', 'grey',  'bg1')
call s:hi('StatusLineTerm',   'fg',   'bg2')
call s:hi('StatusLineTermNC', 'grey', 'bg1')
call s:hi('TabLine',      'grey',  'bg1')
call s:hi('TabLineFill',  'none',  'bg1')
call s:hi('TabLineSel',   'red',   'bg',   'bold')
call s:hi('Title',        'red',   'none', 'bold')
call s:hi('Directory',    'fg',    'none', 'bold')
call s:hi('ErrorMsg',     'red',   'bg',   'bold')
call s:hi('WarningMsg',   'red2',  'bg')
call s:hi('ModeMsg',      'fg',    'bg',   'bold')
call s:hi('MoreMsg',      'fg2',   'bg')
call s:hi('Question',     'fg',    'bg')
call s:hi('QuickFixLine', 'none',  'bg2',  'bold')
call s:hi('DiffAdd',      'none',  'bg2')
call s:hi('DiffChange',   'none',  'bg1')
call s:hi('DiffDelete',   'red',   'bg')
call s:hi('DiffText',     'none',  'dred', 'bold')

" --- Syntaxe ---
call s:hi('Comment',      'grey2', 'none', 'italic')
call s:hi('Constant',     'red2',  'none')
call s:hi('String',       'fg2',   'none')
call s:hi('Character',    'fg2',   'none')
call s:hi('Number',       'red2',  'none')
call s:hi('Float',        'red2',  'none')
call s:hi('Boolean',      'red',   'none', 'bold')
call s:hi('Identifier',   'fg',    'none')
call s:hi('Function',     'fg',    'none', 'bold')
call s:hi('Statement',    'red',   'none')
call s:hi('Conditional',  'red',   'none')
call s:hi('Repeat',       'red',   'none')
call s:hi('Label',        'red',   'none')
call s:hi('Keyword',      'red',   'none', 'bold')
call s:hi('Exception',    'red',   'none', 'bold')
call s:hi('Operator',     'fg2',   'none')
call s:hi('PreProc',      'red2',  'none')
call s:hi('Include',      'red',   'none')
call s:hi('Define',       'red',   'none')
call s:hi('Macro',        'red2',  'none')
call s:hi('Type',         'fg2',   'none', 'bold')
call s:hi('StorageClass', 'red',   'none')
call s:hi('Structure',    'red',   'none')
call s:hi('Typedef',      'fg2',   'none', 'bold')
call s:hi('Special',      'red2',  'none')
call s:hi('SpecialChar',  'red2',  'none')
call s:hi('Delimiter',    'grey2', 'none')
call s:hi('Tag',          'red',   'none')
call s:hi('Debug',        'red',   'none')
call s:hi('Underlined',   'fg',    'none', 'underline')
call s:hi('Ignore',       'bg',    'none')
call s:hi('Error',        'red',   'bg',   'bold,underline')
call s:hi('Todo',         'bg',    'red',  'bold')

" --- Orthographe (soulignement ondulé rouge dans Kitty) ---
hi SpellBad   guifg=NONE guibg=NONE guisp=#ff0000 gui=undercurl ctermfg=196 cterm=underline
hi SpellCap   guifg=NONE guibg=NONE guisp=#ff5555 gui=undercurl ctermfg=203 cterm=underline
hi SpellRare  guifg=NONE guibg=NONE guisp=#8a8a8a gui=undercurl ctermfg=245 cterm=underline
hi SpellLocal guifg=NONE guibg=NONE guisp=#8a8a8a gui=undercurl ctermfg=245 cterm=underline

" --- Statusline (utilisés par ~/.vimrc) ---
call s:hi('StlNormal',   'bg',    'red',  'bold')
call s:hi('StlInsert',   'bg',    'fg',   'bold')
call s:hi('StlVisual',   'fg',    'dred', 'bold')
call s:hi('StlReplace',  'bg',    'red2', 'bold')
call s:hi('StlCommand',  'bg',    'grey2','bold')
call s:hi('StlInfo',     'fg2',   'bg3')
call s:hi('StlFile',     'fg',    'bg2',  'bold')
call s:hi('StlModified', 'red',   'bg2',  'bold')
call s:hi('StlFill',     'grey2', 'bg2')

delfunction s:hi
