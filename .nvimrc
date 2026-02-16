let s:dotfiles = expand('<sfile>:p:h')

unmap Y
set clipboard=unnamed

hi clear
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
execute 'source' s:dotfiles . '/.vimrc'

execute 'luafile' s:dotfiles . '/tabby.lua'
let g:airline_section_y = '%{g:tabby_status}'

lua <<END
require("nvim-autopairs").setup {}
if vim.lsp.config then
  vim.lsp.config.ts_ls = {}
  vim.lsp.enable('ts_ls')
end
END

let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'typescript': ['prettier'],
\ 'python': ['black'],
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ }

let g:ale_linters={
\ 'bash': ['shellcheck'],
\ 'javascript': ['eslint'],
\ 'typescript': ['eslint'],
\ 'python': ['pylint'],
\}

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1

lua <<END
vim.diagnostic.config({
  virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 100
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
END
