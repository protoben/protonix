{ runCommand, vim_configurable, vimPlugins, vimUtils, fetchFromGitHub
, buildEnv, w3m, git, haskellPackages, universal-ctags, man-pages
}:

let

  ctags_config = runCommand "ctags_config" {} ''
    mkdir -p $out/etc/ctags.d
    cat > $out/etc/ctags.d/markdown.ctags << EOF
    --langdef=markdown
    --langmap=markdown:.md
    --regex-markdown=/^#[ \t]+(.*)/\1/h,Heading_L1/
    --regex-markdown=/^##[ \t]+(.*)/\1/i,Heading_L2/
    --regex-markdown=/^###[ \t]+(.*)/\1/k,Heading_L3/
    EOF
    cat > $out/etc/ctags.d/make.ctags << EOF
    --regex-make=/^([^# \t]*):/\1/t,target/
    EOF
  '';

  vim_configured = vim_configurable.customize {
    name = "vim";
    vimrcConfig = {
      customRC = ''
        """ Base Config
        """""""""""""""

        colo elflord
        syn on

        set bs=2 nocompatible laststatus=2 t_Co=256
        set tabstop=4 shiftwidth=4 expandtab
        set wildmode=longest,full wildmenu
        set number
        set mouse=a
        
        filetype plugin indent on
        set autoindent

        " This is janky, but without it, vim-haskellFold only works on buffers
        " after the first.
        autocmd BufNewFile,BufRead *.hs,*.hsc,*.lhs edit %
        autocmd BufNewFile,BufRead *.hs,*.hsc,*.lhs setlocal filetype=haskell

        " Also janky. Should find a better way to do this. Enable .aadl
        " extension.
        autocmd BufNewFile,BufRead *.aadl,*.aaxl setlocal filetype=aadl

        """ Airline config
        """"""""""""""""""

        let g:airline_theme = "kolor"
        let g:airline_right_sep = ""
        let g:airline_left_sep = ""
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tagbar#enabled = 0

        """ W3m config
        """"""""""""""

        let g:w3m#hover_delay_time = 10
        let g:w3m#homepage = "https://duckduckgo.com/"
        let g:w3m#search_engine = "https://duckduckgo.com/?q=%s"

        """ Rainbow parens
        """""""""""""""""

        let g:rbpt_max = 32
        let g:rbpt_colorpairs = [
          \ ["brown",   "RoyalBlue3"],
          \ ["blue",    "SeaGreen3"],
          \ ["gray",    "DarkOrchid3"],
          \ ["green",   "firebrick3"],
          \ ["cyan",    "RoyalBlue3"],
          \ ["red",     "SeaGreen3"],
          \ ["magenta", "DarkOrchid3"],
          \ ["brown",   "firebrick3"],
          \ ["gray",    "RoyalBlue3"],
          \ ["red",     "DarkOrchid3"],
          \ ["green",   "RoyalBlue3"],
          \ ["brown",   "SeaGreen3"],
          \ ["magenta", "DarkOrchid3"],
          \ ["blue",    "firebrick3"],
          \ ["cyan",    "SeaGreen3"],
          \ ["red",     "firebrick3"],
          \ ]
        au VimEnter * RainbowParenthesesToggle
        au VimEnter * RainbowParenthesesLoadRound
        au VimEnter * RainbowParenthesesLoadSquare
        au VimEnter * RainbowParenthesesLoadBraces

        """ Vim addon nix
        """""""""""""""""
        
        let g:nix_maintainer="protob3n"

        """ Signify config
        """"""""""""""""""

        highlight SignColumn cterm=none ctermbg=0
        highlight LineNR     cterm=none ctermbg=0 ctermfg=56

        """ Tagbar config
        """""""""""""""""

        let g:tagbar_type_haskell = {
          \ "ctagsbin"  : "hasktags",
          \ "ctagsargs" : "-x -c -o-",
          \ "kinds"     : [
            \  "m:modules:0:1",
            \  "d:data: 0:1",
            \  "d_gadt: data gadt:0:1",
            \  "t:type names:0:1",
            \  "nt:new types:0:1",
            \  "c:classes:0:1",
            \  "cons:constructors:1:1",
            \  "c_gadt:constructor gadt:1:1",
            \  "c_a:constructor accessors:1:1",
            \  "ft:function types:0:1",
            \  "fi:function implementations:1:1",
            \  "o:others:0:1"
          \ ],
          \ "sro"        : ".",
          \ "kind2scope" : {
            \ "m" : "module",
            \ "c" : "class",
            \ "d" : "data",
            \ "t" : "type"
          \ },
          \ "scope2kind" : {
            \ "module" : "m",
            \ "class"  : "c",
            \ "data"   : "d",
            \ "type"   : "t"
          \ }
        \ }
        let g:tagbar_type_markdown = {
          \ "ctagstype" : "markdown",
          \ "kinds" : [
            \ "h:Heading_L1",
            \ "i:Heading_L2",
            \ "k:Heading_L3"
          \ ]
        \ }
        let g:tagbar_type_make = {
          \ "kinds":[
            \ "m:macros",
            \ "t:targets"
          \ ]
        \ }
        let g:tagbar_map_showproto = "<Tab>"
        let g:tagbar_compact = 1
        let g:tagbar_autofocus = 1

        """ Hoogle
        """"""""""

        let g:hoogle_search_count = 1000

        """ Haskell-Vim
        """""""""""""""

        "let g:haskell_indent_disable = 1
        let g:haskell_indent_if               = 4
        let g:haskell_indent_case             = 4
        let g:haskell_indent_let              = 4
        let g:haskell_indent_where            = 6
        let g:haskell_indent_before_where     = 0
        let g:haskell_indent_after_bare_where = 0
        let g:haskell_indent_in               = 1
        let g:haskell_indent_guard            = 4
        let g:cabal_indent_section            = 4

        """ Keymaps
        """""""""""

        let mapleader=" "

        noremap  <silent> <Leader>j <C-W>h
        noremap  <silent> <Leader>k <C-W>j
        noremap  <silent> <Leader>l <C-W>k
        noremap  <silent> <Leader>; <C-W>l
        noremap  <silent> <Leader>J <C-W>H
        noremap  <silent> <Leader>K <C-W>J
        noremap  <silent> <Leader>L <C-W>K
        noremap  <silent> <Leader>: <C-W>L
        
        noremap  <silent> <Leader>y gT
        noremap  <silent> <Leader>u gt
        
        noremap  <silent> <Leader>by :bprev<CR>
        noremap  <silent> <Leader>bu :bnext<CR>
        noremap  <silent> <Leader>bl :ls<CR>
        noremap  <silent> <Leader>bq :bw<CR>

        vnoremap <silent> <Leader>s  :sort<CR>
        
        " Plugin key mappings
        noremap  <silent> <Leader>w  :ShowWhiteToggle<CR>
        noremap  <silent> <Leader>m  :exe "Man " . expand("<cword>")<CR>
        noremap  <silent> K          :exe "Man " . expand("<cword>")<CR>
        noremap  <silent> <Leader>M  :exe "Vman " . expand("<cword>")<CR>
        noremap  <silent> <Leader>op :W3mSplit <C-R><C-F><CR>
        noremap  <silent> <Leader>oo :W3mVSplit <C-R><C-F><CR>
        nnoremap <silent> <Leader>.  :call unicoder#start(0)<CR>
        inoremap <silent> <C-l>      <Esc>:call unicoder#start(1)<CR>
        vnoremap <silent> <Leader>.  :<C-u>call unicoder#selection()<CR>
        noremap  <silent> <Leader>pp :TagbarOpen fjc<CR>
        noremap  <silent> <Leader>po :TagbarToggle<CR>
        noremap  <silent> <Leader>hh :exe "Hoogle " . expand("<cword>")<CR>
        noremap  <silent> <Leader>hi :exe "HoogleInfo " . expand("<cword>")<CR>
        vnoremap <silent> HH         :exe "Hoogle " . expand("<cword>")<CR>
        vnoremap <silent> HI         :exe "HoogleInfo " . expand("<cword>")<CR>
        noremap  <silent> <Leader>hc :HoogleClose<CR>
        noremap  <silent> j          h
        noremap  <silent> k          j
        noremap  <silent> l          k
        noremap  <silent> ;          l

        " Some dork seems to have imapped <Leader>aj and <Leader>al in the
        " Ada ftplugin. Remove these.
        autocmd BufNewFile,BufRead *.adb,*.ads,*gpr iunmap <buffer> <Leader>aj
        autocmd BufNewFile,BufRead *.adb,*.ads,*gpr iunmap <buffer> <Leader>al
      '';

      vam = {
        knownPlugins = vimPlugins // {
          w3m = vimUtils.buildVimPlugin {
            name = "w3m";
            src = fetchFromGitHub {
              owner = "yuratomo";
              repo = "w3m.vim";
              rev = "228a852b188f1a62ecea55fa48b0ec892fa6bad7";
              sha256 = "0c06yipsm0a1sxdlhnf41lifhzgimybra95v8638ngmr8iv5dznf";
            };
          };
          vim-man = vimUtils.buildVimPlugin {
            name = "vim-man";
            src = fetchFromGitHub {
              owner = "vim-utils";
              repo = "vim-man";
              rev = "cfdc78f52707b4df76cbe57552a7c8c28a390da4";
              sha256 = "1c5g8m77nhxwzdq2fq23s9zy3yyg9mka9056nkqwxna8gl90y3mx";
            };
          };
          vim-haskellFold = vimUtils.buildVimPlugin {
            name = "vim-haskellFold";
            src = fetchFromGitHub {
              owner = "Twinside";
              repo = "vim-haskellFold";
              rev = "6f32264b572821846141c020f28076d745872433";
              sha256 = "19nnk0g5v99sljrkzqd60d1di9ls0fyfw3db1djwaqlprl7zig1q";
            };
          };
          latex-unicoder = vimUtils.buildVimPlugin {
            name = "latex-unicoder";
            src = fetchFromGitHub {
              owner = "joom";
              repo = "latex-unicoder.vim";
              rev = "46c1ccaec312e4d556c45c71b4de8025ff288f48";
              sha256 = "03a16ysy7fy8if6kwkgf2w4ja97bqmg3yk7h1jlssz37b385hl2d";
            };
          };
          cryptol = vimUtils.buildVimPlugin {
            name = "cryptol";
            src = fetchFromGitHub {
              owner = "victoredwardocallaghan";
              repo = "cryptol.vim";
              rev = "15040e77c8256c9d7a8824fd95804836121ed46a";
              sha256 = "0iv8s2z7xap4mj2ad3dq67h629j2bn8zvch32azn3l0q4cppmnw8";
            };
          };
          aadl-syntax = vimUtils.buildVimPlugin {
            name = "aadl-syntax";
            preInstall = "cd share/vim";
            src = fetchFromGitHub {
              owner = "OpenAADL";
              repo = "AADLib";
              rev = "v2017.1";
              sha256 = "15gicvdpvmgbzzgld037z35g373r4l6l8kpzfmavd5bl3rlq9z7s";
            };
          };
        };

        pluginDictionaries = [
          { names = [ "rainbow_parentheses" ]; }
          { names = [ "w3m" ]; }
          { names = [ "vim-man" ]; }
          { names = [ "latex-unicoder" ]; }
          { names = [ "airline" "vim-airline-themes" ]; }
          { names = [ "vim-signify" "fugitive" ]; }
          { names = [ "vim-addon-nix" "vim-nix" ]; ft_regex = "^nix\$"; }
          { names = [ "vim-haskellFold" "vim-hoogle" "haskell-vim" ]; ft_regex = "^haskell\$"; }
          { names = [ "cryptol" ]; }
          { names = [ "Tagbar" ]; ft_regex = "^\\(haskell\\|c\\|cpp\\|markdown\\|make\\)\$"; }
          { names = [ "aadl-syntax" ]; ft_regex = "^aadl$"; }
          { names = [ "rust-vim" ]; ft_regex = "^rs$"; }
        ];
      };
    };
  };

in buildEnv {
  name = "protovim";
  paths = [
    w3m
    git
    haskellPackages.hasktags
    haskellPackages.hoogle
    universal-ctags
    man-pages

    ctags_config
    vim_configured
  ];
}
