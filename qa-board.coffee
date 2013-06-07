QS = require 'querystring'

server_url = "http://qa-board.herokuapp.com/"
# server_url = "http://0.0.0.0:9292/" # process.env.QA_BOARD_URL

module.exports = (robot) ->
  robot.respond /qa help/i, (msg) ->
    text = "Your QA Board, at your service! (goto " + server_url + " for the full screen thingy)\n"
    text += "qa info - shows the qa board here\n"
    text += "qa add <phase name> <ticket number> <person> - adds aa item to the board\n"
    text += "qa remove <phase name> <ticket number> - removes an item from the board\n"
    msg.reply(text)

  robot.respond /qa info/i, (msg) ->
    msg.http(server_url + ".text")
      .get() (err, res, body) ->
        msg.send(body)

  robot.respond /qa (add|remove|rm) ?(\w+)? ?(\w+)? ?(.*)?/i, (msg) ->
    action = msg.match[1]
    phase = msg.match[2]
    ticket = msg.match[3]
    who = msg.match[4]

    data = QS.stringify({phase: phase, ticket: ticket, who: who})

    msg.http(server_url + action + "/.text")
      .post(data) (err, res, body) ->
        msg.send(res.statusCode)
        switch res.statusCode
          when 200
            msg.send(body)
          else
            msg.send("Something was wrong, try again!")
            msg.send(body)
