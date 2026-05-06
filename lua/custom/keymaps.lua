local M = {}

M.setup = function()
  -- Modified/unsaved buffers
  vim.keymap.set('n', '<leader>sm', function()
    local builtin = require 'telescope.builtin'

    local modified = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].modified and vim.api.nvim_buf_get_name(buf) ~= '' then table.insert(modified, buf) end
    end

    if #modified == 0 then
      vim.notify('No unsaved changes', vim.log.levels.INFO)
      return
    end

    builtin.buffers {
      predicate = function(buf) return vim.bo[buf].modified end,
    }
  end, { desc = '[S]earch [M]odified buffers' })

  -- Add more custom keymaps below...
end

return M
