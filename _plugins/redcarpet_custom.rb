# This plugin does one thing: It mixes a module into the Redcarpet renderer
# that creates headers with permalink anchors.
module Jekyll
  module Converters
    class Markdown
      class RedcarpetCustom < RedcarpetParser

        # This is where the business happens.
        module HeaderPermalinks
          # These are taken from the header_anchor method in the Redcarpet
          # source for `html.c`.
          SPACE_REGEX = /[[:space:]]+/
          TAGS_REGEX = %r{<\\/?[^>]*>}

          def header(text, header_level)
            anchor = text.gsub(SPACE_REGEX, '-').gsub(TAGS_REGEX, '').downcase
            # NOTE: It would be _awesome_ to hand this off to a liquid
            # partial... but I don't know how to to that :/
            return <<-EOT
<h#{header_level}>
  <a href="##{anchor}" name="#{anchor}" class="header-permalink">#</a>
  #{text}
</h#{header_level}>
            EOT
          end
        end

        def initialize(config)
          super config
          # Here we mix into whatever renderer class Jekyll created.
          # (They're all subclasses of Redcarpet::Render::HTML)
          @renderer.send :include, HeaderPermalinks
        end
      end
    end
  end
end

