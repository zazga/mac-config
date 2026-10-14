return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                kubernetes = {
                  "**/*deployment*.yaml",
                  "**/*deployment*.yml",
                },
              },
            },
          },
        },
      },
    },
  },
}
