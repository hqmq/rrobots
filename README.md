This is a derivation of [Rrobots by Jason Jones](https://github.com/ralreegorganon/rrobots).
It is implemented using [gosu](https://rubygems.org/gems/gosu) to handle the 2D drawing of the robots.

This derivation exposes the game as a UDP server.
This allows participants to implement their tank in any language they like.
[Tankinho](https://github.com/mmmries/tankinho) is an example implementation in Elixir.

<iframe width="560" height="315" src="https://www.youtube.com/embed/MWC36pFxUrs" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Usage

First you'll need to make sure you have a few dependencies in order to make gosu work.

```
$ brew install sdl2 gosu
$ git clone https://github.com/mmmries/rrobots.git
$ cd rrobots
$ bundle install
$ bundle exec server --resolution=1024,1024 --timeout 3000 --min-players=2 --max-players=4
```

This will start a UDP server that waits for at least 2 clients to join and then put them into a game.
