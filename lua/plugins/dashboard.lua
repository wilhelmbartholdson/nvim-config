return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  enabled = false,
  config = function()
    require('dashboard').setup {
      theme='hyper',
      config={
        -- theme config --

        week_header={ enable=true },

        packages = { enable = true }, -- show how many plugins neovim loaded

        shortcuts = {
          {
            desc = '󰊳 Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u'
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = '§',
          },
          {
            desc = ' Apps',
            group = 'DiagnosticHint',
            action = 'Telescope app',
            key = '2',
          },
          {
            desc = ' dotfiles',
            group = 'Number',
            action = 'Telescope dotfiles',
            key = 'm',
          },
        },

        project = {
          enable = true,
          limit = 8,
          icon = ' ',
          label = 'Project files',
          action = "Telescope find_files"
        },
        -- mru = most recently used (files)
        mru = {
          enable = true,
          limit = 10,
          icon = '󰷉 ',
          label = 'Recent files',
          cwd_only = true
        },
        footer = {}, -- footer 
      },

      shortcut_type='letter',
      change_to_vcs_root=true,
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
