# frozen_string_literal: true

#Dir.foreach('lib') do |filename|
#    puts filename
    # Do work on the remaining files & directories
#  end

Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

#Comment this out to use small dataset
#get_dataset

#get_workflows ARGV[0]

#get_actions
#web_scrape_actions

#get_issues ARGV[0]
#web_scrape_issues

#get_adoption_date
time_series ARGV[0]
