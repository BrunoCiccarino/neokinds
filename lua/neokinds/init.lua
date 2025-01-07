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
            symlink = "",
        },
        files = {
            default = "",
            no_extension = "",
            license = "",
            news = "󰎕",
            readme = "",
            code_of_conduct = "󱃱",
            todo = "󰝖",
            [".bashrc"] = "󰒓",
            extensions = {
                asm = "",
                astro = "",
                angular = "󰚿",
                basic = "󰫯",
                c = "",
                cpp = "󰙲",
                el = "",
                html = "",
                js = "",
                json = "",
                css = "",
                md = "",
                norg = "",
                py = "",
                ts = "",
                java = "",
                lua = "",
                rb = "",
                go = "󰟓",
                gd = "",
                rs = "",
                php = "",
                sh = "",
                txt = "",
                hs = "",
                lisp = "",
                scm = "",
                tailwind = "󱏿",
                svelte = "", 
                jsx = "",
                mod = "",
                sum = "",
                org = "",
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

M.icon = function(config, node, state)
    local icon = config.default or " "
    local padding = config.padding or " "
    local highlight = config.highlight or "NeoTreeFileIcon"

    if node.type == "directory" then
        highlight = "NeoTreeDirectoryIcon"
        if node:is_expanded() then
            icon = config.folder_open or M.config.icons.folders.open
        else
            icon = config.folder_closed or M.config.icons.folders.closed
        end
    elseif node.type == "file" then
        local ext = node.ext or ""  -- Obtemos a extensão do arquivo
        -- Verificação segura se 'extensions' existe dentro de 'files'
        if M.config.icons.files.extensions and M.config.icons.files.extensions[ext] then
            icon = M.config.icons.files.extensions[ext]  -- Icone baseado na extensão
        else
            icon = M.config.icons.files.default  -- Se não encontrar, usa o padrão
        end
    else
        icon = M.config.icons.files.no_extension
    end

    return {
        text = icon .. padding,
        highlight = highlight,
    }
end

function M.setup_lualine()
    local ok, lualine = pcall(require, "lualine")
    if not ok then
        vim.notify("Lualine not found. Please install lualine.", vim.log.levels.ERROR)
        return
    end

    local diagnostics = {
        error = M.config.icons.diagnostics.error,
        warn = M.config.icons.diagnostics.warn,
        info = M.config.icons.diagnostics.info,
        hint = M.config.icons.diagnostics.hint,
    }

    local sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            { "filename", path = 1 },
            { "diagnostics", sources = { "nvim_diagnostic" }, symbols = diagnostics },
        },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    }

    lualine.setup({
        options = {
            theme = "auto",
            section_separators = "",
            component_separators = "",
        },
        sections = sections,
    })
end


function M.configure_file_icons()
    vim.g.neo_tree_file_icons = M.config.icons.files.extensions
end

return M

