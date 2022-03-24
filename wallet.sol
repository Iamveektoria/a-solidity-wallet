//SPDX-License-Identifier: MIT

pragma solidity >= 0.7.0 <0.9.0;

contract wallet{

    //receive ether
    //send ether
    //withdraw ether
    //get balance of an address
    //get balance of the contract

    event deposit(address _addr, uint _amount);
    event send(address _addr, uint _amount);
    event withdraw(address _addr, uint _amount);

    //modifier

    modifier hasEnough(address _addr, uint _amount){
        require(balances[_addr] >= _amount, "insufficient funds");
        _;
    }

    //mapping called balances

    mapping (address => uint) public balances;

    //receive function for ether
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit deposit(msg.sender, msg.value);
    }


    //send function

    function Send(address _receiver, uint _amount) external hasEnough(msg.sender, _amount){
        balances[_receiver] += _amount;
        balances[msg.sender] -= _amount;
        emit send(_receiver, _amount);
    }


    //withdraw ether 

    function Withdraw(uint _amount) external hasEnough(msg.sender, _amount){
        balances[msg.sender] -= _amount;
        address payable _receiver = payable (msg.sender);
        (bool sent,) = _receiver.call{value:_amount}("");
        require(sent, "ether not sent");
        emit withdraw(msg.sender, _amount);

    }

    //get balance of an address

    function getBalance(address _addr) external view returns(uint){
        return balances[_addr];
    }

    //get contract balance

    function getContractBalance() external view returns(uint){
        return address(this).balance;
    }
}