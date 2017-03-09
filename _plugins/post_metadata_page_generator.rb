# adapted from Jekyll docs
module Jekyll

  class MetadataParentPage < Page
    def initialize(site, base, dir, metadataKey, metadataList, metadataHtml, metadataTitleKey, metadataTitle)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), metadataHtml)
      self.data['metadataDir'] = dir
      self.data['metadataKey'] = metadataKey
      self.data['metadataList'] = metadataList

      metadata_title = site.config[metadataTitleKey] || metadataTitle
      self.data['title'] = "#{metadata_title}"

      self.data['base'] = "#{base}"
    end
  end

  class MetadataChildPage < Page
    def initialize(site, base, dir, metadataKey, metadataList, metadataHtml, metadataPrefixKey, metadataPrefix)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), metadataHtml)
      self.data['metadataKey'] = metadataKey
      self.data['metadataList'] = metadataList

      metadata_title_prefix = site.config[metadataPrefixKey] || metadataPrefix
      self.data['title'] = "#{metadata_title_prefix}#{metadataKey}"
    end
  end

  class MetadataParentPageGenerator < Generator
    safe true

    def initialize(*args)
      set_metadataLayout('metadata_page_parent')
      @metadataDirKey = 'metadata_dir'
      @metadataDir = 'metadata'
      @metadataKey = nil
      @metadataTitle = 'Metadata'
      @metadataTitleKey = 'metadata_title'
    end

    def set_metadataLayout(key)
      @metadataLayoutKey = key
      @metadataLayoutHtml = "#{key}.html"
    end

    def generate(site)
      unless @metadataKey.nil?
        metadata = site.post_attr_hash("#{@metadataKey}")
        site.pages << MetadataParentPage.new(site, site.source, @metadataDir, @metadataKey, metadata, @metadataLayoutHtml, @metadataTitleKey, @metadataTitle)
      end
    end
  end

  class CategoryParentPageGenerator < MetadataParentPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @metadataDirKey = 'categories_dir'
      @metadataDir = 'categories'
      @metadataKey = 'categories'
      @metadataTitle = 'Categories'
      @metadataTitleKey = 'categories_title_title'
    end
  end

  class TagParentPageGenerator < MetadataParentPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @metadataDirKey = 'tags_dir'
      @metadataDir = 'tags'
      @metadataKey = 'tags'
      @metadataTitle = 'Tags'
      @metadataTitleKey = 'tags_title_title'
    end
  end

  class MetadataChildPageGenerator < Generator
    safe true

    def initialize(*args)
      set_metadataLayout('metadata_page_child')
      @metadataDirKey = 'metadata_dir'
      @metadataDir = 'metadata'
      @metadataKey = nil
      @metadataPrefix = 'Metadata: '
      @metadataPrefixKey = 'metadata_title_prefix'
    end

    def set_metadataLayout(key)
      @metadataLayoutKey = key
      @metadataLayoutHtml = "#{key}.html"
    end

    def generate(site)
      unless @metadataKey.nil?
        metadata = site.post_attr_hash("#{@metadataKey}")
        metadata.each_key do |item|
          site.pages << MetadataChildPage.new(site, site.source, File.join(@metadataDir, item), item, metadata, @metadataLayoutHtml, @metadataPrefixKey, @metadataPrefix)
        end
      end
    end
  end

  class CategoryPageGenerator < MetadataChildPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @metadataDirKey = 'categories_dir'
      @metadataDir = 'categories'
      @metadataKey = 'categories'
      @metadataPrefix = 'Category: '
      @metadataPrefixKey = 'categories_title_prefix'
    end
  end

  class TagPageGenerator < MetadataChildPageGenerator
    safe true
    def initialize(*args)
      # make sure we use the superclass's attributes
      super(args)
      # and override what we need
      @metadataDirKey = 'tags_dir'
      @metadataDir = 'tags'
      @metadataKey = 'tags'
      @metadataPrefix = 'Tag: '
      @metadataPrefixKey = 'tags_title_prefix'
    end
  end
end
