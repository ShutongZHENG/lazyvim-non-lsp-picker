-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function update_gtags()
  local current_file_dir = vim.fn.expand("%:p:h")

  if current_file_dir == nil or current_file_dir == "" then
    return
  end

  local gtags_file = vim.fs.find({ "GTAGS" }, { path = current_file_dir, upward = true, type = "file" })
  local repo_dir = vim.fs.find({ ".repo" }, { path = current_file_dir, upward = true, type = "directory" })
  local git_dir = vim.fs.find({ ".git" }, { path = current_file_dir, upward = true, type = "directory" })

  local project_root = nil
  if #gtags_file > 0 then
    project_root = vim.fn.fnamemodify(gtags_file[1], ":h")
  elseif #repo_dir > 0 then
    project_root = vim.fn.fnamemodify(repo_dir[1], ":h")
  elseif #git_dir > 0 then
    project_root = vim.fn.fnamemodify(git_dir[1], ":h")
  else
    return
  end

  local command_to_run = {}
  local start_message = ""
  local success_message = ""
  local error_message = ""

  if #gtags_file > 0 then
    command_to_run = { "global", "-u" }
    start_message = "AutoGtags: Starting incremental update (global -u)..."
    success_message = "AutoGtags: Incremental update successful."
    error_message = "AutoGtags: Incremental update failed:\n"
  else
    command_to_run = { "gtags" }
    start_message = "AutoGtags: GTAGS not found. Starting full build (gtags)..."
    success_message = "AutoGtags: Full build successful."
    error_message = "AutoGtags: Full build failed:\n"
  end

  vim.notify(start_message, vim.log.levels.INFO, { title = "Gtags" })

  vim.system(command_to_run, { cwd = project_root }, function(result)
    if result.code == 0 then
      vim.notify(success_message, vim.log.levels.INFO, { title = "Gtags" })
    else
      vim.notify(
        error_message .. table.concat(result.stderr, "\n"),
        vim.log.levels.ERROR,
        { title = "Gtags" }
      )
    end
  end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("UserAutoGtags", { clear = true }),
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.hh" },
  callback = update_gtags,
  desc = "Update Gtags (incremental) on save",
})
