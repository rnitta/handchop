# Handchop

Handchop is simple text converter to HTML.
Probably, `ActionView::Helpers::TextHelper#simple_format` will be helpful for you, rather than this.

Examples below.

```ruby
require 'handchop'

text = <<-'TEXT'
This is made for me to learn how to make parser
So the perfection is not so high.

if you want to highly sophisticated converter, you can use Handsaw.
https://github.com/PORT-INC/handsaw
TEXT

Handchop::Text.new(text).html
# => "<div><span>This is made for me to learn how to make parser</span><span>So the perfection is not so high.</span></div><div><span>if you want to highly sophisticated converter, you can use Handsaw.</span><span><a href='https://github.com/PORT-INC/handsaw' >https://github.com/PORT-INC/handsaw</a></span><span>end</span></div>"

```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'handchop'
```

And then execute:

    $ bundle

Or just install it as:

    $ gem install handchop

## Usage

```ruby
require 'handchop'

text = 'some text'

Handchop::Text.new(text).html


```

## Configure

Output tags and their classes can be modified by configuration.

```ruby
Handchop.configure do |config|
  config.block_tag = 'div.klass.hoge'
  config.inline_tag = 'div.klass2.fuga'
end
```

## Implementation

You can see something.

```ruby
handchop = Handchop::Text.new('some texts')

handchop.send(:lexer)
handchop.send(:parser)
```

## Contributing

I would appreciate any comments or suggestions.
