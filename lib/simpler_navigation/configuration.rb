module SimplerNavigation
  class Configuration
    attr_accessor :selected_class
    attr_accessor :active_leaf_class
    attr_reader :root_item

    def self.run(&block)
      SimplerNavigation.config = new(&block)
    end

    def initialize
      @selected_class = "selected"
      @active_leaf_class = "simple-navigation-active-leaf"

      if block_given?
        yield self
      end
    end

    def items
      @root_item = Item.new(key: nil, name: nil, url: nil)

      if block_given?
        yield @root_item
      end
    end
  end
end
