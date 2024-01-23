// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@gnosis.pm/safe-contracts@1.3.0/contracts/GnosisSafe.sol";

contract Ownable  
{     
  // Variable that maintains  
  // owner address 
  address private _owner; 
  
  // Sets the original owner of  
  // contract when it is deployed 
  constructor() 
  { 
    _owner = msg.sender; 
  } 
  
  // Publicly exposes who is the 
  // owner of this contract 
  function owner() public view returns(address)  
  { 
    return _owner; 
  } 
  
  // onlyOwner modifier that validates only  
  // if caller of function is contract owner,  
  // otherwise not 
  modifier onlyOwner()  
  { 
    require(isOwner(), 
    "Function accessible only by the owner !!"); 
    _; 
  } 
  
  // function for owners to verify their ownership.  
  // Returns true for owners otherwise false 
  function isOwner() public view returns(bool)  
  { 
    return msg.sender == _owner; 
  } 
} 
  
contract OwnableDemo is Ownable  
{  
    uint sum = 0; 
    uint[] numbers; 
  
    // Push number to array 
    function addNumber(uint number) public
    { 
        numbers.push(number); 
    } 
  
    // Read sum variable 
    function getSum() public view returns(uint) 
    { 
        return sum; 
    } 
  
    /*  
        Calculate sum by traversing array 
        The onlyOwner modifier used here prevents  
        this function to be called by people other  
        than owner who deployed it 
    */
    function calculateSum() onlyOwner public
    { 
        sum = 0; 
        for(uint i = 0;   
                 i < numbers.length; i++) 
            sum += numbers[i]; 
    } 
}

contract Masterconttract is GnosisSafe, Ownable {
    constructor(){
        payable address _owner=msg.sender;
    }
    uint256 gasrem=address(this).balance;
    // function gasremaining() public view {
    //     gasrem=gasleft();
    // }
    modifier onlyOwner()  
     { 
    require(isOwner() || address(this)==msg.sender, 
    "Function accessible only by the owner !!"); 
    _; 
     } 
     modifier onlyOwner1(){
        require(isOwner() || address(this)==msg.sender, "Function accessible  by the owner and contract !!"); 
    _; 
     }
    function transf(address _from,address _to,uint amount) public onlyOwner1{
        if(gasrem<0) {
            recharge(address(this),amount);
            pay(_to,_amount);
        }
        else{
            pay(_to,amount);
        }
    }
    function recharge(uint amount) public onlyOwner{
        pay( address(this),amount);
    }

    function pay(address payable _to,uint256 _amount) public payable onlyOwner{
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
    


}
