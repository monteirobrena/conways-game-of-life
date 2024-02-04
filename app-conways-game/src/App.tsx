import React from 'react';
import './App.css';

const apiBaseUrl = 'https://bookish-space-fiesta-5vw4vwj9r346q7-3000.app.github.dev';

type CreateBoardResponse = {
  size: number;
  attempts: number;
};

async function createBoard() {
  try {
    const response = await fetch(apiBaseUrl + '/boards', {
      method: 'POST',
      mode: 'cors',
      body: JSON.stringify({
        size: 30,
        attempts: 10,
      }),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`Error! status: ${response.status}`);
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
}

function App() {
  return (
    <div className="App">
      <button
        type="submit"
        onClick={createBoard}
      >
        Start
      </button>
    </div>
  );
}

export default App;
