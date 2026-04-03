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
end

vim.lsp.config('gdscript', {})

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
  callback = function()
    local ev = vim.api.nvim_get_vvar 'event'
    if ev.status == 0 then
      vim.cmd 'close'
    end
  end,
})

vim.keymap.set('n', '<space>st', function()
  vim.cmd.split 'term://fish'
  vim.api.nvim_win_set_height(0, 20)
end)

local is_rust_project = vim.uv.fs_stat(cwd .. '/Cargo.toml')
if is_rust_project then
  vim.keymap.set('n', '<space>Cr', function()
    vim.cmd.split 'term://cargo run'
  end, { desc = 'Cargo Run' })
end

return {
  {
    'nomnivore/ollama.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },

    -- All the user commands added by the plugin
    cmd = { 'Ollama', 'OllamaModel', 'OllamaServe', 'OllamaServeStop' },

    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        '<leader>oo',
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = 'ollama prompt',
        mode = { 'n', 'v' },
      },

      -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      {
        '<leader>oG',
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = 'ollama Generate Code',
        mode = { 'n', 'v' },
      },
    },

    ---@type Ollama.Config
    opts = {
      model = 'dolphin-mistral',
      url = 'http://ubuntu.local:11434',
    },
  },
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
    'echasnovski/mini.animate',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('mini.animate').setup()
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
