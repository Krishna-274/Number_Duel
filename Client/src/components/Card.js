import React from 'react';

function Card({ card }) {
    return (
        <div className="card">
            <p>Attack: {card.attack_power}</p>
            <p>Defense: {card.defense_value}</p>
            <p>Ability: {card.ability}</p>
        </div>
    );
}

export default Card;
