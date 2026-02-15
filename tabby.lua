-- Tabby AI code completion
-- Delete this file and remove the Plug/source lines to disable

vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--stdio"}
vim.g.tabby_inline_completion_trigger = 'auto'
vim.g.tabby_keybinding_accept = '<Tab>'
vim.g.tabby_keybinding_trigger_or_dismiss = '<C-\\>'

-- Status display for airline
vim.g.tabby_status = ""

local function set_status(msg)
  vim.schedule(function()
    vim.g.tabby_status = msg
    vim.cmd("AirlineRefresh")
  end)
end

-- Read auth token from tabby agent config
local function get_tabby_token()
  local config_path = vim.fn.expand("~/.tabby-client/agent/config.toml")
  local f = io.open(config_path, "r")
  if not f then return "" end
  local content = f:read("*a")
  f:close()
  return content:match('token%s*=%s*"([^"]+)"') or ""
end

-- Auto-start tabby server if not already running
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local token = get_tabby_token()
    local started_server = false
    vim.system({"curl", "-s", "-o", "/dev/null", "-m", "1", "http://127.0.0.1:8080/v1/health"}, {}, function(result)
      if result.code == 0 then
        set_status("[Tabby ready]")
        return
      end
      set_status("[Tabby starting...]")
      started_server = true
      vim.system(
        {"sh", "-c", "/opt/homebrew/bin/tabby serve --model Qwen2.5-Coder-3B --device metal >> ~/.tabby/serve.log 2>&1"}
      )
      -- Poll until server is ready, then restart LSP so it connects cleanly
      local function wait_for_server(attempts)
        if attempts <= 0 then
          set_status("[Tabby failed]")
          return
        end
        vim.system({"curl", "-s", "-o", "/dev/null", "-m", "5",
          "-H", "Authorization: Bearer " .. token,
          "-H", "Content-Type: application/json",
          "-d", '{"language":"python","segments":{"prefix":"def "}}',
          "http://127.0.0.1:8080/v1/completions"}, {}, function(r)
          if r.code == 0 then
            set_status("[Tabby connecting...]")
            vim.schedule(function()
              -- Kill the stale tabby-agent LSP client
              for _, client in ipairs(vim.lsp.get_clients({name = "tabby"})) do
                client:stop(true)
              end
              -- Wait for it to fully stop, then relaunch via :edit
              local function wait_for_stop(stop_attempts)
                if stop_attempts <= 0 then
                  -- Force it — just edit anyway
                  vim.cmd("edit")
                  set_status("[Tabby ready]")
                  return
                end
                local clients = vim.lsp.get_clients({name = "tabby"})
                if #clients == 0 then
                  vim.cmd("edit")
                  -- Wait for new client to attach
                  local function wait_for_lsp(lsp_attempts)
                    if lsp_attempts <= 0 then
                      set_status("[Tabby LSP failed]")
                      return
                    end
                    local c = vim.lsp.get_clients({name = "tabby"})
                    if #c > 0 and c[1].initialized then
                      set_status("[Tabby ready]")
                    else
                      vim.defer_fn(function() wait_for_lsp(lsp_attempts - 1) end, 500)
                    end
                  end
                  wait_for_lsp(20)
                else
                  vim.defer_fn(function() wait_for_stop(stop_attempts - 1) end, 200)
                end
              end
              wait_for_stop(25)
            end)
          else
            vim.defer_fn(function() wait_for_server(attempts - 1) end, 2000)
          end
        end)
      end
      wait_for_server(30)
    end)
  end,
})
