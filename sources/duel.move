module duel::game {
    use aptos_framework::timestamp;
    use std::string::{Self, String};
    use aptos_framework::coin::{Self, Coin, BurnCapability, FreezeCapability, MintCapability};
    use aptos_framework::account;
    use std::signer;
}
module NFTs {
    // NFT struct
    struct NFT {
        card_type: CardTypes::Card,
        owner: address,
    }

    // Function to mint a new NFT
    public fun mintNFT(card: CardTypes::Card): NFT {
        let sender = get_txn_sender();
        NFT {
            card_type: card,
            owner: sender,
        }
    }

    // Function to transfer NFT ownership
    public fun transferNFT(nft: &mut NFT, new_owner: address) {
        let sender = get_txn_sender();
        assert(sender == nft.owner, "Only the owner can transfer NFT");
        nft.owner = new_owner;
    }
}
module Player {
    struct PlayerProfile {
        address: address,
        nft_collection: vector<NFTs::NFT>,
        wins: u64,
        losses: u64,
    }

    // Function to create a new player profile
    public fun createPlayerProfile(addr: address): PlayerProfile {
        PlayerProfile {
            address: addr,
            nft_collection: empty,
            wins: 0,
            losses: 0,
        }
    }
}
module CardTypes {
    struct Card {
        attack_power: u64,
        defense_value: u64,
        ability: SpecialAbility,
    }

    pub enum SpecialAbility {
        None,
        Healing,
        ExtraDamage,
       
    }

    // Function to activate the Healing ability
    public fun activateHealingAbility(card: &mut Card) {
        // Only apply healing ability if the card has the Healing ability
        assert(card.ability == SpecialAbility::Healing, "Card doesn't have the Healing ability");

        // Calculate the amount of healing
        let healing_amount = card.ability_strength; // You can adjust the healing strength as needed

        // Apply healing to the card's owner
        let sender = get_txn_sender();
        let playerProfile = &mut Player::playerProfiles[sender];

        // Ensure the player owns the card
        let owned_card = playerProfile.nft_collection
            .find(|nft| nft.card_type == card);
        assert(owned_card.is_some(), "Player doesn't own the card");

        // Apply healing
        owned_card.unwrap().card_type.defense_value += healing_amount;
    }
}
module Battle {
    // Function to simulate a battle and distribute rewards
    public fun simulateBattle(player1_card: CardTypes::Card, player2_card: CardTypes::Card): bool {
        let player1_win_chance = player1_card.attack_power / (player1_card.attack_power + player2_card.attack_power);
        let random_number =  timestamp::now_microseconds() % 10;;

        if (random_number <= player1_win_chance) {
            // Player 1 wins
            let winner = get_txn_sender();
            CardTypes::activateSpecialAbility(player1_card);
            distributeRewardsAndStats(player1, player2, winner);
            return true;
        } else {
            // Player 2 wins
            let winner = get_txn_sender();
            CardTypes::activateSpecialAbility(player2_card);
            distributeRewardsAndStats(player1, player2, winner);
            return false;
        }
    }

    // Function to distribute rewards and update player stats
    public fun distributeRewardsAndStats(player1: address, player2: address, winner: address) {
        let player1Profile = &mut Player::playerProfiles[player1];
        let player2Profile = &mut Player::playerProfiles[player2];

        if winner == player1 {
            player1Profile.wins += 1;
            player2Profile.losses += 1;

            // Transfer NFT ownership from player2 to player1
            for nft in player2Profile.nft_collection {
                NFTs::transferNFT(&mut nft, player1);
                push_back(&mut player1Profile.nft_collection, nft);
            }
            player2Profile.nft_collection = empty;
        } else {
            player2Profile.wins += 1;
            player1Profile.losses += 1;

            // Transfer NFT ownership from player1 to player2
            for nft in player1Profile.nft_collection {
                NFTs::transferNFT(&mut nft, player2);
                push_back(&mut player2Profile.nft_collection, nft);
            }
            player1Profile.nft_collection = empty;
        }
    }
}
