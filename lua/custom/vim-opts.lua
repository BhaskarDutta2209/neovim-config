local M = {}

M.setup = function()
  vim.opt.expandtab = true -- convert tab to spaces
  vim.opt.tabstop = 4 -- Insert 2 space for a tab
  vim.opt.shiftwidth = 4 -- Change the number of spaces inserted for indentation
  vim.opt.softtabstop = 4 -- Make the space feel like a real tab when deleting
end

return M
