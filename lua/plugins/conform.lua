return {
    {
        'stevearc/conform.nvim',
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.php = { 'pint' }

            opts.formatters = opts.formatters or {}
            opts.formatters.pint = {
                command = 'pint',
                args = function(ctx)
                    local cfg = vim.fs.find({ 'lint.json', 'pint.json' }, {
                        upward = true,
                        path = ctx.dirname,
                    })[1]
                    local args = { ctx.filename }
                    if cfg then
                        table.insert(args, 1, '--config')
                        table.insert(args, 2, cfg)
                    end
                    return args
                end,
                stdin = false,
                condition = function()
                    return vim.fn.executable 'pint' == 1
                end,
            }

            -- do NOT set opts.format_on_save here!
        end,
    },
}
