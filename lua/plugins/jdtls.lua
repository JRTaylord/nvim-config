-- JDTLS Setup Instructions:
-- 1. Install jdtls via Mason: :Mason -> search for jdtls -> install
--    (Located at: C:\Users\james_mtxrk0c\AppData\Local\nvim-data\mason\packages\jdtls\)
--
-- 2. Add Mason bin to Windows PATH so jdtls.cmd is accessible:
--    - Win + X -> System -> Advanced system settings -> Environment Variables
--    - Edit User Path variable and add: C:\Users\james_mtxrk0c\AppData\Local\nvim-data\mason\bin
--    - Restart terminal/Neovim after adding to PATH
--
-- 3. Verify jdtls is accessible:
--    - Windows CMD/PowerShell: where jdtls
--    - Within Neovim: :lua print(vim.fn.exepath('jdtls'))
--
-- 4. Requires Java 21+ and Python 3
--    - Java 21: C:\Program Files\Eclipse Adoptium\jdk-21.0.9.10-hotspot\
--    - JAVA_HOME must be set (winget installer sets this automatically)

return {
  {
    "nvim-jdtls",
    opts = {
      settings = {
        java = {
          format = {
            enabled = false,
            settings = {
              url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
        },
      },
    },
  },
}
