return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
      { 'github/copilot.vim' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'claude-opus-4.6',
    },
    keys = {
      -- Toggle Chat
      { '<leader>cc', '<cmd>CopilotChatToggle<cr>', desc = 'Toggle Copilot Chat' },
      -- Quick actions on visual selection
      { '<leader>ce', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'Explain selected code' },
      { '<leader>cr', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'Review selected code' },
      { '<leader>cf', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = 'Fix selected code' },
      { '<leader>co', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = 'Optimize selected code' },
      { '<leader>cd', '<cmd>CopilotChatDocs<cr>', mode = 'v', desc = 'Generate docs for selection' },
      { '<leader>ct', '<cmd>CopilotChatTests<cr>', mode = 'v', desc = 'Generate tests for selection' },
      -- Quick chat with selection
      {
        '<leader>cq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then require('CopilotChat').ask(input, { selection = require('CopilotChat.select').visual }) end
        end,
        mode = 'v',
        desc = 'Quick chat with selection',
      },
      -- Workspace prompt
      {
        '<leader>cw',
        function()
          local input = vim.fn.input 'Workspace Prompt: '
          if input ~= '' then require('CopilotChat').ask(input, { context = { 'file', 'buffer' } }) end
        end,
        desc = 'CopilotChat - Project Workspace Prompt',
      },
      -- Commit message
      { '<leader>cm', '<cmd>CopilotChatCommit<cr>', desc = 'Generate commit message' },
      -- Reset chat
      { '<leader>cx', '<cmd>CopilotChatReset<cr>', desc = 'Reset chat' },
      -- Custom Jira Code Review Agent
      { '<leader>cj', function() require('custom.utils.jira-agent').run_review_agent() end, desc = 'Review branch diff against Jira ticket' },
    },
  },
}
