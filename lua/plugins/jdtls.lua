config = function()
  local jdtls = require("jdtls")
  local home = os.getenv("HOME")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

  local mason_registry = require("mason-registry")
  local jdtls_pkg = mason_registry.get_package("jdtls")

  local config = {
    root_dir = require("jdtls.setup").find_root({
      ".git",
      "gradlew",
      "build.gradle",
    }),
    settings = {
      java = {
        gradle = {
          buildServer = {
            enabled = true, -- Key setting!
          },
        },
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
      },
    },
  }

  jdtls.start_or_attach(config)
end
