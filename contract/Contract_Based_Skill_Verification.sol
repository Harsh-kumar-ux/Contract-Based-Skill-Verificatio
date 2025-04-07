// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SkillVerification {

    address public admin;

    struct Skill {
        string skillName;
        string skillLevel;
        bool verified;
    }

    struct User {
        string name;
        string email;
        mapping(string => Skill) skills;
        string[] skillList;
    }

    mapping(address => User) public users;
    mapping(address => bool) public verifiers;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyVerifier() {
        require(verifiers[msg.sender], "Only verifiers can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerVerifier(address _verifier) public onlyAdmin {
        verifiers[_verifier] = true;
    }

    function registerUser(string memory _name, string memory _email) public {
        User storage user = users[msg.sender];
        user.name = _name;
        user.email = _email;
    }

    function addSkill(string memory _skillName, string memory _skillLevel) public {
        User storage user = users[msg.sender];
        user.skills[_skillName] = Skill(_skillName, _skillLevel, false);
        user.skillList.push(_skillName);
    }

    function verifySkill(address _userAddress, string memory _skillName) public onlyVerifier {
        require(bytes(users[_userAddress].skills[_skillName].skillName).length > 0, "Skill does not exist");
        users[_userAddress].skills[_skillName].verified = true;
    }

    function getSkill(address _userAddress, string memory _skillName) public view returns (string memory, string memory, bool) {
        Skill memory skill = users[_userAddress].skills[_skillName];
        return (skill.skillName, skill.skillLevel, skill.verified);
    }

    function getUser(address _userAddress) public view returns (string memory, string memory, string[] memory) {
        User storage user = users[_userAddress];
        return (user.name, user.email, user.skillList);
    }
}
