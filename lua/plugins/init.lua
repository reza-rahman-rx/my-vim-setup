return {
  -- ============================================================
  -- UI & Icons
  -- ============================================================
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
      })
      vim.cmd.colorscheme('catppuccin')
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_c = {
            { 'filename', path = 1 }, -- 1 = relative path, 2 = absolute path
          },
        },
      })
    end,
  },

  -- Buffer tabs
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          diagnostics = 'nvim_lsp',
          offsets = {
            { filetype = 'NvimTree', text = 'File Explorer', highlight = 'Directory' },
          },
        },
      })
      vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
      vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })
      vim.keymap.set('n', '<leader>x', ':bp | bd #<CR>', { silent = true, desc = 'Close current buffer' })
      vim.keymap.set('n', '<leader>X', ':BufferLineCloseOthers<CR>', { silent = true, desc = 'Close all other buffers' })
    end,
  },

  -- ============================================================
  -- Navigation
  -- ============================================================

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          preview = { treesitter = false },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
      vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Grep word under cursor' })
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require('nvim-tree').setup({
        view = { width = 30 },
        filters = { dotfiles = false, git_ignored = false },
      })
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true, desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>E', ':NvimTreeFocus<CR>', { silent = true, desc = 'Focus file explorer' })
    end,
  },

  -- ============================================================
  -- Formatting
  -- ============================================================

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format({ async = true, lsp_fallback = true }) end,
        desc = 'Format file',
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd', 'eslint_d' },
        typescript = { 'prettierd', 'eslint_d' },
        vue = { 'prettierd', 'eslint_d' },
        javascriptreact = { 'prettierd', 'eslint_d' },
        typescriptreact = { 'prettierd', 'eslint_d' },
        lua = { 'stylua' },
        python = { 'black' },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    },
  },

  -- ============================================================
  -- LSP & Completion
  -- ============================================================

  -- LSP server installer
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  -- Bridge mason <-> lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'ts_ls', 'lua_ls', 'pyright' },
        automatic_installation = true,
      })
    end,
  },

  -- LSP configs
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim', 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- LSP keymaps via LspAttach autocmd
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          -- <leader>f is handled by conform.nvim
        end,
      })

      -- Setup servers using vim.lsp.config (Nvim 0.11+ API)
      local servers = { 'ts_ls', 'pyright' }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      -- Lua LS with Neovim-specific settings
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.enable({ 'ts_ls', 'pyright', 'lua_ls' })
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- ============================================================
  -- Syntax & Editing
  -- ============================================================

  -- Treesitter (syntax highlighting, text objects)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      vim.env.CC = 'cc' -- use system clang, not homebrew llvm
      require('nvim-treesitter').setup({
        ensure_installed = {
          'lua', 'javascript', 'typescript', 'tsx', 'python',
          'json', 'html', 'css', 'markdown', 'bash', 'vim', 'vimdoc',
        },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      })

      -- Treesitter text objects
      require('nvim-treesitter-textobjects').setup()

      -- Helper: only run treesitter action if parser exists for current buffer
      local function ts_safe(fn)
        return function()
          local ok = pcall(vim.treesitter.get_parser)
          if ok then fn() end
        end
      end

      -- Select text objects (visual/operator-pending)
      vim.keymap.set({ 'x', 'o' }, 'af', ts_safe(function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer') end), { desc = 'Select outer function' })
      vim.keymap.set({ 'x', 'o' }, 'if', ts_safe(function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner') end), { desc = 'Select inner function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', ts_safe(function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer') end), { desc = 'Select outer class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', ts_safe(function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner') end), { desc = 'Select inner class' })
      vim.keymap.set({ 'x', 'o' }, 'ab', ts_safe(function() require('nvim-treesitter-textobjects.select').select_textobject('@block.outer') end), { desc = 'Select outer block' })
      vim.keymap.set({ 'x', 'o' }, 'ib', ts_safe(function() require('nvim-treesitter-textobjects.select').select_textobject('@block.inner') end), { desc = 'Select inner block' })

      -- Move between functions/classes
      vim.keymap.set({ 'n', 'x', 'o' }, ']f', ts_safe(function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer') end), { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']F', ts_safe(function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer') end), { desc = 'Next function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[f', ts_safe(function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer') end), { desc = 'Previous function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[F', ts_safe(function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer') end), { desc = 'Previous function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']c', ts_safe(function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer') end), { desc = 'Next class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[c', ts_safe(function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer') end), { desc = 'Previous class start' })
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('ibl').setup({
        exclude = {
          filetypes = { 'help', 'lazy', 'mason', 'NvimTree' },
        },
        scope = { enabled = false },
      })
    end,
  },

  -- Auto-close brackets/quotes
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },

  -- Toggle comments
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('Comment').setup()
    end,
  },

  -- Surround text objects
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end,
  },

  -- ============================================================
  -- Markdown
  -- ============================================================

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown' },
    opts = {},
    config = function(_, opts)
      require('render-markdown').setup(opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function(args)
          vim.keymap.set('n', '<leader>mp', ':RenderMarkdown toggle<CR>',
            { buffer = args.buf, silent = true, desc = 'Toggle markdown preview' })
        end,
      })
    end,
  },

  -- ============================================================
  -- Git
  -- ============================================================

  -- Git signs in gutter
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
      })
      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { silent = true })
    end,
  },

  -- Full Git wrapper
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gvdiffsplit', 'Glog' },
  },

  -- Merge conflict resolution
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('git-conflict').setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = false,
        list_opener = 'copen',
        highlights = {
          incoming = 'DiffAdd',
          current = 'DiffText',
        },
      })
    end,
  },
}
