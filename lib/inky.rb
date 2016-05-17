module Inky
  class Core
    require 'rexml/document'
    require 'component_factory'
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
      }.merge(options[:components] || {})

      self.component_lookup = self.components.invert

      self.column_count = options[:column_count] || 12

      self.component_tags = self.components.values
    end


    def release_the_kraken(xml_string)
      xml_string = xml_string.gsub(/doctype/i, 'DOCTYPE')
      xml_doc = REXML::Document.new(xml_string)
      if self.components_exist?(xml_doc)
        self.transform_doc(xml_doc.root)
      end
      return xml_doc.to_s
    end


    def components_exist?(xml_doc)
      true
    end

    def transform_doc(elem)
      if elem.respond_to?(:children)
        elem.children.each do |child|
          transform_doc(child)
        end
        component = self.component_factory(elem)
        elem.replace_with(component) if component
      end
      elem
    end
  end
end
begin
  # Only valid in rails environments
  require 'inky/rails/engine'
  require 'inky/rails/template_handler'
  require 'inky/rails/version'
rescue LoadError
end