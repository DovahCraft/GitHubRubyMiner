# frozen_string_literal: true

require 'octokit'
require 'tty-spinner'

def check_rate_limit(client, x, spinner, tokens)
    num_tokens = tokens.length();
    #Check if we have a client 
    client.nil? ? rate_remaining = 0 : rate_remaining = client.rate_limit.remaining
    curr_index = 0
    #Refactored to while instead of if with redo.
    while rate_remaining <= x and curr_index < num_tokens
        spinner.error('ERROR: Rate limit exceeded! Changing token')
        spinner = TTY::Spinner.new("[:spinner] Checking rate limit for token: #{tokens[curr_index]}...", format: :classic)
        spinner.auto_spin

        sleep(5) # additional 10 second cooldown

        
        #If we have trouble authenticating, use a new token.
        begin
            #Check if this token is valid before authing.
            client = authenticate(tokens[curr_index])
            rate_remaining = client.rate_limit.remaining   
        rescue => e
            errbak = e.backtrace
            puts errbak
            rate_remaining = 0
        end
        curr_index += 1
        #Ran outta tokens. 
        if curr_index == num_tokens
            curr_index == 0
            #Sleep for longer before checking again.
            spinner.error('WARN: Ran outta tokens, sleeping then retrying.')
            sleep(1500) 
        end
        
        spinner.success
        spinner = TTY::Spinner.new("[:spinner] Continuing ...", format: :classic)
      
    end
    return client
end
