# frozen_string_literal: true

module TicketCompare
  #
  # Class to draw shapes in a given image, it saves it in a output path
  #
  class DrawBounds
    attr_accessor :input_image, :output_image

    #
    # Creates a new instance of `TicketCompare::DrawTicket`
    #
    # @param [String] input_image Path for the source image
    # @param [String] output_image Path for the output image
    #
    def initialize(input_image:, output_image:)
      @input_image = input_image
      @output_image = output_image
    end

    #
    # Generates the shapres in the image and save the result
    #
    # @param [Array] bounds coordinates to render
    # @param [<Type>] color the shape will have this color
    #
    def draw!(bounds:, color:)
      image.combine_options do |i|
        i.fill 'none'
        i.stroke color
        i.strokewidth 3

        bounds.each do |b|
          i.draw "polygon #{coordinates_from(bound: b)}"
        end
      end
      image.write output_image
    end

    private

    def coordinates_from(bound:)
      coordinates = ''
      bound&.vertices&.each do |vertice|
        coordinates += " #{vertice.x},#{vertice.y}"
      end
      coordinates.strip
    end

    #
    # Opens an image from input_image
    #
    # @return [MiniMagick::Image]
    #
    def image
      @image ||= MiniMagick::Image.open(input_image)
    end
  end
end
