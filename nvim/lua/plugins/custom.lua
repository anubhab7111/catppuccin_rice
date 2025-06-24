return {
  {
  "neovim/nvim-lspconfig",
   config = function()
      require "configs.lspconfig"
   end,
  },
  { "folke/which-key.nvim",  enabled = false }, -- disable a default nvchad plugin

  -- this opts will extend the default opts 
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = {"html", "css", "bash"} },
  },

  -- If your opts uses a function call ex: require*, then make opts spec a function
  -- Then modify the opts arg
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, conf)
      conf.defaults.mappings.i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<Esc>"] = require("telescope.actions").close,
      }

     -- or 
     -- table.insert(conf.defaults.mappings.i, your table)
      return conf
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        hijack_cursor = true,
        disable_netrw = true,
        view = {
          cursorline = false,
          side = "left",
          number = true,
        },
        renderer = {
          hidden_display = "simple",
          highlight_git = "none",
        },
        git = {
          enable = false,
        },
      }
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    -- -@type ibl.config
    opts = {},
  },
  {
    "CRAG666/code_runner.nvim",
    config = true,
    lazy=false
  },
  {
    "CRAG666/betterTerm.nvim",
    lazy = false,
    opts = {
      position = 'vertical',
      size = 85,
      -- position = 'bot',
      -- size = 25,
      jump_tab_mapping = "<A-$tab>",
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      -- Load VSCode-style snippets (from friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Load your own Lua snippets
      require("luasnip.loaders.from_lua").lazy_load({
        paths = "~/.config/nvim/lua/snippets"
      })
    end,
  }
}
