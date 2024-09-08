# frozen_string_literal: true

require_relative '../parser_service'

# rubocop:disable Metrics/BlockLength
RSpec.describe ParserService do
  let(:log_file) { 'spec/fixtures/webserver.log' }

  context 'when parsing the log file' do
    it 'returns page views ordered from most to least' do
      parser = ParserService.new(log_file)
      result = parser.page_views

      expect(result).to eq([
        ['/home', 30],
        ['/about', 26],
        ['/index', 23],
      ])
    end

    it 'returns unique page views ordered from most to least' do
      parser = ParserService.new(log_file)
      result = parser.unique_page_views

      expect(result).to eq([
        ['/home', 30],
        ['/about', 26],
        ['/index', 23],
      ])
    end
  end

  context 'with an empty log file' do
    let(:empty_log_file) { 'spec/fixtures/empty.log' }

    it 'returns an empty list for page views' do
      parser = ParserService.new(empty_log_file)
      result = parser.page_views
      expect(result).to be_empty
    end

    it 'returns an empty list for unique page views' do
      parser = ParserService.new(empty_log_file)
      result = parser.unique_page_views
      expect(result).to be_empty
    end
  end

  context 'with a log file containing duplicates' do
    let(:duplicate_log_file) { 'spec/fixtures/duplicate.log' }

    it 'counts multiple entries from the same IP only once for unique views' do
      parser = ParserService.new(duplicate_log_file)
      result = parser.unique_page_views

      expect(result).to eq([
        ['/home', 1],
        ['/index', 1],
      ])
    end
  end

  context 'with a log file containing missing data' do
    let(:invalid_log_file) { 'spec/fixtures/invalid.log' }

    it 'skips invalid entries' do
      parser = ParserService.new(invalid_log_file)
      result = parser.page_views

      expect(result).to eq([
        ['/home', 1],
      ])
    end
  end

  context 'when log file is missing' do
    let(:non_existent_log_file) { 'spec/fixtures/nonexistent.log' }

    it 'raises an error if the log file does not exist' do
      expect { ParserService.new(non_existent_log_file) }.to raise_error(Errno::ENOENT)
    end
  end

  context 'with invalid log format' do
    let(:log_with_invalid_format) { 'spec/fixtures/invalid_format.log' }

    it 'handles lines with missing IP or page gracefully' do
      parser = ParserService.new(log_with_invalid_format)
      result = parser.page_views

      expect(result).to be_empty
    end
  end

  context 'with ordering' do
    let(:log_with_tied_views) { 'spec/fixtures/tied_views.log' }

    it 'orders pages with equal views alphabetically' do
      parser = ParserService.new(log_with_tied_views)
      result = parser.page_views

      expect(result).to eq([
        ['/about', 2],
        ['/home', 2],
        ['/index', 1],
      ])
    end

    it 'orders pages with equal unique views alphabetically' do
      parser = ParserService.new(log_with_tied_views)
      result = parser.unique_page_views

      expect(result).to eq([
        ['/about', 2],
        ['/home', 2],
        ['/index', 1],
      ])
    end
  end
end
# rubocop:enable Metrics/BlockLength
