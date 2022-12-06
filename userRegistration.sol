// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * create function register
 * function takes address, usernmae, password, email
 * map address to struct
 * map array to bool
 */

 contract register{

     struct userData {
         string username;
         string email;
         string password;
     }
     
     // Map struct to user address to get user credentials
     mapping(address => userData)  private User;
     
     //Map user address to bool to checck if address is already registered
     mapping(address => bool) private isRegistered;
     
     //Map to check if username/email already exist
     mapping(string => bool) private isUser;

     // Event for logging info
     event status(string);
     
     error emptyField(string);
     address[] private userAddresses; //user address storage
     bytes32[] private isRegisteredList; //database of hashed username and password
     string[] private emailList; // Database of user emails
     bytes32[] private emailHash; //database of hashed email and password
     string[] private UserName; // Database of usernames
     
     // needed to verify if user is isRegistered
     mapping(bytes32 => bool) private LoggedIn;

     mapping(address => bool) private isLoggedIn; // required to send and recieve messages
     
     
     function registerUser(address _userAddress, string memory _username, string memory _email, string memory _password) public {
         /** This function takes an address, username, email and password
         * first check user is not already isRegistered
         * check that input is not empty
         * push address to storage array
         * encode username and password and then hash the output
         * verify that user is isRegistered and store the isRegistered user to an array
         */
         
         // check if address is already isRegistered
        require(!validateAddress(_userAddress), "user already exists!");

        // Check if username is used already
        require(!isUser[_username],"Username already exist"); // check if username exist
        require(!isUser[_email], "email already exist"); // check if email already exist

        address addy = _userAddress;
         
         userData memory account = userData(_username, _email, _password); //initialize struct
         account.username = _username;
         require(bytes (_username).length!=0, "Empty username field");
         account.email = _email;
         require(bytes (_email).length!=0, "Empty email field");
         account.password = _password;
         require(bytes (_password).length!=0, "Empty password field");
         
         // prevent registering same username more than once
         isUser[_username] = true;
         UserName.push(_username); // database of usernames
         
         // prevent registring same email more than once
         isUser[_email] = true;
         emailList.push(_email);

         // Encode and  hash username and password
         bytes memory data = abi.encodePacked(_username,_password);
         bytes32 hash = keccak256(data);

         // Encode and  hash email and password
         bytes memory data2 = abi.encodePacked(_email,_password);
         bytes32 hash2 = keccak256(data2);

         LoggedIn[hash2] = true;
         emailHash.push(hash2);
        
         // Bool to check hashed credentials
         LoggedIn[hash] = true; // Vallidate that user can login
         isRegisteredList.push(hash); // store hashed credentials
         
         isRegistered[addy] = true; // Validate that address is isRegistered
         userAddresses.push(addy); // store Addresses
         emit status("isRegistered Successfully");
        
     }
     // Helper function to check address Reentrancy. i.e to stop multiple registration with the same address
     function validateAddress(address checkingAddress) private view returns (bool){
         return isRegistered[checkingAddress];
     }
   
     function Login(string memory _username_or_email, string memory _pasword) public  {
        if (bytes(_username_or_email).length == 0 || bytes(_pasword).length == 0) revert emptyField("Null Input");
        
        //encode username and password
        bytes memory data = abi.encodePacked(_username_or_email,_pasword);
        bytes32 hash = keccak256(data);
        
        //validate user input
        require(LoggedIn[hash], "username/email or password incorrect");
        isLoggedIn[msg.sender] = true;
        
        emit status("Login successful");
     }

     mapping(address => string) messenger;

     function sendMessage(address _to, string memory _message) public  {
        // Map message to a particular address
         require(isLoggedIn[msg.sender], "Login to send message");
         messenger[_to] = _message;
         emit status("Message sent succefully");
     }

     function readMessage() public view returns (string memory) {
         // read message sent to address i.e only msg.sender can read the message
         require(isLoggedIn[msg.sender], "Login to read message");
         return messenger[msg.sender];
     }
 }
