# Inky

[![Gem Version](https://badge.fury.io/rb/inky-rb.svg)](https://badge.fury.io/rb/inky-rb) [![Build Status](https://travis-ci.org/zurb/inky-rb.svg?branch=master)](https://travis-ci.org/zurb/inky-rb)

Inky is an HTML-based templating language that converts simple HTML into complex, responsive email-ready HTML. Designed for [Foundation for Emails](http://foundation.zurb.com/emails), a responsive email framework from [ZURB](http://zurb.com).

To include only the Foundation for Emails styles in your Asset Pipeline, without Inky, use the [**foundation_emails**](https://github.com/zurb/foundation-emails/#using-the-ruby-gem) gem.

Give Inky simple HTML like this:

```html
<row>
  <columns large="6"></columns>
  <columns large="6"></columns>
</row>
```

And get complicated, but battle-tested, email-ready HTML like this:

```html
<table class="row">
  <tbody>
    <tr>
      <th class="small-12 large-6 columns first">
        <table>
          <tr>
            <th class="expander"></th>
          </tr>
        </table>
      </th>
      <th class="small-12 large-6 columns first">
        <table>
          <tr>
            <th class="expander"></th>
          </tr>
        </table>
      </th>
    </tr>
  </tbody>
</table>
```

## Getting Started

Add the following gems to your Gemfile:

```ruby
gem 'inky-rb', require: 'inky'
# Stylesheet inlining for email **
gem 'premailer-rails'
```

Then execute:

```bash
bundle install
```

Run the following command to set up the required styles and mailer layout:

```bash
rails g inky:install
```

You can specify the layout name and templating language with the following options:

```
Usage:
  rails generate inky:install [layout_name] [options]

Options:
  [--haml], [--no-haml]  # Generate layout in Haml
  [--slim], [--no-slim]  # Generate layout in Slim
```

Rename your email templates to use the `.inky` file extension. Note that you'll still be able to use your default
template engine within the `.inky` templates:

```
welcome.html      => welcome.html.inky
pw_reset.html.erb => pw_reset.html.inky
```


You're all set!

** The majority of email clients ignore linked stylesheets. By using a CSS inliner like `premailer-rails` or `roadie`, you're able to leave your stylesheets in a separate file, keeping your markup lean.

## Alternative template engine

If you do not use ERB for your views and layouts but some other markup like Haml or Slim, you can configure Inky to
use these languages. To do so, just set an initializer:

```ruby
# config/initializers/inky.rb
Inky.configure do |config|
  config.template_engine = :slim
end
```

Check [lib/generators/inky/templates/mailer_layout.html.slim](lib/generators/inky/templates/mailer_layout.html.slim)
for a Slim example.

You may prefer to specify which template engine to use before inky:

```
welcome.html.haml => welcome.html.inky-haml
pw_reset.html.erb => pw_reset.html.inky-erb
```

## Other options

### Column Count

You can change the column count in the initializer too:

```ruby
# config/initializers/inky.rb
Inky.configure do |config|
  config.column_count = 24
end
```

Make sure to change the SASS variable as well:

```sass
# assets/stylesheets/foundation_emails.scss
# ...
$grid-column-count: 24;

@import "foundation-emails";
```

## Custom Elements

Inky simplifies the process of creating HTML emails by expanding out simple tags like `<row>` and `<column>` into full table syntax. The names of the tags can be changed with the `components` setting.

Here are the names of the defaults:

```ruby
{
  button: 'button',
  row: 'row',
  columns: 'columns',
  container: 'container',
  inky: 'inky',
  block_grid: 'block-grid',
  menu: 'menu',
  center: 'center',
  callout: 'callout',
  spacer: 'spacer',
  wrapper: 'wrapper',
  menu_item: 'item'
}
```

## Raw HTML

If you need to include raw html, you can wrap raw content in `<raw>` tags

```html
<raw>
  <button></button>
  <asdf></asdf>
</raw>
```

This is a feature intended for advanced users. You will be responsible for ensuring all markup between `<raw>` tags is valid. All content after an opening `<raw>` tag will be inserted "As Is" until the next closing `</raw>` tag.

This means that `<raw>` tags CANNOT be nested


## Programmatic Use

The Inky parser can be accessed directly for programmatic use.

## Requirements

Inky-rb currently requires:

* Ruby 2.0+
* Rails 3, 4, 5 or 6
