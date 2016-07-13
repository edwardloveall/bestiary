module Helpers
  def parse_html(html_string)
    Nokogiri::HTML::DocumentFragment.parse(html_string)
  end
end
