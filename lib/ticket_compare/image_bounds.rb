# frozen_string_literal: true

module TicketCompare
  #
  # Class to obtain bounds in a given response
  #
  class ImageBounds
    KEYS = %i[blocks paragraphs words symbols].freeze
    private_constant :KEYS

    #
    # Returns a hash with the `blocks` `paragraphs` `words` `symbols`
    #
    # @param [OpenStruct] response Contains the json from the OCR
    #
    # @return [Hash]
    #
    def get(response:)
      hash = get_elements(element: response, child: :pages, keys: KEYS)
      hash.delete(:pages)
      hash
    end

    private

    def get_elements(element:, child:, keys:)
      return {} if child.nil?

      hash = init_hash(child)
      my_keys, next_key = init_keys(keys)

      element.send(child).each do |item|
        hash[child].append(item.boundingBox)
        deep_merge!(hash, get_elements(element: item, child: next_key, keys: my_keys))
      end

      hash
    end

    def deep_merge!(hash1, hash2)
      hash1.deep_merge!(hash2) { |_key, this_val, other_val| this_val + other_val }
    end

    def init_hash(child)
      hash = {}
      hash[child] = []
      hash
    end

    def init_keys(keys)
      my_keys = keys.dup
      [my_keys, my_keys.slice!(0)]
    end
  end
end
