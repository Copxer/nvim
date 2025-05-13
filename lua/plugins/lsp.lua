return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            {
                'j-hui/fidget.nvim',
                tag = 'v1.4.0',
                opts = {
                    progress = {
                        display = { done_icon = '✓' },
                    },
                    notification = {
                        window = { winblend = 0 },
                    },
                },
            },
        },
        config = function()
            -- 1) LSP keymaps on attach
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, fn, desc)
                        vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                    map('<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, '[W]orkspace [L]ist Folders')
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- 2) Build up capabilities and the list of servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'Lua 5.4' },
                            diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
                            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
                            completion = { callSnippet = 'Replace' },
                            telemetry = { enable = false },
                        },
                    },
                },
                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                pyflakes = { enabled = false },
                                pycodestyle = { enabled = false },
                                autopep8 = { enabled = false },
                                yapf = { enabled = false },
                                mccabe = { enabled = false },
                                pylsp_mypy = { enabled = false },
                                pylsp_black = { enabled = false },
                                pylsp_isort = { enabled = false },
                            },
                        },
                    },
                },
                ruff = {
                    commands = {
                        RuffAutofix = {
                            function()
                                vim.lsp.buf.execute_command {
                                    command = 'ruff.applyAutofix',
                                    arguments = { { uri = vim.uri_from_bufnr(0) } },
                                }
                            end,
                            description = 'Ruff: Fix all auto-fixable problems',
                        },
                        RuffOrganizeImports = {
                            function()
                                vim.lsp.buf.execute_command {
                                    command = 'ruff.applyOrganizeImports',
                                    arguments = { { uri = vim.uri_from_bufnr(0) } },
                                }
                            end,
                            description = 'Ruff: Format imports',
                        },
                    },
                },
            }

            -- 3) Manual mapping from lspconfig name → mason package name
            local lsp_to_mason = {
                lua_ls = 'lua-language-server',
                pylsp = 'python-lsp-server',
                ruff = 'ruff',
            }

            -- 4) Turn your server keys into Mason package names
            local ensure_installed = vim.tbl_map(function(name)
                return lsp_to_mason[name] or name
            end, vim.tbl_keys(servers))

            -- 5) Setup Mason, Mason-LSPconfig, and Mason-Tool-Installer
            require('mason').setup()
            require('mason-lspconfig').setup()
            require('mason-tool-installer').setup {
                ensure_installed = ensure_installed,
                auto_update = true,
            }

            -- 6) Finally, hook up each LSP to lspconfig
            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local opts = vim.tbl_deep_extend('force', {
                            capabilities = capabilities,
                        }, servers[server_name] or {})
                        require('lspconfig')[server_name].setup(opts)
                    end,
                },
            }
        end,
    },
}
