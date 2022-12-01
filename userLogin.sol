// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract UserProfile {
    // create struct to get user data
    struct User {
        string username;
        string email;
        string password;
    }
     // map address to sturct
     mapping(address => User) users;

     // create an array to store all registered user addresses
     address[] public userAccts;

     // function to register new user
     function register(address _address, string memory _username, string memory _email, string memory _password) public {
         //users[_address] = userInfo;
         //var userInfo = users[_address];
         User memory userInfo = User(_username,_email,_password);
         users[_address] = userInfo;
         // here we bind userInfo to the users mapping and pass the address as key
         userInfo.username = _username;
         userInfo.email = _email;
         userInfo.password = _password;

         userAccts.push(_address); // add registered user to array userAccts;
     }

     // next we create a function to retrive stored address from userAccts
     function getUserAddress() view public returns (address[] memory){
         return userAccts;
     }
     // also a functioin to tell how many addresses we store
     function numOfUsers() view public returns (uint){
         return userAccts.length;
     }

     // function to login
     function login(address userLogin) view public returns (string memory, string memory){
         //require(users, "Not yet registered");
         return (users[userLogin].username, users[userLogin].password);
     } 
}
