-- [[ plug.lua ]]

return require('packer').startup(function()
  -- Packer
  use 'wbthomason/packer.nvim'

  -- UI
  use { 
    'rmehri01/onenord.nvim',
    config = function() require('onenord').setup() end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = { theme = 'onenord' }
      }
    end
  }
  use {
    'folke/which-key.nvim',
    config = function() require('which-key').setup() end
  }
  use {
    'akinsho/bufferline.nvim',
    config = function() require('bufferline').setup() end
  }
  use 'jeffkreeftmeijer/vim-numbertoggle'
  use 'ryanoasis/vim-devicons'

  -- Syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = { 
      'p00f/nvim-ts-rainbow'
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        rainbow = { enable = true }
      }
    end
  }

  -- Utilities
  use {
    'preservim/nerdtree',
    config = function()
      vim.g["NERDTreeWinSize"] = 42
    end
  }
  use { 
    'nvim-telescope/telescope-fzf-native.nvim', 
    run = 'make' 
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case"
          }
        }
      }
      require('telescope').load_extension('fzf')
    end
  }
  use 'Xuyuanp/nerdtree-git-plugin'

  -- Git
  use { 
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use 'tpope/vim-fugitive'

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      'dcampos/nvim-snippy',
      'dcampos/cmp-snippy',
    },
    config = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      local cmp = require('cmp')
      local snippy = require('snippy')

      cmp.setup({
        snippet = { expand = function(args) snippy.expand_snippet(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>']    = cmp.mapping.scroll_docs(-4),
          ['<C-f>']    = cmp.mapping.scroll_docs(4),
          ['<C-Space'] = cmp.mapping.complete(),
          ['<C-q>']    = cmp.mapping.close(),
          ['<Tab>']    = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>']  = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
              snippy.previous()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>']     = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'snippy' },
          { name = 'buffer' }
        })
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'buffer' }}
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{ name = path }}, {{ name = cmdline }})
      })
    end
  }
  use {
    'folke/trouble.nvim',
    config = function() require('trouble').setup {} end
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
      require('lspconfig').clangd.setup {
        capabilities = capabilities,
        on_attach    = function(client, bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {})
        end
      }
    end
  }

  -- General Code Editing
  use {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup() end
  }
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Markdown
  use {
    'davidgranstrom/nvim-markdown-preview',
    config = function()
      vim.g['nvim_markdown_preview_format'] = 'gfm'
      vim.g['nvim_markdown_preview_theme'] = 'github'
    end
  }
  
  -- C and C++
  use 'rhysd/vim-clang-format'
end)
