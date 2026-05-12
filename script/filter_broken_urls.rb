#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Simple, fast URL checker for filtering broken gem homepage URLs
# Usage: ruby script/filter_broken_urls_simple.rb <input.yml> <output.yml> <workers> <limit>
#

require 'yaml'
require 'net/http'
require 'uri'
require 'timeout'
require 'thread'

def valid_url?(url)
  return false if url.nil? || url.strip.empty?

  # Fix common URL issues
  url = "https://#{url}" if url.match?(/^git(hub|lab).com/)

  uri = URI.parse(url)
  return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

  check_url(uri)
rescue URI::InvalidURIError, StandardError
  false
end

def check_url(uri)
  http = Net::HTTP.new(uri.host, uri.port)

  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  end

  request = Net::HTTP::Get.new(uri.request_uri)
  request['User-Agent'] = 'Mozilla/5.0 (compatible; GemSession/1.0; +https://gem-session.example.com)'

  Timeout.timeout(5) do
    response = http.request(request)
    # Consider 2xx and 3xx as success (3xx = redirect, which is fine)
    response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
  end
rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH,
  OpenSSL::SSL::SSLError, SocketError, StandardError
  false
end

def process_gems(input_file, output_file, workers = 4, limit = nil)
  gems = YAML.load_file(input_file)

  if limit && limit > 0
    gems = gems.first(limit)
    puts "Limiting to first #{limit} gems for testing"
  end

  puts "Loaded #{gems.size} gems from #{input_file}"
  puts "Checking URLs with #{workers} workers..."

  # Prepare work: [name, url, gem_data]
  work_queue = Queue.new
  gems.each { |name, data| work_queue.push([name, data['homepage_url'], data]) }

  valid_gems = {}
  mutex = Mutex.new
  processed = 0
  total = gems.size
  removed_count = 0

  workers = [ workers, total ].min
  threads = []

  workers.times do
    threads << Thread.new do
      while true
        begin
          name, url, data = work_queue.pop(true)
          result = valid_url?(url)

          mutex.synchronize do
            processed += 1
            if result
              valid_gems[name] = data
            else
              removed_count += 1
              puts "Removed #{name} (broken URL: #{url})" if removed_count <= 10 || removed_count % 100 == 0
            end

            if processed % 100 == 0
              print "\rProcessed #{processed}/#{total} (#{valid_gems.size} valid, #{removed_count} removed)..."
              $stdout.flush
            end
          end
        rescue ThreadError
          break
        end
      end
    end
  end

  threads.each(&:join)
  puts "\rProcessed #{processed}/#{total} (#{valid_gems.size} valid, #{removed_count} removed)..."
  puts "\nDone! #{valid_gems.size} gems with valid URLs out of #{total}"

  # Sort by gem name (case-insensitively) to maintain consistent ordering
  sorted_gems = valid_gems.sort_by { |name, _| name.downcase }.to_h
  File.write(output_file, sorted_gems.to_yaml(line_width: -1))
  puts "Saved to #{output_file}"
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.size < 2 || ARGV.size > 4
    puts "Usage: #{$PROGRAM_NAME} <input.yml> <output.yml> [workers] [limit]"
    puts "  workers: number of parallel workers (default: 4)"
    puts "  limit: max gems to process (for testing)"
    exit(1)
  end

  input_file = ARGV[0]
  output_file = ARGV[1]
  workers = ARGV[2]&.to_i || 4
  limit = ARGV[3]&.to_i || nil

  unless File.exist?(input_file)
    puts "Error: Input file #{input_file} does not exist"
    exit(1)
  end

  process_gems(input_file, output_file, workers, limit)
end
