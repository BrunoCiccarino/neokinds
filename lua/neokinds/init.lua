local M = {}

M.config = {
  icons = {
    error = "",
    warn = "",
    hint = "",
    info = "",
  },
  completion_kinds = {
    Text = " ",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = " ",
    Field = "ﴲ ",
    Variable = " ",
    Class = " ",
    Interface = "ﰮ ",
    Module = " ",
    Property = "ﰠ ",
    Unit = " ",
    Value = " ",
    Enum = "練",
    Keyword = " ",
    Snippet = "",
    Color = " ",
    File = " ",
    Reference = " ",
    Folder = " ",
    EnumMember = " ",
    Constant = "ﲀ ",
    Struct = "ﳤ ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
  },
}

function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
  M.configure_diagnostics()
  M.configure_cmp()
end

function M.configure_diagnostics()
  local signs = {
    { name = "DiagnosticSignError", text = M.config.icons.error },
    { name = "DiagnosticSignWarn", text = M.config.icons.warn },
    { name = "DiagnosticSignHint", text = M.config.icons.hint },
    { name = "DiagnosticSignInfo", text = M.config.icons.info },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      spacing = 2,
    },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      source = "always",
      border = "rounded",
    },
  })
end

function M.configure_cmp()
  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok then
    cmp.setup({
      formatting = {
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s %s", M.config.completion_kinds[vim_item.kind] or "", vim_item.kind)
          return vim_item
        end,
      },
    })
  else
    vim.api.nvim_set_option("completeopt", "menu,menuone,preview,noinsert")
  end
end

return M

