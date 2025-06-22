require "action_view"

module SimplerNavigation
  module Renderers
    class Base
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::OutputSafetyHelper

      attr_reader :context
      attr_reader :item
      attr_reader :options

      def initialize(context, item, options = {})
        @selected = {}
        @active_leaf = {}
        @show = {}

        @context = context
        @item = item
        @options = options

        @options[:level] ||= :all

        @request_fullpath = context.request.fullpath
        if @options[:request_fullpath]
          @request_fullpath = @options[:request_fullpath]
        end

        if @item.nil?
          case @options[:level]
          when :all
            @item = SimplerNavigation.config.root_item
          when Integer
            @item = find_parent_item_for_level(SimplerNavigation.config.root_item, @options[:level])
          when Range
            @item = find_parent_item_for_level(SimplerNavigation.config.root_item, @options[:level].min)
          else
            raise Error, "Invalid navigation level: #{@options[:level]}"
          end
        end
      end

      protected

      def find_parent_item_for_level(item, level)
        parent_item = nil

        if item.level == (level - 1)
          parent_item = item
        elsif item.children.any?
          selected_child = item.children.find { |key, value| selected?(value) }&.last
          if selected_child
            parent_item = find_parent_item_for_level(selected_child, level)
          end
        end

        parent_item
      end

      def link_tag(item)
        link_to(item.name, item.url, link_tag_options(item))
      end

      def link_tag_options(item)
        render_options = @options[:link_html] || {}
        item_options = item.options[:link_html] || {}
        options = render_options.merge(item_options)

        classes = []
        if render_options[:class]
          classes << render_options[:class]
        end
        if item_options[:class]
          classes << item_options[:class]
        end
        if selected?(item)
          classes << (@options[:selected_class] || SimplerNavigation.config.selected_class)
        end
        options[:class] = classes.compact.join(" ")
        if options[:class].empty?
          options.delete(:class)
        end

        options
      end

      def wrapper_tag_options(item)
        render_options = @options[:html] || {}
        item_options = item.options[:html] || {}
        options = render_options.merge(item_options)

        classes = []
        if render_options[:class]
          classes << render_options[:class]
        end
        if item_options[:class]
          classes << item_options[:class]
        end
        if selected?(item)
          classes << (@options[:selected_class] || SimplerNavigation.config.selected_class)
        end
        if active_leaf?(item)
          classes << (@options[:active_leaf_class] || SimplerNavigation.config.active_leaf_class)
        end
        options[:class] = classes.compact.join(" ")
        if options[:class].empty?
          options.delete(:class)
        end

        options
      end

      def include_sub_navigation?(item)
        consider_sub_navigation?(item) && selected?(item)
      end

      def url_path(url)
        url.sub(/[#?].*/, "")
      end

      def selected?(item)
        return @selected[item] if @selected.key?(item)

        selected = false
        case item.options[:highlights_on]
        when Regexp
          selected = item.options[:highlights_on].match?(@request_fullpath)
        when Proc
          selected = item.options[:highlights_on].call(self)
        else
          item_url_path = url_path(item.url).downcase
          selected = @request_fullpath.downcase.start_with?(item_url_path)
        end

        selected ||= item.children.any? do |key, value|
          selected?(value)
        end

        @selected[item] = selected
      end

      def active_leaf?(item)
        return @active_leaf[item] if @active_leaf.key?(item)

        active_leaf = false
        if selected?(item)
          active_leaf = item.children.none? do |key, value|
            selected?(value)
          end
        end

        @active_leaf[item] = active_leaf
      end

      def show?(item)
        return @show[item] if @show.key?(item)

        show = true
        if !item.options[:if].nil?
          show = item.options[:if].call(self)
        elsif !item.options[:unless].nil?
          show = !item.options[:unless].call
        end

        @show[item] = show
      end

      def consider_sub_navigation?(item)
        return false unless item.children.any?

        case @options[:level]
        when :all
          true
        when Range
          item.level < @options[:level].max
        else
          false
        end
      end
    end
  end
end
