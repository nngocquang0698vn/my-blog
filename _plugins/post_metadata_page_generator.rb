module Jekyll

  class MetadataParentPage < Page
    def initialize(site, base, metadataDirKey, metadataDir, metadataKey, metadataList, metadataHtml, metadataTitleKey, metadataTitle)
      @site = site
      @base = base
      @dir = metadataDir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), metadataHtml)
      self.data['metadataKey'] = metadataKey
      self.data['metadataList'] = metadataList

      metadata_title = site.config[metadataTitleKey] || metadataTitle
      self.data['title'] = "#{metadata_title}"
      metadata_dir = site.config[metadataDirKey] || metadataDir
      self.data['metadataDir'] = metadata_dir

      self.data['base'] = base
    end
  end

  class MetadataChildPage < Page
    def initialize(site, base, metadataDirKey, metadataDir, metadataKey, metadataList, metadataHtml, metadataPrefixKey, metadataPrefix)
      @site = site
      @base = base
      @dir = metadataDir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), metadataHtml)
      self.data['metadataKey'] = metadataKey
      self.data['metadataList'] = metadataList

      metadata_title_prefix = site.config[metadataPrefixKey] || metadataPrefix
      self.data['title'] = "#{metadata_title_prefix}#{metadataKey}"
      metadata_dir = site.config[metadataDirKey] || metadataDir
      self.data['metadataDir'] = metadata_dir
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
        site.pages << MetadataParentPage.new(site, site.source, @metadataDirKey, @metadataDir, @metadataKey, metadata, @metadataLayoutHtml, @metadataTitleKey, @metadataTitle)
      end
    end
  end

  class CategoryParentPageGenerator < MetadataParentPageGenerator
    safe true
    def initialize(*args)
      super(args)
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
      super(args)
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
          site.pages << MetadataChildPage.new(site, site.source, @metadataDirKey, File.join(@metadataDir, item), item, metadata, @metadataLayoutHtml, @metadataPrefixKey, @metadataPrefix)
        end
      end
    end
  end

  class CategoryPageGenerator < MetadataChildPageGenerator
    safe true
    def initialize(*args)
      super(args)
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
      super(args)
      @metadataDirKey = 'tags_dir'
      @metadataDir = 'tags'
      @metadataKey = 'tags'
      @metadataPrefix = 'Tag: '
      @metadataPrefixKey = 'tags_title_prefix'
    end
  end

  class TechStackParentPageGenerator < MetadataParentPageGenerator
    safe true
    def initialize(*args)
      super(args)
      @metadataDirKey = 'tech_dir'
      @metadataDir = 'projects/tech'
      @metadataKey = 'tech_stack'
      @metadataTitle = 'tech'
      @metadataTitleKey = 'tech_title_title'
      @metadataLayoutHtml = 'tech_page_parent.html'
    end

    def generate(site)
      projects = site.collections['projects']

      sorted_projects = {}
      uncategorised_projects = []
      for project in projects.docs
        unless project.data['tech_stack']
          uncategorised_projects.push(project)
          next
        end

        for tech in project.data['tech_stack']
          unless sorted_projects[tech]
            sorted_projects[tech] = []
          end
          sorted_projects[tech].push(project)
        end
      end

      unless @metadataKey.nil?
        site.pages << TechStackParentPage.new(site, site.source, @metadataDirKey, @metadataDir, @metadataKey, sorted_projects, uncategorised_projects, @metadataLayoutHtml, @metadataTitleKey, @metadataTitle)
      end
    end
  end

  class TechStackChildPageGenerator < MetadataParentPageGenerator
    safe true
    def initialize(*args)
      super(args)
      @metadataDirKey = 'tech_dir'
      @metadataDir = 'projects/tech'
      @metadataKey = 'tech_stack'
      @metadataTitle = 'Tech: '
      @metadataLayoutHtml = 'tech_page_child.html'
    end

    def generate(site)
      projects = site.collections['projects']

      sorted_projects = {}
      uncategorised_projects = []
      for project in projects.docs
        unless project.data['tech_stack']
          uncategorised_projects.push(project)
          next
        end

        for tech in project.data['tech_stack']
          unless sorted_projects[tech]
            sorted_projects[tech] = []
          end
          sorted_projects[tech].push(project)
        end
      end

      unless @metadataKey.nil?
        projects = sorted_projects
        projects.each do |tech, projects|
          site.pages << MetadataChildPage.new(site, site.source, @metadataDirKey, File.join(@metadataDir, tech), tech, projects, @metadataLayoutHtml, @metadataTitleKey, @metadataTitle)
        end
      end
    end
  end

  class TechStackParentPage < MetadataParentPage
    def initialize(site, base, techDirKey, techDir, techKey, projects, uncategorised_projects, techHtml, techTitleKey, techTitle)
      super(site, base, techDirKey, techDir, techKey, projects, techHtml, techTitleKey, techTitle)
      self.data['uncategorised_projects'] = uncategorised_projects
    end
  end

end
