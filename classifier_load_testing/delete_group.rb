#!/usr/bin/env ruby

require_relative './helpers'

group_name = get_arg("group_name", 0)
# A successfull delete returns a nil output so we can just swallow it.
classifier_request('Delete', "groups/#{get_group_id(group_name)}")
