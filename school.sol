// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolGradingSystem {
    // State variables
    address public owner;
    mapping(address => Student) public students;

    // Struct for student data
    struct Student {
        string name;
        uint8 grade;
        bool isRegistered;
    }

    // Event declarations
    event StudentRegistered(address studentAddress, string name);
    event GradeUpdated(address studentAddress, uint8 newGrade);
    event StudentNameUpdated(address studentAddress, string newName);

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
    }

    // Function to register a student
    function registerStudent(address studentAddress, string memory name) public onlyOwner {
        require(!students[studentAddress].isRegistered, "Student already registered");
        students[studentAddress] = Student(name, 0, true);
        emit StudentRegistered(studentAddress, name);
    }

    // Function to update a student's grade
    function updateGrade(address studentAddress, uint8 newGrade) public onlyOwner {
        // Ensure the student is registered
        require(students[studentAddress].isRegistered, "Student is not registered");
        
        // Ensure the grade is within valid range
        require(newGrade <= 100, "Grade must be between 0 and 100");

        students[studentAddress].grade = newGrade;
        emit GradeUpdated(studentAddress, newGrade);
    }

    // Function to get a student's grade
    function getStudentGrade(address studentAddress) public view returns (string memory, uint8) {
        // Ensure the student is registered
        require(students[studentAddress].isRegistered, "Student is not registered");

        // Use assert to ensure data consistency
        assert(bytes(students[studentAddress].name).length > 0);

        return (students[studentAddress].name, students[studentAddress].grade);
    }

    // Function to remove a student (for demonstration purposes)
    function removeStudent(address studentAddress) public onlyOwner {
        // Ensure the student is registered
        require(students[studentAddress].isRegistered, "Student is not registered");

        // Revert if the student is being removed with a non-zero grade (business rule)
        if (students[studentAddress].grade > 0) {
            revert("Cannot remove student with a non-zero grade");
        }

        delete students[studentAddress];
    }

    // Function to update a student's name
    function updateStudentName(address studentAddress, string memory newName) public onlyOwner {
        // Ensure the student is registered
        require(students[studentAddress].isRegistered, "Student is not registered");

        // Use assert to ensure name is valid
        assert(bytes(newName).length > 0);

        students[studentAddress].name = newName;
        emit StudentNameUpdated(studentAddress, newName);
    }

    // Function to check if a student is registered
    function isStudentRegistered(address studentAddress) public view returns (bool) {
        // Ensure the student is registered
        require(students[studentAddress].isRegistered, "Student is not registered");

        return students[studentAddress].isRegistered;
    }
}
