// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OpenDAO {
    address public DAOToken = 0x7e992D8F57223661106c29e519E22A2a9a7BceFb;
    address public DAOTokenMockAddrss =
        0xF37778Ff2BE5819efee99A0eB7862515b43ED03F;

    struct preposal {
        address _creator;
        string preposal;
        uint256 date_expires;
        uint256 yes;
        uint256 no;
        uint256 total;
        bool descion;
        bool created;
        bool completed;
    }

    struct votingInfo {
        bool yes;
        bool no;
        bool voted;
    }

    mapping(uint256 => preposal) public Preposals;
    mapping(uint256 => mapping(address => votingInfo)) public VotingInfo;

    constructor() {}

    function createPreposal(
        string memory _preposal,
        uint256 _id,
        uint256 _expirationTime
    ) public returns (bool) {
        //10,000 in decimal
        require(
            IERC20(DAOTokenMockAddrss).balanceOf(msg.sender) >
                10000000000000000000000,
            "Sender Does not enough Have Tokens!"
        );
        require(Preposals[_id].created == false, "Preposal ID already taken");

        Preposals[_id]._creator = msg.sender;
        Preposals[_id].preposal = _preposal;
        Preposals[_id].created = true;
        Preposals[_id].completed = false;
        Preposals[_id].date_expires = _expirationTime;

        return (true);
    }

    function voteOnProposal(uint256 _id, bool _vote) public returns (bool) {
        require(
            Preposals[_id].date_expires >= block.timestamp,
            "No time left to vote"
        );
        require(
            IERC20(DAOTokenMockAddrss).balanceOf(msg.sender) > 0,
            "Sender Does not Have Tokens!"
        );
        require(Preposals[_id].created == true, "Invaild Preposal Id");
        require(Preposals[_id].completed == false, "Preposal is completed");
        require(
            VotingInfo[_id][msg.sender].voted == true,
            "Address has alread voted"
        );

        uint256 AmountOfTokens = IERC20(DAOTokenMockAddrss).balanceOf(
            msg.sender
        );

        if (_vote == true) {
            Preposals[_id].yes += AmountOfTokens;
            Preposals[_id].total += AmountOfTokens;
            VotingInfo[_id][msg.sender].yes = true;
        } else if (_vote == false) {
            Preposals[_id].no += AmountOfTokens;
            Preposals[_id].total += AmountOfTokens;
            VotingInfo[_id][msg.sender].no = true;
        }
        VotingInfo[_id][msg.sender].voted = true;
        return (true);
    }
}
