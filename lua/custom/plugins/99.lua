return {
  'ThePrimeagen/99',
  dependencies = {
    { 'saghen/blink.compat', version = '2.*' },
  },
  config = function()
    local _99 = require '99'

    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    _99.setup {
      provider = _99.Providers.OpenCodeProvider,
      model = 'mistral/codestral-latest',
      tmp_dir = './tmp',
      completion = {
        custom_rules = {
          'scratch/custom_rules/',
        },

        source = 'blink',
      },
      md_files = {
        'AGENT.md',
      },
    }

    require('which-key').add { { '<leader>9', group = '+99 AI', mode = 'n' } }
    vim.keymap.set('v', '<leader>9', _99.visual, { desc = 'visual selection with prompt' })
    vim.keymap.set('n', '<leader>9x', _99.stop_all_requests, { desc = 'stop all requests' })
    vim.keymap.set('n', '<leader>9s', _99.search, { desc = 'search' })
    vim.keymap.set('n', '<leader>9p', function()
      require('99.extensions.telescope').select_provider()
    end)
    vim.keymap.set('n', '<leader>9m', function()
      require('99.extensions.telescope').select_model()
    end)
  end,
}
