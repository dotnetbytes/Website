require "jekyll"
require "pathname"

module Jekyll
    class CoverImageExistsTag < Liquid::Tag

        def initialize(tag_name, path, tokens)
            super
            @path = path
        end

        def render(context)
            # Pipe parameter through Liquid to make additional replacements possible
            page = Liquid::Template.parse(@path).render context

            file_path = File.join(Pathname(page).dirname,"cover.jpg")
            
            #Jekyll.logger.warn("[File Exists]", "#{file_path}")

            if(File.file?(file_path))
              #Jekyll.logger.warn("[File Exists - Is File 1]", "#{File.exist?(file_path)}")
              "#{File.exist?(file_path)}"
            else
              #Jekyll.logger.warn("[File Exists - Is File 2]", "false")
              "false"
            end
        end
    end
end

Liquid::Template.register_tag('cover_exists', Jekyll::CoverImageExistsTag)


