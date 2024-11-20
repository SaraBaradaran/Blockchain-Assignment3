module 0x123::dapp {
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::event;

    // Structure to store participant information
    public struct Participant has key, store {
        id: UID,
        name: address, 
        account_value: u64, // Represents the state of each participant
    }

    // Define a shared object to hold the vector of Participants
    public struct ParticipantList has key {
        id: UID,
        participants: vector<Participant>,
    }
    
    public struct SuccessfulPaymentEvent has drop, copy, store {
        payer: address,
        payee: address,
        amount: u64,
    }

    public struct FailedPaymentEvent has drop, copy, store {
        payer: address,
        payee: address,
        amount: u64,
    }

    fun init(ctx: &mut TxContext) { 
        initialize_participants(ctx);
    }

    // Initialize participants with starting state
    fun initialize_participants(ctx: &mut TxContext) {
        let mut participants = vector::empty<Participant>();
        let mut address_list = vector::empty<address>();
        vector::push_back(&mut address_list, @0x1);
        vector::push_back(&mut address_list, @0x2);
        vector::push_back(&mut address_list, @0x3);
        vector::push_back(&mut address_list, @0x4);
        vector::push_back(&mut address_list, @0x5);
        vector::push_back(&mut address_list, @0x6);
        vector::push_back(&mut address_list, @0x7);
        vector::push_back(&mut address_list, @0x8);
        vector::push_back(&mut address_list, @0x9);
        vector::push_back(&mut address_list, @0x10);
        vector::push_back(&mut address_list, @0x11);
        vector::push_back(&mut address_list, @0x12);
        vector::push_back(&mut address_list, @0x13);
        vector::push_back(&mut address_list, @0x14);
        vector::push_back(&mut address_list, @0x15);
        let participants_num = vector::length(&address_list);
        let mut i = 0;
        while (i < participants_num) {
            let new_participant = add_new_participant(ctx, address_list[i]);
            vector::push_back(&mut participants, new_participant);
            i = i + 1;
        }; let participant_list = ParticipantList { id: object::new(ctx), participants: participants };
        // Publish list of participants as a shared object
        transfer::share_object(participant_list);
    }

    fun add_new_participant(ctx: &mut TxContext, p_name: address): Participant {
        let participant = Participant { id: object::new(ctx), name: p_name, account_value: 20 };
        participant
    }

    // Function to check if all conditions are satisfied
    fun check_conditions(payer: address, payee: address, participant_list: &ParticipantList, threshold: u64): bool {
        let mut satisfied: bool = true;
        let participants = &participant_list.participants;
        let participants_num = vector::length(participants);
        let mut i = 0;
        while(i < participants_num) {
            let participant = &participants[i];
            if (participant.name != payer && participant.name != payee) {
                if (participant.account_value < threshold) {
                    satisfied = false;
                    break
                };
            }; i = i + 1;
        }; satisfied
    }
    
    // Function for doing a payment
    public fun pay(coin: &mut Coin<SUI>, ctx: &mut TxContext, amount: u64, payee: address, participant_list: &mut ParticipantList) {
        let payer = ctx.sender();
        if (check_conditions(payer, payee, participant_list, 0)) { // Check if coditions are satisfied
            transfer::public_transfer(coin::split(coin, amount, ctx), payee);
            update_account_value(payer, payee, amount, participant_list);
            event::emit(SuccessfulPaymentEvent { payer: payer, payee: payee, amount: amount });
        } else {
            event::emit(FailedPaymentEvent { payer: payer, payee: payee, amount: amount });
        }
    }
    
    // Function for updating the account value (state) for each participant
    fun update_account_value(payer: address, payee: address, amount: u64, participant_list: &mut ParticipantList) {
	let participants = &mut participant_list.participants;
        let participants_num = vector::length(participants);
        let mut i = 0;
        while(i < participants_num) {
            let participant = &mut participants[i];
            if (participant.name == payer) {
                participant.account_value = participant.account_value - amount;
            }; 
            if (participant.name == payee) {
                participant.account_value = participant.account_value + amount;
            }; i = i + 1;
        }
    }    
}
