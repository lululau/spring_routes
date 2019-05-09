require 'thor'

module SpringRoutes
  class Cli < ::Thor
    desc 'spring_routes [-c] <LOG_FILE>', 'Parse and print spring mvc routes from spring log'
    option :compact, aliases: ['-c'], type: :boolean, required: false, default: false
    def parse_print(file_name = nil)
      file = file_name ? File.open(file_name) : STDIN
      matched = false
      over = false
      file.each do |line|
        line.chomp!
        matched = true if line =~ /JsonResponseRequestMappingHandlerMapping - /
        over = true if  line !~ /JsonResponseRequestMappingHandlerMapping - / && matched

        break if over

        if matched
          line.sub!(/^.*JsonResponseRequestMappingHandlerMapping - /, '')
          line.gsub!(/([a-z0-9]+\.)+([A-Z])/, '\2') if options[:compact]
          line.sub!(/onto public/, ' ====> ')
          puts line if line =~ /^Mapped/
        end
      end
    end

    default_command :parse_print
  end
end
