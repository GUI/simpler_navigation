require "simpler_navigation/renderers/base"

module SimplerNavigation
  module Renderers
    class Breadcrumb < Base
      def render
        return "" if @item.nil?

        tags = crumb_tags(@item)

        content_tag(:ol, safe_join(tags), @options[:attributes])
      end

      private

      def crumb_tags(parent_item)
        tags = []

        parent_item.children.each_value do |item|
          next unless show?(item) && selected?(item)

          active = active_leaf?(item)
          li_content = if @options[:static_leaf] && active
            content_tag("span", item.name, link_tag_options(item))
          else
            link_tag(item)
          end

          li_options = wrapper_tag_options(item)
          if active
            li_options[:"aria-current"] = "page"
          end

          tags << content_tag(:li, li_content, li_options)

          if include_sub_navigation?(item)
            tags += crumb_tags(item)
          end
        end

        tags
      end

      def link_tag_options(item)
        options = super
        options.delete(:class)

        options
      end
    end
  end
end
