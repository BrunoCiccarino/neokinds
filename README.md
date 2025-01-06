# neokinds 🥴 

jetbrains-like pictograms for neovim lsp completion items, make your lsp icons much more attractive.
 
![img](./img/neokind.jpg)

## 🍺 Installation

```lua
{
    "BrunoCiccarino/neokinds",
}
```

## ⚙️  Config -- Opitional

```
    opts = {
        icons = {
            error = "", -- Changing the error icon
            warn = "", -- Keeping the warning icon
        }
    }
```

## 🌐 Compatibility

- nvim-cmp: The plugin adjusts the completion type icon.
- vim-builtin-cmp: Provides basic support by adjusting the completeopt option.
