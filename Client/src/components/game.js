import React, { useState } from 'react';
import Card from './Card';
import BattleOutcome from './BattleOutcome';
import PlayerStats from './PlayerStats';

function Game() {
    const [outcome, setOutcome] = useState('');
    const [player1Wins, setPlayer1Wins] = useState(0);
    const [player2Wins, setPlayer2Wins] = useState(0);

    const handleDuel = () => {
      
        if (player1CardValue > player2CardValue) {
            setOutcome('Player 1 wins!');
            setPlayer1Wins(player1Wins + 1);
        } else if (player2CardValue > player1CardValue) {
            setOutcome('Player 2 wins!');
            setPlayer2Wins(player2Wins + 1);
        } else {
            setOutcome('It\'s a tie!');
        }
    };


    return (
        <div className="game">
            <div className="player" id="player1">
                {/* Display player 1's NFTs here */}
            </div>
            <div className="battle-area">
                <button onClick={handleDuel}>Duel</button>
                <BattleOutcome outcome={outcome} />
            </div>
            <div className="player" id="player2">
                {/* Display player 2's NFTs here */}
            </div>
            <PlayerStats player1Wins={player1Wins} player2Wins={player2Wins} />
        </div>
    );
}

export default Game;
