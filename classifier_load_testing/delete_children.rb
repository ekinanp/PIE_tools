#!/usr/bin/env ruby

require_relative './helpers'

group_name = get_arg("group_name", 0)
delete_children(get_group_id(group_name))
