return {
    "kevinhwang91/nvim-ufo",

    dependencies = {
        "kevinhwang91/promise-async",
    },

    config = function()
        local ufo = require("ufo")

        ufo.setup()

        vim.keymap.set("n", "fO", ufo.openAllFolds)
        vim.keymap.set("n", "fC", ufo.closeAllFolds)
    end
}
