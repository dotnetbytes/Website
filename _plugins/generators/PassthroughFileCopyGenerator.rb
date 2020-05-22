# frozen_string_literal: true

require "jekyll"
require "pathname"

module Jekyll
  class PassthroughFileCopyGenerator < Generator
    Jekyll::Hooks.register :posts, :pre_render do |post, hash|
      post.to_s.gsub!(/!\[(.*?)\]\((.*?)\)/) do |match| 
        "![#{$1}](#{hash.site["url"]}#{hash.page.id}/#{$2})"
      end
    end

    FIXED_DATE_FILENAME_MATCHER = %r!^(?:.+/)*(\d{2,4}-\d{1,2}-\d{1,2})-([^/]*)(\.[^.]+)$!

    # _posts/
    #   2018-01-01-whatever.md     # there's a date on this filename, so it will be treated as a post
    #                              # it's a direct descendant of _posts, so we do not treat it as an asset root
    #   somedir/
    #     2018-05-01-some-post.md  # there's a date on this filename, so it will be treated as a post.
    #                              # moreover, we will treat its dir as an asset root
    #     cool.svg                 # there's no date on this filename, so it will be treated as an asset
    #     undated.md               # there's no date on this filename, so it will be treated as an asset
    #     img/
    #       cool.png               # yes, even deeply-nested files are eligible to be copied.
    def generate(site)
      site_srcroot = Pathname.new site.source
      posts_src_dir = site_srcroot + "_posts"
      drafts_src_dir = site_srcroot + "_drafts"

      docs_with_dirs = site.posts.docs
        .reject { |doc|
          Pathname.new(doc.path).dirname.instance_eval { |dirname|
            [posts_src_dir, drafts_src_dir].reduce(false) { |acc, dir|
              acc || dirname.eql?(dir)
            }
          }
        }

      assets = docs_with_dirs.map { |doc|
        dest_dir = Pathname.new(doc.destination("")).dirname
        Pathname.new(doc.path).dirname.instance_eval { |postdir|
          Dir[postdir + "**/*"]
            .reject { |fname| fname =~ FIXED_DATE_FILENAME_MATCHER }
            .reject { |fname| File.directory? fname }
            .map { |fname|
              asset_abspath = Pathname.new fname
              srcroot_to_asset = asset_abspath.relative_path_from(site_srcroot)
              srcroot_to_assetdir = srcroot_to_asset.dirname
              asset_basename = srcroot_to_asset.basename

              assetdir_abs = site_srcroot + srcroot_to_assetdir
              postdir_to_assetdir = assetdir_abs.relative_path_from(postdir)
              PassthroughPostAsset.new(site, site_srcroot, srcroot_to_assetdir.to_path, asset_basename, (dest_dir + postdir_to_assetdir).to_path)
            }
        }
      }.flatten

      site.static_files.concat(assets)
    end
  end

  class PassthroughPostAsset < StaticFile
    def initialize(site, base, dir, name, dest)
      super(site, base, dir, name)
      @name = name
      @dest = dest
    end

    def destination(dest)
      File.join(@dest, @name)
    end
  end
end
