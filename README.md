# Selective Inspect

Simple gem to customize the output of the `#inspect` method.

Ruby's default `#inspect` implementation prints EVERY instance variable in your object objects, which can be really painful sometimes.

This gem allows to define a whitelist of the instance variables you want to output or a blacklist of those you don't.

## Installation

Add this line to your application's Gemfile:

    gem 'selective_inspect'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install selective_inspect

## Usage

```rb
class Game
  # ...
end

game = Game.new(difficulty: 'hard', mode: 'deathmatch')

game.inspect
# => #<Game:0x70238562842620 @difficulty="hard", @mode="deathmatch"> # Defaults inspect

SelectiveInspect.perform_inspect(game, :mode)
# => #<Game:0x70238562842620 @mode="deathmatch"> # Custom inspection

# You can also include the module in those classes you want to be inspected
# in a certain way by default, and add a whitelist or blacklist of variables.
#

class Player
  include SelectiveInspect
  inspectable_vars :id, :nickname, :score, :health, :ip_address
  # ...
end

class Weapon
  include SelectiveInspect
  uninspectable_vars :range, :damage
  # ...
end
weapon = Weapon.new(type: 'Bazooka', ammo: 3, range: 600, damage: 'max')
player = Player.new(id: 1, name: 'John', health: 100, weapon: weapon)

player.inspect
# =>

# Even if you have included the module, you still can pass a whitelist
# of variables to inspect.
#

player.inspect(:nickname, :ip_address)
# =>
```

## TODOs (by priority)
1. Allow to pass a list of instance methods to inspect along with the instance variables
2. Avoid infinite recursion checking for cycles.
3. Rails environment integration: Only enable it for development and test.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
