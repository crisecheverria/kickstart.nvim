return {
  'wojciech-kulik/filenav.nvim',
  config = function()
    require('filenav').setup {
      next_file_key = '<C-i>',
      prev_file_key = '<C-o>',
      max_history = 100,
      remove_duplicates = false,
    }
  end,
}
