-- local M = {}
-- local merge_tb = vim.tbl_deep_extend
--
-- M.load_config = function()
--   local config = require "core.default_config"
--   local chadrc_path = vim.api.nvim_get_runtime_file("lua/custom/chadrc.lua", false)[1]
--
--   if chadrc_path then
--     local chadrc = dofile(chadrc_path)
--
--     config.mappings = M.remove_disabled_keys(chadrc.mappings, config.mappings)
--     config = merge_tb("force", config, chadrc)
--     config.mappings.disabled = nil
--   end
--
--   return config
-- end
--
-- M.remove_disabled_keys = function(chadrc_mappings, default_mappings)
--   if not chadrc_mappings then
--     return default_mappings
--   end
--
--   -- store keys in a array with true value to compare
--   local keys_to_disable = {}
--   for _, mappings in pairs(chadrc_mappings) do
--     for mode, section_keys in pairs(mappings) do
--       if not keys_to_disable[mode] then
--         keys_to_disable[mode] = {}
--       end
--       section_keys = (type(section_keys) == "table" and section_keys) or {}
--       for k, _ in pairs(section_keys) do
--         keys_to_disable[mode][k] = true
--       end
--     end
--   end
--
--   -- make a copy as we need to modify default_mappings
--   for section_name, section_mappings in pairs(default_mappings) do
--     for mode, mode_mappings in pairs(section_mappings) do
--       mode_mappings = (type(mode_mappings) == "table" and mode_mappings) or {}
--       for k, _ in pairs(mode_mappings) do
--         -- if key if found then remove from default_mappings
--         if keys_to_disable[mode] and keys_to_disable[mode][k] then
--           default_mappings[section_name][mode][k] = nil
--         end
--       end
--     end
--   end
--
--   return default_mappings
-- end
--
-- M.load_mappings = function(section, mapping_opt)
--   vim.schedule(function()
--     local function set_section_map(section_values)
--       if section_values.plugin then
--         return
--       end
--
--       section_values.plugin = nil
--
--       for mode, mode_values in pairs(section_values) do
--         local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
--         for keybind, mapping_info in pairs(mode_values) do
--           -- merge default + user opts
--           local opts = merge_tb("force", default_opts, mapping_info.opts or {})
--
--           mapping_info.opts, opts.mode = nil, nil
--           opts.desc = mapping_info[2]
--
--           vim.keymap.set(mode, keybind, mapping_info[1], opts)
--         end
--       end
--     end
--
--     local mappings = require("core.utils").load_config().mappings
--
--     if type(section) == "string" then
--       mappings[section]["plugin"] = nil
--       mappings = { mappings[section] }
--     end
--
--     for _, sect in pairs(mappings) do
--       set_section_map(sect)
--     end
--   end)
-- end
--
-- M.lazy_load = function(plugin)
--   vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
--     group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
--     callback = function()
--       local file = vim.fn.expand "%"
--       local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""
--
--       if condition then
--         vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)
--
--         -- dont defer for treesitter as it will show slow highlighting
--         -- This deferring only happens only when we do "nvim filename"
--         if plugin ~= "nvim-treesitter" then
--           vim.schedule(function()
--             require("lazy").load { plugins = plugin }
--
--             if plugin == "nvim-lspconfig" then
--               vim.cmd "silent! do FileType"
--             end
--           end, 0)
--         else
--           require("lazy").load { plugins = plugin }
--         end
--       end
--     end,
--   })
-- end
--
-- return M


local M = {}
local merge_tb = vim.tbl_deep_extend or function(_, ...)
  local result = {}
  for i = 1, select('#', ...) do
    local tbl = select(i, ...)
    if tbl then
      for k, v in pairs(tbl) do
        result[k] = v
      end
    end
  end
  return result
end

M.load_config = function()
  local config = require "core.default_config"
  local chadrc_files = vim.api.nvim_get_runtime_file("lua/custom/chadrc.lua", false)
  local chadrc_path = chadrc_files and chadrc_files[1]

  if chadrc_path then
    local ok, chadrc = pcall(dofile, chadrc_path)
    if ok and chadrc then
      config.mappings = M.remove_disabled_keys(chadrc.mappings, config.mappings)
      config = merge_tb("force", config, chadrc)
      config.mappings.disabled = nil
    end
  end

  return config
end

M.remove_disabled_keys = function(chadrc_mappings, default_mappings)
  if not chadrc_mappings or not default_mappings then
    return default_mappings or {}
  end

  local keys_to_disable = {}
  for _, mappings in pairs(chadrc_mappings) do
    if type(mappings) == "table" then
      for mode, section_keys in pairs(mappings) do
        keys_to_disable[mode] = keys_to_disable[mode] or {}
        section_keys = (type(section_keys) == "table" and section_keys) or {}
        for k, _ in pairs(section_keys) do
          keys_to_disable[mode][k] = true
        end
      end
    end
  end

  local result = vim.deepcopy(default_mappings)
  for section_name, section_mappings in pairs(result) do
    if type(section_mappings) == "table" then
      for mode, mode_mappings in pairs(section_mappings) do
        mode_mappings = (type(mode_mappings) == "table" and mode_mappings) or {}
        for k, _ in pairs(mode_mappings) do
          if keys_to_disable[mode] and keys_to_disable[mode][k] then
            result[section_name][mode][k] = nil
          end
        end
      end
    end
  end

  return result
end

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    local function set_section_map(section_values)
      if not section_values or section_values.plugin then
        return
      end

      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        if type(mode_values) == "table" then
          local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
          for keybind, mapping_info in pairs(mode_values) do
            if type(mapping_info) == "table" then
              local opts = merge_tb("force", default_opts, mapping_info.opts or {})
              mapping_info.opts, opts.mode = nil, nil
              opts.desc = mapping_info[2]
              vim.keymap.set(mode, keybind, mapping_info[1], opts)
            end
          end
        end
      end
    end

    local config = M.load_config()
    local mappings = config and config.mappings or {}

    if type(section) == "string" then
      if mappings[section] then
        mappings[section]["plugin"] = nil
        mappings = { mappings[section] }
      else
        mappings = {}
      end
    end

    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load { plugins = plugin }
            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end)
        else
          require("lazy").load { plugins = plugin }
        end
      end
    end,
  })
end

return M
