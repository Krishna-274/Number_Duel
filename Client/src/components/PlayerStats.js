import React from 'react';

function PlayerStats({ player1Wins, player2Wins }) {
    return (
        <div className="player-stats">
            <h2>Player Statistics</h2>
            <p>Player 1 Wins: {player1Wins}</p>
            <p>Player 2 Wins: {player2Wins}</p>
        </div>
    );
}

export default PlayerStats;
