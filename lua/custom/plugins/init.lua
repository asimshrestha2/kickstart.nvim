-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- paths to check for project.godot file
local paths_to_check = { '/', '/../' }
local is_godot_project = false
local godot_project_path = ''
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for _, value in pairs(paths_to_check) do
  if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
    is_godot_project = true
    godot_project_path = cwd .. value
    break
  end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. '/server.pipe')
-- start server, if not already running
if is_godot_project and not is_server_running then
  vim.fn.serverstart(godot_project_path .. '/server.pipe')
  if vim.fn.maparg('<leader>sf', 'n') ~= '' then
    vim.keymap.del('n', '<leader>sf')
  end
  vim.keymap.set('n', '<leader>sf', function()
    require('telescope.builtin').find_files {
      file_ignore_patterns = { '%.uid$' },
    }
  end, { desc = '[S]earch [F]iles in Godot Project' })
end

vim.lsp.config('gdscript', {})
vim.lsp.enable 'gleam'

-- terminal
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.o.number = false
    vim.o.relativenumber = false
    vim.cmd 'startinsert'
  end,
})

vim.api.nvim_create_autocmd('TermClose', {
  callback = function(evm)
    local ev = vim.api.nvim_get_vvar 'event'
    if ev.status == 0 then
      vim.api.nvim_buf_delete(evm.buf, {})
    end
  end,
})

vim.keymap.set('n', '<space>st', function()
  vim.cmd.vsplit 'term://fish'
end, { desc = 'Split Terminal' })

vim.keymap.set('n', '<space>sb', function()
  vim.cmd.split 'term://fish'
  vim.api.nvim_win_set_height(0, 20)
end, { desc = 'Split Terminal Bottom ' })

local is_rust_project = vim.uv.fs_stat(cwd .. '/Cargo.toml')
if is_rust_project then
  vim.keymap.set('n', '<space>Cr', function()
    vim.cmd.split 'term://cargo run'
  end, { desc = 'Cargo Run' })
end

return {
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'laytan/cloak.nvim',
    opts = {
      cloak_telescope = true,
    },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          -- for godot projects ignore *.uid files
          if is_godot_project then
            -- ignore *.uid files introduced in godot 4.4
            if vim.endswith(name, '.uid') then
              return true
            end
            -- ignore server.pipe file
            if name == 'server.pipe' then
              return true
            end
          else
            return false
          end
        end,
      },
    },
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
