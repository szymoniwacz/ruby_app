#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'parser_service'

if __FILE__ == $PROGRAM_NAME
  if ARGV.length != 1
    puts "Usage: #{$PROGRAM_NAME} <logfile>"
    exit 1
  end

  logfile = ARGV[0]
  parser = ParserService.new(logfile)

  puts 'Page views:'
  parser.page_views.each do |path, count|
    puts "#{path}: #{count} views"
  end

  puts "\nUnique page views:"
  parser.unique_page_views.each do |path, count|
    puts "#{path}: #{count} unique views"
  end
end
