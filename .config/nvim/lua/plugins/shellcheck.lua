return {
  -- ShellCheck automatisch installeren via Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
      },
    },
  },

  -- ShellCheck integreren met LazyVim
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },

      linters = {
        shellcheck = {
          -- ShellCheck niet uitvoeren op Zsh-scripts
          condition = function(ctx)
            local filename = ctx.filename

            if filename == "" or vim.fn.filereadable(filename) == 0 then
              return false
            end

            local lines = vim.fn.readfile(filename, "", 1)
            local shebang = lines[1] or ""

            -- Alleen Bash, sh, dash en ksh
            return shebang:match("^#!.*[/ ]bash%s*$") ~= nil
              or shebang:match("^#!.*[/ ]sh%s*$") ~= nil
              or shebang:match("^#!.*[/ ]dash%s*$") ~= nil
              or shebang:match("^#!.*[/ ]ksh%s*$") ~= nil
          end,
        },
      },
    },
  },
}
