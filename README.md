# PickAKey

Hello there, future rock star/Mozart. If you are using a Ruby Gem to incorporate music theory into your life, then I have to say I'm impressed. What this gem provides is pretty straight forward. When you start the program, you will be prompted to select a key from the provided list. After picking the key, a list of attributes belonging to the key will be presented. Those attributes include:
```
    -The Key's name
    -The notes within the Major or minor scale of the key(depening on if you chose a Major or minor key)
    -The standard chords within that key in order of their scale degree (along with alternate chords you could play in their place.
    -The key's relative major and minor.
```
    
Below that list of attributes, a menu will pop up and give you ways to interact with the key you have chosen. The menu is listed as follows:

    -To find this key's relative Major/minor, type 'Major' or 'minor'.
    -To find this key's relative fifth, type 'fifth'.
    -To generate a random chord progression in this key, type 'chord'.
    -To get a random song generated in this key, type 'song'.
    -To look up a new key, type 'new' to review and choose from the list of keys.
    -To see all keys at once, type 'all'.
    -To exit, type 'exit'.
    
From this menu, you see that you can flow between keys you have chosen and their relative keys, generate random chord progressions and full songs, and also get a ful list of keys available with all of their information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pick_a_key'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pick_a_key

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pick_a_key.

## License
https://github.com/taylortreece/pick-a-key/blob/main/LICENSE
