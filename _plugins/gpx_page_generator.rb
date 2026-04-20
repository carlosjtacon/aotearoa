module GPXPagePlugin
  class GPXPageGenerator < Jekyll::Generator
	safe true

	def generate(site)
		tracks = site.static_files.select { |file| file.extname == '.gpx' }
	    tracks.each do |track|
			site.pages << GPXPage.new(site, 'tracks', track.basename, track)
		end
	end
  end

  # Subclass of `Jekyll::Page` with custom method definitions.
  class GPXPage < Jekyll::Page
	def initialize(site, category, name, track)
	  @site = site             # the current site instance.
	  @base = site.source      # path to the source directory.
	  @dir  = category         # the directory the page will reside in.

	  # All pages have the same filename, so define attributes straight away.
	  @basename = name      # filename without the extension.
	  @ext      = '.html'      # the extension.
	  @name     = name + '.html' # basically @basename + @ext.

	  @data = {
		  'gpx_path' => track.relative_path,
		  'title' => name
	  }

	  # Look up front matter defaults scoped to type `categories`, if given key
	  # doesn't exist in the `data` hash.
	  data.default_proc = proc do |_, key|
		site.frontmatter_defaults.find(relative_path, :tracks, key)
	  end
	end

	# Placeholders that are used in constructing page URL.
	def url_placeholders
	  {
		:path       => @dir,
		:category   => @dir,
		:basename   => basename,
		:output_ext => output_ext,
	  }
	end
  end
end