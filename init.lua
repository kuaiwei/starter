-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 自动检查远端仓库更新
local function check_remote_update()
  local config_dir = vim.fn.stdpath("config")
  local git_dir = config_dir .. "/.git"

  -- 检查是否是 git 仓库
  if vim.fn.isdirectory(git_dir) == 0 then
    return
  end

  -- 获取当前分支
  local branch = vim.fn.system("git -C " .. vim.fn.shellescape(config_dir) .. " rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  if branch == "" then
    return
  end

  -- fetch 远端更新
  vim.fn.system("git -C " .. vim.fn.shellescape(config_dir) .. " fetch")

  -- 检查是否有更新
  local local_head = vim.fn.system("git -C " .. vim.fn.shellescape(config_dir) .. " rev-parse HEAD"):gsub("\n", "")
  local remote_head = vim.fn.system("git -C " .. vim.fn.shellescape(config_dir) .. " rev-parse @{u} 2>/dev/null"):gsub("\n", "")

  if local_head ~= "" and remote_head ~= "" and local_head ~= remote_head then
    vim.ui.select({ "是", "否" }, {
      prompt = "检测到 Neovim 配置仓库有更新，是否立即拉取更新？",
    }, function(choice)
      if choice == "是" then
        local result = vim.fn.system("git -C " .. vim.fn.shellescape(config_dir) .. " pull")
        if vim.v.shell_error == 0 then
          vim.notify("配置更新成功！\n" .. result, vim.log.levels.INFO)
        else
          vim.notify("更新失败：" .. result, vim.log.levels.ERROR)
        end
      end
    end)
  end
end

-- 启动后延迟 5 秒检查，之后每 30 分钟检查一次
vim.defer_fn(check_remote_update, 5000)
vim.loop.new_timer():start(1800000, 1800000, vim.schedule_wrap(check_remote_update))
