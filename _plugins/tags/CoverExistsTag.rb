require "jekyll"
require "pathname"

module Jekyll
    class CoverExistsTag < Liquid::Tag
        def initialize(tag_name, params, tokens)
            super
            @args = self.split_params(params)
            @page = @args[0]
            @image = @args[1]
         end

        def split_params(params)
          params.split(",").map(&:strip)
        end

        def render(context)
            # Pipe parameter through Liquid to make additional replacements possible
            page = Liquid::Template.parse(@page).render context
            image = Liquid::Template.parse(@image).render context

            file_path = File.join(Pathname(page).dirname,image)

            if(File.file?(file_path))
              "#{File.exist?(file_path)}"
            else
              "false"
            end
        end
    end
end

Liquid::Template.register_tag('cover_exists', Jekyll::CoverExistsTag)
