require 'xmlrpc/client'
require 'soap/wsdlDriver'
require 'rexml/document'

# Bugzilla requests are performed using the xmlrpc client
# Jira uses Net:HTTP + JSON

class Ticket
  def self.version
    settings = ticket_settings

    if settings['system'] == 'Bugzilla'
      server = XMLRPC::Client.new2(settings['url'])
      bugzilla = server.proxy('Bugzilla')
      return bugzilla.version

    elsif settings['system'] == 'Jira'
      # Build the URI
      # It is assumed that the URL fully includes the API path
      uri = URI(settings['url'] + 'serverInfo')
      # Build the requests
      req = Net::HTTP::Get.new(uri.request_uri)
      # Add authentication info
      req.basic_auth settings['username'], settings['password']
      # Enable ssl if uri starts with https
      if uri.scheme == 'https'
        req.use_ssl = true
        # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      # Run the request
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      # Was there a 2xx pass result
      if Net::HTTPSuccess === result
        # Result is in json... break it down
        jsonResult = ActiveSupport::JSON.decode(result.body)
        # and return the version
        return jsonResult['version']
      else
        return 'ERROR'
      end

    elsif settings['system'] == 'Mantis'
      # Build the URL
      url = settings['url'] + 'api/soap/mantisconnect.php?wsdl'
      # Create the soap entity
      client = SOAP::WSDLDriverFactory.new(url).create_rpc_driver
      # Generate the request
      request = client.mc_version
      # Return the version
      return request

    elsif settings['system'] == 'Redmine'
      # There is no api command in mantis for this.
      # We simply inform users
      return 'The Mantis API does not have a version command'
    end
  end

  # Takes an array of bug numbers
  def self.bug_status(ids)
    bug_status = {}
    settings = ticket_settings

    # Using XML we can query all statuses at once
    if settings['system'] == 'Bugzilla'
      server = XMLRPC::Client.new2(settings['url'])
      ok, result = server.call2('Bug.get', ids: ids, include_fields: %w(id status summary), Bugzilla_login: settings['username'], Bugzilla_password: settings['password'])

      if ok
        result['bugs'].each do |bug|
          bug_status[bug['id'].to_s] = { status: bug['status'], name: bug['summary'] }
        end
      else
        bug_status['error'] = true
        puts result.faultCode
        puts result.faultString
      end

    elsif settings['system'] == 'Jira'
      # Jira, need to query each bug one by one and add to hash
      ids.each do |id|
        # Build the URI
        # It is assumed that the URL fully includes the API path
        uri = URI(settings['url'] + 'issue/' + id)
        # Build the requests
        req = Net::HTTP::Get.new(uri.request_uri)
        # Add authentication info
        req.basic_auth settings['username'], settings['password']
        # Enable ssl if uri starts with https
        if uri.scheme == 'https'
          req.use_ssl = true
          # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        # Run the request
        result = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end

        # Was there a 2xx pass result
        if Net::HTTPSuccess === result
          # Result is in json... break it down
          jsonResult = ActiveSupport::JSON.decode(result.body)

          # and add the status to the hash
          bug_status[id] = { status: jsonResult['fields']['status']['value']['name'], name: jsonResult['fields']['summary']['value'] }
        else
          bug_status['error'] = true
        end
      end

    elsif settings['system'] == 'Mantis'
      # Build the URL
      url = settings['url'] + 'api/soap/mantisconnect.php?wsdl'

      # There can be issues with initial contact, example, bad url.
      # We capture it here
      begin
        # Create the soap entity
        client = SOAP::WSDLDriverFactory.new(url).create_rpc_driver
      rescue
        bug_status['error'] = true
      end

      # Mantis, need to query each bug one by one and add to hash
      # Notice that we have one wisdldriver object
      ids.each do |id|
        request = nil
        # STart the request
        begin
          # Generate the issue get request
          request = client.mc_issue_get(settings['username'], settings['password'], id)
        # IF there is a soap error, we set error here
        rescue
          bug_status['error'] = true
        # Otherwise we record the value
        else
          bug_status[id] = { status: request['status']['name'], name: request['summary'] }
        end
      end

    elsif settings['system'] == 'Redmine'
      # Mantis, need to query each bug one by one and add to hash
      ids.each do |id|
        # Build the URI
        # It is assumed that the URL fully includes the API path
        uri = URI(settings['url'] + 'issues/' + id + '.xml')
        # Build the requests
        req = Net::HTTP::Get.new(uri.request_uri)
        # Add authentication info
        req.basic_auth settings['username'], settings['password']
        # Enable ssl if uri starts with https
        if uri.scheme == 'https'
          req.use_ssl = true
          # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        # Run the request
        result = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end

        # Was there a 2xx pass result
        if Net::HTTPSuccess === result
          # Result is in xml... break it down
          xmlResult = REXML::Document.new(result.body)

          # and add the status to the hash
          # We need the value of name for the status element
          bug_status[id] = { id: xmlResult.elements['//id'].text,
                             status: xmlResult.elements['//status'].attributes['name'],
                             name: xmlResult.elements['//subject'].text,
                             description: xmlResult.elements['//description'].text }
        else
          bug_status['error'] = true
        end
      end
    end

    bug_status
  end

  def self.project_issues(project_id, version_id = 0)
    issues = []
    settings = ticket_settings
    if settings['system'] == 'Redmine'
      # Build the URI
      # It is assumed that the URL fully includes the API path
      parameters = 'project_id=' + project_id.to_s + '&limit=200&status_id=*'
      if version_id != 0
        parameters = parameters + '&fixed_version_id=' + version_id.to_s
      end
      uri = URI(settings['url'] + 'issues.xml?' + parameters)
      # Build the requests
      req = Net::HTTP::Get.new(uri.request_uri)
      # Add authentication info
      req.basic_auth settings['username'], settings['password']
      # Enable ssl if uri starts with https
      if uri.scheme == 'https'
        req.use_ssl = true
        # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      # Run the request
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      # Was there a 2xx pass result
      if Net::HTTPSuccess === result
        # Result is in xml... break it down
        xml_result = REXML::Document.new(result.body)

        # and add the status to the hash
        # We need the value of name for the status element
        xml_result.elements.each('//issue') do |element|
          issue = {}
          issue[:id] = element.elements['id'].text
          issue[:status] = element.elements['status'].attributes['name']
          issue[:name] = element.elements['subject'].text
          issue[:description] = element.elements['description'].text
          issue[:version] = element.elements['fixed_version'].attributes['name']
          issues.push(issue)
        end
      else
        issues['error'] = true
      end
    end
    issues
  end

  def self.projects
    ticket_projects = []
    settings = ticket_settings
    if settings['system'] == 'Redmine'
      # Build the URI
      # It is assumed that the URL fully includes the API path
      uri = URI(settings['url'] + 'projects.xml')
      # Build the requests
      req = Net::HTTP::Get.new(uri.request_uri)
      # Add authentication info
      req.basic_auth settings['username'], settings['password']
      # Enable ssl if uri starts with https
      if uri.scheme == 'https'
        req.use_ssl = true
        # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      # Run the request
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      # Was there a 2xx pass result
      if Net::HTTPSuccess === result
        # Result is in xml... break it down
        xml_result = REXML::Document.new(result.body)

        # and add the status to the hash
        # We need the value of name for the status element
        xml_result.elements.each('//project') do |element|
          ticket_project = {}
          ticket_project[:id] = element.elements['id'].text
          ticket_project[:name] = element.elements['name'].text
          ticket_projects.push(ticket_project)
        end
      end
    end
    ticket_projects
  end

  def self.projects_info(ids)
    ticket_project = {}
    settings = ticket_settings
    if settings['system'] == 'Redmine'
      # Mantis, need to query each bug one by one and add to hash
      ids.each do |id|
        # Build the URI
        # It is assumed that the URL fully includes the API path
        uri = URI(settings['url'] + 'projects/' + id + '.xml')
        # Build the requests
        req = Net::HTTP::Get.new(uri.request_uri)
        # Add authentication info
        req.basic_auth settings['username'], settings['password']
        # Enable ssl if uri starts with https
        if uri.scheme == 'https'
          req.use_ssl = true
          # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        # Run the request
        result = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end

        # Was there a 2xx pass result
        if Net::HTTPSuccess === result
          # Result is in xml... break it down
          xml_result = REXML::Document.new(result.body)

          # and add the status to the hash
          # We need the value of name for the status element
          ticket_project[id] = { name: xml_result.elements['//name'].text, description: xml_result.elements['//description'].text }
        else
          ticket_project['error'] = true
        end
      end
    end
    ticket_project
  end

  def self.project_version(project_id)
    ticket_versions = []
    settings = ticket_settings
    if settings['system'] == 'Redmine'
      # Build the URI
      # It is assumed that the URL fully includes the API path
      uri = URI(settings['url'] + 'projects/' + project_id + '/versions.xml')
      # Build the requests
      req = Net::HTTP::Get.new(uri.request_uri)
      # Add authentication info
      req.basic_auth settings['username'], settings['password']
      # Enable ssl if uri starts with https
      if uri.scheme == 'https'
        req.use_ssl = true
        # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      # Run the request
      result = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end

      # Was there a 2xx pass result
      if Net::HTTPSuccess === result
        # Result is in xml... break it down
        xml_result = REXML::Document.new(result.body)

        # and add the status to the hash
        # We need the value of name for the status element
        xml_result.elements.each('//version') do |element|
          ticket_version = {}
          ticket_version[:id] = element.elements['id'].text
          ticket_version[:name] = element.elements['name'].text
          ticket_version[:description] = element.elements['description'].text
          ticket_version[:status] = element.elements['status'].text
          ticket_versions.push(ticket_version)
        end
      end
    end
    ticket_versions
  end

  def self.versions_info(ids)
    ticket_version = {}
    settings = ticket_settings
    if settings['system'] == 'Redmine'
      # Mantis, need to query each bug one by one and add to hash
      ids.each do |id|
        # Build the URI
        # It is assumed that the URL fully includes the API path
        uri = URI(settings['url'] + 'versions/' + id.to_s + '.xml')
        # Build the requests
        req = Net::HTTP::Get.new(uri.request_uri)
        # Add authentication info
        req.basic_auth settings['username'], settings['password']
        # Enable ssl if uri starts with https
        if uri.scheme == 'https'
          req.use_ssl = true
          # req.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        # Run the request
        result = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end

        # Was there a 2xx pass result
        if Net::HTTPSuccess === result
          # Result is in xml... break it down
          xml_result = REXML::Document.new(result.body)

          # and add the status to the hash
          # We need the value of name for the status element
          ticket_version[id] = {
            name: xml_result.elements['//name'].text,
            description: xml_result.elements['//description'].text,
            status: xml_result.elements['//status'].text
          }
        else
          ticket_version['error'] = true
        end
      end
    end
    ticket_version
  end

  private

  # Retrieves a list of ticket settings and returns a hash with URL, username, password
  def self.ticket_settings
    settings = {}
    settings['system'] = Setting.value('Ticket System')
    settings['username'] = Setting.value('Ticket System Username')
    settings['password'] = Setting.value('Ticket System Password')

    # For bugzilla we need to add the xmlrpc.cgi. It is the same for all systems
    # For other systems, not required
    if settings['system'] == 'Bugzilla'
      settings['url'] = Setting.value('Ticket System Url') + 'xmlrpc.cgi'
    else
      settings['url'] = Setting.value('Ticket System Url')
    end

    settings
  end
end
