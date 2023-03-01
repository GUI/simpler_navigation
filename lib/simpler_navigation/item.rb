module SimplerNavigation
  class Item
    attr_reader :name
    attr_reader :url
    attr_reader :level
    attr_reader :options
    attr_reader :children

    def initialize(key:, name:, url:, level: 0, options: {})
      @key = key
      @name = name
      @url = url
      @level = level
      @options = options
      @children = {}
    end

    def item(key, name, url, options = {})
      if @children[key]
        raise "Navigation item already exists for #{key.inspect}"
      end

      @children[key] = Item.new(key: key, name: name, url: url, level: @level + 1, options: options)

      if block_given?
        yield @children[key]
      end
    end

    def [](key)
      @children[key]
    end

    def fetch(key)
      @children.fetch(key)
    end
  end
end
