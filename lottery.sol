
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;//using array because there are many participants

    constructor(){
        manager=msg.sender; //will transfer the address to the manager
    }

    receive() external payable //can be used only once
    {
        require(msg.value==1 ether);
        participants.push(payable( msg.sender));

    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender== manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length))) ;
    }

    function selectWinner() public
    
    {

        require(msg.sender==manager); //only manager can select the winner
        require(participants.length>=10);// lottery process will take place only when there are more than 10 people
        uint r=random();
        address payable winner;
        uint index = r % participants.length; // by using participants length me make sure that the value is always smaller than participants length as the random number creates 16 didgit number so to make it samll we are using modulas
        winner=participants[index];
        winner.transfer(getBalance());
        participants= new address payable[](0);


    }
}