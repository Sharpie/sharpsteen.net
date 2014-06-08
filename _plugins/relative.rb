# A few quick helpers to transform all post and page URLs from absolute to
# relative. This allows the static builds of this site to be served from
# multiple baseurls.
#
# Based on:
#   https://jclement.ca/2013/12/06/relative_jekyll_paths.html
#
# TODO: Consider replacing some of these with Liquid Filters:
#   http://stackoverflow.com/a/18430117/135870
class Jekyll::Page

  # Returns the relative path to the root of the blog.
  def relroot
    repeat = url.split("/").length-1
    if repeat >= 1
      "../" * repeat
    else
      ""
    end
  end

  # Trims any leading slashes from the front of the URL for this entity so that
  # a relative url is produced.
  def relurl
    url.sub(/^[\/]+/, '')
  end

  def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
    super(attrs + %w[
      relroot
      relurl
    ])

  end
end

# Same as above. Duplication necessary because of `#to_liquid` override.
class Jekyll::Post

  def relroot
    repeat = url.split("/").length-1
    if repeat >= 1
      "../" * repeat
    else
      ""
    end
  end

  def relurl
    url.sub(/^[\/]+/, '')
  end

  def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
    super(attrs + %w[
      relroot
      relurl
    ])

  end
end
