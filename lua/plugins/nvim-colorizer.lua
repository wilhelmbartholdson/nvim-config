return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  enabled = false,
  opts = {
    tailwind = true,
    sass = { enable = false },
    virtualtext_inline = 'after',
    names_opts = {
      lowercase = true,
      camelcase = true,
      uppercase = true,
      strip_digits = true,
    }
  },
}
