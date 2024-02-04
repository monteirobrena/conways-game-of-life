import React, { ChangeEvent, MouseEvent } from 'react';
import './Board.css';

type CreateBoardResponse = {
  id: number;
  size: number;
  attempts: number;
  cells: [];
};

class Board extends React.Component {
  state = {
    size: 1,
    attempts: 1,
  };

  apiBaseUrl = 'https://bookish-space-fiesta-5vw4vwj9r346q7-3000.app.github.dev';

  handleParamsChange = (event: ChangeEvent<HTMLInputElement>) => {
    this.setState({
      [event.target.id]: event.target.value
    });
  };

  handleSubmit = async (event: MouseEvent<HTMLButtonElement>) => {
    try {
      const response = await fetch(this.apiBaseUrl + '/boards', {
        method: 'POST',
        mode: 'cors',
        body: JSON.stringify({
          board: {
            size: this.state.size,
            attempts: this.state.attempts,
            cells: this.getRamdomCells()
          }
        }),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          Accept: 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Error! status: ${response.json()}`);
      }

      const result = (await response.json()) as CreateBoardResponse;
      console.log('result is: ', JSON.stringify(result, null, 4));
      return result;
    } catch (error) {
      if (error instanceof Error) {
        console.log('error message: ', error.message);
        return error.message;
      } else {
        console.log('unexpected error: ', error);
        return 'An unexpected error occurred';
      }
    }
  };

  getRamdomCells() {
    let cells = [];

    for(let cellsSize = this.getRandomNumber(this.state.size); cellsSize--;) {
      cells.push({
        alive: true,
        x_position: this.getRandomNumber(this.state.size),
        y_position: this.getRandomNumber(this.state.size)
      });
    }

    return cells;
  }

  getRandomNumber(max: number) {
    return Math.floor(Math.random() * max);
  };

  render() {
    return (
      <div className="Board">
        <h1>Conway's Game Life</h1>
        <label>Size</label>
        <input id="size" type="number" min="1" value={this.state.size} onChange={this.handleParamsChange} />
        <label>Attempts</label>
        <input id="attempts" type="number" min="1" value={this.state.attempts} onChange={this.handleParamsChange} />
        <button type="submit" onClick={this.handleSubmit}>Start new board</button>
      </div>
    );
  }
}

export default Board;
