#!/usr/bin/env ruby

require_relative './helpers'

num_nodes = get_arg("num_nodes", 0)
start_at = get_arg("start_at", 1).to_i
per_node_delay = get_arg("per_node_delay", 2).to_i

create_csv = get_arg("create_csv?", 3)
unless ["true", "false"].include?(create_csv)
  raise "create_csv? must be 'true' or 'false'"
end
create_csv = (create_csv == "true") ? true : false

env_group_parent_id = get_group_id('all-snow-environments')
cv_group_parent_id = get_group_id('all-snow-classes-vars')

if create_csv
  File.write('timing.csv',"node, group, parent, elapsedTime \n")
end

overallElapsedTime = time_block do
  # Common helper that removes the "with_retry", "time_block" clutter.
  # Helper returns how long it took to create the group.
  create_group = lambda do |group|
    retryDelay = per_node_delay.zero? ? 5 : 5 * per_node_delay
    with_retry("Create the #{group['name']} group", 3, retryDelay) do
      time_block do
        classifier_request('Post', 'groups', group)
      end
    end
  end

  num_nodes.to_i.times do |node|
    node = node + start_at
    node_name = "node#{node}"
    if (node % 100) == 0
      puts(node_name)
    end

    rule = ["=", "name", node_name]

    # Create the node's environment group
    envGroupElapsedTime = create_group.call({
      'name' => "#{node_name}_environment",
      'parent' => env_group_parent_id,
      'environment' => "#{node_name}_environment",
      'environment_trumps' => true,
      'rule' => rule,
      'classes' => {},
    })
    File.write('timing.csv', "#{node_name}, #{node_name}_environment, all-snow-environments, #{envGroupElapsedTime}\n", mode: 'a')

    # Create the node's classes/variables group
    cvGroupElapsedTime = create_group.call({
      'name' => "#{node_name}_classes_vars",
      'parent' => cv_group_parent_id,
      'rule' => rule,
      'classes' => {},
      'variables' => {'foo' => 5},
    })
    File.write('timing.csv', "#{node_name}, #{node_name}_classes_vars, all-snow-classes-vars, #{cvGroupElapsedTime}\n", mode: 'a')

    sleep per_node_delay
  end
end

puts overallElapsedTime
