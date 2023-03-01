require "simpler_navigation/renderers/base"

module SimplerNavigation
  module Renderers
    class List < Base
      def render
        list = []
        @item.children.each_value do |item|
          next unless show?(item)

          li_content = link_tag(item)
          if include_sub_navigation?(item)
            li_content << List.new(@context, item, @options).render
          end

          if @options[:render_content_partials] && item.options[:content_partial]
            li_content << @context.render(partial: item.options[:content_partial])
          end

          list << content_tag(:li, li_content, wrapper_tag_options(item))
        end

        content_tag(:ul, safe_join(list))
      end
    end
  end
end
