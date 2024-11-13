-- Custom nvim config written by michaelcorduroy in 2024
--

-- Automatically reload files when changed outside of nvim
vim.o.autoread = true



-- Set leader to hashtag
vim.g.mapleader = '#'


-- Map "+y to <leader>y in normal and visual mode
vim.api.nvim_set_keymap('n', '<leader>w', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>w', '"+y', { noremap = true, silent = true })


-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


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

-- Example key mappings for Telescope commands
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true, silent = true })


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
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")


-- Initialize Lazy.nvim for plugin management
require('lazy').setup({
    -- Add your plugins here

    -- Lualine status line
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    },

    -- Codeium for code completion
    {
        'Exafunction/codeium.vim',
        event = 'BufEnter', -- Load on buffer enter
    },

    -- TokyoNight theme
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
    },

    -- Treesitter for syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    },

    -- Telescope for fuzzy finding
    {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
    },

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


 require("tokyonight").setup({
  style = "storm", -- Available styles: 'storm', 'night', 'moon'
  transparent = false, -- Enable/Disable transparent background
  terminal_colors = true, -- Adjust terminal colors based on the theme
  styles = {
    comments = { italic = false },
    keywords = { italic = true },
    functions = { bold = true },
  },
  -- Add any additional customization here
})

-- Activate the colorscheme
vim.cmd([[colorscheme tokyonight]])

-- Set cursor color white
vim.api.nvim_set_hl(0, "Cursor", { fg = "black", bg = "white" })

--treesitter requirements
require('nvim-treesitter.configs').setup {
  ensure_installed =  
  { "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "java", "yaml" }, 
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  
  }


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

-- Map Ctrl-n to toggle from terminal to normal mode
map_in_terminal_mode('<C-w>', '<C-\\><C-n>')
