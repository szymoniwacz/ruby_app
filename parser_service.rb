# frozen_string_literal: true

class ParserService
  def initialize(file)
    @file = file
    raise Errno::ENOENT unless File.exist?(file)
  end

  def page_views
    views = Hash.new(0)

    each_line do |line|
      page, _ip = parse_line(line)
      views[page] += 1 if page
    end

    sorted_views(views)
  end

  def unique_page_views
    unique_views = Hash.new { |hash, key| hash[key] = [] }

    each_line do |line|
      page, ip = parse_line(line)
      unique_views[page] << ip if page && ip && !unique_views[page].include?(ip)
    end

    sorted_views(unique_views.transform_values(&:count))
  end

  private

  def each_line(&)
    File.readlines(@file).each(&)
  end

  def parse_line(line)
    page, ip = line.split
    return nil if page.nil? || ip.nil?

    [page, ip]
  end

  def sorted_views(views)
    views.sort_by { |page, count| [-count, page] }
  end
end
