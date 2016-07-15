module Helpers
  def parse_html(html_string)
    Nokogiri::HTML::DocumentFragment.parse(html_string)
  end

  def fixture_load(file_name)
    this_dir = File.dirname(__FILE__)
    fixture_path = File.expand_path("../fixtures/#{file_name}", this_dir)
    File.read(fixture_path)
  end
end
