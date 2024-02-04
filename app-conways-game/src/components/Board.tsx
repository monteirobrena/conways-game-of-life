import React, { ChangeEvent, MouseEvent } from 'react';
import { v4 as uuidv4 } from 'uuid';
import './Board.css';

type CreateBoardResponse = {
  id: number;
  size: number;
  attempts: number;
  cells: [];
};

class Board extends React.Component {
  state = {
    size: 10,
    attempts: 1,
    cells: []
  };

  apiBaseUrl = 'https://bookish-space-fiesta-5vw4vwj9r346q7-3000.app.github.dev';

  handleParamsChange = (event: ChangeEvent<HTMLInputElement>) => {
    this.setState({
      [event.target.id]: event.target.value
    });
  };

  handleSubmit = async (event: MouseEvent<HTMLButtonElement>) => {
    const cells = this.getRamdomCells();

    this.setState({
      cells: cells
    });

    try {
      const response = await fetch(this.apiBaseUrl + '/boards', {
        method: 'POST',
        mode: 'cors',
        body: JSON.stringify({
          board: {
            size: this.state.size,
            attempts: this.state.attempts,
            cells: cells
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
    const min = 1;
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  render() {
    const space = 20;
    const sizeSquare = 18;
    const boardSquares = [];

    let x_position = 0;
    let y_position = 0;

    for (let row = 1; row <= this.state.size + 1; row++) {
      for (let col = 1; col <= this.state.size; col++) {
        y_position = (col * space) - space;
        boardSquares.push(<rect key={uuidv4()} width={sizeSquare} height={sizeSquare} x={x_position} y={y_position} fill="#fff" />);
      }
      x_position = (row * space) - space;
    } 

    return (
      <div className="Board">
        <h1>Conway's Game Life</h1>
        <label>Size</label>
        <input id="size" type="number" min="1" value={this.state.size} onChange={this.handleParamsChange} />
        <label>Attempts</label>
        <input id="attempts" type="number" min="1" value={this.state.attempts} onChange={this.handleParamsChange} />
        <button type="submit" onClick={this.handleSubmit}>Start new board</button>
        <svg
          width={500}
          height={500}
          viewBox="0 0 500 500"
          xmlns="http://www.w3.org/2000/svg"
        >
          {boardSquares}
        </svg>
      </div>
    );
  }
}

export default Board;
