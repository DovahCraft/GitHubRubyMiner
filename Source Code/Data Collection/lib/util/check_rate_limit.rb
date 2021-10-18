# frozen_string_literal: true

require 'octokit'
require 'tty-spinner'

def check_rate_limit(client, x, spinner)
    #Refactored to while instead of if with redo. 
    while client.rate_limit.remaining <= x
        spinner.error('ERROR: Rate limit exceeded!')
        spinner = TTY::Spinner.new("[:spinner] Rate limit resets in #{client.rate_limit.resets_in + 10} seconds ...", format: :classic)
        spinner.auto_spin

        sleep(client.rate_limit.resets_in + 10) # additional 10 second cooldown

        spinner.success

        spinner = TTY::Spinner.new("[:spinner] Continuing ...", format: :classic)
    end
end
