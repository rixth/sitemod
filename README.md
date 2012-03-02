# sitemod

Sitemod lets you customize your favourite websites in a way that isn't painful. It is heavily inspired by [dotjs](http://github.com/defunkt/dotjs).

While user scripts & user styles are possible in Chrome, they're a pain to manage. With sitemod, you have a directory at ~/.sitemod. Inside here, are folders for domains. Inside domain directories, you can have subdirectories that match individual paths. Wildcard directories are also allowed.

You can write your modifications in JavaScript, CoffeeScript, CSS or SCSS. When you visit a webpage in Chrome, any file that matches under your ~/.sitemod directory will be loaded in to the page.

## Setup

You need to install the browser extension, located in `extension/`, and start the server with `rake start_server`.

## Example

Given this file structure:

    ~/.sitemod
      google.com/
        move_top_bar.coffee
        finance/
          highlight_portfolio.js
          increase_contrast.css
      github.com/
        hide_footer.css
        */
          pull/
            comment_templates.js

If you were to go to `google.com/finance` it would load both the specific files for the finance path, in addition to your mods to google.com.

The GitHub example demonstrates the use of wildcards. `comment_templates.js` will be injected on to any page that matches `http://github.com/*/pull`.

Subdomains are supported too. `www` is automatically stripped from the beginning of URLs when calculating what files to apply to a page.

## TODO

* Auto-start the mod server with a plist
* Shell-script installation proceedure
* Share your mods over a LAN using Bonjour, useful to show quick ideas to colleagues