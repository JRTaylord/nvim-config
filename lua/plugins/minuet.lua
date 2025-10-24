--[[
MINUET AI SETUP INSTRUCTIONS
=============================

This plugin provides AI-powered code completion using Claude, OpenAI, or other providers.

SETUP STEPS FOR CLAUDE (Default Provider):
------------------------------------------

1. GET AN API KEY:
   - Visit: https://console.anthropic.com/
   - Sign up or log in to your Anthropic account
   - Navigate to "API Keys" section
   - Click "Create Key" and copy your API key

2. SET UP ENVIRONMENT VARIABLE:

   On Linux/Mac (add to ~/.bashrc, ~/.zshrc, or ~/.profile):
   ----------------------------------------------------------
   export ANTHROPIC_API_KEY="sk-ant-api03-your-key-here"

   After adding, reload your shell:
   source ~/.bashrc  # or ~/.zshrc or ~/.profile

   On Windows (PowerShell):
   ------------------------
   # Temporary (current session only):
   $env:ANTHROPIC_API_KEY = "sk-ant-api03-your-key-here"

   # Permanent (all sessions):
   [System.Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', 'sk-ant-api03-your-key-here', 'User')

   On Windows (Command Prompt):
   ----------------------------
   # Temporary:
   set ANTHROPIC_API_KEY=sk-ant-api03-your-key-here

   # Permanent: Use System Properties > Environment Variables GUI
   # Or use PowerShell command above

3. INSTALL THE PLUGIN:
   - Restart Neovim or run: :Lazy sync
   - The plugin will automatically install with dependencies

4. USAGE:
   - Start typing in any file
   - AI completions will appear in your completion menu
   - Press <A-y> (Alt+y) to accept AI suggestions
   - Completions trigger after 400ms of idle typing

5. SWITCHING PROVIDERS:
   - Change line 10 below: provider = "claude" to "openai" or "codestral"
   - Set up corresponding environment variable (see provider_options below)

TROUBLESHOOTING:
---------------
- If completions don't appear, check :messages for errors
- Verify API key is set: :echo getenv('ANTHROPIC_API_KEY')
- Check notification level (line 13) - set to "debug" for more info
- Ensure you have internet connection for API calls

--]]

return {
  {
    "milanglacier/minuet-ai.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("minuet").setup({
        -- Provider selection (options: 'openai', 'claude', 'codestral', 'gemini', 'ollama', etc.)
        provider = "claude",

        -- Notification level: false, 'debug', 'verbose', 'warn', 'error'
        notify = "debug",

        -- Context window size in characters
        context_window = 16000,

        -- Throttle requests (ms) - minimum time between requests
        throttle = 2000,

        -- Debounce input (ms) - wait time after typing stops
        debounce = 1000,

        -- Request timeout (ms)
        request_timeout = 3000,

        -- Number of completion items to generate
        n_completions = 3,

        -- Add single line completions
        add_single_line_entry = true,

        -- Provider-specific configurations
        provider_options = {
          -- Claude configuration (Anthropic)
          claude = {
            model = "claude-sonnet-4-0",
            stream = true,
            -- API key from environment variable
            api_key = "ANTHROPIC_API_KEY",
            end_point = "https://api.anthropic.com/v1/messages",
            max_tokens = 512,
            optional = {
              -- Additional Claude-specific parameters can go here
            },
          },

          -- OpenAI configuration
          openai = {
            model = "gpt-4o-mini",
            stream = true,
            api_key = "OPENAI_API_KEY",
            end_point = "https://api.openai.com/v1/chat/completions",
            optional = {
              max_tokens = 256,
            },
          },

          -- Codestral configuration (FIM model)
          codestral = {
            model = "codestral-latest",
            stream = true,
            api_key = "CODESTRAL_API_KEY",
            end_point = "https://api.mistral.ai/v1/fim/completions",
            optional = {
              max_tokens = 256,
            },
          },
        },
        -- Virtual text mode configuration
        virtualtext = {
          auto_trigger_ft = {
            "lua",
            "python",
            "java",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "cpp",
            "c",
            "rust",
            "go",
            "html",
            "css",
            "json",
            "yaml",
            "markdown",
          },
          keymap = {
            accept = "<C-j>",
            accept_line = "<C-l>",
            dismiss = "<C-e>",
          },
        },
      })
    end,
  },

}
