local M = {}

M.setup = function()
  vim.opt.expandtab = true -- convert tab to spaces
  vim.opt.tabstop = 2 -- Insert 2 space for a tab
  vim.opt.shiftwidth = 2 -- Change the number of spaces inserted for indentation
  vim.opt.softtabstop = 2 -- Make the space feel like a real tab when deleting
end

return M
