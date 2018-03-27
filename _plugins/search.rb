module Jekyll
  class SearchPage < Page
    def initialize(site, base, name, hash_arr)
      @site = site
      @base = base
      @hash_arr = hash_arr
      @dir = 'search'
      @name = name

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'search.json')
      self.data['hash_arr'] = hash_arr
    end
  end

  class SearchGenerator < Generator
    def self.post_to_hash(project)
      {
        categories: project.data['categories'].join(', '),
        date: project.data['date'],
        description: project.data['description'],
        tags: project.data['tags'].join(', '),
        title: "Post: #{project.data['title']}", #TODO: only if on `all`?
        url: project.url
      }
    end

    def self.project_to_hash(project)
      # base information
      h = {
        date: project.data['date'],
        description: project.data['description'],
        title: "Project: #{project.data['title']}", #TODO: only if on `all`?
        url: project.url
      }

      # optional information
      h[:github] = project.data['github'] if project.data.key?('github')
      h[:gitlab] = project.data['gitlab'] if project.data.key?('gitlab')
      h[:tech_stack] =
        if project.data.key?('tech_stack')
          if project.data['tech_stack'].is_a?(Array)
            project.data['tech_stack'].join(', ')
          else
            project.data['tech_stack']
          end
        end
      h[:project_status] = project.data['project_status'] if project.data.key?('project_status')

      h
    end

    def generate(site)
      posts = site.collections['posts'].docs.map do |post|
        SearchGenerator.post_to_hash post
      end
      projects = site.collections['projects'].docs.map do |project|
        SearchGenerator.project_to_hash project
      end
      all = posts + projects
      site.pages << SearchPage.new(site, site.source, 'all.json', all)
      site.pages << SearchPage.new(site, site.source, 'posts.json', posts)
      site.pages << SearchPage.new(site, site.source, 'projects.json', projects)
    end
  end
end
