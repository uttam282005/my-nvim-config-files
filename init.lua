-- init.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Basic options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- Bootstrap lazy.nvim
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Plugin setup
require("lazy").setup({
  -- Existing plugins
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      execution_message = {
        message = function()
          return "saved"
        end,
        dim = 0.18,
        cleaning_interval = 100,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
    },
  },
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  { "nvim-tree/nvim-web-devicons" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { import = "lazyvim.plugins.extras.ui.mini-animate" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.ui.alpha" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "plugins" },
}, {
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "catppuccin" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Custom command for C++ compilation and execution
vim.api.nvim_create_user_command("CompileAndRunCppWithFiles", function()
  local full_file = vim.fn.expand("%:p")
  local file_name = vim.fn.expand("%:t:r")
  local dir = vim.fn.expand("%:p:h")

  vim.fn.chdir(dir)

  local compile_cmd = string.format('g++ -std=c++20 "%s" -o "%s"', full_file, file_name)
  local compile_output = vim.fn.system(compile_cmd)

  if vim.v.shell_error == 0 then
    local run_cmd = string.format("./%s < input.txt > output.txt 2>&1", file_name)
    local run_output = vim.fn.system(run_cmd)

    vim.fn.system(string.format('rm "%s"', file_name))

    if vim.fn.filereadable("output.txt") == 1 and vim.fn.getfsize("output.txt") > 0 then
      local output_bufnr = vim.fn.bufnr("output.txt")

      if output_bufnr ~= -1 then
        local lines = vim.fn.readfile("output.txt")
        vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, lines)
        print("Execution completed. Output and errors saved to output.txt buffer.")
      else
        print("Execution completed. Output and errors saved to output.txt, but buffer not found.")
      end
    else
      print("Execution completed, but output.txt is empty or doesn't exist.")
    end
  else
    local error_msg = "Compilation failed. Error:\n" .. compile_output
    vim.fn.writefile(vim.split(error_msg, "\n"), "output.txt")

    local output_bufnr = vim.fn.bufnr("output.txt")

    if output_bufnr ~= -1 then
      local lines = vim.fn.readfile("output.txt")
      vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, lines)
      print("Compilation failed. Error saved to output.txt buffer.")
    else
      print("Compilation failed. Error saved to output.txt, but buffer not found.")
    end
  end

  vim.fn.chdir("-")
end, {})

-- Reload config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "**/lua/shxfee/config/*.lua",
  callback = function()
    local filepath = vim.fn.expand("%")
    dofile(filepath)
    vim.notify("Configuration reloaded \n" .. filepath, vim.log.levels.INFO)
  end,
  desc = "Reload config on save",
})

-- Cursor settings
vim.opt.guicursor = "n-v-c-sm:block-blinkon100,i-ci-ve:block-blinkon0,r-cr-o:hor20"
vim.cmd("highlight Cursor guibg=NONE guifg=NONE guisp=NONE")

-- File type specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>r",
      ":!go run % < input.txt > output.txt<CR>",
      { buffer = true, desc = "Run Go program" }
    )
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.keymap.set("n", "<leader>r", function()
      local file = vim.fn.expand("%:r")
      local cmd = string.format(
        "!g++ -std=c++17 %% -o %s > output.txt 2>&1 && if [ -f %s ]; then %s < input.txt >> output.txt 2>&1 && rm %s; fi",
        vim.fn.shellescape(file),
        vim.fn.shellescape(file),
        vim.fn.shellescape("./" .. file),
        vim.fn.shellescape(file)
      )
      vim.cmd(cmd)
    end, { buffer = true, desc = "Compile, run C++ program (with all output), and remove binary" })
  end,
})

-- Plugin configurations
require("nvim-web-devicons").setup({
  default = true,
})

-- Catppuccin theme setup
require("catppuccin").setup({
  flavour = "mocha",
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
  },
})

-- Set colorscheme
vim.cmd.colorscheme("catppuccin")
