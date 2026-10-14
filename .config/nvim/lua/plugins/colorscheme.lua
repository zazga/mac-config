-- Wallpaper theme based on Kitty colors.conf

local p = {
  bg = "#170f1f",
  fg = "#dfaba2",

  purple = "#5D4159",
  muted = "#704553",
  bordeaux = "#8D3749",
  brick = "#8F4F4E",
  red = "#A6494E",
  rose = "#AE6072",

  comment = "#9c7771",
  pink = "#e5b6a9",
  peach = "#e2b98f",
  lavender = "#c58dba",
  dusty_rose = "#d88a90",

  bg_highlight = "#281b30",
}

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",

      on_colors = function(c)
        c.bg = p.bg
        c.bg_dark = p.bg
        c.bg_float = p.bg_highlight
        c.bg_popup = p.bg_highlight
        c.bg_sidebar = p.bg

        c.fg = p.fg
        c.fg_dark = p.comment
        c.fg_gutter = p.muted

        c.bg_highlight = p.bg_highlight
        c.bg_visual = p.purple
        c.bg_search = p.bordeaux

        c.comment = p.comment

        c.blue = p.lavender
        c.cyan = p.pink
        c.green = p.peach
        c.magenta = p.rose
        c.orange = p.peach
        c.purple = p.lavender
        c.red = p.dusty_rose
        c.yellow = p.peach

        c.border = p.purple
      end,

      on_highlights = function(hl)
        hl.Normal = { fg = p.fg, bg = p.bg }
        hl.NormalFloat = {
          fg = p.fg,
          bg = p.bg_highlight,
        }

        hl.CursorLine = { bg = p.bg_highlight }
        hl.LineNr = { fg = p.muted }
        hl.CursorLineNr = {
          fg = p.pink,
          bold = true,
        }

        hl.Visual = { bg = p.purple }
        hl.Comment = {
          fg = p.comment,
          italic = true,
        }

        hl.String = { fg = p.peach }
        hl.Number = { fg = p.dusty_rose }
        hl.Boolean = { fg = p.dusty_rose }
        hl.Function = { fg = p.pink }
        hl.Keyword = {
          fg = p.lavender,
          bold = true,
        }
        hl.Type = { fg = p.rose }

        -- Tree-sitter syntax highlighting
        hl["@string"] = { fg = p.peach }
        hl["@number"] = { fg = p.dusty_rose }
        hl["@boolean"] = { fg = p.dusty_rose }
        hl["@function"] = { fg = p.pink }
        hl["@function.call"] = { fg = p.pink }
        hl["@keyword"] = { fg = p.lavender }
        hl["@type"] = { fg = p.rose }
        hl["@comment"] = {
          fg = p.comment,
          italic = true,
        }
        hl["@property"] = { fg = p.lavender }

        -- Diagnostics
        hl.DiagnosticError = { fg = p.dusty_rose }
        hl.DiagnosticWarn = { fg = p.peach }
        hl.DiagnosticInfo = { fg = p.lavender }
        hl.DiagnosticHint = { fg = p.rose }

        -- Borders and selections
        hl.FloatBorder = {
          fg = p.purple,
          bg = p.bg_highlight,
        }
        hl.Pmenu = {
          fg = p.fg,
          bg = p.bg_highlight,
        }
        hl.PmenuSel = {
          fg = p.pink,
          bg = p.purple,
          bold = true,
        }
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
