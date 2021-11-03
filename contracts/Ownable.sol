pragma solidity 0.6.0;

contract Ownable {
    address _owner;
    
    constructor() public {
        _owner = address(msg.sender);
    }
    
    modifier onlyOwner() {
        require(isOwner(), "You are not the owner");
        _;
    }
    
    function isOwner() public view returns(bool) {
        return (msg.sender == _owner);
    }
}
