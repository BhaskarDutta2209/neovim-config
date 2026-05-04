return {
  'tpope/vim-fugitive',
  keys = {
    { '<leader>G', ':Gvdiffsplit!<CR>', desc = 'Open vertical merge window' },

    -- Run these from the MIDDLE buffer during a merge
    { '<leader>gj', ':diffget //3<CR>', desc = 'Get change from RIGHT (theirs)' },
    { '<leader>gf', ':diffget //2<CR>', desc = 'Get change from LEFT (ours)' },

    -- Navigation
    { ']c', ']c', desc = 'Next diff hunk' },
    { '[c', '[c', desc = 'Prev diff hunk' },
  },
}
