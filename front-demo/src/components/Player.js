import React, { Component } from "react";

export default class Player extends Component {
  constructor(props) {
    super(props);

    console.log(this.props);
  }

  render() {
    return(
      <tr>
        <td>{this.props.player.id}</td>        
        <td>{this.props.player.healthPoints}/100</td>
        <td>{this.props.player.shieldPoints}</td>
        <td>{this.props.player.luck}</td>
        <td>{this.props.player.accuracy}</td>
      </tr>
    )
  }
}