return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',

    config = function ()
        require 'nvim-treesitter'.install {
            "python", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "typescript", "tsx", "html",
            "markdown", "markdown_inline", "latex", "regex", "r", "csv", "yaml", "css"
        }
    end
}
