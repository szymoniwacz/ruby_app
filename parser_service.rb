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
    []
  end

  private

  def each_line(&)
    File.readlines(@file).each(&)
  end

  def parse_line(line)
    page, ip = line.split

    [page, ip]
  end

  def sorted_views(views)
    views.sort_by { |page, count| [-count, page] }
  end
end
