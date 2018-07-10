module Jekyll
  class CategoryParentPage < Page
    def initialize(site, base)
      config = site.config['taxonomy']['categories']

      @site = site
      @base = base
      @name = 'index.html'
      @dir = config['path']

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'metadata_page_parent.html')
      self.data['base'] = base

      self.data['metadataList'] = site.categories

      self.data['title'] = config['title']
    end
  end

  class CategoryChildPage < Page
    def initialize(site, base, category_name, category_documents)
      config = site.config['taxonomy']['categories']

      @site = site
      @base = base
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'metadata_page_child.html')
      self.data['base'] = base

      self.data['metadataKey'] = category_name
      self.data['metadataList'] = category_documents

      self.data['title'] = "#{config['child_title_prefix']}#{category_name}"

      @dir = "#{config['path']}/#{category_name}"
    end
  end

  class TagParentPage < Page
    def initialize(site, base)
      config = site.config['taxonomy']['tags']

      @site = site
      @base = base
      @name = 'index.html'
      @dir = config['path']

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'metadata_page_parent.html')
      self.data['base'] = base

      self.data['metadataList'] = site.tags

      self.data['title'] = config['title']
    end
  end

  class TagChildPage < Page
    def initialize(site, base, tag_name, tag_documents)
      config = site.config['taxonomy']['tags']

      @site = site
      @base = base
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'metadata_page_child.html')
      self.data['base'] = base

      self.data['metadataKey'] = tag_name
      self.data['metadataList'] = tag_documents

      self.data['title'] = "#{config['child_title_prefix']}#{tag_name}"

      @dir = "#{config['path']}/#{tag_name}"
    end
  end

  class TaxonomyPageGenerator < Generator
    safe true
    def generate(site)
      site.pages << CategoryParentPage.new(site, site.source)
      site.post_attr_hash('categories').each do |category_name, category_documents|
        site.pages << CategoryChildPage.new(site, site.source, category_name, category_documents)
      end

      site.pages << TagParentPage.new(site, site.source)
      site.post_attr_hash('tags').each do |tag_name, tag_documents|
        site.pages << TagChildPage.new(site, site.source, tag_name, tag_documents)
      end
    end
  end

  class TechParentPage < Page
    def initialize(site, base, categorised_projects, uncategorised_projects)
      config = site.config['taxonomy']['tech']

      @site = site
      @base = base
      @name = 'index.html'
      @dir = config['path']

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tech_page_parent.html')
      self.data['base'] = base

      self.data['categorised_projects'] = categorised_projects
      self.data['uncategorised_projects'] = uncategorised_projects

      self.data['title'] = config['title']
    end
  end

  class TechChildPage < Page
    def initialize(site, base, tech_name, projects)
      config = site.config['taxonomy']['tech']

      @site = site
      @base = base
      @name = 'index.html'
      @dir = config['path']

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tech_page_child.html')
      self.data['base'] = base

      self.data['projects'] = projects

      self.data['title'] = "#{config['child_title_prefix']}#{tech_name}"

      @dir = "#{config['path']}/#{tech_name}"
    end
  end

  class TechPageGenerator < Generator
    safe true
    def generate(site)
      uncategorised_projects = []
      projects_by_tech = {}
      for project in site.collections['projects'].docs
        for tech in project.data['tech_stack']
          unless project.data['tech_stack']
            uncategorised_projects.push(project)
            next
          end

          unless projects_by_tech[tech]
            projects_by_tech[tech] = []
          end
          projects_by_tech[tech].push(project)
        end
      end

      site.pages << TechParentPage.new(site, site.source, projects_by_tech, uncategorised_projects)
      projects_by_tech.each do |tech_name, projects|
        site.pages << TechChildPage.new(site, site.source, tech_name, projects)
      end
    end
  end
end
