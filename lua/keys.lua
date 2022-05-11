-- [[ keys.lua ]]
local map = vim.api.nvim_set_keymap

map('n', '<C-t>', [[:NERDTreeToggle<CR>]], {})

map('n', '<Space>cf', [[:ClangFormat<CR>]], {})
map('v', '<Space>cf', [[:ClangFormat<CR>]], {})

map('n', '<Space>ff', [[:lua require 'telescope.builtin'.find_files {} <CR>]], {})
map('n', '<Space>gf', [[:lua require 'telescope.builtin'.git_files  {} <CR>]], {})
map('n', '<Space>lf', [[:lua require 'telescope.builtin'.lsp_document_symbols  {} <CR>]], {})

