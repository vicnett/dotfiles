" Vimrc
"
" This file contains the minimal settings to set the foundation, with the
" majority of the configuration and settings living in files spread between
" vim/rcfiles and vim/rcplugins

set nocompatible

" Need to set the leader before defining any leader mappings
let mapleader = "\<Space>"

function! s:SourceConfigFilesIn(directory)
  let directory_splat = a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfunction

call plug#begin('~/.vim/bundle')
call s:SourceConfigFilesIn('~/.dotfiles/vim/rcplugins')
call s:SourceConfigFilesIn('~/.vimrc.d/rcplugins')
call plug#end()

call s:SourceConfigFilesIn('~/.dotfiles/vim/rcfiles')
call s:SourceConfigFilesIn('~/.vimrc.d/rcfiles')
