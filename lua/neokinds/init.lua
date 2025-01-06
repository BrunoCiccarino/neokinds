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
    Field = "",
    Variable = " ",
    Class = "󰠱 ",
    Interface = " ",
    Module = " ",
    Property = "󰜢 ",
    Unit = " ",
    Value = " ",
    Enum = "練",
    Keyword = "󰌋",
    Snippet = "",
    Color = " ",
    File = " ",
    Reference = " ",
    Folder = " ",
    EnumMember = " ",
    Constant = "ﲀ ",
    Struct = "ﳤ ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
    Boolean = " ",
    Array = " ",
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
  local blink_cmp_ok, blink_cmp = pcall(require, "blink-cmp")

  if blink_cmp_ok and blink_cmp.setup then

    local success = pcall(function()
      blink_cmp.setup({

        completion = {
          completeopt = "menu,menuone,preview,noinsert", 
        },
      })
    end)

    if not success then
      vim.notify("blink-cmp setup failed. Please check configuration.", vim.log.levels.WARN)
    end
  elseif cmp_ok then
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
