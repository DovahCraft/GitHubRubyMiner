# frozen_string_literal: true

require 'octokit'
require 'tty-spinner'

def check_rate_limit(client, x, spinner, tokens)
    num_tokens = tokens.length();
    #Refactored to while instead of if with redo.
    rate_remaining = client.rate_limit.remaining
    curr_index = 0
    while rate_remaining <= x and curr_index < num_tokens
        spinner.error('ERROR: Rate limit exceeded! Changing token')
        spinner = TTY::Spinner.new("[:spinner] Rate limit resets in #{client.rate_limit.resets_in + 10} seconds ...", format: :classic)
        spinner.auto_spin

        sleep(10) # additional 10 second cooldown

        curr_index += 1
        client = authenticate(tokens[curr_index])
        rate_remaining = client.rate_limit.remaining
        if curr_index == num_tokens then curr_index == 0 end
        
        spinner.success
        spinner = TTY::Spinner.new("[:spinner] Continuing ...", format: :classic)
      
    end
    return client
end
