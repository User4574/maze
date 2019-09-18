#!/usr/bin/env ruby

require "sinatra"
require "./lib/maze"
require "./lib/path"

def newmaze
  Maze.new(40, 30).generate_random(150)
end

def newpath(maze)
  Path.new(maze).generate_astar
end

maze = newmaze
path = newpath(maze)

get "/" do
  redirect "maze.html"
end

get "/api/v0.1/maze" do
  #redirect "maze.mml"
  maze.mml
end

post "/api/v0.1/maze" do
  maze = newmaze
  maze.mml
end

get "/api/v0.1/path" do
  #redirect "path.pml"
  path.pml
end

get "/api/v0.1/path/valid" do
  #redirect "path.pml"
  path.valid? ? "true" : "false"
end

post "/api/v0.1/path" do
  path = newpath(maze)
end
