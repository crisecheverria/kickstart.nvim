return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
    },
    config = function()
      require('codecompanion').setup {
        adapters = {
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              schema = {
                model = {
                  default = 'gemini-1.5-pro',
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = 'gemini',
          },
          inline = {
            adapter = 'gemini',
          },
        },
      }
    end,
  },
  {
    'kiddos/gemini.nvim',
    config = function()
      require('gemini').setup {
        model_config = {
          completion_delay = 1000,
          model_id = 'gemini-1.5-pro',
          temperature = 0.01,
          top_k = 1.0,
          max_output_tokens = 8196,
          response_mime_type = 'text/plain',
        },
        chat_config = {
          enabled = false,
        },
        hints = {
          enabled = false,
        },
        completion = {
          enabled = true,
          insert_result_key = '<S-Tab>',
          get_prompt = function(bufnr, pos)
            local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
            local prompt = 'Below is a %s file:\n' .. '```%s\n%s\n```\n\n' .. 'Instruction:\nWhat code should be place at <insert_here></insert_here>?\n'
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local line = pos[1]
            local col = pos[2]
            local target_line = lines[line]
            if target_line then
              lines[line] = target_line:sub(1, col) .. '<insert_here></insert_here>' .. target_line:sub(col + 1)
            else
              return nil
            end
            local code = vim.fn.join(lines, '\n')
            prompt = string.format(prompt, filetype, filetype, code)
            return prompt
          end,
        },
        instruction = {
          enabled = true,
          menu_key = '<C-o>',
          prompts = {
            {
              name = 'Unit Test',
              command_name = 'GeminiUnitTest',
              menu = 'Unit Test 🚀',
              get_prompt = function(lines, bufnr)
                local code = vim.fn.join(lines, '\n')
                local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                local prompt = 'Context:\n\n```%s\n%s\n```\n\n' .. 'Objective: Write unit test for the above snippet of code\n'
                return string.format(prompt, filetype, code)
              end,
            },
            {
              name = 'Code Review',
              command_name = 'GeminiCodeReview',
              menu = 'Code Review 📜',
              get_prompt = function(lines, bufnr)
                local code = vim.fn.join(lines, '\n')
                local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                local prompt = 'Context:\n\n```%s\n%s\n```\n\n'
                  .. 'Objective: Do a thorough code review for the following code.\n'
                  .. 'Provide detail explaination and sincere comments.\n'
                return string.format(prompt, filetype, code)
              end,
            },
            {
              name = 'Code Explain',
              command_name = 'GeminiCodeExplain',
              menu = 'Code Explain',
              get_prompt = function(lines, bufnr)
                local code = vim.fn.join(lines, '\n')
                local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                local prompt = 'Context:\n\n```%s\n%s\n```\n\n'
                  .. 'Objective: Explain the following code.\n'
                  .. 'Provide detail explaination and sincere comments.\n'
                return string.format(prompt, filetype, code)
              end,
            },
          },
        },
      }
    end,
  },
}
