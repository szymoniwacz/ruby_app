# frozen_string_literal: true

class ParserService
  attr_reader :file, :all_page_views, :unique_views

  def initialize(file)
    @file = file
    raise Errno::ENOENT unless File.exist?(file)

    @all_page_views = Hash.new(0)
    @unique_views = Hash.new { |hash, key| hash[key] = [] }
    @parsed = false
  end

  def page_views
    parse_logs unless parsed
    sorted_views(all_page_views)
  end

  def unique_page_views
    parse_logs unless parsed
    sorted_views(unique_views.transform_values(&:count))
  end

  private

  attr_accessor :parsed

  def parse_logs
    return if parsed

    each_line do |line|
      page, ip = parse_line(line)
      next unless page && ip

      all_page_views[page] += 1
      unique_views[page] << ip unless unique_views[page].include?(ip)
    end
    self.parsed = true
  end

  def each_line(&)
    File.readlines(file).each(&)
  end

  def parse_line(line)
    page, ip = line.split
    return [nil, nil] if page.nil? || ip.nil?

    [page, ip]
  end

  def sorted_views(views)
    views.sort_by { |page, count| [-count, page] }
  end
end
