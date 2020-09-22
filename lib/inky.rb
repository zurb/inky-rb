require 'nokogiri'
require_relative 'inky/configuration'
require_relative 'inky/component_factory'

module Inky
  class Core
    attr_accessor :components, :column_count, :component_lookup, :component_tags

    include ComponentFactory
    def initialize(options = {})
      self.components = {
        button: 'button',
        row: 'row',
        columns: 'columns',
        container: 'container',
        inky: 'inky',
        block_grid: 'block-grid',
        menu: 'menu',
        center: 'center',
        callout: 'callout',
        spacer: 'spacer',
        wrapper: 'wrapper',
        menu_item: 'item'
      }.merge(::Inky.configuration.components).merge(options[:components] || {})

      self.component_lookup = components.invert

      self.column_count = options[:column_count] || ::Inky.configuration.column_count

      self.component_tags = components.values
    end

    def release_the_kraken(html_string)
      if html_string.encoding.name == "ASCII-8BIT"
        html_string.force_encoding('utf-8') # transform_doc barfs if encoding is ASCII-8bit
      end
      html_string = html_string.gsub(/doctype/i, 'DOCTYPE')
      raws, str = Inky::Core.extract_raws(html_string)
      parse_cmd = str =~ /<html/i ? :parse : :fragment
      html = Nokogiri::HTML.public_send(parse_cmd, str)
      transform_doc(html)
      string = html.to_html
      string.gsub!(INTERIM_TH_TAG_REGEX, 'th')
      Inky::Core.re_inject_raws(string, raws)
    end

    def transform_doc(elem)
      if elem.respond_to?(:children)
        elem.children.each do |child|
          transform_doc(child)
        end
        component = component_factory(elem)
        elem.replace(component) if component
      end
      elem
    end

    def self.extract_raws(string)
      raws = []
      i = 0
      regex = %r((?:\n *)?< *raw *>([\s\S]*?)</ *raw *>(?: *\n)?)i
      str = string
      while raw = str.match(regex)
        raws[i] = raw[1]
        str = str.sub(regex, "###RAW#{i}###")
        i += 1
      end
      [raws, str]
    end

    def self.re_inject_raws(string, raws)
      str = string
      raws.each_with_index do |val, i|
        str = str.sub("###RAW#{i}###", val)
      end
      # If we're in rails, these should be considered safe strings
      str = str.html_safe if str.respond_to?(:html_safe)
      str
    end
  end
end
begin
  # Only valid in rails environments
  require 'foundation_emails'
  require 'inky/rails/engine'
  require 'inky/rails/template_handler'
  require 'inky/rails/version'
rescue LoadError
end
