# frozen_string_literal: true

class ParserService
  def initialize(file)
    @file = file
    raise Errno::ENOENT unless File.exist?(file)
  end

  def page_views
    []
  end

  def unique_page_views
    []
  end
end
