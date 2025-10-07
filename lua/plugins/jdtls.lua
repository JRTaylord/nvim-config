return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")
    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

    local mason_registry = require("mason-registry")
    local jdtls_pkg = mason_registry.get_package("jdtls")
    local jdtls_path = jdtls_pkg:get_install_path()

    -- Function to find WPILib vendor dependencies
    local function get_vendor_bundles()
      local bundles = {}
      local vendordeps_dir = vim.fn.getcwd() .. "/vendordeps"

      -- Check if vendordeps directory exists
      if vim.fn.isdirectory(vendordeps_dir) == 0 then
        return bundles
      end

      -- Get all JSON files in vendordeps
      local vendor_files = vim.fn.glob(vendordeps_dir .. "/*.json", false, true)

      for _, vendor_file in ipairs(vendor_files) do
        local file = io.open(vendor_file, "r")
        if file then
          local content = file:read("*all")
          file:close()

          -- Parse JSON to extract JAR paths
          local ok, json = pcall(vim.json.decode, content)
          if ok and json then
            -- Process javaDependencies
            if json.javaDependencies then
              for _, dep in ipairs(json.javaDependencies) do
                if dep.groupId and dep.artifactId and dep.version then
                  -- WPILib stores dependencies in ~/.gradle or GradleRIO cache
                  local gradle_cache = home .. "/.gradle/caches/modules-2/files-2.1"
                  local artifact_path = gradle_cache .. "/" .. dep.groupId .. "/" .. dep.artifactId .. "/" .. dep.version

                  -- Try to find the JAR file
                  local jar_pattern = artifact_path .. "/**/" .. dep.artifactId .. "-" .. dep.version .. ".jar"
                  local jar_files = vim.fn.glob(jar_pattern, false, true)

                  for _, jar in ipairs(jar_files) do
                    table.insert(bundles, jar)
                  end
                end
              end
            end

            -- Process jniDependencies for simulation/native libs if needed
            if json.jniDependencies then
              for _, dep in ipairs(json.jniDependencies) do
                if dep.groupId and dep.artifactId and dep.version then
                  local gradle_cache = home .. "/.gradle/caches/modules-2/files-2.1"
                  local artifact_path = gradle_cache .. "/" .. dep.groupId .. "/" .. dep.artifactId .. "/" .. dep.version
                  local jar_pattern = artifact_path .. "/**/" .. dep.artifactId .. "-" .. dep.version .. ".jar"
                  local jar_files = vim.fn.glob(jar_pattern, false, true)

                  for _, jar in ipairs(jar_files) do
                    table.insert(bundles, jar)
                  end
                end
              end
            end
          end
        end
      end

      return bundles
    end

    -- Determine the OS-specific config directory
    local os_config = "linux"
    if vim.fn.has("mac") == 1 then
      os_config = "mac"
    elseif vim.fn.has("win32") == 1 then
      os_config = "win"
    end

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration", jdtls_path .. "/config_" .. os_config,
        "-data", workspace_dir,
      },
      root_dir = require("jdtls.setup").find_root({
        ".git",
        "gradlew",
        "build.gradle",
        "build.gradle.kts",
      }),
      settings = {
        java = {
          gradle = {
            buildServer = {
              enabled = true,
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
          format = {
            enabled = true,
          },
          configuration = {
            updateBuildConfiguration = "automatic",
          },
        },
      },
      init_options = {
        bundles = get_vendor_bundles(),
      },
    }

    jdtls.start_or_attach(config)
  end,
}
