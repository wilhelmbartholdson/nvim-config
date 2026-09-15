return {
    cmd          = { "sql-language-server", "up", "--method", "stdio" },
    filetypes    = { "sql", "mysql" },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
        ".sqllsrc.json"
    },
    settings     = {}
}
