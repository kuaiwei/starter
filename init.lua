-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 异步检查远端仓库更新
local function check_remote_update()
  local config_dir = vim.fn.stdpath("config")
  local git_dir = config_dir .. "/.git"

  -- 检查是否是 git 仓库
  if vim.fn.isdirectory(git_dir) == 0 then
    return
  end

  -- 异步获取当前分支和本地 HEAD
  vim.system({ "git", "-C", config_dir, "rev-parse", "HEAD" }, function(local_res)
    if local_res.code ~= 0 then
      return
    end
    local local_head = vim.trim(local_res.stdout)

    -- 异步 fetch 远端
    vim.system({ "git", "-C", config_dir, "fetch" }, function(fetch_res)
      if fetch_res.code ~= 0 then
        return
      end

      -- 异步获取远端 HEAD
      vim.system({ "git", "-C", config_dir, "rev-parse", "@{u}" }, function(remote_res)
        if remote_res.code ~= 0 then
          return
        end
        local remote_head = vim.trim(remote_res.stdout)

        if local_head ~= remote_head then
          vim.schedule(function()
            vim.ui.select({ "是", "否" }, {
              prompt = "检测到 Neovim 配置仓库有更新，是否立即拉取更新？",
            }, function(choice)
              if choice == "是" then
                vim.system({ "git", "-C", config_dir, "pull" }, function(pull_res)
                  vim.schedule(function()
                    if pull_res.code == 0 then
                      vim.notify("配置更新成功！\n" .. pull_res.stdout, vim.log.levels.INFO)
                    else
                      vim.notify("更新失败：" .. pull_res.stderr, vim.log.levels.ERROR)
                    end
                  end)
                end)
              end
            end)
          end)
        end
      end)
    end)
  end)
end

-- 启动后延迟 5 秒检查，之后每 30 分钟检查一次
vim.defer_fn(check_remote_update, 5000)
vim.uv.new_timer():start(1800000, 1800000, vim.schedule_wrap(check_remote_update))
