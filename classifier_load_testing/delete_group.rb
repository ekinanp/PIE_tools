require_relative './helpers'

groupID = ENV['GROUP_ID']

raise "GROUP_ID environment variable not set" if groupID.nil?

# A successfull delete returns a nil output. So we capture the output
# and swollow it.
output = classifier_request('Delete', "groups/#{groupID}")
