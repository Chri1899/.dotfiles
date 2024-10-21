return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },

    config = function()
        local dap = require("dap")

        local dapui = require("dapui")

        require("mason-nvim-dap").setup {
            automatic_setup = true,
            automatic_installation = true,

            handlers = {},

            ensure_installed = {
            },
        }
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Coninue" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step into" })
        vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step over" })
        vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step out" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })

        dapui.setup {
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                }
            }
        }
        vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Debug: Toggle last session result" })

        dap.listeners.after.event_initializied["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end
}
