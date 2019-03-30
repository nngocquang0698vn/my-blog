require_relative './predicate'

class ValidPauthor < ::Predicate
  def validate(entry)
    raise InvalidMetadataError, 'No p-author found' unless entry.respond_to? :author
    author = entry.author

    [::HasUUrl, ::ValidUUrl, ::HasPName, ::ValidPName].each do |clazz|
      clazz.new.validate(author)
    end
  end
end
