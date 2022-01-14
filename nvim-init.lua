local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  print 'Installing packer close and reopen Neovim...'
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

-- Install your plugins here
packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use "williamboman/nvim-lsp-installer"
end)

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if status_ok then
  for _, lsp in ipairs({'pyright', 'sumneko_lua'}) do
    local server_available, requested_server = require('nvim-lsp-installer.servers').get_server(lsp)
    if server_available then
      if not requested_server:is_installed() then
        requested_server:install()
      end
    end
  end


  lsp_installer.on_server_ready(function(server)
      local opts = {}
      server:setup(opts)
  end)
end
