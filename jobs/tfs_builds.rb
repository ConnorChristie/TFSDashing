def api_request(url, auth = nil)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  if auth != nil
    request.basic_auth *auth
  end

  response = http.request(request)
  return JSON.parse(response.body)
end

def get_tfs_build_definitions(overview_id)
  url = "http://localhost:58885/api/BuildDefinitions?overviewId=#{overview_id}"
  results = api_request url

  results.each do |build_definition|
    build_definition['IsPassing'] = build_definition['LastPassingPercentage'] == 100
    build_definition['IsFailing'] = build_definition['LastPassingPercentage'] != 100

    build_definition['LastPassingPercentageFormatted'] = '%.1f%' % build_definition['LastPassingPercentage']
  end

  return results
end

def get_passing_percentage(build_definitions)
  passing_percentage = 0
  total_test_count = 0

  build_definitions.each do |build_definition|
    total_test_count += build_definition['LastTotalTestCount']
    passing_percentage += build_definition['LastPassingPercentage'] * build_definition['LastTotalTestCount']
  end

  passing_percentage = total_test_count != 0 ? (passing_percentage / total_test_count) : 0

  return {
      all_passing: passing_percentage == 100,
      passing_percentage: '%.1f%' % passing_percentage
  }
end

SCHEDULER.every '30s', :first_in => 0 do |job|
  build_definitions = get_tfs_build_definitions(1)

  send_event('tfs_passing', get_passing_percentage(build_definitions))
  send_event('tfs_builds', {builds: build_definitions})
end