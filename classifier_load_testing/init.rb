#!/opt/puppetlabs/puppet/bin/ruby

require 'base64'
require 'json'

require 'net/http'
require 'openssl'

require 'securerandom'

require_relative './helpers'

begin
  # Get an API Auth Token

  instance = ENV['PE_INSTANCE']
  loopcount = ENV['loopcount'].to_i
  token = ENV['RBAC_TOKEN']
  allEnvironmentsID = nil
  allNodesID = nil
  classesParentGroupID = nil
  environmentsParentGroupID = nil

  # Get Parent Group IDs

  response = classifier_request('Get', 'groups')
  parsedBody = JSON.parse(response.body)

  allEnvironmentsGroup = parsedBody.find do |group|
    group['name'] == 'All Environments'
  end
  allEnvironmentsID = allEnvironmentsGroup['id']
  
  allNodesGroup = parsedBody.find do |group|
    group['name'] == 'All Nodes'
  end
  allNodesID = allNodesGroup['id']

  # Add Parent Groups

  data = {
    name: 'all-snow-environments',
    environment_trumps: true,
    parent: allEnvironmentsID,
    description: 'snow environments collection',
    classes: {},
  }

  response = classifier_request('Post','groups', data)
  environmentsParentGroupID = response.header['location'].split('/')[-1]

  data = {
    name: 'all-snow-classes-vars',
    parent: allNodesID,
    description: 'snow classes and vars',
    classes: {},
  }

  response = classifier_request('Post','groups', data)
  classesParentGroupID = response.header['location'].split('/')[-1]

  output = {'classesParentGroupID': classesParentGroupID,'environmentsParentGroupID': environmentsParentGroupID,'token': token,}.to_json
  puts output

rescue => e
  puts "ERROR: #{e}"
  raise e
end