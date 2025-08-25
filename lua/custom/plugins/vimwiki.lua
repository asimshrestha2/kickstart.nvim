return {
  'vimwiki/vimwiki',
  init = function()
    vim.g.vimwiki_list = {
      {
        path = '~/Nextcloud/Notes',
        syntax = 'markdown',
        ext = 'md',
      },
      {
        path = '~/Documents/personal',
        syntax = 'markdown',
        ext = 'md',
      },
    }
  end,
}
