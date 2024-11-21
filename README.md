# Blockchain-Assignment3


### DAPP Scenario
In the implemented DAPP, a shared object is first created and published into the blockchain, which contains the information of all 15 participants, including their states and addresses. Then, each participant can call the public entry function `pay` to pay other participants. When calling the function `pay` in a transaction, the aforementioned shared object should also be taken as an input. Accordingly, upon making a payment by calling `pay`, the contract will check if all participants, except the payer and the payee, have account values more than 0, then the payment would be successful. Otherwise, the payment fails. Here, the account value represents each participant's balance in the current DAPP. In the first step, each participant has an initial account value of 20. When a participant pays another participant by calling the function `pay` of the current contract (or DAPP), then the account value of the payer is reduced by the amount paid. Also, the account value of the payee is increased by the amount received. Based on this scenario, each participant is restricted in terms of the money they pay through this application if they do not get it back from other participants.

### Build the DAPP
You can compile the written contract by using the following commands:
```
git clone https://github.com/SaraBaradaran/Blockchain-Assignment3
cd Blockchain-Assignment3/DAPP/sources
sui move build
```
