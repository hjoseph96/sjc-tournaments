import React, { Component } from 'react';
import { Socket } from "phoenix";

const graphql = require("graphql.js");

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      players: []
    }

    this._createGame = this._createGame.bind(this);
    this._addPlayer = this._addPlayer.bind(this);
    this._getGame = this._getGame.bind(this);
    this._getRandom = this._getRandom.bind(this);
  }

  componentWillMount() {
    let socket = new Socket("ws://localhost:4000/game", {})
    socket.connect()

    this.channel = socket.channel("game:first", {})

    this.channel.join()
    .receive("ok", resp => { console.log("Joined", resp) })
    .receive("error", resp => { console.log("Error", resp) })

    // Creates graphql connection
    this.graph = graphql("http://localhost:4000/api");

    console.log("Initialized")
  }

  initiatePlayers() {
    let ids = [1, 2, 3, 4, 5];
    let luck = [40.0, 24.1, 8.3, 9.1, 38.2];
    let accuracies = [3.4, 6.4, 12.6, 31.4, 8.3];
    let sp = [50.3, 43.5, 93.4, 84.3, 53.4];

    for(let i = 0; i <= ids.length; i++) {
      let rand = this._getRandom();

      this._addPlayer(ids[i], luck[rand], accuracies[rand], sp[rand]);
    }
  }

  _getRandom() { return Math.floor(Math.random() * 5) }

  _createGame() {
    this.graph(`mutation {
      createGame(name: "first") {
        name
        round {
          number
        }
        players {
          id
        }
        specialRules {
          carePackage
        }
      }
    }`, {})
    .then(res => {
      this.initiatePlayers();
      console.log(res)
    })
    .catch(err => { console.log(err) })
  }

  _addPlayer(_id, _luck, _accuracy, _sp) {
    this.graph(`mutation ($id: ID!, $luck: Float!, $accuracy: Float!, $sp: Float!) {
      addPlayer(
        name: "first",
        attributes: {
          id: $id
          healthPoints: 100.0
          shieldPoints: $sp
          luck: $luck
          accuracy: $accuracy
        }
      ) {
        name
        players {
          id
          healthPoints
        }
        round {
          number
        }
        specialRules {
          carePackage
        }
      }
    }
    `, {
      id: _id, luck: _luck, accuracy: _accuracy, sp: _sp
    })
    .then(res => { console.log(res) })
    .catch(err => { console.log(err) })
  }

  _getGame() {
    this.graph(`query {
      getGame(name: "first") {
        players {
          id
          healthPoints
          shieldPoints
          luck
          accuracy
        }
        name
      }
    }`, {})
    .then(res => { this.setState({ players: res.getGame.players }) })
    .catch(err => { console.log(err) })
  }

  render() {
    return (
      <div className="container">
        <h3 onClick={this._createGame}>Create game</h3>
        <h3 onClick={this._getGame}>Get current game</h3>

        <br />

        <table className="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>HP</th>
              <th>SP</th>
              <th>Luck</th>
              <th>Accuracy</th>
            </tr>
          </thead>

          <tbody>
            {
              this.state.players.map((player, index) => {
                return(
                  <tr key={"body_" + index}>
                    <td>{player.id}</td>
                    <td>{player.healthPoints}</td>
                    <td>{player.shieldPoints}</td>
                    <td>{player.luck}</td>
                    <td>{player.accuracy}</td>
                  </tr>
                )
              })
            }
          </tbody>
        </table>
      </div>
    );
  }
}

export default App;