# frozen_string_literal: true

# Given a relation containing all of the element objects, sort them by name while accounting for
# ordinal numbers
class SortCollectionOrdinally
  include Service

  def call(collection)
    first_sort = collection.sort_by { |e| ActiveSupport::Inflector.transliterate(e.name.downcase) }
    names_with_numbers = first_sort.select { |element| element.name.match(/(\d+)/) }
    return first_sort if names_with_numbers.empty?
    names_with_no_numbers = first_sort - names_with_numbers
    sorted_names_with_numbers = ordinal_sort(names_with_numbers)
    sorted_names_with_numbers + names_with_no_numbers
  end

  private

  # Performs ordinal sort removes number portion from string, then sorts names based on
  # number then following words
  def ordinal_sort(collection)
    name_object_hash = {}
    collection.each { |element| name_object_hash[element.name] = element }

    names = name_object_hash.keys
    sorted_names = names.sort_by do |n|
      [n.split(/(\d+)/)[1].to_i, n.split(/\s/)]
    end

    sorted_names.collect { |n| name_object_hash[n] }
  end
end
