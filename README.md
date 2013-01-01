sugar_png    [![Build Status](https://secure.travis-ci.org/zed-0xff/sugar_png.png)](http://secure.travis-ci.org/zed-0xff/sugar_png)  [![Dependency Status](https://gemnasium.com/zed-0xff/sugar_png.png)](https://gemnasium.com/zed-0xff/sugar_png)
======


Description
-----------
A pure ruby high-level PNG file creation toolkit

Features
--------
 * neat syntax
 * unicode text drawing support
 * 16-bit color depth support

Installation
------------
    gem install sugar_png

Examples
--------

### Hello World!
<img src="//raw.github.com/zed-0xff/sugar_png/master/samples/readme/hello_world.png" alt="Hello World!" title="Hello World!" align="right" />
```ruby
  SugarPNG.new do
    text "Hello World!"
    save "out.png"
  end
```

### Explicit image dimensions + bg color
<img src="//raw.github.com/zed-0xff/sugar_png/master/samples/readme/explicit_image_dimensions_bg_color.png" alt="Explicit image dimensions + bg color" title="Explicit image dimensions + bg color" align="right" />
```ruby
  SugarPNG.new do
    background 'red' # or :blue, or #ffee00, or :transparent (default)
    width 100
    height 50
    text "Hello World!", :color => '#ffffff'
    save "out.png"
  end
```

### Japanese text with rainbow borders, zoomed 4x
<img src="//raw.github.com/zed-0xff/sugar_png/master/samples/readme/japanese_text_with_rainbow_borders_zoomed_4x.png" alt="Japanese text with rainbow borders, zoomed 4x" title="Japanese text with rainbow borders, zoomed 4x" align="right" />
```ruby
  SugarPNG.new do
    border 1, :red
    border 1, :green
    border 1, :blue
    text '水水水'
    zoom 4

    save "out.png"
  end
```

License
-------
Released under the MIT License.  See the [LICENSE](https://github.com/zed-0xff/sugar_png/blob/master/LICENSE.txt) file for further details.
