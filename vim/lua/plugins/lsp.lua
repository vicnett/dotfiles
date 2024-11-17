return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", config = true },
  },
  config = function()
    -- Things to do only when the current buffer attaches to a language server
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      desc = "LSP actions",

      -- Create keymaps only when attached to a language server
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, {
            buffer = event.buf,
            desc = "LSP: " .. desc,
          })
        end

        -- Jump to the definition of the word under your cursor.
        -- This is where a variable was first declared, or where a function is
        -- defined, etc. To jump back, press <C-t>.
        map(
          "gd",
          require("telescope.builtin").lsp_definitions,
          "[g]oto [d]efinition"
        )
        -- Find references for the word under your cursor.
        map(
          "gr",
          require("telescope.builtin").lsp_references,
          "[g]oto [r]eferences"
        )
        -- Jump to the implementation of the word under your cursor.
        -- Useful when your language has ways of declaring types without an
        -- actual implementation.
        map(
          "gI",
          require("telescope.builtin").lsp_implementations,
          "[g]oto [I]mplementation"
        )
        -- Jump to the type of the word under your cursor.
        -- Useful when you're not sure what type a variable is and you want to
        -- see the definition of its *type*, not where it was *defined*.
        map(
          "<leader>D",
          require("telescope.builtin").lsp_type_definitions,
          "Type [D]efinition"
        )
        -- Fuzzy find all the symbols in your current document.
        -- Symbols are things like variables, functions, types, etc.
        map(
          "<leader>ds",
          require("telescope.builtin").lsp_document_symbols,
          "[d]ocument [s]ymbols"
        )
        -- Fuzzy find all the symbols in your current workspace.
        -- Similar to document symbols, except searches over your entire project.
        map(
          "<leader>ws",
          require("telescope.builtin").lsp_dynamic_workspace_symbols,
          "[w]orkspace [s]ymbols"
        )
        -- Rename the variable under your cursor.
        -- Most Language Servers support renaming across files, etc.
        map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
        -- Execute a code action, usually your cursor needs to be on top of an
        -- error or a suggestion from your LSP for this to activate.
        map(
          "<leader>ca",
          vim.lsp.buf.code_action,
          "[c]ode [a]ction",
          { "n", "x" }
        )
        -- WARN: This is not Goto Definition, this is Goto Declaration.
        -- For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
        map("K", vim.lsp.buf.hover, "Information in floating window")
        map("gs", vim.lsp.buf.signature_help, "[g]oto [s]ignature help")

        -- Highlight references of the word under the cursor when it rests there
        -- for a little while, and clear them when the cursor is moved.
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_documentHighlight
          )
        then
          local highlight_augroup =
            vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({
                group = "lsp-highlight",
                buffer = event2.buf,
              })
            end,
          })
        end

        if
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_inlayHint
          )
        then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            )
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
      pylsp = {},
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      -- formatters
      "black", -- Python
      "stylua", -- Lua
      --linters
      "flake8", -- Python
      "jsonlint", -- Json
      "markdownlint", -- Markdown
      "tflint", -- Terraform
    })

    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
    })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed by the server
          -- configuration above. Useful when disabling certain features of an
          -- LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend(
            "force",
            {},
            capabilities,
            server.capabilities or {}
          )
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
