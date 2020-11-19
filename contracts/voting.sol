pragma solidity ^0.7.4;

contract voting {
    
    uint256 public yesTransfer;
    uint256 public noTransfer;
    uint256 public voteEnd;
    uint32 public voterCount;
    
    Proposal[] public proposals;
    Voter[] public voters;
    
    mapping(address => Voter) public voterList;
    mapping(uint => address) public idToAddress;
  
  
    struct Voter {
        uint id;
        bool voted;
        address voterAddress;
    }
    
    function checkBalance() view public returns(uint) {
        return(msg.sender.balance); 
    }
    
    function createVoter() public returns(uint, address) {
        voterCount = voterCount + 1;
        voters.push(Voter(voterCount, false, msg.sender));
        idToAddress[voterCount] = msg.sender;
        address output;
        output = idToAddress[voterCount];
        return (voterCount, output);
    }
    
    //function testVoterCreation() public returns(uint) {
    //    return voters[1];
    //}
    
    struct Proposal {
        uint256 id;
        bool result;
    }
    
    function assessVoter() public view returns(uint){
        uint weight = (msg.sender).balance;
        return (weight);
    }
    
    function decideToTransfer() public view returns(bool){
        bool shouldTransfer;
        if (yesTransfer > noTransfer){
            shouldTransfer = true;
        }
        return shouldTransfer;
    }
    
    
    
    //function proposeVote(uint durationMinutes){
    //    voteEnd = block.timestamp + (durationMinutes * 1 minutes);
        
    //}
    
    function setVoteEnd(uint _durationMinutes) public {
        voteEnd = block.timestamp + (_durationMinutes * 1 minutes);
    }
    
    function voteYesTransfer() public returns(uint){
        require(block.timestamp < voteEnd);
        yesTransfer = yesTransfer + 1;
        return yesTransfer;
    }
    
     function voteNoTransfer() public returns(uint){
        require(block.timestamp < voteEnd);
        noTransfer = noTransfer + 1;
        return noTransfer;
    }
    
    function checkYesTransfer() public view returns(uint){
        return yesTransfer;
    }
    
    modifier voteApproved() {
        require(decideToTransfer());
        _;
    }
    
    function transfer() public voteApproved view returns(uint) {
        return(1);
    }
   // function voteNoTranser() {
//        require(block.timestamp < voteEnd);
    //}
    
 
}

