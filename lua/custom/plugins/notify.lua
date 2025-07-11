return {
  {
    'rcarriga/nvim-notify',
    -- @type nofiy.Config
    opt = {
      background_colour = '#000000',
    },
    config = function()
      vim.cmd [[
		hi NotifyBackground guibg = #000000
	  ]]
      vim.notify = require 'notify'
    end,
  },
}
