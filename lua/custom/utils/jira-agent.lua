local M = {}

function M.run_review_agent()
  -- 1. Auto-detect ticket ID from git branch name
  local active_branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('%s+', '')
  local guessed_id = active_branch:match '([^/]+-[0-9]+)' -- Matches e.g., PROJ-123

  -- 2. Prompt for Ticket ID (pre-filled with guess if available)
  local ticket_id = vim.fn.input('Enter Jira Ticket ID: ', guessed_id or '')
  if ticket_id == '' then
    print '\n[Jira Review] Ticket ID is required.'
    return
  end

  -- 3. Retrieve environment credentials
  local jira_url = os.getenv 'JIRA_INSTANCE'
  local jira_email = os.getenv 'JIRA_EMAIL'
  local jira_token = os.getenv 'JIRA_TOKEN'

  if not jira_url or not jira_email or not jira_token then
    print '\n[Jira Review] Error: Missing environment variables (JIRA_INSTANCE, JIRA_EMAIL, JIRA_TOKEN).'
    return
  end

  print '\n[Jira Review] Fetching ticket details...'

  -- 4. Execute API request against Jira Cloud Rest API v3
  local api_endpoint = string.format('%s/rest/api/3/issue/%s', jira_url, ticket_id)
  local curl_cmd = string.format("curl -s --user '%s:%s' -H 'Accept: application/json' '%s'", jira_email, jira_token, api_endpoint)

  local raw_json = vim.fn.system(curl_cmd)
  local status, parsed = pcall(vim.fn.json_decode, raw_json)

  if not status or not parsed or not parsed.fields then
    print '\n[Jira Review] Error: Failed to fetch or parse API payload. Verify credentials/network.'
    return
  end

  -- 5. Extract summary and process Jira Document Format (ADF) description fields
  local summary = parsed.fields.summary or 'No Summary'
  local description = ''

  if type(parsed.fields.description) == 'table' then
    for _, block in ipairs(parsed.fields.description.content or {}) do
      for _, text_node in ipairs(block.content or {}) do
        if text_node.text then description = description .. text_node.text .. '\n' end
      end
    end
  else
    description = parsed.fields.description or 'No Description Provided'
  end

  local jira_context_string = string.format('ID: %s\nSummary: %s\nDescription:\n%s', ticket_id, summary, description)

  -- 6. Collect Git unified diff from development divergence
  local target_branch = vim.fn.input('Enter target branch for diff (default: develop): ', 'develop')
  local diff_output = vim.fn.system(string.format('git diff %s 2>/dev/null', target_branch))
  if diff_output == '' then
    print(string.format('\n[Jira Review] Warning: No differences detected against branch "%s". Attempting fallback to "dev"...', target_branch))
    diff_output = vim.fn.system 'git diff dev 2>/dev/null'
  end

  if diff_output == '' then
    print "\n[Jira Review] Error: No local working branch difference detected against 'develop' or 'dev'."
    return
  end

  -- 7. Combine template strings cleanly here in regular Lua logic
  local complete_prompt = string.format(
    'You are an expert code reviewer. Review the provided git diff against the requirements of the Jira ticket. Check for bugs, architectural consistency, edge cases, performance bottlenecks, and adherence to clean backend engineering principles.\n\n### JIRA TICKET DETAILS:\n%s\n\n### GIT DIFF (current vs develop):\n%s',
    jira_context_string,
    diff_output
  )

  -- 8. Programmatically push execution directly to the Chat window agent interface
  print '\n[Jira Review] Sending payload to Copilot...'
  require('CopilotChat').ask(complete_prompt, {
    system_prompt = 'You are a strict and helpful senior backend engineer doing a PR review.',
  })
end

return M
