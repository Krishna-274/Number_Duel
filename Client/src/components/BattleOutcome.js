import React from 'react';

function BattleOutcome({ outcome }) {
    return (
        <div className="battle-outcome">
            <p>{outcome}</p>
        </div>
    );
}

export default BattleOutcome;
