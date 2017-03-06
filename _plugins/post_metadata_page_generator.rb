# adapted from Jekyll docs
module Jekyll

  class MetadataPage < Page
    def initialize(site, base, dir, collectionKey, collectionList, collectionHtml = 'metadata_page_index.html', collectionPrefixKey = 'collection_title_prefix', collectionPrefix = 'Collection: ')
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), collectionHtml)
      self.data['collectionKey'] = collectionKey
      self.data['collectionList'] = collectionList

      collection_title_prefix = site.config[collectionPrefixKey] || collectionPrefix
      self.data['title'] = "#{collection_title_prefix}#{collectionKey}"
    end
  end

  class MetadataPageGenerator < Generator
    safe true

    def initialize(*args)
      set_collectionLayout('metadata_page_index')
      @collectionDirKey = 'collections_dir'
      @collectionDir = 'collections'
      @collectionKey = nil
      @collectionPrefix = 'Collection: '
      @collectionPrefixKey = 'collection_title_prefix'
    end

    def set_collectionLayout(key)
      @collectionLayoutKey = key
      @collectionLayoutHtml = "#{key}.html"
    end

    def generate(site)
      unless @collectionKey.nil?
        collection = site.post_attr_hash("#{@collectionKey}")
        collection.each_key do |item|
          site.pages << MetadataPage.new(site, site.source, File.join(@collectionDir, item), item, collection, @collectionLayoutHtml, @collectionPrefixKey, @collectionPrefix)
        end
      end
    end
  end

  class CategoryPageGenerator < MetadataPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @collectionDirKey = 'categories_dir'
      @collectionDir = 'categories'
      @collectionKey = 'categories'
      @collectionPrefix = 'Category: '
      @collectionPrefixKey = 'categories_title_prefix'
    end
  end

  class TagPageGenerator < MetadataPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @collectionDirKey = 'tags_dir'
      @collectionDir = 'tags'
      @collectionKey = 'tags'
      @collectionPrefix = 'Tag: '
      @collectionPrefixKey = 'tags_title_prefix'
    end
  end
end
