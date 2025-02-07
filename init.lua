
-- Automatically reload files when changed outside of nvim
vim.o.autoread = true

-- Set leader to hashtag
vim.g.mapleader = '#'

-- Map "+y to <leader>y in normal and visual mode
vim.api.nvim_set_keymap('n', '<leader>w', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>w', '"+y', { noremap = true, silent = true })

-- Example key mappings for Telescope commands
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true, silent = true })


--Add line numbers
vim.opt.number = true

--quick config refresh
vim.api.nvim_set_keymap('n', '<leader>r', ':source $MYVIMRC<CR>', { noremap = true, silent = true })


-- Enable 24-bit true color support
vim.opt.termguicolors = true

--'TODO:' highlighting
-- Enable syntax highlighting
vim.cmd('syntax on')

-- Highlight TODO comments
vim.api.nvim_command('highlight Todo guifg=Green ctermfg=Green')
vim.api.nvim_command('match Todo /TODO:/')

-- Function to resize the current vertical window
local function resize_current_window(width)
    if width then
        vim.cmd("vertical resize " .. width)
    else
        print("Usage: :vs size <width>")
    end
end


-- Create a user command `vs size` for resizing the current window
vim.api.nvim_create_user_command('VsSize', function(opts)
    resize_current_window(tonumber(opts.args))
end, { nargs = 1 })


-- Set 'cursor at end line ($)' to m in normal and visual mode
vim.api.nvim_set_keymap('n', 'm', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'm', '$', { noremap = true, silent = true })


-- Automatically reload files without prompting
vim.api.nvim_create_augroup("auto_reload", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "auto_reload",
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= 'help' then
      vim.cmd("checktime")
    end
  end
})
--Plugins using Lazy.nvim
-- Set the runtime path to include lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/site/pack/lazy/start/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Initialize Lazy.nvim for plugin management
require('lazy').setup({
    -- Add your plugins here
-- Lualine status line
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons'},
    },

-- Alpha dashboard
    {
	'goolord/alpha-nvim',
	requires = { 'nvim-tree/nvim-web-devicons' },
	config = function ()
	    require'alpha'.setup(require'alpha.themes.dashboard'.config)
	end
    },
-- Codeium for code completion
    {
        'Exafunction/codeium.vim',
        event = 'BufEnter', -- Load on buffer enter
    },
-- Telescope for fuzzy finding
    {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
    },
    --Nightfox theme
    { "EdenEast/nightfox.nvim" },
    -- Nvim-Tree file explorer
    {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- Optional, for file icons
        },
        config = function()
            print("Setting up nvim-tree") -- Debug print statement
            require("nvim-tree").setup {
                view = {
                    side = "left",  -- Position of the tree
                    width = 30,     -- Width of the tree
                },
            }
        end,
    }

})
-- Set key mapping for toggling Nvim-Tree in normal and visual mode
vim.api.nvim_set_keymap('n', '<Leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


--

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'dracula',  -- You can change the theme to whatever you like
    component_separators = { left = '/', right = '/'},
    section_separators = { left = '/', right = '/'},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
-- Default options
require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,     -- Disable setting background
    terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,    -- Non focused panes set to alternative background
    module_default = true,   -- Default enable value for modules
    colorblind = {
      enable = false,        -- Enable colorblind support
      simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
      severity = {
        protan = 0,          -- Severity [0,1] for protan (red)
        deutan = 0,          -- Severity [0,1] for deutan (green)
        tritan = 0,          -- Severity [0,1] for tritan (blue)
      },
    },
    styles = {               -- Style to be applied to different syntax groups
      comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {             -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = {             -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = {},
  specs = {},
  groups = {},
})

-- setup must be called before loading
vim.cmd("colorscheme nightfox")

--Simplify copy command to just 'C'
vim.api.nvim_set_keymap('v', ':C', '"+y', { noremap = true, silent = true })

-- :shell command creates a custom terminal just how i like it
vim.api.nvim_create_user_command('Sh',
	function()
		-- create a horizontal split terminal
		vim.cmd('botright split | terminal')
	end,
	{}
	)


vim.api.nvim_create_user_command('KK',
	function(opts)
		local path = opts.args or '.'  -- Default to current directory
		-- Create a vertical split and open the directory
		vim.cmd('vsplit | Explore ' .. vim.fn.shellescape(path))
	end,
	{ nargs = '?' }
)


--Really dope shortcuts
--
--this maps <leader>j to select all the file's text and copy to system clipboard
vim.api.nvim_set_keymap('n', '<leader>j', 'ggVG"+y', { noremap = true, silent = true })


--this maps <leader>d to delete every line in the file
vim.api.nvim_set_keymap('n', '<leader>d', 'ggVGd', { noremap = true, silent = true })



--terminal functions
--
--
-- Function to map keys in terminal mode
function map_in_terminal_mode(lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, { noremap = true, silent = true })
end

-- :ap Ctrl-n to toggle from terminal to normal mode
map_in_terminal_mode('<C-w>', '<C-\\><C-n:')
-- Activate the colorscheme

-- Map <leader>9 to close current window
vim.keymap.set("n", "<leader>9", "<cmd>close<CR>", { noremap = true, silent = true })

-- Map <leader>0 to open a new terminal
vim.keymap.set("n", "<leader>0", "<cmd>belowright split | terminal<CR>", { noremap = true, silent = true })

-- Map Ctrl-w to toggle from terminal to normal mode
vim.keymap.set("t", "<C-w>", "<C-\\><C-n>", { noremap = true, silent = true })







