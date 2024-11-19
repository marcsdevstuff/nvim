local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup LuaRocks with Windows paths
local function setup_luarocks()
    local userprofile = os.getenv("USERPROFILE")
    if not userprofile then return end  -- Exit if not on Windows

    -- User-level LuaRocks paths
    local luarocks_user_path = userprofile .. '\\.luarocks\\share\\lua\\5.1\\?.lua;' ..
                              userprofile .. '\\.luarocks\\share\\lua\\5.1\\?\\init.lua'
    local luarocks_user_cpath = userprofile .. '\\.luarocks\\lib\\lua\\5.1\\?.dll'

    -- Add LuaRocks paths to package.path and package.cpath
    package.path = package.path .. ';' .. luarocks_user_path:gsub('\\', '/')
    package.cpath = package.cpath .. ';' .. luarocks_user_cpath:gsub('\\', '/')

    -- Add LuaRocks bin directory to PATH for external commands
    local luarocks_bin = userprofile .. '\\.luarocks\\bin'
    local current_path = os.getenv("PATH") or ""
    
    if not current_path:find(luarocks_bin, 1, true) then
        os.setenv("PATH", luarocks_bin .. ";" .. current_path)
    end
end

-- Initialize LuaRocks paths
setup_luarocks()

-- Global leader settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("lazy").setup("plugins", {
    debug = false,  -- ensure this is disabled
    log_level = "warn",  -- log only warnings and errors
})

require("settings")
require('lualine').setup()

-- Set NVIM_LOG_LEVEL to 'debug'
--vim.fn.setenv("NVIM_LOG_LEVEL", "debug")

-- Set verbose to 15 for maximum verbosity and output to %LOCALAPPDATA%/nvim/log
--vim.cmd('set verbose=15')
--vim.cmd('set verbosefile=' .. vim.fn.stdpath("data") .. '/log')
