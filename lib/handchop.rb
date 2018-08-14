require 'strscan'
require "handchop/version"
require "handchop/extend_array"
require "handchop/xpathoid"


module Handchop
  class Config
    attr_accessor :block_tag, :inline_tag
  end

  class Text
    def initialize(text)
      @text = text
    end

    class << self
      # Settings
      def configure
        yield config
      end

      def config
        @config ||= Config.new
      end
    end

    using EArray

    # Convert
    def html
      block_open = Text.config.block_tag ? Xpathoid.open_tag(Text.config.block_tag) : '<div>'
      block_close = Text.config.block_tag ? Xpathoid.close_tag(Text.config.block_tag) : '</div>'
      inline_open = Text.config.inline_tag ? Xpathoid.open_tag(Text.config.inline_tag) : '<span>'
      inline_close = Text.config.inline_tag ? Xpathoid.close_tag(Text.config.inline_tag) : '</span>'

      ''.tap do |body|
        is_block, is_inline = false, false
        parser.traverse do |node|
          case node.first
          when :block
            body << inline_close if is_inline
            body << block_close if is_block
            body << block_open
            is_inline = false
            is_block = true
          when :inline
            body << inline_close if is_inline
            body << inline_open
            is_inline = true
          when :plain
            body << node[1]
          when :uri
            body << "<a href='#{node[1]}' >#{node[1]}</a>"
          end
        end
        body << inline_close if is_inline
        body << block_close if is_block
      end
    end

    private

    # Lexical Analyz...oid
    def lexer
      [].tap do |tokens|
        s = StringScanner.new(@text)
        until s.eos?
          case
          when s.scan(Regexp.compile("(.*)(#{URI.regexp(%w(http https))})"))
            tokens << [:plain, s[1]] if s[1]
            tokens << [:uri, s[2]]
          when s.scan(/.+/)
            tokens << [:plain, s.matched]
          when s.scan(/\n{2,}/)
            tokens << [:eol]
            tokens << [:eob]
          when s.scan(/\n/)
            tokens << [:eol]
          end
        end
      end
    end

    # Parsoid
    def parser
      document, block, inline = [], [], []

      lexer.each do |item|
        case
        when item[0] == :plain
          inline << [:plain, item[1]]
        when item[0] == :uri
          inline << [:uri, item[1]]
        when item[0] == :eol
          block << [:inline, inline]
          inline = []
        when item[0] == :eob
          document << [:block, block]
          block = []
        end
      end
      [:doc, document]
    end
  end
end
