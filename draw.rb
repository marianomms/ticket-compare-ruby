# frozen_string_literal: true

require_relative 'lib/ticket_compare'

MiniMagick.logger.level = Logger::DEBUG

# if ARGV.length < 2
#   puts 'Too few arguments'
#   exit
# end

# puts "Working on #{ARGV}"

puts `clear`
puts 'Starting to draw shapes in the ticket.'
puts ''

JSON_RESPONSE = "#{__dir__}/json/google_visision.json"
IMAGE_INPUT = "#{__dir__}/images/ticket_partial_vertical.jpg"
IMAGE_OUTPUT_WORDS = "#{__dir__}/out/ticket_partial_vertical_words.jpg"
File.delete(IMAGE_OUTPUT_WORDS) if File.exist?(IMAGE_OUTPUT_WORDS)
IMAGE_OUTPUT_SYMBOLS = "#{__dir__}/out/ticket_partial_vertical_symbols.jpg"
File.delete(IMAGE_OUTPUT_SYMBOLS) if File.exist?(IMAGE_OUTPUT_SYMBOLS)

json = TicketCompare::JsonParser.parse(json_path: JSON_RESPONSE)
# bounds = TicketCompare::ImageBounds.new(response: json)

# block_bounds = bounds.get(TicketCompare::ImageBounds::BLOCK)
# para_bounds = bounds.get(TicketCompare::ImageBounds::PARAGRAPH)
# word_bounds = bounds.get(TicketCompare::ImageBounds::WORD)
# symbol_bounds = bounds.get(TicketCompare::ImageBounds::SYMBOL)

# draw = TicketCompare::DrawTicket.new(input_image: IMAGE_INPUT, output_image: IMAGE_OUTPUT_WORDS)
# draw.draw!(bounds: block_bounds, color: 'green')
# draw.draw!(bounds: word_bounds, color: 'red')

# draw = TicketCompare::DrawTicket.new(input_image: IMAGE_INPUT, output_image: IMAGE_OUTPUT_SYMBOLS)
# draw.draw!(bounds: para_bounds, color: 'blue')
# draw.draw!(bounds: symbol_bounds, color: 'red')

bounds = TicketCompare::ImageBounds.new
elements = bounds.get(response: json)

draw = TicketCompare::DrawBounds.new(input_image: IMAGE_INPUT, output_image: IMAGE_OUTPUT_WORDS)
draw.draw!(bounds: elements[:blocks], color: 'green')
draw.draw!(bounds: elements[:words], color: 'red')

draw = TicketCompare::DrawBounds.new(input_image: IMAGE_INPUT, output_image: IMAGE_OUTPUT_SYMBOLS)
draw.draw!(bounds: elements[:paragraphs], color: 'blue')
draw.draw!(bounds: elements[:symbols], color: 'red')

puts ''
puts "Ticket with shapes generated with words in '#{IMAGE_OUTPUT_WORDS}'"
puts
puts "Ticket with shapes generated with symbols in '#{IMAGE_OUTPUT_SYMBOLS}'"
