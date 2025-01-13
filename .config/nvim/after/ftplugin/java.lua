local config = {
  cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
  root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "settings.gradle", "build.gradle" }, { upward = true})[1]),
}

require("jdtls").start_or_attach(config)
