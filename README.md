# GymManagementSystem Smart Contract

This Solidity program implements a smart contract for managing a gym's member system. It allows the owner (typically a gym administrator) to register members, update their workout levels, and manage member records securely on the Ethereum blockchain.

## Description

The `GymManagementSystem` contract is written in Solidity, a programming language used to develop smart contracts on the Ethereum blockchain. The contract includes several functions that allow the owner to manage gym member records, update workout levels, and verify member registration status.

### Key Features:
- **Register Members:** The owner can register new gym members by providing their Ethereum address and name.
- **Update Workout Levels:** The owner can assign or update a member's workout level, ensuring that levels are within a valid range (0 to 10).
- **Get Member Details:** Anyone can query a registered member's name and workout level.
- **Update Member Name:** The owner can update a member's name if necessary.
- **Remove Members:** The owner can remove a member from the system, provided they have a workout level of zero.
- **Check Registration:** Verify if a member is registered in the system.

## Getting Started

### Prerequisites

To interact with this contract, you will need:

- Basic knowledge of Solidity.
- Access to Remix, an online Solidity IDE.
- A MetaMask wallet or another Ethereum wallet for testing transactions.

### Executing Program

To deploy and interact with this contract, you can use Remix, an online Solidity IDE. Follow these steps:

1. **Open Remix:** Go to [Remix](https://remix.ethereum.org/).

2. **Create a New File:** Click on the "+" icon in the left-hand sidebar. Save the file with a `.sol` extension (e.g., `GymManagementSystem.sol`).

3. **Copy the Code:** Copy and paste the following code into the file:

    ```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract GymManagementSystem {
        address public owner;
        mapping(address => Member) public members;

        struct Member {
            string name;
            uint8 workoutLevel; // Represents the member's workout intensity level
            bool isRegistered;
        }

        event MemberRegistered(address memberAddress, string name);
        event WorkoutLevelUpdated(address memberAddress, uint8 newLevel);
        event MemberNameUpdated(address memberAddress, string newName);

        modifier onlyOwner() {
            require(msg.sender == owner, "You are not the owner");
            _;
        }

        constructor() {
            owner = msg.sender;
        }

        function registerMember(address memberAddress, string memory name) public onlyOwner {
            require(!members[memberAddress].isRegistered, "Member already registered");
            members[memberAddress] = Member(name, 0, true);
            emit MemberRegistered(memberAddress, name);
        }

        function updateWorkoutLevel(address memberAddress, uint8 newLevel) public onlyOwner {
            require(members[memberAddress].isRegistered, "Member is not registered");
            require(newLevel <= 10, "Workout level must be between 0 and 10");
            members[memberAddress].workoutLevel = newLevel;
            emit WorkoutLevelUpdated(memberAddress, newLevel);
        }

        function getMemberDetails(address memberAddress) public view returns (string memory, uint8) {
            require(members[memberAddress].isRegistered, "Member is not registered");
            assert(bytes(members[memberAddress].name).length > 0);
            return (members[memberAddress].name, members[memberAddress].workoutLevel);
        }

        function removeMember(address memberAddress) public onlyOwner {
            require(members[memberAddress].isRegistered, "Member is not registered");
            if (members[memberAddress].workoutLevel > 0) {
                revert("Cannot remove member with a non-zero workout level");
            }
            delete members[memberAddress];
        }

        function updateMemberName(address memberAddress, string memory newName) public onlyOwner {
            require(members[memberAddress].isRegistered, "Member is not registered");
            assert(bytes(newName).length > 0);
            members[memberAddress].name = newName;
            emit MemberNameUpdated(memberAddress, newName);
        }

        function isMemberRegistered(address memberAddress) public view returns (bool) {
            require(members[memberAddress].isRegistered, "Member is not registered");
            return members[memberAddress].isRegistered;
        }
    }
    ```

4. **Compile the Contract:** Go to the "Solidity Compiler" tab in Remix, select the appropriate compiler version (0.8.x), and click "Compile GymManagementSystem.sol."

5. **Deploy the Contract:** Switch to the "Deploy & Run Transactions" tab, ensure the correct environment is selected (e.g., JavaScript VM for testing), and click "Deploy."

6. **Interact with the Contract:** Use the provided functions to manage gym members. You can register new members, update workout levels, get member details, and more.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Solidity Documentation: [Solidity Docs](https://docs.soliditylang.org/)
- Remix IDE: [Remix](https://remix.ethereum.org/)
