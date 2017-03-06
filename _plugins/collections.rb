# adapted from Jekyll docs
module Jekyll

  class CollectionPage < Page
    def initialize(site, base, dir, collectionKey, collectionList, collectionHtml = 'collection_index.html', collectionPrefixKey = 'collection_title_prefix', collectionPrefix = 'Collection: ')
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

  class CategoryPageGenerator < Generator
    safe true

    # TODO make this generic, too!
    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each_key do |category|
          site.pages << CollectionPage.new(site, site.source, File.join(dir, category), category, site.categories, 'collection_index.html', 'category_title_prefix')
        end
      end
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || 'tags'
        site.tags.each_key do |tag|
          site.pages << CollectionPage.new(site, site.source, File.join(dir, tag), tag, site.tags, 'collection_index.html', 'tag_title_prefix')
        end
      end
    end
  end

end
