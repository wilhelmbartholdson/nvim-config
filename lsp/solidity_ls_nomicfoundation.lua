return {
  cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  filetypes = { "solidity" },
  root_markers = {
    "hardhat.config.js",
    "hardhat.config.ts",
    "foundry.toml",
    "truffle.js",
    "truffle-config.js",
    "ape-config.yaml",
    ".git",
    "package.json"
  }
}
