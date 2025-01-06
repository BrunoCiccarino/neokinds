local M = {}

M.default_config = {
    icons = {
        diagnostics = {
            error = "",
            warn = "",
            hint = "",
            info = "",
        },
        folders = {
            closed = "",
            open = "",
            empty = "",
            empty_open = "",
        },
        files = {
            default = "",
            no_extension = "",
            extensions = {
                lua = "",
                js = "",
                json = "",
                html = "",
                css = "",
                md = "",
                py = "",
                ts = "ﯤ",
                java = "",
                c = "",
                cpp = "",
                rb = "",
                go = "",
                rs = "",
                php = "",
                sh = "",
                txt = "",
            },
        },
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
        Constant = " ",
        Struct = "",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
        Boolean = " ",
        Array = " ",
    },
}

M.config = vim.deepcopy(M.default_config)

function M.setup(user_config)
    if user_config and type(user_config) == "table" then
        M.config = vim.tbl_deep_extend("force", M.default_config, user_config)
    end
    M.configure_diagnostics()
    M.configure_cmp()
    M.configure_file_icons()
end

function M.configure_diagnostics()
    local signs = {
        { name = "DiagnosticSignError", text = M.config.icons.diagnostics.error },
        { name = "DiagnosticSignWarn", text = M.config.icons.diagnostics.warn },
        { name = "DiagnosticSignHint", text = M.config.icons.diagnostics.hint },
        { name = "DiagnosticSignInfo", text = M.config.icons.diagnostics.info },
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
        pcall(function()
            blink_cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noinsert",
                },
            })
        end)
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

function M.configure_file_icons()
    vim.g.neo_tree_file_icons = M.config.icons.files.extensions
end

return M

