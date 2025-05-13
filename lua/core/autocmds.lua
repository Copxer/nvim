-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ~/.config/nvim/lua/config/autocmds.lua
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.php',
    callback = function(ctx)
        -- run Pint on the file you just wrote
        local fname = ctx.file
        if vim.fn.executable 'pint' == 1 then
            -- shell out to Pint with your lint.json (if present)
            local cfg = vim.fs.find({ 'lint.json', 'pint.json' }, {
                upward = true,
                path = vim.fn.fnamemodify(fname, ':p:h'),
            })[1]
            local cmd = { 'pint' }
            if cfg then
                table.insert(cmd, '--config')
                table.insert(cmd, cfg)
            end
            table.insert(cmd, fname)
            vim.fn.system(cmd)
            -- reload the file so buffer reflects Pint’s changes
            vim.cmd 'silent! edit!'
        end
    end,
})
