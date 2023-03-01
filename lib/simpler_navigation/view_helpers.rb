module SimplerNavigation
  module ViewHelpers
    def render_navigation(renderer: SimplerNavigation::Renderers::List, item: nil, **args)
      renderer.new(self, item, **args).render
    end
  end
end
