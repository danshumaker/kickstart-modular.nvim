return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 1000,
            async = false,
            lsp_format = 'fallback',
            lsp_fallback = true,
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        php = { 'phpcs', 'phpcbf' },
      },
      formatters = {
        ['phpcs'] = {
          -- Optionally specify the command if not in $PATH
          command = 'phpcs',
          args = {
            '--standard=Drupal', -- or your preferred standard
            '--report=emacs',
            '-',
          },
        },
        ['phpcbf'] = {
          command = 'phpcbf',
          args = {
            'fix',
            '--rules=@PSR12',
            '$FILENAME',
          },
          stdin = false,
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
