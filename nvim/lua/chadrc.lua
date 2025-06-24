local lazy = require "lazy"
-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",
  transparency = true,

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    -- "                            ",
    -- "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
    -- "   ▄▀███▄     ▄██ █████▀    ",
    -- "   ██▄▀███▄   ███           ",
    -- "   ███  ▀███▄ ███           ",
    -- "   ███    ▀██ ███           ",
    -- "   ███      ▀ ███           ",
    -- "   ▀██ █████▄▀█▀▄██████▄    ",
    -- "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    -- "                            ",
    -- "     Powered By  eovim    ",
    -- "                            ",
  --   " ██████╗ ██╗  ██╗██╗ ██████╗     ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
  --   "██╔═══██╗██║  ██║██║██╔═══██╗    ████╗  ██║██║   ██║██║████╗ ████║",
  --   "██║   ██║███████║██║██║   ██║    ██╔██╗ ██║██║   ██║██║██╔████╔██║",
  --   "██║   ██║██╔══██║██║██║   ██║    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  --   "╚██████╔╝██║  ██║██║╚██████╔╝    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
  --   " ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝     ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
  --   "                                                                  ",
  --   "                          vision111                               ",
    "██╗   ██╗██╗███████╗██╗ ██████╗ ███╗   ██╗ ██╗ ██╗ ██╗",
    "██║   ██║██║██╔════╝██║██╔═══██╗████╗  ██║███║███║███║",
    "██║   ██║██║███████╗██║██║   ██║██╔██╗ ██║╚██║╚██║╚██║",
    "╚██╗ ██╔╝██║╚════██║██║██║   ██║██║╚██╗██║ ██║ ██║ ██║",
    " ╚████╔╝ ██║███████║██║╚██████╔╝██║ ╚████║ ██║ ██║ ██║",
    "  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═╝ ╚═╝ ╚═╝",
    "                                                      ",
    "                                                      ",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },

}

M.term = {
  base46_colors = true,
  winopts = {
    number = true,
    relativenumber = false
  },
  sizes = {
    sp = 0.35,
    vsp = 0.45,
    ["bo sp"] = 0.3,
    ["bo vsp"] = 0.2
  },
  float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
  },
}

M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
}

M.lsp = {
  signature = true,
}

M.ui = {
  cmp = {
    icons_left = true,
    style = "atom_colored",
    abbr_maxwidth = 45,
    format_colors = { lsp = true, icon = "󱓻" },
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  statusline = {
    enabled = true,
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "block",
    -- order = nil,
    order = { "mode", "file", "git", "%=", "diagnostics", "lsp", "cwd",  "cursor" },
    modules = nil,
  },

  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
    bufwidth = 21,
  },
}

return M
