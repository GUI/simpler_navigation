require "simpler_navigation/renderers/base"

module SimplerNavigation
  module Renderers
    class Breadcrumb < Base
      def render
        return "" if @item.nil?

        tags = crumb_tags(@item)

        join_with = @options[:join_with] || " "
        content_tag(:div, safe_join(tags, join_with))
      end

      private

      def crumb_tags(parent_item)
        tags = []

        parent_item.children.each_value do |item|
          next unless show?(item) && selected?(item)

          tags << if @options[:static_leaf] && active_leaf?(item)
            content_tag("span", item.name, link_tag_options(item))
          else
            link_tag(item)
          end

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
