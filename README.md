## About

This is a thing that allows a team to update and view the progress of work through the release process of clouds, staging and then to live.

It allows updating and viewing in Campfire via a [Hubot (GitHub's Campfire bot)][1] script, and includes a wall display (information radiator) for large screen team viewing.


## Usage

Get help on commands :

    Hubot> hubot qa help
    Your QA Board, at your service! (goto http://0.0.0.0:9292/ for the full screen thingy)
    qa info - shows the qa board here
    qa add <phase name> <ticket number> <person> - adds aa item to the board
    qa remove <phase name> <ticket number> - removes an item from the board

Get info about current status :

    Hubot> qa info
    qa1 | - => - |
    qa2 | - => - |
    qa3 | - => - |
    qa4 | - => - |
    ready | - => - |
    staging1 | - => - |
    staging2 | - => - |
    live | - => - |

Adding info :

    Hubot> hubot qa add qa1 123 Ian
    Hubot> 200
    Hubot> qa1 | 123 => Ian |
    Hubot> hubot qa info
    Hubot> qa1 | 123 => Ian |
    qa2 | - => - |
    qa3 | - => - |
    qa4 | - => - |
    ready | - => - |
    staging1 | - => - |
    staging2 | - => - |
    live | - => - |

Whoa, add another :

    Hubot> hubot qa add qa1 567 Foo
    Hubot> 200
    Hubot> qa1 | 123 => Ian | 567 => Foo |
    Hubot> hubot qa info
    Hubot> qa1 | 123 => Ian | 567 => Foo |
    qa2 | - => - |
    qa3 | - => - |
    qa4 | - => - |
    ready | - => - |
    staging1 | - => - |
    staging2 | - => - |
    live | - => - |


Wall display

![Wall](http://cl.ly/image/0G1J0I0h0Y2N)


[1]: http://hubot.github.com/
