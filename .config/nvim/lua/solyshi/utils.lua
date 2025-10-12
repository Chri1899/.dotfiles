--- @class Utils
--- @field deboounce fun(func: function, timeout: integer): function
local M = {}

M.debounce = function(func, timeout)
  local timer = vim.uv.new_timer()
  return function(...)
    timer:stop()
    local args = { ... }
    timer:start(timeout, 0, function()
      vim.schedule_wrap(func)(unpack(args))
    end)
  end
end

return M
