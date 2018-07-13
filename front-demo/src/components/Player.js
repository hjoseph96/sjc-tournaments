import React, { Component } from "react";

export default class Player extends Component {
  constructor(props) {
    super(props);

    this.state = {
      type: "damage",
      amount: 0.0,
      to: 0,
      from: 0,
      index: 0
    }

    this._handleChange = this._handleChange.bind(this);
    this._handleTargetChange = this._handleTargetChange.bind(this);
    this._getRandom = this._getRandom.bind(this);
  }

  componentDidMount() {
    this.setState({ to: this.props.player.id, from: this.props.player.id, index: this.props.index })
  }

  _handleChange(e) {
    let amount = this._getRandom([14.4, 13.6, 32.1, 35.2, 26.4]);
    this.setState({ type: e.target.value, amount: amount });

    this.props.callbackParent(this.state);
  }

  _handleTargetChange(e) {
    this.setState({ to: e.target.value })

    this.props.callbackParent(this.state);
  }

  _getRandom(arr) { return arr[Math.floor(Math.random * arr.length)] }

  render() {
    return(
      <tr>
        <td>{this.props.player.id}</td>        
        <td>{this.props.player.healthPoints}/100</td>
        <td>{this.props.player.shieldPoints}</td>
        <td>{this.props.player.luck}</td>
        <td>{this.props.player.accuracy}</td>

        <td>
          <select value={this.state.type} onChange={this._handleChange}>
            <option value="damage">Bomb</option>
            <option value="shield">Shield</option>
          </select>
        </td>

        <td>
          <select value={this.state.to} onChange={this._handleTargetChange}>
            {
              this.props.players.map(player => (
                <option key={player.id} value={player.id}>{player.id}</option>
              ))
            }
          </select>
        </td>
      </tr>
    )
  }
}