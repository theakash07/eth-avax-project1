# SchoolGradingSystem Smart Contract

This Solidity program implements a smart contract for managing a simple school grading system. It allows the owner (typically a school administrator) to register students, update their grades, and manage student records securely on the Ethereum blockchain.

## Description

The `SchoolGradingSystem` contract is written in Solidity, a programming language used to develop smart contracts on the Ethereum blockchain. The contract includes several functions that allow the owner to manage student records, update grades, and verify student registration status.

### Key Features:
- **Register Students:** The owner can register new students by providing their Ethereum address and name.
- **Update Grades:** The owner can assign or update a student's grade, ensuring that grades are within a valid range (0 to 100).
- **Get Student Grade:** Anyone can query a registered student's name and grade.
- **Update Student Name:** The owner can update a student's name if necessary.
- **Remove Students:** The owner can remove a student from the system, provided they have a grade of zero.
- **Check Registration:** Verify if a student is registered in the system.

## Getting Started

### Prerequisites

To interact with this contract, you will need:

- Basic knowledge of Solidity.
- Access to Remix, an online Solidity IDE.
- A MetaMask wallet or another Ethereum wallet for testing transactions.

### Executing Program

To run this program, you can use Remix, an online Solidity IDE. Follow these steps:

1. **Open Remix:** Go to [Remix](https://remix.ethereum.org/).

2. **Create a New File:** Click on the "+" icon in the left-hand sidebar. Save the file with a `.sol` extension (e.g., `SchoolGradingSystem.sol`).

3. **Copy the Code:** Copy and paste the following code into the file:

    ```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract SchoolGradingSystem {
        address public owner;
        mapping(address => Student) public students;

        struct Student {
            string name;
            uint8 grade;
            bool isRegistered;
        }

        event StudentRegistered(address studentAddress, string name);
        event GradeUpdated(address studentAddress, uint8 newGrade);
        event StudentNameUpdated(address studentAddress, string newName);

        modifier onlyOwner() {
            require(msg.sender == owner, "You are not the owner");
            _;
        }

        constructor() {
            owner = msg.sender;
        }

        function registerStudent(address studentAddress, string memory name) public onlyOwner {
            require(!students[studentAddress].isRegistered, "Student already registered");
            students[studentAddress] = Student(name, 0, true);
            emit StudentRegistered(studentAddress, name);
        }

        function updateGrade(address studentAddress, uint8 newGrade) public onlyOwner {
            require(students[studentAddress].isRegistered, "Student is not registered");
            require(newGrade <= 100, "Grade must be between 0 and 100");
            students[studentAddress].grade = newGrade;
            emit GradeUpdated(studentAddress, newGrade);
        }

        function getStudentGrade(address studentAddress) public view returns (string memory, uint8) {
            require(students[studentAddress].isRegistered, "Student is not registered");
            assert(bytes(students[studentAddress].name).length > 0);
            return (students[studentAddress].name, students[studentAddress].grade);
        }

        function removeStudent(address studentAddress) public onlyOwner {
            require(students[studentAddress].isRegistered, "Student is not registered");
            if (students[studentAddress].grade > 0) {
                revert("Cannot remove student with a non-zero grade");
            }
            delete students[studentAddress];
        }

        function updateStudentName(address studentAddress, string memory newName) public onlyOwner {
            require(students[studentAddress].isRegistered, "Student is not registered");
            assert(bytes(newName).length > 0);
            students[studentAddress].name = newName;
            emit StudentNameUpdated(studentAddress, newName);
        }

        function isStudentRegistered(address studentAddress) public view returns (bool) {
            require(students[studentAddress].isRegistered, "Student is not registered");
            return students[studentAddress].isRegistered;
        }
    }
    ```

4. **Compile the Contract:** Click on the "Solidity Compiler" tab, select your Solidity version (0.8.0 or higher), and compile the contract.

5. **Deploy the Contract:** Go to the "Deploy & Run Transactions" tab, choose the environment (e.g., JavaScript VM for testing), and deploy the contract.

6. **Interact with the Contract:** After deployment, use the interface in Remix to interact with the contract functions like registering students, updating grades, and querying student information.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
