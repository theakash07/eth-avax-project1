// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GymManagementSystem {
    // State variables
    address public owner;
    mapping(address => Member) public members;

    // Struct for member data
    struct Member {
        string name;
        uint8 workoutLevel; // Represents the member's workout intensity level
        bool isRegistered;
    }

    // Event declarations
    event MemberRegistered(address memberAddress, string name);
    event WorkoutLevelUpdated(address memberAddress, uint8 newLevel);
    event MemberNameUpdated(address memberAddress, string newName);

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
    }

    // Function to register a new gym member
    function registerMember(address memberAddress, string memory name) public onlyOwner {
        require(!members[memberAddress].isRegistered, "Member already registered");
        members[memberAddress] = Member(name, 0, true);
        emit MemberRegistered(memberAddress, name);
    }

    // Function to update a member's workout level
    function updateWorkoutLevel(address memberAddress, uint8 newLevel) public onlyOwner {
        // Ensure the member is registered
        require(members[memberAddress].isRegistered, "Member is not registered");
        
        // Ensure the workout level is within valid range (0-10)
        require(newLevel <= 10, "Workout level must be between 0 and 10");

        members[memberAddress].workoutLevel = newLevel;
        emit WorkoutLevelUpdated(memberAddress, newLevel);
    }

    // Function to get a member's details
    function getMemberDetails(address memberAddress) public view returns (string memory, uint8) {
        // Ensure the member is registered
        require(members[memberAddress].isRegistered, "Member is not registered");

        // Use assert to ensure data consistency
        assert(bytes(members[memberAddress].name).length > 0);

        return (members[memberAddress].name, members[memberAddress].workoutLevel);
    }

    // Function to remove a member (for demonstration purposes)
    function removeMember(address memberAddress) public onlyOwner {
        // Ensure the member is registered
        require(members[memberAddress].isRegistered, "Member is not registered");

        // Revert if the member is being removed with a workout level (business rule)
        if (members[memberAddress].workoutLevel > 0) {
            revert("Cannot remove member with a non-zero workout level");
        }

        delete members[memberAddress];
    }

    // Function to update a member's name
    function updateMemberName(address memberAddress, string memory newName) public onlyOwner {
        // Ensure the member is registered
        require(members[memberAddress].isRegistered, "Member is not registered");

        // Use assert to ensure name is valid
        assert(bytes(newName).length > 0);

        members[memberAddress].name = newName;
        emit MemberNameUpdated(memberAddress, newName);
    }

    // Function to check if a member is registered
    function isMemberRegistered(address memberAddress) public view returns (bool) {
        // Ensure the member is registered
        require(members[memberAddress].isRegistered, "Member is not registered");

        return members[memberAddress].isRegistered;
    }
}
